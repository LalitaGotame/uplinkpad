import 'dart:io';

import '../config/network_config.dart';
import 'input_packet.dart';

/// Opens a UDP socket and fires input packets at the hardcoded PC
/// address from [NetworkConfig]. Phase 2 skeleton: fire-and-forget,
/// no ack, no reconnect logic, no encryption — just prove packets
/// arrive intact on the other end.
class UdpSender {
  RawDatagramSocket? _socket;
  int _seq = 0;

  bool get isConnected => _socket != null;

  /// Binds a local UDP socket. Cheap and doesn't require the PC to be
  /// reachable yet — UDP has no connection handshake, so this can't
  /// fail just because the target IP is wrong or unreachable.
  Future<void> connect() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  }

  /// Encodes and sends one packet. Silently does nothing if not
  /// connected yet or the socket send fails — losing a frame of
  /// controller input is expected/fine over UDP.
  void send({
    required Map<String, bool> buttons,
    required double stickX,
    required double stickY,
  }) {
    final socket = _socket;
    if (socket == null) return;

    final packet = InputPacket(
      seq: _seq++,
      buttons: buttons,
      stickX: stickX,
      stickY: stickY,
    );

    try {
      socket.send(
        packet.toBytes(),
        InternetAddress(NetworkConfig.pcIpAddress),
        NetworkConfig.pcPort,
      );
    } on SocketException {
      // e.g. no route to host — drop the frame, keep the UI running.
    }
  }

  void close() {
    _socket?.close();
    _socket = null;
  }
}
