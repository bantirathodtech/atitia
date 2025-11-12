// Platform detection helper with conditional imports for web compatibility
// This file uses conditional imports to safely access Platform on non-web platforms

import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import: use Platform on non-web, stub on web
// ignore: avoid_web_libraries_in_flutter
import 'dart:io' if (dart.library.html) 'platform_helper_stub.dart'
    show Platform;

/// Safe platform detection for macOS
/// Returns false on web, true only on actual macOS
bool get isMacOSSafe {
  if (kIsWeb) return false;
  try {
    return Platform.isMacOS;
  } catch (_) {
    return false;
  }
}
