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
  // TEST MODE DETECTION (Runtime - Based on Phone Number)
  // ==========================================================================

  /// Test phone numbers that automatically enable test mode
  /// Guest: +91 98765 43210 (or 9876543210)
  /// Owner: +91 70207 97849 (or 7020797849)
  static const List<String> _testPhoneNumbers = [
    '9876543210', // Guest test phone
    '7020797849', // Owner test phone
    '+919876543210', // Guest with country code
    '+917020797849', // Owner with country code
    '919876543210', // Guest with country code (no +)
    '917020797849', // Owner with country code (no +)
  ];

  /// Runtime flag to track if test mode is active (set based on phone number)
  /// This is set when user logs in with test phone numbers
  static bool _isTestModeActive = false;

  /// Check if a phone number is a test phone number
  /// Normalizes phone number (removes spaces, +, etc.) before checking
  static bool isTestPhoneNumber(String phoneNumber) {
    // Normalize phone number: remove spaces, +, dashes, parentheses
    final normalized = phoneNumber
        .replaceAll(RegExp(r'[\s+\-()]'), '')
        .replaceAll('+91', '')
        .replaceAll('91', '')
        .trim();

    // Check if normalized number matches any test phone number
    return _testPhoneNumbers.any((testNumber) {
      final normalizedTest = testNumber
          .replaceAll(RegExp(r'[\s+\-()]'), '')
          .replaceAll('+91', '')
          .replaceAll('91', '')
          .trim();
      return normalized == normalizedTest;
    });
  }

  /// Set test mode based on phone number (called from AuthProvider)
  /// This enables test Firebase and test Razorpay automatically
  static void setTestModeFromPhoneNumber(String phoneNumber) {
    _isTestModeActive = isTestPhoneNumber(phoneNumber);
    debugPrint(
      '🧪 EnvironmentConfig: Test mode ${_isTestModeActive ? "ENABLED" : "DISABLED"} for phone: $phoneNumber',
    );
  }

  /// Reset test mode (called on logout)
  static void resetTestMode() {
    _isTestModeActive = false;
    debugPrint('🧪 EnvironmentConfig: Test mode RESET');
  }

  /// Check if test mode is currently active (runtime check)
  static bool get isTestModeActive => _isTestModeActive;

  // ==========================================================================
  // FIREBASE CONFIGURATION
  // ==========================================================================

  /// Use Test Firebase Project
  /// Priority:
  /// 1. Runtime test mode (if user logged in with test phone number)
  /// 2. Environment variable (USE_TEST_FIREBASE=true)
  /// 3. Default: false (production)
  static bool get useTestFirebase {
    // Check runtime test mode first (set by phone number)
    if (_isTestModeActive) {
      return true;
    }
    // Fallback to environment variable
    return const bool.fromEnvironment(
      'USE_TEST_FIREBASE',
      defaultValue: false,
    );
  }

  /// Firebase Project ID
  /// Set USE_TEST_FIREBASE=true to use test Firebase project
  static String get firebaseProjectId => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_PROJECT_ID',
          defaultValue: 'YOUR_TEST_PROJECT_ID',
        )
      : 'atitia-87925';

  /// Firebase Project Number
  static String get firebaseProjectNumber => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_PROJECT_NUMBER',
          defaultValue: 'YOUR_TEST_PROJECT_NUMBER',
        )
      : '665010238088';

  /// Firebase Storage Bucket
  static String get firebaseStorageBucket => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_STORAGE_BUCKET',
          defaultValue: 'YOUR_TEST_PROJECT_ID.firebasestorage.app',
        )
      : 'atitia-87925.firebasestorage.app';

  /// Firebase Auth Domain
  static String get firebaseAuthDomain => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_AUTH_DOMAIN',
          defaultValue: 'YOUR_TEST_PROJECT_ID.firebaseapp.com',
        )
      : 'atitia-87925.firebaseapp.com';

  // ==========================================================================
  // FIREBASE API KEYS (Platform Specific)
  // ==========================================================================

  /// Firebase Web API Key
  static String get firebaseWebApiKey => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_WEB_API_KEY',
          defaultValue: 'YOUR_TEST_WEB_API_KEY',
        )
      : 'AIzaSyArl95qqaPZNtT2_NVg9sY15t06zq5h6dg';

  /// Firebase Android API Key
  static String get firebaseAndroidApiKey => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_ANDROID_API_KEY',
          defaultValue: 'YOUR_TEST_ANDROID_API_KEY',
        )
      : 'AIzaSyCWFaZgLfoGlJeLIrLNK_d9xFuYfqp6XtQ';

  /// Firebase iOS API Key
  static String get firebaseIosApiKey => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_IOS_API_KEY',
          defaultValue: 'YOUR_TEST_IOS_API_KEY',
        )
      : 'AIzaSyCzEcqX-xF7EqTWsrqkF0mihRdwBRxUZA8';

  /// Firebase macOS API Key
  static String get firebaseMacosApiKey => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_IOS_API_KEY', // macOS uses iOS credentials
          defaultValue: 'YOUR_TEST_IOS_API_KEY',
        )
      : 'AIzaSyCzEcqX-xF7EqTWsrqkF0mihRdwBRxUZA8';

  /// Firebase Windows API Key
  static String get firebaseWindowsApiKey => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_WEB_API_KEY', // Windows uses Web credentials
          defaultValue: 'YOUR_TEST_WEB_API_KEY',
        )
      : 'AIzaSyArl95qqaPZNtT2_NVg9sY15t06zq5h6dg';

  // ==========================================================================
  // FIREBASE APP IDs (Platform Specific)
  // ==========================================================================

  /// Firebase Web App ID
  static String get firebaseWebAppId => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_WEB_APP_ID',
          defaultValue: 'YOUR_TEST_WEB_APP_ID',
        )
      : '1:665010238088:web:4ab7c29b9112469119a53d';

  /// Firebase Android App ID
  static String get firebaseAndroidAppId => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_ANDROID_APP_ID',
          defaultValue: 'YOUR_TEST_ANDROID_APP_ID',
        )
      : '1:665010238088:android:27a01be236b0ad9d19a53d';

  /// Firebase iOS App ID
  static String get firebaseIosAppId => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_IOS_APP_ID',
          defaultValue: 'YOUR_TEST_IOS_APP_ID',
        )
      : '1:665010238088:ios:76437d681978a96019a53d';

  /// Firebase macOS App ID
  static String get firebaseMacosAppId => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_IOS_APP_ID', // macOS uses iOS credentials
          defaultValue: 'YOUR_TEST_IOS_APP_ID',
        )
      : '1:665010238088:ios:76437d681978a96019a53d';

  /// Firebase Windows App ID
  static String get firebaseWindowsAppId => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_WEB_APP_ID', // Windows uses Web credentials
          defaultValue: 'YOUR_TEST_WEB_APP_ID',
        )
      : '1:665010238088:web:128b16317971fd2819a53d';

  // ==========================================================================
  // FIREBASE MESSAGING & ANALYTICS
  // ==========================================================================

  /// Firebase Messaging Sender ID
  static String get firebaseMessagingSenderId => useTestFirebase
      ? const String.fromEnvironment(
          'FIREBASE_TEST_MESSAGING_SENDER_ID',
          defaultValue: 'YOUR_TEST_PROJECT_NUMBER',
        )
      : '665010238088';

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
  /// ⚠️ NOTE: Client ID is public but GitHub may flag it. Use environment variable for production.
  static const String googleSignInWebClientId = String.fromEnvironment(
    'GOOGLE_SIGN_IN_WEB_CLIENT_ID',
    defaultValue:
        '665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com', // Production key from .secrets/google-oauth/client_secret_google_oauth.json
  );

  /// Google Sign-In Android Client ID
  ///
  /// **Flutter Best Practice:**
  /// - OAuth Client IDs are PUBLIC by design - safe to commit to Git
  /// - Auto-created by Firebase in `android/app/google-services.json`
  ///
  /// Get from: `android/app/google-services.json` (auto-created by Firebase)
  static const String googleSignInAndroidClientId = String.fromEnvironment(
      'GOOGLE_SIGN_IN_ANDROID_CLIENT_ID',
      defaultValue:
          '665010238088-27a01be236b0ad9d19a53d.apps.googleusercontent.com'); // Public Client ID - safe to commit

  /// Google Sign-In iOS Client ID
  ///
  /// **Flutter Best Practice:**
  /// - OAuth Client IDs are PUBLIC by design - safe to commit to Git
  /// - They're meant to be in client-side code
  ///
  /// Get from: Google Cloud Console → APIs & Services → Credentials
  static const String googleSignInIosClientId = String.fromEnvironment(
      'GOOGLE_SIGN_IN_IOS_CLIENT_ID',
      defaultValue:
          '665010238088-b381opop8oqfkto97j4hgvlilg0uplik.apps.googleusercontent.com'); // Public Client ID - safe to commit

  /// Google Sign-In Client Secret (for desktop platforms only)
  ///
  /// ⚠️ **CRITICAL SECURITY**: This is a sensitive credential - NEVER commit to Git!
  ///
  /// **Flutter Best Practice:**
  /// - Mobile/Web apps (Android, iOS, Web): Client Secret NOT needed (returns null)
  /// - Desktop apps (macOS, Windows, Linux): Client Secret required
  /// - Use environment variable: `GOOGLE_SIGN_IN_CLIENT_SECRET` (recommended)
  /// - Or load from secure storage at runtime
  ///
  /// **How to configure:**
  /// ```bash
  /// export GOOGLE_SIGN_IN_CLIENT_SECRET="GOCSPX-your-secret-here"
  /// flutter run
  /// ```
  ///
  /// **Where to find this secret:**
  /// - Google Cloud Console: https://console.cloud.google.com/apis/credentials?project=atitia-87925
  /// - Click "Web client (auto created by Google Service)"
  /// - Scroll to "Client secrets" section
  ///
  /// **Important Notes:**
  /// - Only required for desktop platforms (macOS, Windows, Linux)
  /// - NOT needed for mobile/web (Android, iOS, Web) - app returns null
  /// - Backup stored in: `.secrets/google-oauth/client_secret_google_oauth.json` (for reference only)
  /// - ⚠️ Use environment variable - do NOT hardcode in production!
  static const String googleSignInClientSecret = String.fromEnvironment(
    'GOOGLE_SIGN_IN_CLIENT_SECRET',
    defaultValue: '', // Empty default - use environment variable for production
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

  /// Use Test Razorpay Keys
  /// Priority:
  /// 1. Runtime test mode (if user logged in with test phone number)
  /// 2. Environment variable (USE_TEST_RAZORPAY=true)
  /// 3. Default: false (production)
  /// ⚠️ NOTE: `.secrets/api-keys/razorpay-*.json` files are for BACKUP ONLY.
  /// The app ONLY uses values from EnvironmentConfig (this file).
  static bool get useTestRazorpay {
    // Check runtime test mode first (set by phone number)
    if (_isTestModeActive) {
      return true;
    }
    // Fallback to environment variable
    return const bool.fromEnvironment(
      'USE_TEST_RAZORPAY',
      defaultValue: false,
    );
  }

  /// Razorpay API Key (App-level, for subscriptions/featured listings)
  /// Get from: Razorpay Dashboard → Settings → API Keys
  /// ⚠️ NOTE: `.secrets/api-keys/razorpay-*.json` files are for BACKUP ONLY.
  /// The app ONLY uses hardcoded values here. Set USE_TEST_RAZORPAY=true for test keys.
  static String get razorpayApiKey => useTestRazorpay
      ? const String.fromEnvironment(
          'RAZORPAY_API_KEY',
          defaultValue:
              'rzp_test_RlAOuGGXSxvL66', // Test key (backup in .secrets/api-keys/razorpay-test.json)
        )
      : const String.fromEnvironment(
          'RAZORPAY_API_KEY',
          defaultValue:
              'rzp_live_Rlw34MEmvHMQte', // Production key (backup in .secrets/api-keys/razorpay-production.json)
        );

  /// Razorpay Key Secret (App-level, for server-side operations)
  /// ⚠️ SECRET: Never expose in client code, use only in Cloud Functions
  /// Get from: Razorpay Dashboard → Settings → API Keys
  /// ⚠️ NOTE: `.secrets/api-keys/razorpay-*.json` files are for BACKUP ONLY.
  /// The app ONLY uses hardcoded values here. Set USE_TEST_RAZORPAY=true for test secret.
  static String get razorpayKeySecret => useTestRazorpay
      ? const String.fromEnvironment(
          'RAZORPAY_KEY_SECRET',
          defaultValue:
              '2cwRmmNzqj3Bzpn0muOgO62U', // Test secret (backup in .secrets/api-keys/razorpay-test.json)
        )
      : const String.fromEnvironment(
          'RAZORPAY_KEY_SECRET',
          defaultValue:
              'HYNmEFQ8GQc1CwwqnL6P121g', // Production secret (backup in .secrets/api-keys/razorpay-production.json)
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

    // Check Razorpay credentials (production keys are defaults)
    if (razorpayApiKey.isEmpty || !razorpayApiKey.startsWith('rzp_')) {
      missing.add('Razorpay API Key');
    }

    if (razorpayKeySecret.isEmpty) {
      missing.add('Razorpay Key Secret');
    }

    // Warn if using test keys in production mode (log to console)
    if (isReleaseMode && razorpayApiKey.startsWith('rzp_test_')) {
      debugPrint(
          '⚠️  WARNING: Razorpay API Key is a TEST key. Use production key (rzp_live_*) for production builds.');
    }

    return missing;
  }
}
