import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages application locale state and language switching.
///
/// Responsibility:
/// - Maintain current locale state
/// - Provide supported locales list
/// - Handle locale changes and notify listeners
/// - Persist locale preference to SharedPreferences
/// - Load saved locale on initialization
/// - Detect device locale on first launch
///
/// Usage:
/// - Wrap with ChangeNotifierProvider in main.dart
/// - Call `loadLocale()` in main.dart before runApp() to restore saved locale
/// - Use `context.read<LocaleProvider>().setLocale()` to change language
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('en');
  bool _isInitialized = false;

  /// Get current locale
  Locale get locale => _locale;

  /// Check if provider has been initialized
  bool get isInitialized => _isInitialized;

  /// List of supported locales in the app
  List<Locale> get supportedLocales => const [Locale('en'), Locale('te')];

  /// Load saved locale from SharedPreferences or detect device locale
  /// Call this in main.dart before runApp() to restore user's language choice
  Future<void> loadLocale() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey);

      if (savedLocaleCode != null) {
        // Load saved locale preference
        final savedLocale = Locale(savedLocaleCode);
        if (supportedLocales.any(
            (l) => l.languageCode == savedLocale.languageCode)) {
          _locale = savedLocale;
        }
      } else {
        // First launch - detect device locale
        final deviceLocale = ui.PlatformDispatcher.instance.locale;
        final supportedLocale = _getSupportedLocale(deviceLocale);
        _locale = supportedLocale;
        // Save detected locale for future use
        await prefs.setString(_localeKey, _locale.languageCode);
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, use default locale
      _locale = const Locale('en');
      _isInitialized = true;
    }
  }

  /// Get supported locale from device locale
  /// Returns English if device locale is not supported
  Locale _getSupportedLocale(Locale deviceLocale) {
    return supportedLocales.firstWhere(
      (supported) => supported.languageCode == deviceLocale.languageCode,
      orElse: () => const Locale('en'),
    );
  }

  /// Change app locale if supported and persist to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales
        .any((l) => l.languageCode == locale.languageCode)) {
      return;
    }

    if (_locale.languageCode != locale.languageCode) {
      _locale = locale;
      notifyListeners();

      // Persist locale preference
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_localeKey, _locale.languageCode);
      } catch (e) {
        // If saving fails, continue anyway - locale is already changed
      }
    }
  }

  /// Toggle between English and Telugu
  Future<void> toggleLanguage() async {
    final newLocale = _locale.languageCode == 'en'
        ? const Locale('te')
        : const Locale('en');
    await setLocale(newLocale);
  }
}
