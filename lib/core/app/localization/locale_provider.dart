import 'package:flutter/material.dart';

/// Manages application locale state and language switching.
///
/// Responsibility:
/// - Maintain current locale state
/// - Provide supported locales list
/// - Handle locale changes and notify listeners
///
/// Usage:
/// - Wrap with ChangeNotifierProvider in main.dart
/// - Use `context.read<LocaleProvider>().setLocale()` to change language
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  /// Get current locale
  Locale get locale => _locale;

  /// List of supported locales in the app
  List<Locale> get supportedLocales => const [Locale('en'), Locale('te')];

  /// Change app locale if supported
  void setLocale(Locale locale) {
    if (supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      _locale = locale;
      notifyListeners();
    }
  }

  /// Toggle between English and Telugu
  void toggleLanguage() {
    _locale =
        _locale.languageCode == 'en' ? const Locale('te') : const Locale('en');
    notifyListeners();
  }
}
