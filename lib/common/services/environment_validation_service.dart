/// 🔍 ENVIRONMENT VALIDATION SERVICE
///
/// This service validates that all required environment variables and credentials
/// are properly configured before the app starts.
library;

import 'package:flutter/foundation.dart';

import '../constants/environment_config.dart';

class EnvironmentValidationService {
  /// Validate all environment configuration
  static Future<bool> validateEnvironment() async {
    // Check if all required credentials are present
    if (!EnvironmentConfig.validateCredentials()) {
      return false;
    }

    // Check for missing optional credentials
    final missingCredentials = EnvironmentConfig.getMissingCredentials();
    if (missingCredentials.isNotEmpty) {
      // Log missing credentials for debugging (non-critical)
      if (kDebugMode) {
        debugPrint('⚠️ Missing optional credentials: ${missingCredentials.join(', ')}');
      }
    }

    // Validate Firebase configuration
    if (!_validateFirebaseConfig()) {
      return false;
    }

    // Validate Google Sign-In configuration
    if (!_validateGoogleSignInConfig()) {
      return false;
    }

    // Validate reCAPTCHA configuration
    if (!_validateRecaptchaConfig()) {
      return false;
    }

    return true;
  }

  /// Validate Firebase configuration
  static bool _validateFirebaseConfig() {
    final requiredFields = [
      EnvironmentConfig.firebaseProjectId,
      EnvironmentConfig.firebaseWebApiKey,
      EnvironmentConfig.firebaseAndroidApiKey,
      EnvironmentConfig.firebaseIosApiKey,
      EnvironmentConfig.firebaseWebAppId,
      EnvironmentConfig.firebaseAndroidAppId,
      EnvironmentConfig.firebaseIosAppId,
    ];

    for (final field in requiredFields) {
      if (field.isEmpty || field.contains('REPLACE_WITH')) {
        return false;
      }
    }

    return true;
  }

  /// Validate Google Sign-In configuration
  static bool _validateGoogleSignInConfig() {
    final requiredFields = [
      EnvironmentConfig.googleSignInWebClientId,
      EnvironmentConfig.googleSignInAndroidClientId,
      EnvironmentConfig.googleSignInIosClientId,
    ];

    for (final field in requiredFields) {
      if (field.isEmpty || field.contains('REPLACE_WITH')) {
        return false;
      }
    }

    return true;
  }

  /// Validate reCAPTCHA configuration
  static bool _validateRecaptchaConfig() {
    if (EnvironmentConfig.recaptchaEnterpriseSiteKey.isEmpty ||
        EnvironmentConfig.recaptchaEnterpriseSiteKey.contains('REPLACE_WITH')) {
      return false;
    }

    return true;
  }

  /// Get environment summary for debugging
  static Map<String, dynamic> getEnvironmentSummary() {
    return {
      'appName': EnvironmentConfig.appName,
      'appVersion': EnvironmentConfig.appVersion,
      'environment': EnvironmentConfig.environmentName,
      'firebaseProjectId': EnvironmentConfig.firebaseProjectId,
      'bundleId': EnvironmentConfig.bundleId,
      'packageName': EnvironmentConfig.packageName,
      'isDebugMode': EnvironmentConfig.isDebugMode,
      'isReleaseMode': EnvironmentConfig.isReleaseMode,
      'missingCredentials': EnvironmentConfig.getMissingCredentials(),
    };
  }

  /// Print environment summary to console
  static void printEnvironmentSummary() {
    final missingCredentials = EnvironmentConfig.getMissingCredentials();
    if (missingCredentials.isNotEmpty) {
      debugPrint('⚠️ Missing optional credentials: ${missingCredentials.join(', ')}');
    } else {
      debugPrint('✅ All required credentials are configured');
    }
  }
}
