# Uplink Pad — Architecture

Turns a smartphone into a virtual PC game controller over the local
network. No internet required, LAN only.

```
mobile/      Flutter app (the controller UI, touch/gyro input)
pc-client/   Windows companion app (Python + vgamepad/ViGEmBus)
shared/      Wire protocol shared between mobile/ and pc-client/
docs/        Design notes
```

Flow: phone touch/gyro input -> UDP packets over local Wi-Fi ->
PC companion app -> ViGEmBus virtual Xbox 360 controller -> seen
natively by Windows and games.

## Phases

1. **Static Flutter UI** (done) — D-pad, A/B/X/Y buttons, one
   analog stick, landscape layout. No networking.
2. **UDP skeleton** (current) — `mobile/` sends JSON input packets
   over UDP (`RawDatagramSocket`) to a hardcoded PC IP/port;
   `pc-client/udp_listener.py` prints what it receives. Protocol
   defined in `shared/protocol/packet_format.md`.
3. `pc-client/` emulates an Xbox 360 controller via `vgamepad`.
4. Real-game test.
5. Polish: pairing, reconnect handling, latency tuning, multiple layouts.
