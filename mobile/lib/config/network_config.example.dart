/// Template for [NetworkConfig] -- copy this file to
/// `network_config.dart` (same directory) and fill in your PC's real
/// LAN IP. `network_config.dart` is gitignored so your IP never gets
/// committed; this `.example.dart` file is the checked-in template
/// showing the expected shape.
///
/// Phase 2 skeleton: the PC address is hardcoded, no discovery or
/// manual-entry UI yet (that's Phase 5 pairing). Find your PC's LAN
/// IP with `ipconfig` (look for "IPv4 Address" under your Wi-Fi
/// adapter).
class NetworkConfig {
  NetworkConfig._();

  static const String pcIpAddress = '192.168.1.100';

  /// Must match the port `pc-client/udp_listener.py` /
  /// `pc-client/gamepad_server.py` bind to.
  static const int pcPort = 9000;
}
