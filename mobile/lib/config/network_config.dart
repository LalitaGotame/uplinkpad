/// Phase 2 skeleton: the PC address is hardcoded, no discovery or
/// manual-entry UI yet (that's Phase 5 pairing). Change [pcIpAddress]
/// to your Windows PC's LAN IP before running — find it with
/// `ipconfig` (look for "IPv4 Address" under your Wi-Fi adapter).
class NetworkConfig {
  NetworkConfig._();

  static const String pcIpAddress = '192.168.1.100';

  /// Must match the port `pc-client/udp_listener.py` binds to.
  static const int pcPort = 9000;
}
