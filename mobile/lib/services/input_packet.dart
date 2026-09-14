import 'dart:convert';

/// One frame of controller input, matching the wire format documented
/// in `shared/protocol/packet_format.md`. Keep the two in sync.
class InputPacket {
  InputPacket({
    required this.seq,
    required this.buttons,
    required this.stickX,
    required this.stickY,
  });

  final int seq;
  final Map<String, bool> buttons;
  final double stickX;
  final double stickY;

  List<int> toBytes() {
    final json = jsonEncode({
      'seq': seq,
      'buttons': buttons,
      'stick': {'x': stickX, 'y': stickY},
    });
    return utf8.encode(json);
  }
}
