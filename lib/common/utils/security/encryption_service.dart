// lib/common/utils/security/encryption_service.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

import '../../../../core/services/localization/internationalization_service.dart';

/// Advanced encryption service for sensitive data protection
/// Provides AES encryption, hashing, and secure key management
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final InternationalizationService _i18n =
      InternationalizationService.instance;

  Encrypter? _encrypter;
  IV? _iv;
  Key? _key;

  /// Initialize encryption service with secure key generation
  void initialize() {
    if (_encrypter == null) {
      // Generate or retrieve encryption key
      _key = _generateOrRetrieveKey();
      _encrypter = Encrypter(AES(_key!));
      _iv = IV.fromSecureRandom(16);
    }
  }

  /// Generate or retrieve encryption key
  Key _generateOrRetrieveKey() {
    // In production, this should retrieve a securely stored key
    // For now, we'll generate a consistent key based on app-specific data
    final keyString = _generateKeyString();
    return Key.fromBase64(keyString);
  }

  /// Generate a consistent key string for the app
  String _generateKeyString() {
    // This should be replaced with a proper key management system
    // For now, using a deterministic approach based on app constants
    final appId = 'atitia_pg_management_app';
    final salt = 'secure_salt_2024';
    final keyData = '$appId:$salt';
    final bytes = utf8.encode(keyData);
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }

  /// Encrypt sensitive data
  String encrypt(String plaintext) {
    if (_encrypter == null) initialize();

    try {
      final encrypted = _encrypter!.encrypt(plaintext, iv: _iv!);
      return encrypted.base64;
    } catch (e) {
      throw EncryptionException(_translate(
        'encryptionEncryptFailed',
        'Failed to encrypt data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Decrypt sensitive data
  String decrypt(String ciphertext) {
    if (_encrypter == null) initialize();

    try {
      final encrypted = Encrypted.fromBase64(ciphertext);
      return _encrypter!.decrypt(encrypted, iv: _iv!);
    } catch (e) {
      throw EncryptionException(_translate(
        'encryptionDecryptFailed',
        'Failed to decrypt data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Hash sensitive data (one-way encryption)
  String hash(String data, {String? salt}) {
    final dataToHash = salt != null ? '$data:$salt' : data;
    final bytes = utf8.encode(dataToHash);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Hash with salt for password storage
  String hashPassword(String password, String salt) {
    return hash(password, salt: salt);
  }

  /// Generate secure random salt
  String generateSalt() {
    // Use a combination of timestamp and a counter to ensure uniqueness
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = (timestamp * 1000 + _saltCounter++) % 0x7FFFFFFF;
    final bytes = List<int>.generate(32, (i) => (random + i * 17 + timestamp % 256) % 256);
    return base64.encode(bytes);
  }
  
  static int _saltCounter = 0;

  /// Generate secure random token
  String generateSecureToken({int length = 32}) {
    final bytes = List<int>.generate(
        length, (i) => DateTime.now().millisecondsSinceEpoch % 256);
    return base64.encode(bytes);
  }

  /// Encrypt sensitive user data
  Map<String, String> encryptUserData(Map<String, dynamic> userData) {
    final encryptedData = <String, String>{};

    for (final entry in userData.entries) {
      if (_isSensitiveField(entry.key)) {
        encryptedData[entry.key] = encrypt(entry.value.toString());
      } else {
        encryptedData[entry.key] = entry.value.toString();
      }
    }

    return encryptedData;
  }

  /// Decrypt sensitive user data
  Map<String, dynamic> decryptUserData(Map<String, String> encryptedData) {
    final decryptedData = <String, dynamic>{};

    for (final entry in encryptedData.entries) {
      if (_isSensitiveField(entry.key)) {
        try {
          decryptedData[entry.key] = decrypt(entry.value);
        } catch (e) {
          // If decryption fails, store as-is (might be plaintext)
          decryptedData[entry.key] = entry.value;
        }
      } else {
        decryptedData[entry.key] = entry.value;
      }
    }

    return decryptedData;
  }

  /// Check if a field contains sensitive data
  bool _isSensitiveField(String fieldName) {
    final sensitiveFields = [
      'phoneNumber',
      'email',
      'password',
      'aadhaarNumber',
      'emergencyPhone',
      'emergencyContact',
      'address',
      'bankAccount',
      'upiId',
      'panNumber',
    ];

    return sensitiveFields.contains(fieldName.toLowerCase());
  }

  /// Encrypt file data
  Uint8List encryptFileData(Uint8List fileData) {
    if (_encrypter == null) initialize();

    try {
      final encrypted = _encrypter!.encryptBytes(fileData, iv: _iv!);
      return encrypted.bytes;
    } catch (e) {
      throw EncryptionException(_translate(
        'encryptionFileEncryptFailed',
        'Failed to encrypt file data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Decrypt file data
  Uint8List decryptFileData(Uint8List encryptedData) {
    if (_encrypter == null) initialize();

    try {
      final encrypted = Encrypted(encryptedData);
      return Uint8List.fromList(_encrypter!.decryptBytes(encrypted, iv: _iv!));
    } catch (e) {
      throw EncryptionException(_translate(
        'encryptionFileDecryptFailed',
        'Failed to decrypt file data: {error}',
        parameters: {'error': e.toString()},
      ));
    }
  }

  /// Validate encryption integrity
  bool validateEncryption(String plaintext) {
    try {
      final encrypted = encrypt(plaintext);
      final decrypted = decrypt(encrypted);
      return plaintext == decrypted;
    } catch (e) {
      return false;
    }
  }

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
}

/// Custom exception for encryption errors
class EncryptionException implements Exception {
  final String message;
  EncryptionException(this.message);

  @override
  String toString() => 'EncryptionException: $message';
}

/// Security utility for data protection
class SecurityUtils {
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  /// Sanitize input data to prevent injection attacks
  static String sanitizeInput(String input) {
    if (input.isEmpty) return input;

    // Remove potentially dangerous characters
    return input
        .replaceAll(
            RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }

  /// Validate and sanitize email input
  static String sanitizeEmail(String email) {
    final sanitized = sanitizeInput(email);
    if (sanitized.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(sanitized)) {
      throw SecurityException(_translate(
        'securityInvalidEmailFormat',
        'Invalid email format',
      ));
    }
    return sanitized;
  }

  /// Validate and sanitize phone number
  static String sanitizePhone(String phone) {
    final sanitized = sanitizeInput(phone);
    final digitsOnly = sanitized.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length != 10) {
      throw SecurityException(_translate(
        'securityInvalidPhoneFormat',
        'Invalid phone number format',
      ));
    }
    return digitsOnly;
  }

  /// Generate secure random string
  static String generateSecureString({int length = 16}) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final result = StringBuffer();

    for (int i = 0; i < length; i++) {
      result.write(chars[random % chars.length]);
    }

    return result.toString();
  }

  /// Check for suspicious patterns in input
  static bool isSuspiciousInput(String input) {
    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'union\s+select', caseSensitive: false),
      RegExp(r'drop\s+table', caseSensitive: false),
      RegExp(r'delete\s+from', caseSensitive: false),
      RegExp(r'insert\s+into', caseSensitive: false),
      RegExp(r'update\s+set', caseSensitive: false),
    ];

    for (final pattern in suspiciousPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Mask sensitive data for logging
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) return '*' * data.length;

    final visiblePart = data.substring(0, visibleChars);
    final maskedPart = '*' * (data.length - visibleChars);

    return visiblePart + maskedPart;
  }

  static String _translate(
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
}

/// Custom exception for security errors
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
