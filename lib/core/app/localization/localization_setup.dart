import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../l10n/app_localizations.dart';

/// Bridges Flutter's generated localization with app's locale management.
///
/// Responsibility:
/// - Configure MaterialApp localization delegates
/// - Provide supported locales list
/// - Handle localization setup for the entire app
///
/// Usage in main.dart:
/// ```dart
/// MaterialApp(
///   localizationsDelegates: LocalizationSetup.delegates,
///   supportedLocales: LocalizationSetup.supportedLocales,
///   locale: context.watch<LocaleProvider>().locale,
/// )
/// ```
class LocalizationSetup {
  /// Complete list of localization delegates for MaterialApp
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    AppLocalizations.delegate, // Generated from ARB files
    GlobalMaterialLocalizations.delegate, // Material widgets localization
    GlobalCupertinoLocalizations.delegate, // iOS-style widgets localization
    GlobalWidgetsLocalizations.delegate, // Default text direction, etc.
  ];

  /// Supported locales matching your ARB files and LocaleProvider
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('te'), // Telugu
  ];

  /// Fallback locale when device locale is not supported
  static const Locale fallbackLocale = Locale('en');

  /// Check if a locale is supported by the app
  static bool isLocaleSupported(Locale locale) {
    return supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  /// Get supported locale from device locale
  /// Returns fallbackLocale if device locale is not supported
  static Locale getSupportedLocale(Locale deviceLocale) {
    return supportedLocales.firstWhere(
      (supported) => supported.languageCode == deviceLocale.languageCode,
      orElse: () => fallbackLocale,
    );
  }
}
