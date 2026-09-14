# Uplink Pad

Turns a smartphone into a virtual PC game controller. A Flutter mobile
app sends touch/gyro input over UDP on the local Wi-Fi network to a
Windows companion app, which emulates an Xbox 360 controller via
ViGEmBus (`vgamepad`) so Windows and games see it natively. LAN only,
no internet required.

## Structure

- `mobile/` — Flutter app (controller UI, input capture)
- `pc-client/` — Windows companion app (Python + vgamepad)
- `shared/` — wire protocol shared between mobile and pc-client
- `docs/` — design notes ([architecture](docs/architecture.md))

## Status

Phase 3: `pc-client/gamepad_server.py` applies incoming UDP packets to
a virtual Xbox 360 controller via ViGEmBus (`vgamepad`). Phase 2 (UDP
send/receive) is confirmed working end-to-end on real hardware. See
`mobile/README.md` and `pc-client/README.md` to run both sides.
