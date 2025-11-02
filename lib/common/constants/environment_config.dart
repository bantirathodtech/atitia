/// 🌍 ENVIRONMENT CONFIGURATION
///
/// This file contains ALL sensitive credentials and configuration values.
/// Keep this file secure and never commit sensitive production keys to version control.
///
/// For production, consider using environment variables or secure key management services.
library;

import 'package:flutter/foundation.dart';

class EnvironmentConfig {
  // ==========================================================================
  // APP INFORMATION
  // ==========================================================================

  /// App Name
  static const String appName = 'Atitia';

  /// App Version
  static const String appVersion = '1.0.0+1';

  /// App Description
  static const String appDescription =
      'Premium PG Management & Guest Experience Platform';

  /// App Bundle ID (iOS/macOS)
  static const String bundleId = 'com.avishio.atitia';

  /// App Package Name (Android)
  static const String packageName = 'com.avishio.atitia';

  // ==========================================================================
  // FIREBASE CONFIGURATION
  // ==========================================================================

  /// Firebase Project ID
  static const String firebaseProjectId = 'atitia-87925';

  /// Firebase Project Number
  static const String firebaseProjectNumber = '665010238088';

  /// Firebase Storage Bucket
  static const String firebaseStorageBucket =
      'atitia-87925.firebasestorage.app';

  /// Firebase Auth Domain
  static const String firebaseAuthDomain = 'atitia-87925.firebaseapp.com';

  // ==========================================================================
  // FIREBASE API KEYS (Platform Specific)
  // ==========================================================================

  /// Firebase Web API Key
  static const String firebaseWebApiKey =
      'AIzaSyArl95qqaPZNtT2_NVg9sY15t06zq5h6dg';

  /// Firebase Android API Key
  static const String firebaseAndroidApiKey =
      'AIzaSyCWFaZgLfoGlJeLIrLNK_d9xFuYfqp6XtQ';

  /// Firebase iOS API Key
  static const String firebaseIosApiKey =
      'AIzaSyCzEcqX-xF7EqTWsrqkF0mihRdwBRxUZA8';

  /// Firebase macOS API Key
  static const String firebaseMacosApiKey =
      'AIzaSyCzEcqX-xF7EqTWsrqkF0mihRdwBRxUZA8';

  /// Firebase Windows API Key
  static const String firebaseWindowsApiKey =
      'AIzaSyArl95qqaPZNtT2_NVg9sY15t06zq5h6dg';

  // ==========================================================================
  // FIREBASE APP IDs (Platform Specific)
  // ==========================================================================

  /// Firebase Web App ID
  static const String firebaseWebAppId =
      '1:665010238088:web:4ab7c29b9112469119a53d';

  /// Firebase Android App ID
  static const String firebaseAndroidAppId =
      '1:665010238088:android:27a01be236b0ad9d19a53d';

  /// Firebase iOS App ID
  static const String firebaseIosAppId =
      '1:665010238088:ios:76437d681978a96019a53d';

  /// Firebase macOS App ID
  static const String firebaseMacosAppId =
      '1:665010238088:ios:76437d681978a96019a53d';

  /// Firebase Windows App ID
  static const String firebaseWindowsAppId =
      '1:665010238088:web:128b16317971fd2819a53d';

  // ==========================================================================
  // FIREBASE MESSAGING & ANALYTICS
  // ==========================================================================

  /// Firebase Messaging Sender ID
  static const String firebaseMessagingSenderId = '665010238088';

  /// Firebase Web Measurement ID
  static const String firebaseWebMeasurementId = 'G-SBS8EXZF76';

  /// Firebase Windows Measurement ID
  static const String firebaseWindowsMeasurementId = 'G-CMR3GYQ8GB';

  // ==========================================================================
  // GOOGLE SIGN-IN CONFIGURATION
  // ==========================================================================

  /// Google Sign-In Web Client ID
  static const String googleSignInWebClientId =
      '665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com';

  /// Google Sign-In Android Client ID
  static const String googleSignInAndroidClientId =
      '665010238088-27a01be236b0ad9d19a53d.apps.googleusercontent.com';

  /// Google Sign-In iOS Client ID
  static const String googleSignInIosClientId =
      '665010238088-76437d681978a96019a53d.apps.googleusercontent.com';

  /// Google Sign-In Client Secret (for desktop platforms)
  /// TODO: Replace with your actual client secret from Google Cloud Console
  /// Get this from: Google Cloud Console → APIs & Services → Credentials → Your Web Client
  static const String googleSignInClientSecret =
      'GOCSPX-REPLACE_WITH_YOUR_ACTUAL_CLIENT_SECRET';

  // ==========================================================================
  // GOOGLE OAUTH JAVASCRIPT ORIGINS (for web development)
  // ==========================================================================

  /// Authorized JavaScript origins for Google OAuth (web development)
  static const List<String> googleOAuthJavaScriptOrigins = [
    'http://localhost:8080',
    'http://127.0.0.1:8080',
    'http://localhost:3000',
    'http://127.0.0.1:3000',
    'http://localhost:5000',
    'http://127.0.0.1:5000',
    'http://localhost:4173', // Vite preview port
    'http://127.0.0.1:4173',
    // Add your production domain here when ready
    // 'https://yourdomain.com',
  ];

