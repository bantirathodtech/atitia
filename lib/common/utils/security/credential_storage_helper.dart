// lib/common/utils/security/credential_storage_helper.dart

import 'package:flutter/foundation.dart';
import '../../../core/db/flutter_secure_storage.dart';
import '../../../../core/services/localization/internationalization_service.dart';

/// Helper utility for storing Google OAuth credentials in secure storage
///
/// Purpose:
/// - Provide easy methods to store credentials securely
/// - Validate credentials before storing
/// - Document where credentials come from
///
/// Usage:
/// ```dart
/// final helper = CredentialStorageHelper();
/// await helper.storeGoogleWebClientId('your-client-id');
/// await helper.storeGoogleClientSecret('your-secret');
/// ```
class CredentialStorageHelper {
  final LocalStorageService _storage = LocalStorageService();
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _translate(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  /// Store Google Sign-In Web Client ID
  ///
  /// FIXED: Helper utility for credential storage
  /// Flutter recommends: Store sensitive credentials in secure storage
  /// This helper provides a convenient way to store Google OAuth credentials
  ///
  /// Parameters:
  /// - [clientId]: The Google OAuth Web Client ID
  /// - [validate]: Whether to validate the client ID format (default: true)
  ///
  /// Returns: true if stored successfully, false otherwise
  Future<bool> storeGoogleWebClientId(String clientId,
      {bool validate = true}) async {
    try {
      if (validate && !_isValidClientId(clientId)) {
        debugPrint(
            '❌ ${_translate('credentialInvalidWebClientId', 'Invalid Google Web Client ID format')}');
        return false;
      }

      await _storage.write('google_web_client_id', clientId);
      debugPrint(
          '✅ ${_translate('credentialStoredWebClientId', 'Google Web Client ID stored in secure storage')}');
      return true;
    } catch (e) {
      debugPrint(
          '❌ ${_translate('credentialStoreWebClientIdFailure', 'Failed to store Google Web Client ID: {error}', parameters: {
            'error': e.toString()
          })}');
      return false;
    }
  }

  /// Store Google Sign-In Android Client ID
  Future<bool> storeGoogleAndroidClientId(String clientId,
      {bool validate = true}) async {
    try {
      if (validate && !_isValidClientId(clientId)) {
        debugPrint(
            '❌ ${_translate('credentialInvalidAndroidClientId', 'Invalid Google Android Client ID format')}');
        return false;
      }

      await _storage.write('google_android_client_id', clientId);
      debugPrint(
          '✅ ${_translate('credentialStoredAndroidClientId', 'Google Android Client ID stored in secure storage')}');
      return true;
    } catch (e) {
      debugPrint(
          '❌ ${_translate('credentialStoreAndroidClientIdFailure', 'Failed to store Google Android Client ID: {error}', parameters: {
            'error': e.toString()
          })}');
      return false;
    }
  }

  /// Store Google Sign-In iOS Client ID
  Future<bool> storeGoogleIosClientId(String clientId,
      {bool validate = true}) async {
    try {
      if (validate && !_isValidClientId(clientId)) {
        debugPrint(
            '❌ ${_translate('credentialInvalidIosClientId', 'Invalid Google iOS Client ID format')}');
        return false;
      }

      await _storage.write('google_ios_client_id', clientId);
      debugPrint(
          '✅ ${_translate('credentialStoredIosClientId', 'Google iOS Client ID stored in secure storage')}');
      return true;
    } catch (e) {
      debugPrint(
          '❌ ${_translate('credentialStoreIosClientIdFailure', 'Failed to store Google iOS Client ID: {error}', parameters: {
            'error': e.toString()
          })}');
      return false;
    }
  }

  /// Store Google Sign-In Client Secret
  Future<bool> storeGoogleClientSecret(String clientSecret,
      {bool validate = true}) async {
    try {
      if (validate && !_isValidClientSecret(clientSecret)) {
        debugPrint(
            '❌ ${_translate('credentialInvalidClientSecret', 'Invalid Google Client Secret format')}');
        return false;
      }

      await _storage.write('google_client_secret', clientSecret);
      debugPrint(
          '✅ ${_translate('credentialStoredClientSecret', 'Google Client Secret stored in secure storage')}');
      return true;
    } catch (e) {
      debugPrint(
          '❌ ${_translate('credentialStoreClientSecretFailure', 'Failed to store Google Client Secret: {error}', parameters: {
            'error': e.toString()
          })}');
      return false;
    }
  }

  /// Store all Google OAuth credentials at once
  ///
  /// Convenience method to store all credentials in a single call
  Future<Map<String, bool>> storeAllGoogleCredentials({
    String? webClientId,
    String? androidClientId,
    String? iosClientId,
    String? clientSecret,
  }) async {
    final results = <String, bool>{};

    if (webClientId != null) {
      results['web_client_id'] = await storeGoogleWebClientId(webClientId);
    }

    if (androidClientId != null) {
      results['android_client_id'] =
          await storeGoogleAndroidClientId(androidClientId);
    }

    if (iosClientId != null) {
      results['ios_client_id'] = await storeGoogleIosClientId(iosClientId);
    }

    if (clientSecret != null) {
      results['client_secret'] = await storeGoogleClientSecret(clientSecret);
    }

    return results;
  }

  /// Validate Google OAuth Client ID format
  ///
  /// Client IDs typically end with .apps.googleusercontent.com
  bool _isValidClientId(String clientId) {
    if (clientId.isEmpty) {
      return false;
    }
    if (clientId.contains('YOUR_') || clientId.contains('REPLACE_WITH')) {
      return false;
    }
    // Basic format check - should contain .apps.googleusercontent.com
    return clientId.contains('.apps.googleusercontent.com') ||
        clientId.length > 20; // Allow for other formats
  }

  /// Validate Google OAuth Client Secret format
  ///
  /// Client secrets typically start with GOCSPX-
  bool _isValidClientSecret(String clientSecret) {
    if (clientSecret.isEmpty) {
      return false;
    }
    if (clientSecret.contains('YOUR_') ||
        clientSecret.contains('REPLACE_WITH')) {
      return false;
    }
    // Basic format check - should start with GOCSPX- or be a reasonable length
    return clientSecret.startsWith('GOCSPX-') || clientSecret.length > 20;
  }

  /// Clear all stored Google OAuth credentials
  ///
  /// Use this to remove credentials from secure storage
  Future<void> clearAllGoogleCredentials() async {
    try {
      await _storage.delete('google_web_client_id');
      await _storage.delete('google_android_client_id');
      await _storage.delete('google_ios_client_id');
      await _storage.delete('google_client_secret');
      debugPrint(
          '✅ ${_translate('credentialClearedAll', 'All Google OAuth credentials cleared from secure storage')}');
    } catch (e) {
      debugPrint(
          '⚠️ ${_translate('credentialClearFailure', 'Failed to clear credentials: {error}', parameters: {
            'error': e.toString()
          })}');
    }
  }

  /// Check if credentials are stored
  ///
  /// Returns a map indicating which credentials are stored
  Future<Map<String, bool>> checkStoredCredentials() async {
    final results = <String, bool>{};

    try {
      final webId = await _storage.read('google_web_client_id');
      results['web_client_id'] = webId != null && webId.isNotEmpty;

      final androidId = await _storage.read('google_android_client_id');
      results['android_client_id'] = androidId != null && androidId.isNotEmpty;

      final iosId = await _storage.read('google_ios_client_id');
      results['ios_client_id'] = iosId != null && iosId.isNotEmpty;

      final secret = await _storage.read('google_client_secret');
      results['client_secret'] = secret != null && secret.isNotEmpty;
    } catch (e) {
      debugPrint(
          '⚠️ ${_translate('credentialCheckFailure', 'Failed to check stored credentials: {error}', parameters: {
            'error': e.toString()
          })}');
    }

    return results;
  }
}
