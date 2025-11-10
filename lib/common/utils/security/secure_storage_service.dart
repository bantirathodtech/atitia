// lib/common/utils/security/secure_storage_service.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/services/localization/internationalization_service.dart';
import 'encryption_service.dart';

/// Enhanced secure storage service with encryption
/// Provides secure storage for sensitive data with automatic encryption/decryption
class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final EncryptionService _encryptionService = EncryptionService();
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

  /// Store sensitive data with encryption
  Future<void> storeSecureData(String key, String value) async {
    try {
      // Encrypt the data before storing
      final encryptedValue = _encryptionService.encrypt(value);
      await _secureStorage.write(key: key, value: encryptedValue);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreFailed',
        'Failed to store secure data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve sensitive data with decryption
  Future<String?> getSecureData(String key) async {
    try {
      final encryptedValue = await _secureStorage.read(key: key);
      if (encryptedValue == null) return null;

      // Decrypt the data before returning
      return _encryptionService.decrypt(encryptedValue);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveFailed',
        'Failed to retrieve secure data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store user credentials securely
  Future<void> storeUserCredentials(
      String userId, Map<String, dynamic> credentials) async {
    try {
      final credentialsJson = json.encode(credentials);
      await storeSecureData('user_credentials_$userId', credentialsJson);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreCredentialsFailed',
        'Failed to store user credentials: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve user credentials securely
  Future<Map<String, dynamic>?> getUserCredentials(String userId) async {
    try {
      final credentialsJson = await getSecureData('user_credentials_$userId');
      if (credentialsJson == null) return null;

      return json.decode(credentialsJson) as Map<String, dynamic>;
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveCredentialsFailed',
        'Failed to retrieve user credentials: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store authentication token securely
  Future<void> storeAuthToken(String token) async {
    try {
      await storeSecureData('auth_token', token);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreAuthTokenFailed',
        'Failed to store auth token: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve authentication token securely
  Future<String?> getAuthToken() async {
    try {
      return await getSecureData('auth_token');
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveAuthTokenFailed',
        'Failed to retrieve auth token: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store user session data securely
  Future<void> storeUserSession(
      String userId, Map<String, dynamic> sessionData) async {
    try {
      final sessionJson = json.encode(sessionData);
      await storeSecureData('user_session_$userId', sessionJson);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreSessionFailed',
        'Failed to store user session: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve user session data securely
  Future<Map<String, dynamic>?> getUserSession(String userId) async {
    try {
      final sessionJson = await getSecureData('user_session_$userId');
      if (sessionJson == null) return null;

      return json.decode(sessionJson) as Map<String, dynamic>;
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveSessionFailed',
        'Failed to retrieve user session: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store sensitive user profile data
  Future<void> storeUserProfile(
      String userId, Map<String, dynamic> profileData) async {
    try {
      // Encrypt sensitive fields before storing
      final encryptedProfile = _encryptionService.encryptUserData(profileData);
      final profileJson = json.encode(encryptedProfile);
      await _secureStorage.write(
          key: 'user_profile_$userId', value: profileJson);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreProfileFailed',
        'Failed to store user profile: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve user profile data with decryption
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final profileJson =
          await _secureStorage.read(key: 'user_profile_$userId');
      if (profileJson == null) return null;

      final encryptedProfile = json.decode(profileJson) as Map<String, dynamic>;
      return _encryptionService.decryptUserData(encryptedProfile
          .map((key, value) => MapEntry(key, value.toString())));
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveProfileFailed',
        'Failed to retrieve user profile: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store API keys securely
  Future<void> storeApiKey(String keyName, String apiKey) async {
    try {
      await storeSecureData('api_key_$keyName', apiKey);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreApiKeyFailed',
        'Failed to store API key: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve API key securely
  Future<String?> getApiKey(String keyName) async {
    try {
      return await getSecureData('api_key_$keyName');
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveApiKeyFailed',
        'Failed to retrieve API key: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store payment information securely
  Future<void> storePaymentInfo(
      String userId, Map<String, dynamic> paymentInfo) async {
    try {
      final paymentJson = json.encode(paymentInfo);
      await storeSecureData('payment_info_$userId', paymentJson);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStorePaymentFailed',
        'Failed to store payment info: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve payment information securely
  Future<Map<String, dynamic>?> getPaymentInfo(String userId) async {
    try {
      final paymentJson = await getSecureData('payment_info_$userId');
      if (paymentJson == null) return null;

      return json.decode(paymentJson) as Map<String, dynamic>;
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrievePaymentFailed',
        'Failed to retrieve payment info: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store biometric authentication data
  Future<void> storeBiometricData(String userId, String biometricData) async {
    try {
      await storeSecureData('biometric_$userId', biometricData);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreBiometricFailed',
        'Failed to store biometric data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve biometric authentication data
  Future<String?> getBiometricData(String userId) async {
    try {
      return await getSecureData('biometric_$userId');
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveBiometricFailed',
        'Failed to retrieve biometric data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Store device-specific security data
  Future<void> storeDeviceSecurityData(
      String deviceId, Map<String, dynamic> securityData) async {
    try {
      final securityJson = json.encode(securityData);
      await storeSecureData('device_security_$deviceId', securityJson);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageStoreDeviceSecurityFailed',
        'Failed to store device security data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Retrieve device-specific security data
  Future<Map<String, dynamic>?> getDeviceSecurityData(String deviceId) async {
    try {
      final securityJson = await getSecureData('device_security_$deviceId');
      if (securityJson == null) return null;

      return json.decode(securityJson) as Map<String, dynamic>;
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageRetrieveDeviceSecurityFailed',
        'Failed to retrieve device security data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Check if secure data exists
  Future<bool> hasSecureData(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Delete secure data
  Future<void> deleteSecureData(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageDeleteFailed',
        'Failed to delete secure data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Delete all secure data
  Future<void> deleteAllSecureData() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageDeleteAllFailed',
        'Failed to delete all secure data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Get all stored keys
  Future<List<String>> getAllKeys() async {
    try {
      return await _secureStorage.readAll().then((map) => map.keys.toList());
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageGetKeysFailed',
        'Failed to get all keys: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Clear user-specific data
  Future<void> clearUserData(String userId) async {
    try {
      final keysToDelete = [
        'user_credentials_$userId',
        'user_session_$userId',
        'user_profile_$userId',
        'payment_info_$userId',
        'biometric_$userId',
      ];

      for (final key in keysToDelete) {
        await _secureStorage.delete(key: key);
      }
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageClearUserDataFailed',
        'Failed to clear user data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Validate storage integrity
  Future<bool> validateStorageIntegrity() async {
    try {
      // Test encryption/decryption
      const testKey = 'integrity_test';
      const testValue = 'test_data_123';

      await storeSecureData(testKey, testValue);
      final retrievedValue = await getSecureData(testKey);
      await deleteSecureData(testKey);

      return retrievedValue == testValue;
    } catch (e) {
      return false;
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final allKeys = await getAllKeys();
      final userKeys = allKeys.where((key) => key.startsWith('user_')).length;
      final apiKeys = allKeys.where((key) => key.startsWith('api_key_')).length;
      final deviceKeys =
          allKeys.where((key) => key.startsWith('device_')).length;

      return {
        'totalKeys': allKeys.length,
        'userKeys': userKeys,
        'apiKeys': apiKeys,
        'deviceKeys': deviceKeys,
        'otherKeys': allKeys.length - userKeys - apiKeys - deviceKeys,
      };
    } catch (e) {
      throw SecureStorageException(_translate(
        'secureStorageGetStatsFailed',
        'Failed to get storage stats: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }
}

/// Custom exception for secure storage errors
class SecureStorageException implements Exception {
  final String message;
  SecureStorageException(this.message);

  @override
  String toString() => 'SecureStorageException: $message';
}
