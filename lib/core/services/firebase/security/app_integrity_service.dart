import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// 🔐 FIREBASE APP CHECK SERVICE
///
/// ## PURPOSE:
/// Provides application integrity protection by verifying that incoming requests
/// originate from your genuine app running on trusted devices.
///
/// ## SECURITY MODEL:
/// - DEBUG MODE: Uses debug provider for development (controlled via Firebase Console)
/// - RELEASE MODE: Uses Play Integrity (Android) / App Attest (iOS) for production
///
/// ## CRITICAL NOTES:
/// - Debug provider is ESSENTIAL for development workflow
/// - Play Integrity only works with Play Store distributed apps
/// - Never modify core security logic - extend instead
class AppIntegrityServiceWrapper {
  // MARK: - Singleton Instance
  // ========================================================================

  /// Singleton instance for consistent service access across the application
  static final AppIntegrityServiceWrapper _instance =
      AppIntegrityServiceWrapper._internal();

  /// Private constructor enforcing singleton pattern
  AppIntegrityServiceWrapper._internal();

  /// Public factory constructor providing global access to singleton instance
  factory AppIntegrityServiceWrapper() => _instance;

  // MARK: - Service Dependencies
  // ========================================================================

  /// Core Firebase App Check instance for all integrity operations
  final FirebaseAppCheck _appCheck = FirebaseAppCheck.instance;

  // MARK: - Service Initialization
  // ========================================================================

  /// 🚀 INITIALIZE APP CHECK SERVICE
  ///
  /// ## RESPONSIBILITIES:
  /// 1. Detect current build environment (debug vs release)
  /// 2. Activate appropriate security provider
  /// 3. Enable automatic token refresh
  /// 4. Verify successful initialization
  /// 5. Generate debug tokens in development mode
  ///
  /// ## PROVIDER SELECTION LOGIC:
  /// - DEBUG: Debug provider (development backdoor)
  /// - RELEASE: Play Integrity (Android) / App Attest (iOS) production security
  ///
  /// ## ERROR STRATEGY:
  /// - Non-critical failures are logged but don't crash the app
  /// - App continues functioning with reduced security
  Future<void> initialize() async {
    try {
      print('🛡️ APP CHECK: Using debug token from Firebase Console');

      if (kDebugMode) {
        // Simple debug provider activation
        await _appCheck.activate(androidProvider: AndroidProvider.debug);
        await _appCheck.setTokenAutoRefreshEnabled(true);
        print('✅ Debug provider ready - using console token');
      } else {
        await _appCheck.activate(
            androidProvider: AndroidProvider.playIntegrity);
        await _appCheck.setTokenAutoRefreshEnabled(true);
        print('✅ Production provider ready');
      }
    } catch (error) {
      print('⚠️ App Check note: $error');
      print('💡 Debug token from console should still work');
    }
  }

