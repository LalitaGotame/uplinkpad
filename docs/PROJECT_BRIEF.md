# Uplink Pad — Project Brief

Turn a smartphone into a virtual PC game controller. Local network only, no internet dependency.

## Architecture

```
[Mobile App: Flutter]  --touch/gyro capture-->  [UDP packet]
      |
      |  UDP over local Wi-Fi (LAN only, no internet)
      v
[PC Companion: Python (v1) -> C# (v2)]
      |
      |-- Mode A: Gamepad  --> ViGEmBus (vgamepad) --> virtual Xbox 360 controller --> Windows --> Game
      |-- Mode B: Keyboard/Mouse --> SendInput --> Windows --> Game
      |
      +-- Profile Manager (per-game button mapping, local JSON for v1)
      +-- Pairing/Session Manager (QR + token, added in Phase 5)
```

## Stack decisions

- **Mobile:** Flutter (Dart), landscape-only UI, `RawDatagramSocket` for UDP.
- **PC companion:** Python + `vgamepad` for the prototype; port hot path to C# + ViGEm client SDK once the pipeline is proven.
- **Virtual controller layer:** ViGEmBus. Note: upstream repo is archived/unmaintained as of 2026 but the last stable release still works — pin the version, don't expect updates.
- **Transport:** UDP, not TCP (avoid head-of-line blocking on stale input). Sequence numbers to drop out-of-order/old packets.
- **No internet required** — same-LAN only for v1. Manual IP entry for v1; QR pairing added in Phase 5.
- **Storage:** local JSON for profiles in v1. SQLite only once multiple devices/profiles justify it — don't add early.

## Known constraints to respect

- Games with kernel-level anti-cheat (BattlEye, Easy Anti-Cheat) may flag virtual HID devices — this is a real limitation, not something to architect around.
- Input latency budget: phone-to-virtual-HID-update <20ms is realistic; end-to-end "feels responsive in game" is dominated by the game's own input polling rate, not this app.
- Games with zero controller support only work in Keyboard/Mouse mode, and it will feel worse than native controller support — set that expectation in-app.

## Project structure

```
uplinkpad/
├── mobile/          # Flutter app
├── pc-client/        # Python/C# companion app
├── shared/
│   └── protocol/    # packet format definitions, shared between mobile & pc-client
├── docs/
└── README.md
```

## Roadmap (work one phase at a time — do not let Claude Code skip ahead)

1. **Static mobile UI** — D-pad, A/B/X/Y, one analog stick, landscape only, no networking.
2. **UDP skeleton** — phone sends packets, PC prints them to console. No ViGEm yet.
3. **ViGEm integration** — PC receiver turns packets into a virtual Xbox 360 controller. Test with Windows' "Game Controllers" panel before touching a real game.
4. **Real-game test** — try it end-to-end in one forgiving title (Rocket League or an emulator).
5. **Pairing** — QR code or manual code + basic auth token.
6. **Keyboard/mouse mode.**
7. **Profiles + customization UI.**
8. **Multi-controller support.**
9. **Polish, latency instrumentation, security hardening.**
10. **Packaging/installer** (driver install + companion app installer).

## Phase prompts (copy into Claude Code, one at a time)

### Phase 1
> We're building "Uplink Pad" — see docs/PROJECT_BRIEF.md for full architecture. Start Phase 1 only: a static Flutter UI with a D-pad, A/B/X/Y buttons, and one analog stick, landscape orientation, no networking yet. Set up `mobile/`, `pc-client/`, `shared/`, `docs/` at the repo root if not already present. Explain what you're building before you write code.

### Phase 2
> Phase 1 is done and committed. Now build Phase 2: a UDP send/receive skeleton. The Flutter app should send a simple packet (button states + stick position) over UDP to a hardcoded local IP. Build a minimal Python script in `pc-client/` that listens on that UDP port and prints received packets to the console. No ViGEm yet — just prove the pipe works.

### Phase 3
> Phase 2 works — packets are arriving on the PC. Now build Phase 3: integrate `vgamepad` in the PC companion so incoming packets update a virtual Xbox 360 controller. Test using Windows' built-in "Set up USB game controllers" panel to confirm button presses register — don't test in a real game yet.

### Phase 4
> Phase 3 works in the Windows controller panel. Now let's test end-to-end in [Rocket League / an emulator]. Help me verify the virtual controller is recognized by the game and walk through any input mapping issues.

### Phase 5
> Core loop works end-to-end. Now build Phase 5: pairing. PC displays a QR code (or short manual code) on startup; phone scans/enters it to connect, and a session token authorizes that phone for the session. Keep it realistic for a student project — no need for heavy crypto.

### Phase 6+
> Continue with [keyboard/mouse mode / profiles / multi-controller / polish / packaging] per the roadmap in docs/PROJECT_BRIEF.md, one phase at a time.

## Working style reminders for Claude Code sessions

- Ask it to explain before it commits, so you're learning the codebase.
- Commit after each phase works, not mid-phase.
- Paste exact terminal output/errors back to it, not a paraphrase.