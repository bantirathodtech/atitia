// lib/core/services/localization/internationalization_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../di/firebase/di/firebase_service_locator.dart';

/// Internationalization service for multi-language support
/// Provides comprehensive localization and translation capabilities
class InternationalizationService {
  static final InternationalizationService _instance =
      InternationalizationService._internal();
  factory InternationalizationService() => _instance;
  InternationalizationService._internal();

  static InternationalizationService get instance => _instance;

  // Logger not available - removed for now
  final _analyticsService = getIt.analytics;

  Locale _currentLocale = const Locale('en', 'US');
  final Map<String, Map<String, String>> _translations = {};
  bool _isInitialized = false;

  /// Current locale
  Locale get currentLocale => _currentLocale;

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('hi', 'IN'), // Hindi
    Locale('te', 'IN'), // Telugu
    Locale('ta', 'IN'), // Tamil
    Locale('bn', 'BD'), // Bengali
    Locale('gu', 'IN'), // Gujarati
    Locale('mr', 'IN'), // Marathi
    Locale('kn', 'IN'), // Kannada
    Locale('ml', 'IN'), // Malayalam
    Locale('pa', 'IN'), // Punjabi
  ];

  /// Initialize internationalization service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
    // Logger not available: _logger.info call removed

      // Load translations for all supported locales
      await _loadTranslations();

      _isInitialized = true;

      await _analyticsService.logEvent(
        name: 'i18n_service_initialized',
        parameters: {
          'current_locale': _currentLocale.languageCode,
          'supported_locales':
              supportedLocales.map((l) => l.languageCode).toList(),
        },
      );

    // Logger not available: _logger.info call removed
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Load translations for all supported locales
  Future<void> _loadTranslations() async {
    for (final locale in supportedLocales) {
      try {
        final translations = await _loadLocaleTranslations(locale);
        _translations[locale.languageCode] = translations;
      } catch (e) {
    // Logger not available: _logger call removed
      }
    }
  }

  /// Load translations for a specific locale
  Future<Map<String, String>> _loadLocaleTranslations(Locale locale) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/localization/app_${locale.languageCode}.arb',
      );
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      // Convert to string map
      final Map<String, String> translations = {};
      jsonMap.forEach((key, value) {
        if (value is String) {
          translations[key] = value;
        }
      });

      return translations;
    } catch (e) {
    // Logger not available: _logger call removed

      // Return fallback translations
      return _getFallbackTranslations();
    }
  }

  /// Get fallback translations (English)
  Map<String, String> _getFallbackTranslations() {
    return {
      'app_name': 'Atitia',
      'welcome': 'Welcome',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'phone': 'Phone',
      'name': 'Name',
      'submit': 'Submit',
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'refresh': 'Refresh',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Info',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'close': 'Close',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'done': 'Done',
      'continue': 'Continue',
      'skip': 'Skip',
      'retry': 'Retry',
      'try_again': 'Try Again',
      'network_error': 'Network Error',
      'server_error': 'Server Error',
      'unknown_error': 'Unknown Error',
      'no_internet': 'No Internet Connection',
      'connection_timeout': 'Connection Timeout',
      'invalid_input': 'Invalid Input',
      'required_field': 'This field is required',
      'invalid_email': 'Invalid email address',
      'invalid_phone': 'Invalid phone number',
      'password_too_short': 'Password is too short',
      'passwords_dont_match': 'Passwords do not match',
      'login_success': 'Login successful',
      'login_failed': 'Login failed',
      'signup_success': 'Sign up successful',
      'signup_failed': 'Sign up failed',
      'logout': 'Logout',
      'profile': 'Profile',
      'settings': 'Settings',
      'about': 'About',
      'help': 'Help',
      'contact': 'Contact',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'version': 'Version',
      'build': 'Build',
      'last_updated': 'Last Updated',
      'created_by': 'Created By',
      'all_rights_reserved': 'All Rights Reserved',
    };
  }

  /// Get translated text
  String translate(String key, {Map<String, dynamic>? parameters}) {
    if (!_isInitialized) {
    // Logger not available: _logger call removed
      return key;
    }

    final localeTranslations = _translations[_currentLocale.languageCode];
    if (localeTranslations == null) {
    // Logger not available: _logger call removed
      return key;
    }

    String translation = localeTranslations[key] ?? key;

    // Replace parameters if provided
    if (parameters != null) {
      parameters.forEach((paramKey, value) {
        translation = translation.replaceAll('{$paramKey}', value.toString());
      });
    }

    return translation;
  }

  /// Get translated text with pluralization
  String translatePlural(String key, int count,
      {Map<String, dynamic>? parameters}) {
    final baseKey = key;
    final pluralKey = '${key}_plural';

    // Try to get plural form first
    String translation = translate(pluralKey, parameters: parameters);
    if (translation == pluralKey) {
      // Fall back to singular form
      translation = translate(baseKey, parameters: parameters);
    }

    // Replace count parameter
    translation = translation.replaceAll('{count}', count.toString());

    return translation;
  }

  /// Change locale
  Future<void> changeLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
    // Logger not available: _logger call removed
      return;
    }

    _currentLocale = locale;

    await _analyticsService.logEvent(
      name: 'locale_changed',
      parameters: {
        'new_locale': locale.languageCode,
        'country_code': locale.countryCode ?? '',
      },
    );

    // Logger not available: _logger.info call removed
  }

  /// Get localized time format
  String formatTime(DateTime time, {String? pattern}) {
    final formatter =
        DateFormat(pattern ?? _getTimePattern(), _currentLocale.languageCode);
    return formatter.format(time);
  }

  /// Get localized number format
  String formatNumber(num number, {int? decimalPlaces}) {
    final formatter = NumberFormat.decimalPattern(_currentLocale.languageCode);
    if (decimalPlaces != null) {
      formatter.minimumFractionDigits = decimalPlaces;
      formatter.maximumFractionDigits = decimalPlaces;
    }
    return formatter.format(number);
  }

  /// Get localized currency format
  String formatCurrency(num amount, {String? currencyCode}) {
    final formatter = NumberFormat.currency(
      locale: _currentLocale.languageCode,
      symbol: currencyCode ?? _getCurrencySymbol(),
    );
    return formatter.format(amount);
  }

  /// Get date pattern for current locale
  String _getDatePattern() {
    switch (_currentLocale.languageCode) {
      case 'hi':
      case 'te':
      case 'ta':
      case 'bn':
      case 'gu':
      case 'mr':
      case 'kn':
      case 'ml':
      case 'pa':
        return 'dd/MM/yyyy'; // Indian format
      default:
        return 'MM/dd/yyyy'; // US format
    }
  }

  /// Get time pattern for current locale
  String _getTimePattern() {
    switch (_currentLocale.languageCode) {
      case 'hi':
      case 'te':
      case 'ta':
      case 'bn':
      case 'gu':
      case 'mr':
      case 'kn':
      case 'ml':
      case 'pa':
        return 'HH:mm'; // 24-hour format
      default:
        return 'h:mm a'; // 12-hour format
    }
  }

  /// Get currency symbol for current locale
  String _getCurrencySymbol() {
    switch (_currentLocale.languageCode) {
      case 'hi':
      case 'te':
      case 'ta':
      case 'bn':
      case 'gu':
      case 'mr':
      case 'kn':
      case 'ml':
      case 'pa':
        return '₹'; // Indian Rupee
      default:
        return '\$'; // US Dollar
    }
  }

  /// Get localized text direction
  /// Note: TextDirection enum values need to be verified for your Flutter version
  /// Common values are TextDirection.rtl and TextDirection.ltr
  bool get isRTL {
    final rtlLanguages = ['ar', 'he', 'fa'];
    return rtlLanguages.contains(_currentLocale.languageCode);
  }

  /// Get localized app name
  String get appName => translate('app_name');

  /// Get localized welcome message
  String get welcomeMessage => translate('welcome');

  /// Get localized login text
  String get loginText => translate('login');

  /// Get localized signup text
  String get signupText => translate('signup');

  /// Get localized email text
  String get emailText => translate('email');

  /// Get localized password text
  String get passwordText => translate('password');

  /// Get localized phone text
  String get phoneText => translate('phone');

  /// Get localized name text
  String get nameText => translate('name');

  /// Get localized submit text
  String get submitText => translate('submit');

  /// Get localized cancel text
  String get cancelText => translate('cancel');

  /// Get localized save text
  String get saveText => translate('save');

  /// Get localized edit text
  String get editText => translate('edit');

  /// Get localized delete text
  String get deleteText => translate('delete');

  /// Get localized search text
  String get searchText => translate('search');

  /// Get localized filter text
  String get filterText => translate('filter');

  /// Get localized sort text
  String get sortText => translate('sort');

  /// Get localized refresh text
  String get refreshText => translate('refresh');

  /// Get localized loading text
  String get loadingText => translate('loading');

  /// Get localized error text
  String get errorText => translate('error');

  /// Get localized success text
  String get successText => translate('success');

  /// Get localized warning text
  String get warningText => translate('warning');

  /// Get localized info text
  String get infoText => translate('info');

  /// Get localized yes text
  String get yesText => translate('yes');

  /// Get localized no text
  String get noText => translate('no');

  /// Get localized ok text
  String get okText => translate('ok');

  /// Get localized close text
  String get closeText => translate('close');

  /// Get localized back text
  String get backText => translate('back');

  /// Get localized next text
  String get nextText => translate('next');

  /// Get localized previous text
  String get previousText => translate('previous');

  /// Get localized done text
  String get doneText => translate('done');

  /// Get localized continue text
  String get continueText => translate('continue');

  /// Get localized skip text
  String get skipText => translate('skip');

  /// Get localized retry text
  String get retryText => translate('retry');

  /// Get localized try again text
  String get tryAgainText => translate('try_again');

  /// Get localized network error text
  String get networkErrorText => translate('network_error');

  /// Get localized server error text
  String get serverErrorText => translate('server_error');

  /// Get localized unknown error text
  String get unknownErrorText => translate('unknown_error');

  /// Get localized no internet text
  String get noInternetText => translate('no_internet');

  /// Get localized connection timeout text
  String get connectionTimeoutText => translate('connection_timeout');

  /// Get localized invalid input text
  String get invalidInputText => translate('invalid_input');

  /// Get localized required field text
  String get requiredFieldText => translate('required_field');

  /// Get localized invalid email text
  String get invalidEmailText => translate('invalid_email');

  /// Get localized invalid phone text
  String get invalidPhoneText => translate('invalid_phone');

  /// Get localized password too short text
  String get passwordTooShortText => translate('password_too_short');

  /// Get localized passwords don't match text
  String get passwordsDontMatchText => translate('passwords_dont_match');

  /// Get localized login success text
  String get loginSuccessText => translate('login_success');

  /// Get localized login failed text
  String get loginFailedText => translate('login_failed');

  /// Get localized signup success text
  String get signupSuccessText => translate('signup_success');

  /// Get localized signup failed text
  String get signupFailedText => translate('signup_failed');

  /// Get localized logout text
  String get logoutText => translate('logout');

  /// Get localized profile text
  String get profileText => translate('profile');

  /// Get localized settings text
  String get settingsText => translate('settings');

  /// Get localized about text
  String get aboutText => translate('about');

  /// Get localized help text
  String get helpText => translate('help');

  /// Get localized contact text
  String get contactText => translate('contact');

  /// Get localized privacy policy text
  String get privacyPolicyText => translate('privacy_policy');

  /// Get localized terms of service text
  String get termsOfServiceText => translate('terms_of_service');

  /// Get localized version text
  String get versionText => translate('version');

  /// Get localized build text
  String get buildText => translate('build');

  /// Get localized last updated text
  String get lastUpdatedText => translate('last_updated');

  /// Get localized created by text
  String get createdByText => translate('created_by');

  /// Get localized all rights reserved text
  String get allRightsReservedText => translate('all_rights_reserved');

  /// Get supported locales
  List<Locale> get supportedLocalesList => supportedLocales;

  /// Check if locale is supported
  bool isLocaleSupported(Locale locale) => supportedLocales.contains(locale);

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      case 'te':
        return 'తెలుగు';
      case 'ta':
        return 'தமிழ்';
      case 'bn':
        return 'বাংলা';
      case 'gu':
        return 'ગુજરાતી';
      case 'mr':
        return 'मराठी';
      case 'kn':
        return 'ಕನ್ನಡ';
      case 'ml':
        return 'മലയാളം';
      case 'pa':
        return 'ਪੰਜਾਬੀ';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  /// Get current locale display name
  String get currentLocaleDisplayName => getLocaleDisplayName(_currentLocale);

  /// Get translation statistics
  Map<String, dynamic> getTranslationStats() {
    final stats = <String, dynamic>{};

    for (final locale in supportedLocales) {
      final translations = _translations[locale.languageCode];
      stats[locale.languageCode] = {
        'translation_count': translations?.length ?? 0,
        'coverage_percentage': translations != null
            ? (translations.length / _translations['en']!.length * 100)
                .toStringAsFixed(1)
            : '0.0',
      };
    }

    return stats;
  }
}