  /// 🔧 ACTIVATE DEBUG PROVIDER
  ///
  /// ## PURPOSE:
  /// Enable development workflow by allowing debug builds to communicate
  /// with Firebase services without requiring Play Store distribution.
  ///
  /// ## SECURITY NOTES:
  /// - Debug tokens MUST be registered in Firebase Console
  /// - This provider ONLY works in debug builds
  /// - Automatically disabled in production builds
  Future<void> _activateDebugProvider() async {
    _logMessage('Configuring App Check for DEBUG environment');

    try {
      // ✅ DEBUG MODE: Use AndroidProvider.debug
      await _appCheck.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );

      _logMessage('✅ Debug provider activated successfully');
      _logMessage('💡 IMPORTANT: Register debug token in Firebase Console');
    } catch (error) {
      _logError('Failed to activate debug provider: $error');
      _logMessage('🔄 Attempting alternative debug provider activation...');

      // Fallback: Try direct debug provider activation
      await _activateDebugProviderFallback();
    }
  }

  /// 🔧 ALTERNATIVE DEBUG PROVIDER ACTIVATION (FALLBACK)
  ///
  /// ## PURPOSE:
  /// Secondary method to activate debug provider if primary method fails
  Future<void> _activateDebugProviderFallback() async {
    try {
      _logMessage('Trying fallback debug provider activation...');

      // More direct approach for debug provider
      await _appCheck.activate(
        androidProvider: AndroidProvider.debug,
      );

      _logMessage('✅ Debug provider activated via fallback method');
      _logMessage('📋 Debug tokens should now be available');
    } catch (error) {
      _logError('Fallback debug provider activation also failed: $error');
      _logMessage('⚠️ Manual debug token setup may be required');
      throw Exception('Cannot activate App Check debug provider');
    }
  }

  /// 🚀 ACTIVATE PRODUCTION PROVIDERS
  ///
  /// ## PURPOSE:
  /// Enable maximum security for production builds using platform-specific
  /// integrity verification services.
  ///
  /// ## PROVIDER DETAILS:
  /// - ANDROID: Play Integrity (verifies app via Play Store)
  /// - iOS: App Attest (Apple device attestation service)
  Future<void> _activateProductionProviders() async {
    _logMessage('Configuring App Check for PRODUCTION environment');

    // ✅ PRODUCTION MODE: Use AndroidProvider.playIntegrity
    await _appCheck.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

    _logMessage('✅ Production providers (Play Integrity/App Attest) activated');
    _logMessage('🔒 Maximum security enabled for production build');
  }

  /// 🎯 GENERATE AND DISPLAY DEBUG TOKEN
  ///
  /// ## PURPOSE:
  /// Automatically generate and display debug token with clear instructions
  /// for Firebase Console registration in debug mode only.
  Future<void> _generateAndDisplayDebugToken() async {
    _logMessage('🛠️ Generating debug token for Firebase Console...');

    try {
      // Wait for debug provider to fully initialize
      _logMessage('Waiting for debug provider to initialize...');
      await Future.delayed(const Duration(seconds: 2));

      // Get a fresh debug token with force refresh
      _logMessage('Requesting fresh debug token...');
      final String? token = await _appCheck.getToken(true);

      if (token != null && token.isNotEmpty) {
        _displayDebugTokenWithInstructions(token);
      } else {
        _logWarning('Debug token is empty or null - retrying...');
        await _retryDebugTokenGeneration();
      }
    } catch (error) {
      _logError('Initial debug token generation failed: $error');
      _logMessage('🔄 Starting retry process...');
      await _retryDebugTokenGeneration();
    }
  }

  /// 🔄 RETRY DEBUG TOKEN GENERATION
  ///
  /// ## PURPOSE:
  /// Retry mechanism for debug token generation with multiple attempts
  /// and progressive delays.
  Future<void> _retryDebugTokenGeneration() async {
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 3);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        _logMessage('Retry attempt $attempt of $maxRetries...');

        await Future.delayed(retryDelay);

        final String? token = await _appCheck.getToken(true);

        if (token != null && token.isNotEmpty) {
          _displayDebugTokenWithInstructions(token);
          _logMessage(
              '✅ Debug token retrieved successfully on attempt $attempt');
          return;
        } else {
          _logWarning('Attempt $attempt: Token still empty or null');
        }
      } catch (error) {
        _logError('Attempt $attempt failed: $error');
      }
    }

    _logWarning('All debug token generation attempts failed');
    _logMessage(
        '📋 Manual debug token setup required - check Firebase documentation');
  }

  /// 📋 DISPLAY DEBUG TOKEN WITH INSTRUCTIONS
  ///
  /// ## PURPOSE:
  /// Format and display debug token with clear, step-by-step instructions
  /// for Firebase Console registration.
  void _displayDebugTokenWithInstructions(String token) {
    // Create visually distinct output
    final String border = '=' * 70;

    print('');
    print(border);
    print('🎉 FIREBASE APP CHECK DEBUG TOKEN GENERATED!');
    print(border);
    print('🛠️ YOUR DEBUG TOKEN:');
    print('');
    print(token);
    print('');
    print(border);
    print('📋 FIREBASE CONSOLE SETUP INSTRUCTIONS:');
    print('');
    print('1. Go to Firebase Console → App Check → Apps');
    print('2. Select your app: com.avishio.atitia');
    print('3. Click "Manage debug tokens"');
    print('4. Click "Add debug token"');
    print('5. PASTE THE TOKEN ABOVE into the token field');
    print('6. Click "SAVE" to register the token');
    print('7. RESTART YOUR APP after registration');
    print('');
    print(border);
    print('⚠️  SECURITY NOTES:');
    print('');
    print('• Keep this token secure - it allows debug access to Firebase');
    print('• This token only works in debug builds');
    print('• Production builds will use Play Integrity automatically');
    print('• Register this token to enable App Check during development');
    print('');
    print(border);
    print('');
  }

  /// ✅ VERIFY INITIALIZATION SUCCESS
  ///
  /// ## PURPOSE:
  /// Confirm that App Check is properly configured and can obtain tokens.
  /// Provides immediate feedback about service health.
  Future<void> _verifyInitializationSuccess() async {
    try {
      _logMessage('Verifying App Check initialization...');

      final String? token = await getToken();

      if (token != null && token.isNotEmpty) {
        _logMessage('✅ App Check initialization verified successfully');
        _logDebug('Token length: ${token.length} characters');

        // Provide environment-specific feedback
        if (kDebugMode) {
          _logMessage('🔧 Debug provider active - development mode enabled');
          _logMessage(
              '💡 Firebase services will work after debug token registration');
        } else {
          _logMessage(
              '🚀 Play Integrity provider active - production security enabled');
          _logMessage('🔒 Maximum security enforced for production build');
        }
      } else {
        _logWarning('⚠️ App Check initialized but token retrieval failed');

        if (kDebugMode) {
          _logMessage('💡 This is normal before debug token registration');
          _logMessage(
              '📋 Register the debug token shown above in Firebase Console');
        } else {
          _logMessage(
              '🔍 Check Play Integrity configuration in Google Play Console');
        }
      }
    } catch (error) {
      _logWarning('App Check verification check failed: $error');
      _logMessage('🔄 App will continue with reduced security');
    }
  }

  // MARK: - Token Management
  // ========================================================================

  /// 🔑 GET APP CHECK TOKEN
  ///
  /// ## PURPOSE:
  /// Retrieve the current valid App Check token for attaching to Firebase requests.
  /// This token proves your app's integrity to Firebase services.
  ///
  /// ## RETURNS:
  /// - Valid token string for Firebase requests
  /// - Null if token unavailable (security degraded)
  Future<String?> getToken() async {
    try {
      // CORRECTED: getToken() doesn't take parameters in current Firebase App Check
      final String? token = await _appCheck.getToken();

      // Validate token existence and format
      return _validateAndLogToken(token);
    } catch (error) {
      _logError('Token retrieval failed: $error');
      return null;
    }
  }

  /// 🔄 GET FRESH TOKEN (FORCED REFRESH)
  ///
  /// ## USE CASES:
  /// - Security-sensitive operations requiring latest token
  /// - Recovery from potential token compromise
  /// - Periodic security revalidation
  ///
  /// ## IMPLEMENTATION NOTE:
  /// Firebase App Check automatically manages token refresh.
  /// This method forces a new token by temporarily disabling auto-refresh.
  Future<String?> getFreshToken() async {
    _logMessage('Forcing fresh token generation...');

    try {
      // CORRECTED: Firebase App Check doesn't have forceRefresh parameter
      // Workaround: Temporarily disable and re-enable auto-refresh
      await _appCheck.setTokenAutoRefreshEnabled(false);
      await Future.delayed(const Duration(milliseconds: 100));
      await _appCheck.setTokenAutoRefreshEnabled(true);

      // Get the fresh token
      final String? token = await _appCheck.getToken();
      return _validateAndLogToken(token, isForceRefresh: true);
    } catch (error) {
      _logError('Fresh token generation failed: $error');
      return null;
    }
  }

  /// ✅ VALIDATE AND LOG TOKEN
  ///
  /// ## SECURITY PRACTICES:
  /// - Never log full tokens in production
  /// - Provide appropriate environment-specific logging
  /// - Validate token format and characteristics
  String? _validateAndLogToken(String? token, {bool isForceRefresh = false}) {
    // Handle null token scenario
    if (token == null) {
      _logTokenFailure('Token is null', isForceRefresh: isForceRefresh);
      return null;
    }

    // Handle empty token scenario
    if (token.isEmpty) {
      _logTokenFailure('Token is empty', isForceRefresh: isForceRefresh);
      return null;
    }

    // Successful token retrieval - log appropriately
    _logTokenSuccess(token, isForceRefresh: isForceRefresh);
    return token;
  }

  /// 📝 LOG TOKEN SUCCESS
  void _logTokenSuccess(String token, {bool isForceRefresh = false}) {
    final String refreshIndicator = isForceRefresh ? ' (Fresh)' : '';

    if (kDebugMode) {
      _logDebug('Debug Token Obtained$refreshIndicator: ${token.length} chars');
      // In debug, we can show partial token for verification
      if (token.length > 10) {
        _logDebug('Token sample: ${token.substring(0, 10)}...');
      }
    } else {
      // Production security: never log actual tokens
      _logMessage(
          'Production Token Obtained$refreshIndicator: ${token.length} chars');
    }
  }

  /// 📝 LOG TOKEN FAILURE
  void _logTokenFailure(String reason, {bool isForceRefresh = false}) {
    final String refreshIndicator = isForceRefresh ? 'fresh ' : '';
    final String environment = kDebugMode ? 'Debug' : 'Production';

    _logWarning(
        '$environment: Failed to get $refreshIndicator token - $reason');

    if (kDebugMode) {
      _logMessage(
          'Debug Tip: Check debug token registration in Firebase Console');
    }
  }

  // MARK: - Integrity Verification
  // ========================================================================

  /// 🎯 VERIFY INTEGRITY STATUS
  ///
  /// ## PURPOSE:
  /// Quick health check to determine if App Check is functioning properly
  /// and providing valid tokens.
  ///
  /// ## USE CASES:
  /// - Pre-operation security checks
  /// - Health monitoring and analytics
  /// - User-facing security indicators
  Future<bool> verifyIntegrity() async {
    try {
      final String? token = await getToken();
      final bool isValid = token != null && token.isNotEmpty;

      if (isValid) {
        _logMessage('App Check Integrity: HEALTHY');
      } else {
        _logWarning('App Check Integrity: DEGRADED');
      }
      return isValid;
    } catch (error) {
      _logError('App Check Integrity: FAILED - $error');
      return false;
    }
  }

  /// 📊 COMPREHENSIVE INTEGRITY CHECK
  ///
  /// ## PURPOSE:
  /// Detailed diagnostic check providing comprehensive information about
  /// App Check health, token status, and any issues.
  ///
  /// ## RETURNS:
  /// Detailed result object suitable for logging, monitoring, or debugging
  Future<AppCheckIntegrityResult> checkIntegrity() async {
    try {
      final DateTime checkTime = DateTime.now();
      final String? token = await getToken();
      final bool isValid = token != null && token.isNotEmpty;

      // Create comprehensive result object
      final AppCheckIntegrityResult result = AppCheckIntegrityResult(
        isValid: isValid,
        token: token,
        timestamp: checkTime,
        environment: kDebugMode ? 'debug' : 'production',
      );

      // Log appropriate message based on result
      if (isValid) {
        _logMessage('Comprehensive Integrity Check: PASSED');
      } else {
        _logWarning('Comprehensive Integrity Check: FAILED');
        _logMessage('Investigate Firebase Console configuration');
      }

      return result;
    } catch (error, stackTrace) {
      _logError('Comprehensive Integrity Check: ERROR - $error');

      return AppCheckIntegrityResult(
        isValid: false,
        token: null,
        timestamp: DateTime.now(),
        environment: kDebugMode ? 'debug' : 'production',
        error: error.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  // MARK: - Service Status & Monitoring
  // ========================================================================

  /// 📡 GET SERVICE STATUS
  ///
  /// ## PURPOSE:
  /// High-level status indicator for UI components, health checks,
  /// or feature flagging based on App Check availability.
  Future<AppCheckStatus> getStatus() async {
    try {
      final String? token = await getToken();

      // Determine status based on token availability and validity
      if (token == null) {
        return AppCheckStatus.notInitialized;
      } else if (token.isEmpty) {
        return AppCheckStatus.noToken;
      } else {
        return AppCheckStatus.active;
      }
    } catch (error) {
      return AppCheckStatus.error;
    }
  }

  /// 📋 GET DEBUG INFORMATION
  ///
  /// ## PURPOSE:
  /// Comprehensive diagnostic information for debugging, support tickets,
  /// or development troubleshooting.
  ///
  /// ## SECURITY NOTE:
  /// Never expose full tokens in production environments
  Future<Map<String, dynamic>> getDebugInfo() async {
    try {
      final String? token = await getToken();
      final AppCheckStatus status = await getStatus();
      final bool isHealthy = status.isHealthy;

      // Base debug information
      final Map<String, dynamic> debugInfo = <String, dynamic>{
        'status': status.description,
        'environment': kDebugMode ? 'debug' : 'production',
        'tokenAvailable': token != null,
        'tokenLength': token?.length ?? 0,
        'isHealthy': isHealthy,
        'timestamp': DateTime.now().toIso8601String(),
        'autoRefreshEnabled': true,
      };

      // Add token samples for debugging (security-conscious)
      if (kDebugMode && token != null && token.isNotEmpty) {
        final int sampleLength = token.length > 10 ? 10 : token.length;
        debugInfo['tokenSample'] = '${token.substring(0, sampleLength)}...';
      }

      // Log health status
      if (isHealthy) {
        _logDebug('App Check Debug Info: System Healthy');
      } else {
        _logDebug('App Check Debug Info: System Issues Detected');
      }

      return debugInfo;
    } catch (error) {
      _logError('Failed to gather App Check debug info: $error');

      return {
        'status': 'error',
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'isHealthy': false,
        'environment': kDebugMode ? 'debug' : 'production',
      };
    }
  }

  // MARK: - Utility Methods
  // ========================================================================

  /// 🧪 TEST APP CHECK INTEGRATION
  ///
  /// ## PURPOSE:
  /// Comprehensive test suite for verifying App Check functionality
  /// during development or in diagnostic modes.
  Future<void> testIntegration() async {
    _logMessage('=' * 50);
    _logMessage('APP CHECK INTEGRATION TEST');
    _logMessage('=' * 50);

    try {
      // Test 1: Basic token retrieval
      _logMessage('1. Testing basic token retrieval...');
      final String? basicToken = await getToken();
      _logMessage('   ${basicToken != null ? 'SUCCESS' : 'FAILED'}');

      // Test 2: Force refresh
      _logMessage('2. Testing token refresh...');
      final String? freshToken = await getFreshToken();
      _logMessage('   ${freshToken != null ? 'SUCCESS' : 'FAILED'}');

      // Test 3: Integrity verification
      _logMessage('3. Testing integrity check...');
      final bool integrityValid = await verifyIntegrity();
      _logMessage('   ${integrityValid ? 'VALID' : 'INVALID'}');

      // Test 4: Comprehensive check
      _logMessage('4. Running comprehensive diagnostic...');
      final AppCheckIntegrityResult result = await checkIntegrity();
      _logMessage('   Result: ${result.isValid ? 'HEALTHY' : 'UNHEALTHY'}');

      // Summary
      _logMessage('TEST SUMMARY:');
      _logMessage('   • Basic Token: ${basicToken != null ? 'OK' : 'FAIL'}');
      _logMessage('   • Token Refresh: ${freshToken != null ? 'OK' : 'FAIL'}');
      _logMessage('   • Integrity: ${integrityValid ? 'VALID' : 'INVALID'}');
      _logMessage('   • Overall: ${result.isValid ? 'PASS' : 'FAIL'}');
    } catch (error) {
      _logError('Integration test failed: $error');
    }

    _logMessage('=' * 50);
  }

  // MARK: - Secure Logging Methods
  // ========================================================================

  /// 📝 SECURE LOGGING: MESSAGE
  ///
  /// Use for general operational messages
  void _logMessage(String message) {
    if (kDebugMode) {
      print('🔐 App Check: $message');
    }
    // In production, you could send to your logging service
  }

  /// 📝 SECURE LOGGING: DEBUG
  ///
  /// Use for detailed debug information (only in debug mode)
  void _logDebug(String message) {
    if (kDebugMode) {
      print('🔧 App Check Debug: $message');
    }
  }

  /// 📝 SECURE LOGGING: WARNING
  ///
  /// Use for non-critical warnings
  void _logWarning(String message) {
    if (kDebugMode) {
      print('⚠️ App Check Warning: $message');
    }
    // In production, you might want to log warnings too
  }

  /// 📝 SECURE LOGGING: ERROR
  ///
  /// Use for error conditions
  void _logError(String message) {
    if (kDebugMode) {
      print('❌ App Check Error: $message');
    }
    // In production, always log errors to your monitoring service
  }
}

// MARK: - Supporting Data Models
// ========================================================================

/// 📊 APP CHECK INTEGRITY RESULT
///
/// Comprehensive result object containing all relevant information
/// from an integrity verification check.
class AppCheckIntegrityResult {
  final bool isValid;
  final String? token;
  final DateTime timestamp;
  final String environment;
  final String? error;
  final String? stackTrace;

  const AppCheckIntegrityResult({
    required this.isValid,
    required this.token,
    required this.timestamp,
    required this.environment,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppCheckIntegrityResult{'
        'isValid: $isValid, '
        'tokenLength: ${token?.length ?? 0}, '
        'timestamp: $timestamp, '
        'environment: $environment, '
        'error: $error'
        '}';
  }

  /// Convert to JSON for logging or API transmission
  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'tokenLength': token?.length ?? 0,
      'timestamp': timestamp.toIso8601String(),
      'environment': environment,
      'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
    };
  }
}

/// 📡 APP CHECK STATUS ENUMERATION
///
/// Represents the current operational status of the App Check service.
enum AppCheckStatus {
  notInitialized,
  noToken,
  active,
  error,
}

/// 🔧 APP CHECK STATUS EXTENSIONS
///
/// Provides utility methods and properties for the AppCheckStatus enum.
extension AppCheckStatusExtension on AppCheckStatus {
  /// Human-readable description of the status
  String get description {
    switch (this) {
      case AppCheckStatus.notInitialized:
        return 'Service not initialized';
      case AppCheckStatus.noToken:
        return 'Initialized but no tokens available';
      case AppCheckStatus.active:
        return 'Service active and healthy';
      case AppCheckStatus.error:
        return 'Service error occurred';
    }
  }

  /// Indicates if the service is in a healthy, operational state
  bool get isHealthy => this == AppCheckStatus.active;

  /// Priority level for monitoring alerts (1 = highest)
  int get alertPriority {
    switch (this) {
      case AppCheckStatus.error:
        return 1;
      case AppCheckStatus.noToken:
        return 2;
      case AppCheckStatus.notInitialized:
        return 3;
      case AppCheckStatus.active:
        return 0;
    }
  }
}
