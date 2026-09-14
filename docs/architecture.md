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

1. **Static Flutter UI** (current) — D-pad, A/B/X/Y buttons, one
   analog stick, landscape layout. No networking.
2. Wire up local input state/events within the app.
3. UDP client in `mobile/`, matching UDP server in `pc-client/`,
   protocol defined in `shared/`.
4. `pc-client/` emulates an Xbox 360 controller via `vgamepad`.
5. Polish: reconnect handling, latency tuning, multiple layouts.