  /// Authorized redirect URIs for Google OAuth (web development)
  static const List<String> googleOAuthRedirectUris = [
    'http://localhost:8080',
    'http://127.0.0.1:8080',
    'http://localhost:3000',
    'http://127.0.0.1:3000',
    'http://localhost:5000',
    'http://127.0.0.1:5000',
    'http://localhost:4173', // Vite preview port
    'http://127.0.0.1:4173',
    // Add your production domain here when ready
    // 'https://yourdomain.com',
  ];

  // ==========================================================================
  // reCAPTCHA ENTERPRISE CONFIGURATION
  // ==========================================================================

  /// reCAPTCHA Enterprise Site Key
  static const String recaptchaEnterpriseSiteKey =
      '6Lcay_ArAAAAAJyOnbVzzLGSQp_MKZGQcDIwT13p';

  /// reCAPTCHA Enterprise Debug Token (for development)
  static const String recaptchaEnterpriseDebugToken =
      'debug-token-from-firebase-console';

  // ==========================================================================
  // ANDROID CERTIFICATE CONFIGURATION
  // ==========================================================================

  /// Android Certificate Hash (SHA-1)
  static const String androidCertificateHash =
      'c35426383935af00f2f54b0bb7fc7cb6e8150f15';

  // ==========================================================================
  // SUPABASE CONFIGURATION (if using)
  // ==========================================================================

  /// Supabase URL
  static const String supabaseUrl = 'your_supabase_url_here';

  /// Supabase Anon Key
  static const String supabaseAnonKey = 'your_supabase_anon_key_here';

  // ==========================================================================
  // DEVELOPMENT vs PRODUCTION CONFIGURATION
  // ==========================================================================

  /// Check if running in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Check if running in release mode
  static bool get isReleaseMode => kReleaseMode;

  /// Get environment name
  static String get environmentName =>
      isDebugMode ? 'development' : 'production';

  // ==========================================================================
  // PLATFORM-SPECIFIC GETTERS
  // ==========================================================================

  /// Get Firebase API Key based on platform
  static String getFirebaseApiKey(String platform) {
    switch (platform.toLowerCase()) {
      case 'web':
        return firebaseWebApiKey;
      case 'android':
        return firebaseAndroidApiKey;
      case 'ios':
        return firebaseIosApiKey;
      case 'macos':
        return firebaseMacosApiKey;
      case 'windows':
        return firebaseWindowsApiKey;
      default:
        return firebaseWebApiKey; // Default to web
    }
  }

  /// Get Firebase App ID based on platform
  static String getFirebaseAppId(String platform) {
    switch (platform.toLowerCase()) {
      case 'web':
        return firebaseWebAppId;
      case 'android':
        return firebaseAndroidAppId;
      case 'ios':
        return firebaseIosAppId;
      case 'macos':
        return firebaseMacosAppId;
      case 'windows':
        return firebaseWindowsAppId;
      default:
        return firebaseWebAppId; // Default to web
    }
  }

  /// Get Google Sign-In Client ID based on platform
  static String getGoogleSignInClientId(String platform) {
    switch (platform.toLowerCase()) {
      case 'web':
        return googleSignInWebClientId;
      case 'android':
        return googleSignInAndroidClientId;
      case 'ios':
        return googleSignInIosClientId;
      default:
        return googleSignInWebClientId; // Default to web
    }
  }

  /// Get reCAPTCHA site key based on environment
  static String get recaptchaSiteKey {
    return isDebugMode
        ? recaptchaEnterpriseDebugToken
        : recaptchaEnterpriseSiteKey;
  }

  // ==========================================================================
  // SECURITY VALIDATION
  // ==========================================================================

  /// Validate that all required credentials are present
  static bool validateCredentials() {
    final requiredFields = [
      firebaseProjectId,
      firebaseWebApiKey,
      firebaseAndroidApiKey,
      firebaseIosApiKey,
      googleSignInWebClientId,
      googleSignInAndroidClientId,
      googleSignInIosClientId,
      recaptchaEnterpriseSiteKey,
    ];

    return requiredFields.every(
      (field) => field.isNotEmpty && !field.contains('REPLACE_WITH'),
    );
  }

  /// Get missing credentials for debugging
  static List<String> getMissingCredentials() {
    final missing = <String>[];

    if (googleSignInClientSecret.contains('REPLACE_WITH')) {
      missing.add('Google Sign-In Client Secret');
    }

    // Skip reCAPTCHA debug token check in development since App Check is disabled
    if (isReleaseMode &&
        recaptchaEnterpriseDebugToken.contains(
          'debug-token-from-firebase-console',
        )) {
      missing.add('reCAPTCHA Enterprise Debug Token');
    }

    if (supabaseUrl.contains('your_supabase_url_here')) {
      missing.add('Supabase URL');
    }

    if (supabaseAnonKey.contains('your_supabase_anon_key_here')) {
      missing.add('Supabase Anon Key');
    }

    return missing;
  }
}
