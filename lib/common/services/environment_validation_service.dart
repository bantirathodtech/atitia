/// 🔍 ENVIRONMENT VALIDATION SERVICE
///
/// This service validates that all required environment variables and credentials
/// are properly configured before the app starts.
library;

import 'package:flutter/foundation.dart';

import '../constants/environment_config.dart';

class EnvironmentValidationService {
  /// Validate all environment configuration
  ///
  /// FIXED: Async credential validation
  /// Flutter recommends: Validate runtime-loaded credentials asynchronously
  /// Changed from: Only validating static const fields
  /// Changed to: Also validate async-loaded Google OAuth credentials
  static Future<bool> validateEnvironment() async {
    // Check if all required static credentials are present
    if (!EnvironmentConfig.validateCredentials()) {
      return false;
    }

    // Check for missing optional credentials (static fields)
    final missingCredentials = EnvironmentConfig.getMissingCredentials();
    if (missingCredentials.isNotEmpty) {
      // Log missing credentials for debugging (non-critical)
      if (kDebugMode) {
        debugPrint(
            '⚠️ Missing optional credentials: ${missingCredentials.join(', ')}');
      }
    }

    // Validate Firebase configuration
    if (!_validateFirebaseConfig()) {
      return false;
    }

    // Validate Google Sign-In configuration (async - includes runtime credentials)
    if (!await _validateGoogleSignInConfigAsync()) {
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

  /// Validate Google Sign-In configuration (async)
  ///
  /// FIXED: Async credential validation
  /// Flutter recommends: Validate runtime-loaded credentials asynchronously
  /// Changed from: Only validating static const fields
  /// Changed to: Also validate async-loaded Google OAuth credentials from secure storage
  static Future<bool> _validateGoogleSignInConfigAsync() async {
    try {
      // Use async validation which checks both static and runtime credentials
      final isValid = await EnvironmentConfig.validateCredentialsAsync();

      if (!isValid && kDebugMode) {
        // Log which credentials are missing for debugging
        try {
          await EnvironmentConfig.getGoogleSignInWebClientIdAsync();
          debugPrint('✅ Google Web Client ID: Configured');
        } catch (e) {
          debugPrint('❌ Google Web Client ID: Not configured');
        }

        try {
          await EnvironmentConfig.getGoogleSignInAndroidClientIdAsync();
          debugPrint('✅ Google Android Client ID: Configured');
        } catch (e) {
          debugPrint('❌ Google Android Client ID: Not configured');
        }

        try {
          await EnvironmentConfig.getGoogleSignInIosClientIdAsync();
          debugPrint('✅ Google iOS Client ID: Configured');
        } catch (e) {
          debugPrint('❌ Google iOS Client ID: Not configured');
        }

        try {
          await EnvironmentConfig.getGoogleSignInClientSecretAsync();
          debugPrint('✅ Google Client Secret: Configured');
        } catch (e) {
          debugPrint('❌ Google Client Secret: Not configured');
        }
      }

      return isValid;
    } catch (e) {
      debugPrint('⚠️ Google Sign-In configuration validation error: $e');
      return false;
    }
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
      debugPrint(
          '⚠️ Missing optional credentials: ${missingCredentials.join(', ')}');
    } else {
      debugPrint('✅ All required credentials are configured');
    }
  }
}
