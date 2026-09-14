# pc-client

Windows companion app that receives controller input over UDP.

- `udp_listener.py` (Phase 2) — plain stdlib script, prints decoded
  packets to the console. No driver dependency; useful for checking
  raw packets are arriving if `gamepad_server.py` ever misbehaves.
- `gamepad_server.py` (Phase 3, current) — drives a virtual Xbox 360
  controller via ViGEmBus (through the `vgamepad` wrapper).

## Setup (Phase 3)

1. Install the [ViGEmBus driver](https://github.com/nefarius/ViGEmBus/releases/tag/v1.22.0)
   (`ViGEmBus_1.22.0_x64_x86_arm64.exe`) — the kernel driver `vgamepad`
   talks to. Pinned to this version per `docs/PROJECT_BRIEF.md`: the
   upstream repo is archived, so don't expect a newer release. Confirm
   it installed via Device Manager -> System devices -> "Nefarius
   Virtual USB Gaming Bus" (or similar).
2. `pip install -r requirements.txt` (installs `vgamepad`, also
   pinned).

## Run

```
python gamepad_server.py
```

It binds `0.0.0.0:9000`, creates one virtual Xbox 360 controller for
as long as the script runs, and applies each incoming packet to it
(button presses, D-pad, left stick). Stale/out-of-order packets
(by `seq`) are dropped rather than applied, per the transport rules in
`shared/protocol/packet_format.md`.

**Test with Windows' controller panel first, not a real game:**
`Win+R` -> `joy.cpl` -> select the Xbox 360 controller -> Properties ->
Test tab. Press buttons / move the stick on the phone and confirm they
register there.

Find this PC's LAN IP with `ipconfig` (the "IPv4 Address" under your
Wi-Fi adapter) and set it as `NetworkConfig.pcIpAddress` in
`mobile/lib/config/network_config.dart` before running the phone app.
Make sure Windows Firewall allows inbound UDP on port 9000 for
Python, or packets will be silently dropped before reaching the
script.

Wire format: [`shared/protocol/packet_format.md`](../shared/protocol/packet_format.md).
