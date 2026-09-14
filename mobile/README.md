# mobile

Flutter controller UI. Phase 1: static layout only (D-pad, A/B/X/Y,
one analog stick, landscape) — no networking yet.

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
