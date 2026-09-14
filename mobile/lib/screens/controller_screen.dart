import 'package:flutter/material.dart';
import '../config/network_config.dart';
import '../services/udp_sender.dart';
import '../theme/colors.dart';
import '../widgets/action_buttons_cluster.dart';
import '../widgets/analog_stick.dart';
import '../widgets/dpad.dart';

/// Phase 2: same static layout as Phase 1, now wired to a [UdpSender].
/// Every button/stick change is packed into an [InputPacket] (see
/// shared/protocol/packet_format.md) and fired at the hardcoded PC
/// address in [NetworkConfig]. No ViGEm yet — the PC side just prints
/// what it receives.
class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  final UdpSender _sender = UdpSender();

  // All 8 button ids from the packet schema; D-pad directions are
  // mutually exclusive, face buttons are independent.
  final Map<String, bool> _buttons = {
    'a': false, 'b': false, 'x': false, 'y': false,
    'up': false, 'down': false, 'left': false, 'right': false,
  };
  double _stickX = 0;
  double _stickY = 0;
  int _packetsSent = 0;

  @override
  void initState() {
    super.initState();
    _sender.connect();
  }

  @override
  void dispose() {
    _sender.close();
    super.dispose();
  }

  void _sendState() {
    _sender.send(buttons: _buttons, stickX: _stickX, stickY: _stickY);
    setState(() => _packetsSent++);
  }

  void _onFaceButtonChanged(String button, bool pressed) {
    _buttons[button] = pressed;
    _sendState();
  }

  void _onDpadChanged(DpadDirection? direction) {
    for (final d in DpadDirection.values) {
      _buttons[d.name] = d == direction;
    }
    _sendState();
  }

  void _onStickChanged(Offset normalized) {
    _stickX = normalized.dx;
    _stickY = normalized.dy;
    _sendState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PadColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _StatusBar(packetsSent: _packetsSent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Left column stacks the stick above the D-pad with a
                    // gap between them; size both to whatever fits so
                    // shorter landscape screens (e.g. an SE) don't overflow.
                    const gap = 16.0;
                    const minControlSize = 110.0;
                    const maxControlSize = 176.0;
                    final available = (constraints.maxHeight - gap) / 2;
                    final controlSize =
                        available.clamp(minControlSize, maxControlSize).toDouble();

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnalogStick(
                                size: controlSize,
                                thumbSize: controlSize * 0.4,
                                onChanged: _onStickChanged,
                              ),
                              const SizedBox(height: gap),
                              Dpad(size: controlSize, onDirectionChanged: _onDpadChanged),
                            ],
                          ),
                        ),
                        // Right cluster: face buttons, vertically centered.
                        Expanded(
                          child: Center(
                            child: ActionButtonsCluster(
                              buttonSize: (controlSize * 0.36).clamp(48.0, 64.0).toDouble(),
                              onButtonChanged: _onFaceButtonChanged,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.packetsSent});

  final int packetsSent;

  @override
  Widget build(BuildContext context) {
    // "Sent" only means the packet left the phone — UDP gives no
    // delivery confirmation, so this isn't proof the PC received it.
    // Check the PC console for that. Real connection status (ack'd,
    // paired) comes in a later phase.
    final sending = packetsSent > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Text(
            'UPLINK PAD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: sending ? PadColors.stickThumbActive : PadColors.labelMuted,
            ),
          ),
          Text(
            '${NetworkConfig.pcIpAddress}:${NetworkConfig.pcPort} · SENT $packetsSent',
            style: const TextStyle(
              color: PadColors.labelMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
