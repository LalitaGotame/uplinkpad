# mobile

Flutter controller UI. Phase 2: static layout (D-pad, A/B/X/Y, one
analog stick, landscape) now sends input over UDP to a hardcoded PC
address — see `lib/config/network_config.dart`.

## First-time setup

This checkout has `pubspec.yaml` and `lib/` but not the generated
platform folders (`android/`, `ios/`, etc.) — the Flutter SDK isn't
installed in the environment this was scaffolded in. With the Flutter
SDK installed, from this directory:

```
flutter create --org com.uplinkpad --project-name uplink_pad .
flutter pub get
```

`flutter create .` will not overwrite the existing `lib/` or
`pubspec.yaml`; it only adds the missing platform folders.

## Run

```
flutter run
```

Pick an Android/iOS device or emulator — the UI forces landscape
orientation on launch.

## Networking (Phase 2)

Before running on a real device, set `NetworkConfig.pcIpAddress` in
`lib/config/network_config.dart` to your PC's LAN IP (`ipconfig`,
look for "IPv4 Address"), and start `pc-client/udp_listener.py` on
that PC first. The phone and PC must be on the same Wi-Fi network.
The status bar shows a running count of packets sent — that only
means they left the phone, not that the PC received them; check the
PC console for that.
