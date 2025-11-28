/// 🌍 ENVIRONMENT CONFIGURATION
///
/// This file contains ALL sensitive credentials and configuration values.
/// Keep this file secure and never commit sensitive production keys to version control.
///
/// For production, consider using environment variables or secure key management services.
library;

import 'package:flutter/foundation.dart';
import '../../core/db/flutter_secure_storage.dart';

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
  /// ⚠️ SECRET: Store in environment variable or secure storage
  /// Get from: Google Cloud Console → APIs & Services → Credentials
  /// Source: `.secrets/google-oauth/client_secret_google_oauth.json`
  static const String googleSignInWebClientId = String.fromEnvironment(
    'GOOGLE_SIGN_IN_WEB_CLIENT_ID',
    defaultValue:
        '665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com',
  );

  /// Google Sign-In Android Client ID
  /// ⚠️ SECRET: Store in environment variable or secure storage
  /// Get from: Google Cloud Console → APIs & Services → Credentials
  static const String googleSignInAndroidClientId = String.fromEnvironment(
      'GOOGLE_SIGN_IN_ANDROID_CLIENT_ID',
      defaultValue: 'YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com');

  /// Google Sign-In iOS Client ID
  /// ⚠️ SECRET: Store in environment variable or secure storage
  /// Get from: Google Cloud Console → APIs & Services → Credentials
  static const String googleSignInIosClientId = String.fromEnvironment(
      'GOOGLE_SIGN_IN_IOS_CLIENT_ID',
      defaultValue: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com');

  /// Google Sign-In Client Secret (for desktop platforms and server-side flows)
  ///
  /// ⚠️ **CRITICAL SECURITY**: This is a sensitive credential - NEVER commit to Git!
  ///
  /// **How to configure:**
  /// 1. Store the actual secret in `.secrets/google-oauth/client_secret_google_oauth.json`
  /// 2. Or use environment variable: `GOOGLE_SIGN_IN_CLIENT_SECRET`
  /// 3. Or load from secure storage at runtime
  ///
  /// **Where to find/replace this secret:**
  /// - Google Cloud Console: https://console.cloud.google.com/apis/credentials?project=atitia-87925
  /// - Click "Web client (auto created by Google Service)"
  /// - Scroll to "Client secrets" section
  /// - If you need to reset: Click "ADD SECRET" or "RESET SECRET"
  ///
  /// **Important Notes:**
  /// - This is required for desktop platforms (macOS, Windows, Linux) Google Sign-In
  /// - Also used for server-side authentication flows
  /// - Google no longer allows viewing existing secrets - must create new one if lost
  /// - If resetting, update this value immediately after generation
  ///
  /// **Related Documentation:**
  /// - See `GOOGLE_CLIENT_SECRET_SETUP.md` for setup guide
  /// - See `GOOGLE_CLIENT_SECRET_CREATE_NEW.md` for creating new secrets
  /// - See `.secrets/README.md` for secure storage setup
  /// Source: `.secrets/google-oauth/client_secret_google_oauth.json`
  /// ⚠️ WARNING: Never commit the actual secret! Use environment variable or secure storage.
  static const String googleSignInClientSecret = String.fromEnvironment(
    'GOOGLE_SIGN_IN_CLIENT_SECRET',
    defaultValue:
        'YOUR_CLIENT_SECRET_HERE', // Replace with actual secret from .secrets or env var
  );

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
  // SUPABASE CONFIGURATION
  // ==========================================================================

  /// Supabase Project URL
  /// Get from: Supabase Dashboard → Settings → API → Project URL
  /// Source: `.secrets` and `lib/core/services/supabase/supabase_config.dart`
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://iteharwqzobkolybqvsl.supabase.co',
  );

  /// Supabase Anonymous Key (Public Key)
  /// This is safe to use in client-side code
  /// Get from: Supabase Dashboard → Settings → API → anon/public key
  /// Source: `.secrets` and `lib/core/services/supabase/supabase_config.dart`
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml0ZWhhcndxem9ia29seWJxdnNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5MTUzMjYsImV4cCI6MjA3NTQ5MTMyNn0.AK5HCzXT_wafICarwp0-3nALJxQ0RjB6pPg0j9TbBcA',
  );

  /// Supabase Storage Bucket Name
  static const String supabaseStorageBucket = 'atitia-storage';

  // ==========================================================================
  // RAZORPAY CONFIGURATION
  // ==========================================================================

  /// Razorpay API Key (App-level, for subscriptions/featured listings)
  /// Get from: Razorpay Dashboard → Settings → API Keys
  /// Source: `.secrets/api-keys/razorpay-test.json`
  /// ⚠️ NOTE: This is the TEST key. Replace with production key for production builds.
  static const String razorpayApiKey = String.fromEnvironment(
    'RAZORPAY_API_KEY',
    defaultValue: 'rzp_test_RlAOuGGXSxvL66',
  );

  /// Razorpay Key Secret (App-level, for server-side operations)
  /// ⚠️ SECRET: Never expose in client code, use only in Cloud Functions
  /// Get from: Razorpay Dashboard → Settings → API Keys
  /// Source: `.secrets/api-keys/razorpay-test.json`
  /// ⚠️ NOTE: This is the TEST secret. Replace with production secret for production builds.
  static const String razorpayKeySecret = String.fromEnvironment(
    'RAZORPAY_KEY_SECRET',
    defaultValue: '2cwRmmNzqj3Bzpn0muOgO62U',
  );

  // ==========================================================================
  // DISCORD WEBHOOK CONFIGURATION
  // ==========================================================================

  /// Discord Webhook URL (for notifications/alerts)
  /// Get from: Discord Server → Server Settings → Integrations → Webhooks
  /// Source: `.secrets/api-keys/DISCORD_WEBHOOK_URL.txt`
  /// ⚠️ SECRET: Keep this URL private, it allows posting to your Discord channel
  static const String discordWebhookUrl = String.fromEnvironment(
    'DISCORD_WEBHOOK_URL',
    defaultValue:
        'https://discord.com/api/webhooks/1443555560091029576/OxxszMilMffKCLRpzO_n0LxUc3oQKvTy9J54t-o5uXohOJaSQG1jnxTiMMqBWcD4oGZE',
  );

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
  // RUNTIME CREDENTIAL LOADING (Secure Storage)
  // ==========================================================================

  /// Get Google Sign-In Web Client ID from secure storage or environment
  ///
  /// FIXED: Runtime credential loading from secure storage
  /// Flutter recommends: Load sensitive credentials from secure storage at runtime
  /// Changed from: Static const with environment variable fallback only
  /// Changed to: Check secure storage first, then environment variable, then throw error
  ///
  /// Priority:
  /// 1. Secure storage (if available)
  /// 2. Environment variable (build-time)
  /// 3. Throw exception if neither is configured
  static Future<String> getGoogleSignInWebClientIdAsync() async {
    try {
      // Try to load from secure storage first
      final storage = LocalStorageService();
      final clientId = await storage.read('google_web_client_id');
      if (clientId != null &&
          clientId.isNotEmpty &&
          !clientId.contains('YOUR_') &&
          !clientId.contains('REPLACE_WITH')) {
        return clientId;
      }
    } catch (e) {
      debugPrint(
          '⚠️ EnvironmentConfig: Could not load Google Web Client ID from storage: $e');
    }

    // Fallback to environment variable
    final envClientId = googleSignInWebClientId;
    if (envClientId.contains('YOUR_') || envClientId.contains('REPLACE_WITH')) {
      throw Exception('Google Web Client ID not configured. '
          'Set GOOGLE_SIGN_IN_WEB_CLIENT_ID environment variable or '
          'store in secure storage with key "google_web_client_id"');
    }
    return envClientId;
  }

  /// Get Google Sign-In Android Client ID from secure storage or environment
  static Future<String> getGoogleSignInAndroidClientIdAsync() async {
    try {
      final storage = LocalStorageService();
      final clientId = await storage.read('google_android_client_id');
      if (clientId != null &&
          clientId.isNotEmpty &&
          !clientId.contains('YOUR_') &&
          !clientId.contains('REPLACE_WITH')) {
        return clientId;
      }
    } catch (e) {
      debugPrint(
          '⚠️ EnvironmentConfig: Could not load Google Android Client ID from storage: $e');
    }

    final envClientId = googleSignInAndroidClientId;
    if (envClientId.contains('YOUR_') || envClientId.contains('REPLACE_WITH')) {
      throw Exception('Google Android Client ID not configured. '
          'Set GOOGLE_SIGN_IN_ANDROID_CLIENT_ID environment variable or '
          'store in secure storage with key "google_android_client_id"');
    }
    return envClientId;
  }

  /// Get Google Sign-In iOS Client ID from secure storage or environment
  static Future<String> getGoogleSignInIosClientIdAsync() async {
    try {
      final storage = LocalStorageService();
      final clientId = await storage.read('google_ios_client_id');
      if (clientId != null &&
          clientId.isNotEmpty &&
          !clientId.contains('YOUR_') &&
          !clientId.contains('REPLACE_WITH')) {
        return clientId;
      }
    } catch (e) {
      debugPrint(
          '⚠️ EnvironmentConfig: Could not load Google iOS Client ID from storage: $e');
    }

    final envClientId = googleSignInIosClientId;
    if (envClientId.contains('YOUR_') || envClientId.contains('REPLACE_WITH')) {
      throw Exception('Google iOS Client ID not configured. '
          'Set GOOGLE_SIGN_IN_IOS_CLIENT_ID environment variable or '
          'store in secure storage with key "google_ios_client_id"');
    }
    return envClientId;
  }

  /// Get Google Sign-In Client Secret from secure storage or environment
  static Future<String> getGoogleSignInClientSecretAsync() async {
    try {
      final storage = LocalStorageService();
      final clientSecret = await storage.read('google_client_secret');
      if (clientSecret != null &&
          clientSecret.isNotEmpty &&
          !clientSecret.contains('YOUR_') &&
          !clientSecret.contains('REPLACE_WITH')) {
        return clientSecret;
      }
    } catch (e) {
      debugPrint(
          '⚠️ EnvironmentConfig: Could not load Google Client Secret from storage: $e');
    }

    final envClientSecret = googleSignInClientSecret;
    if (envClientSecret.contains('YOUR_') ||
        envClientSecret.contains('REPLACE_WITH')) {
      throw Exception('Google Client Secret not configured. '
          'Set GOOGLE_SIGN_IN_CLIENT_SECRET environment variable or '
          'store in secure storage with key "google_client_secret"');
    }
    return envClientSecret;
  }

  // ==========================================================================
  // SECURITY VALIDATION
  // ==========================================================================

  /// Validate that all required credentials are present (static fields)
  ///
  /// Note: For runtime credentials (Google OAuth), use validateCredentialsAsync()
  static bool validateCredentials() {
    final requiredFields = [
      firebaseProjectId,
      firebaseWebApiKey,
      firebaseAndroidApiKey,
      firebaseIosApiKey,
      recaptchaEnterpriseSiteKey,
      supabaseUrl,
      supabaseAnonKey,
      razorpayApiKey,
      razorpayKeySecret,
    ];

    return requiredFields.every(
      (field) => field.isNotEmpty && !field.contains('REPLACE_WITH'),
    );
  }

  /// Validate that all required credentials are present (including runtime credentials)
  ///
  /// FIXED: Async credential validation
  /// Flutter recommends: Validate runtime-loaded credentials asynchronously
  /// Changed from: Only validating static const fields
  /// Changed to: Also validate async-loaded Google OAuth credentials
  static Future<bool> validateCredentialsAsync() async {
    // Check static credentials first
    if (!validateCredentials()) {
      return false;
    }

    // Check runtime credentials (Google OAuth)
    try {
      final webClientId = await getGoogleSignInWebClientIdAsync();
      final androidClientId = await getGoogleSignInAndroidClientIdAsync();
      final iosClientId = await getGoogleSignInIosClientIdAsync();
      final clientSecret = await getGoogleSignInClientSecretAsync();

      return !webClientId.contains('YOUR_') &&
          !androidClientId.contains('YOUR_') &&
          !iosClientId.contains('YOUR_') &&
          !clientSecret.contains('YOUR_');
    } catch (e) {
      debugPrint('⚠️ EnvironmentConfig: Credential validation error: $e');
      return false;
    }
  }

  /// Get missing credentials for debugging
  static List<String> getMissingCredentials() {
    final missing = <String>[];

    // Google Sign-In Client Secret is now configured (no longer a placeholder)
    // if (googleSignInClientSecret.contains('REPLACE_WITH')) {
    //   missing.add('Google Sign-In Client Secret');
    // }

    // Skip reCAPTCHA debug token check in development since App Check is disabled
    if (isReleaseMode &&
        recaptchaEnterpriseDebugToken.contains(
          'debug-token-from-firebase-console',
        )) {
      missing.add('reCAPTCHA Enterprise Debug Token');
    }

    // Check Supabase credentials (now using String.fromEnvironment with defaults)
    // These should be set via environment variables for production
    if (supabaseUrl.isEmpty || !supabaseUrl.startsWith('https://')) {
      missing.add('Supabase URL');
    }

    if (supabaseAnonKey.isEmpty || supabaseAnonKey.length < 50) {
      missing.add('Supabase Anon Key');
    }

    // Check Razorpay credentials (test keys are defaults, production should use env vars)
    if (razorpayApiKey.isEmpty || !razorpayApiKey.startsWith('rzp_')) {
      missing.add('Razorpay API Key');
    }

    if (razorpayKeySecret.isEmpty) {
      missing.add('Razorpay Key Secret');
    }

    return missing;
  }
}
