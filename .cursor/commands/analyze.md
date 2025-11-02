# analyze

  flutter analyze
  ```
- Format (check)
  ```bash
  dart format --set-exit-if-changed .
  ```
- Format (apply)
  ```bash
  dart format .
  ```
- Dart Fix
  ```bash
  dart fix --apply
  ```
- Pub Outdated
  ```bash
  dart pub outdated
  ```
- Pub Get (clean)
  ```bash
  flutter clean && flutter pub get
  ```

### Codegen & Assets
- Build Runner (build)
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- Build Runner (watch)
  ```bash
  dart run build_runner watch --delete-conflicting-outputs
  ```
- Flutter Gen (assets/fonts)
  ```bash
  fluttergen -c pubspec.yaml
  ```

### Localization
- L10n Generate
  ```bash
  flutter gen-l10n
  ```
- Intl Utils Generate (if using intl_utils)
  ```bash
  flutter pub run intl_utils:generate
  ```

### Testing
- Test (unit+widget)
  ```bash
  flutter test
  ```
- Test (goldens only)
  ```bash
  flutter test --tags=golden
  ```
- Test (coverage)
  ```bash
  flutter test --coverage && genhtml coverage/lcov.info -o coverage/html || true
  ```
- Test (integration default device)
  ```bash
  flutter drive --target=integration_test/app_test.dart
  ```

### Golden Testing Helpers
- Update Goldens (env var)
  ```bash
  UPDATE_GOLDENS=1 flutter test --tags=golden
  ```
- Goldens Multi-Size (text scales)
  ```bash
  flutter test --tags=golden --dart-define=TEST_MULTISIZE=1
  ```

### Run & Build (Common)
- Run Android (debug)
  ```bash
  flutter run -d android
  ```
- Run iOS Simulator
  ```bash
  flutter run -d ios
  ```
- Run Web (CanvasKit)
  ```bash
  flutter run -d chrome --web-renderer canvaskit
  ```
- Build APK (debug)
  ```bash
  flutter build apk --debug
  ```
- Build APK (release, arm64)
  ```bash
  flutter build apk --release --target-platform android-arm64
  ```
- Build AppBundle (release)
  ```bash
  flutter build appbundle --release
  ```
- Build iOS (release, no code sign)
  ```bash
  flutter build ios --release --no-codesign
  ```
- Build Web (release, CanvasKit)
  ```bash
  flutter build web --release --web-renderer canvaskit
  ```

### Flavors (example: dev/staging/prod)
- Run Dev (Android)
  ```bash
  flutter run --flavor dev -t lib/main_dev.dart -d android
  ```
- Run Staging (iOS Sim)
  ```bash
  flutter run --flavor staging -t lib/main_staging.dart -d ios
  ```
- Build Prod APK
  ```bash
  flutter build apk --flavor prod -t lib/main_prod.dart --release
  ```
- Build Prod iOS (no codesign)
  ```bash
  flutter build ios --flavor prod -t lib/main_prod.dart --release --no-codesign
  ```

### Size & Performance
- Analyze APK Size
  ```bash
  flutter build apk --release --analyze-size --target-platform android-arm64
  ```
- Analyze Web Size
  ```bash
  flutter build web --release --analyze-size --web-renderer canvaskit
  ```
- Profile Mode (Android)
  ```bash
  flutter run --profile -d android
  ```
- Trace Skia (debug jank)
  ```bash
  flutter run -d android --trace-skia
  ```

### Linting (Strict)
- Lint Package (flutter_lints)
  ```bash
  dart run dart_code_metrics:metrics analyze lib
  ```

### CI Pre-Push Gate
- Prepush
  ```bash
  flutter analyze && dart format --set-exit-if-changed . && flutter test
  ```

### Cache & Cleanups
- Full Clean Rebuild
  ```bash
  flutter clean && rm -rf ~/.pub-cache/git && flutter pub get && dart run build_runner build --delete-conflicting-outputs
  ```

### Monorepo (optional, if using Melos)
- Melos Bootstrap
  ```bash
  melos bootstrap
  ```
- Melos Test All
  ```bash
  melos run test
  ```
- Melos Analyze All
  ```bash
  melos run analyze
  ```

If you share your exact stack (e.g., Riverpod + Freezed + GoRouter + intl_utils), I can tailor and group these into folders in the Commands UI for quick access.
