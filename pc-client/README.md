# pc-client

Windows companion app that receives controller input over UDP. Phase 2:
plain Python stdlib script that prints received packets to the
console — no `vgamepad`/ViGEmBus yet, that's Phase 3.

## Run

Requires Python 3 (stdlib only, no `pip install` needed for this phase):

```
python udp_listener.py
```

It binds `0.0.0.0:9000` and prints each decoded packet as it arrives.
Find this PC's LAN IP with `ipconfig` (the "IPv4 Address" under your
Wi-Fi adapter) and set it as `NetworkConfig.pcIpAddress` in
`mobile/lib/config/network_config.dart` before running the phone app.

Make sure Windows Firewall allows inbound UDP on port 9000 for Python,
or packets will be silently dropped before reaching the script.

Wire format: [`shared/protocol/packet_format.md`](../shared/protocol/packet_format.md).
