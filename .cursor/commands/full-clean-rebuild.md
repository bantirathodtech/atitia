# full-clean-rebuild

  flutter clean && rm -rf ~/.pub-cache/git && flutter pub get && dart run build_runner build --delete-conflicting-outputs
