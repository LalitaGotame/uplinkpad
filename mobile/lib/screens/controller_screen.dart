import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/action_buttons_cluster.dart';
import '../widgets/analog_stick.dart';
import '../widgets/dpad.dart';

/// Phase 1: a static controller layout. Nothing here is wired to
/// networking yet — widgets just track and expose their own touch
/// state for the input pipeline to consume later.
class ControllerScreen extends StatelessWidget {
  const ControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PadColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _StatusBar(),
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
                              AnalogStick(size: controlSize, thumbSize: controlSize * 0.4),
                              const SizedBox(height: gap),
                              Dpad(size: controlSize),
                            ],
                          ),
                        ),
                        // Right cluster: face buttons, vertically centered.
                        Expanded(
                          child: Center(
                            child: ActionButtonsCluster(
                              buttonSize: (controlSize * 0.36).clamp(48.0, 64.0).toDouble(),
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
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: PadColors.labelMuted,
            ),
          ),
          const Text(
            'NOT CONNECTED',
            style: TextStyle(
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
