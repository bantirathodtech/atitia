// lib/core/services/security/security_hardening_service.dart

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';

import '../../di/firebase/di/firebase_service_locator.dart';
import '../../../common/constants/environment_config.dart';

/// Security hardening service for advanced security features
/// Provides encryption, data protection, and security monitoring
class SecurityHardeningService {
  static final SecurityHardeningService _instance =
      SecurityHardeningService._internal();
  factory SecurityHardeningService() => _instance;
  SecurityHardeningService._internal();

  static SecurityHardeningService get instance => _instance;

  // Logger not available - removed for now
  final _analyticsService = getIt.analytics;

  late encrypt.Encrypter _encrypter;
  late encrypt.Key _encryptionKey;
  late encrypt.IV _encryptionIV;
  bool _isInitialized = false;

  // Security settings
  static const int _minPasswordLength = 8;
  static const int _maxPasswordLength = 128;
  static const int _saltLength = 32;
  static const int _keyLength = 32;
  static const int _ivLength = 16;

  /// Initialize security service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
    // Logger not available: _logger.info call removed

      // Generate or retrieve encryption key
      await _initializeEncryption();

      _isInitialized = true;

      await _analyticsService.logEvent(
        name: 'security_service_initialized',
        parameters: {
          'encryption_enabled': true,
          'key_length': _keyLength,
          'iv_length': _ivLength,
        },
      );

    // Logger not available: _logger.info call removed
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Initialize encryption
  Future<void> _initializeEncryption() async {
    try {
      // Generate encryption key (in production, this should be stored securely)
      _encryptionKey = encrypt.Key.fromSecureRandom(_keyLength);
      _encryptionIV = encrypt.IV.fromSecureRandom(_ivLength);

      // Initialize encrypter with AES encryption
      _encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
    } catch (e) {
    // Logger not available: _logger call removed
      rethrow;
    }
  }

  /// Encrypt sensitive data
  String encryptData(String plainText) {
    if (!_isInitialized) {
      throw Exception('Security service not initialized');
    }

    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _encryptionIV);
      return encrypted.base64;
    } catch (e) {
    // Logger not available: _logger call removed
      rethrow;
    }
  }

  /// Decrypt sensitive data
  String decryptData(String encryptedText) {
    if (!_isInitialized) {
      throw Exception('Security service not initialized');
    }

    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      final decrypted = _encrypter.decrypt(encrypted, iv: _encryptionIV);
      return decrypted;
    } catch (e) {
    // Logger not available: _logger call removed
      rethrow;
    }
  }

  /// Hash password with salt
  String hashPassword(String password, {String? salt}) {
    try {
      final saltBytes = salt != null ? base64Decode(salt) : _generateSalt();

      final passwordBytes = utf8.encode(password);
      final saltedPassword = [...passwordBytes, ...saltBytes];

      final hash = sha256.convert(saltedPassword);
      return base64Encode(hash.bytes);
    } catch (e) {
    // Logger not available: _logger call removed
      rethrow;
    }
  }

  /// Generate salt for password hashing
  List<int> _generateSalt() {
    final random = Random.secure();
    return List.generate(_saltLength, (index) => random.nextInt(256));
  }

  /// Verify password against hash
  bool verifyPassword(String password, String hash, String salt) {
    try {
      final expectedHash = hashPassword(password, salt: salt);
      return expectedHash == hash;
    } catch (e) {
    // Logger not available: _logger call removed
      return false;
    }
  }

  /// Generate secure random string
  String generateSecureRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  /// Generate secure random number
  int generateSecureRandomNumber(int min, int max) {
    final random = Random.secure();
    return min + random.nextInt(max - min);
  }

  /// Validate password strength
  PasswordStrength validatePasswordStrength(String password) {
    int score = 0;
    final issues = <String>[];

    // Length check
    if (password.length < _minPasswordLength) {
      issues
          .add('Password must be at least $_minPasswordLength characters long');
    } else {
      score += 1;
    }

    if (password.length > _maxPasswordLength) {
      issues.add(
          'Password must be no more than $_maxPasswordLength characters long');
    }

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) {
      score += 1;
    } else {
      issues.add('Password must contain at least one lowercase letter');
    }

    if (password.contains(RegExp(r'[A-Z]'))) {
      score += 1;
    } else {
      issues.add('Password must contain at least one uppercase letter');
    }

    if (password.contains(RegExp(r'[0-9]'))) {
      score += 1;
    } else {
      issues.add('Password must contain at least one number');
    }

    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score += 1;
    } else {
      issues.add('Password must contain at least one special character');
    }

    // Common password check
    if (_isCommonPassword(password)) {
      issues.add('Password is too common');
      score = 0;
    }

    // Determine strength
    PasswordStrengthLevel strength;
    if (score < 2) {
      strength = PasswordStrengthLevel.weak;
    } else if (score < 4) {
      strength = PasswordStrengthLevel.medium;
    } else {
      strength = PasswordStrengthLevel.strong;
    }

    return PasswordStrength(
      strength: strength,
      score: score,
      issues: issues,
      isValid: issues.isEmpty,
    );
  }

  /// Check if password is common
  bool _isCommonPassword(String password) {
    const commonPasswords = [
      'password',
      '123456',
      '123456789',
      'qwerty',
      'abc123',
      'password123',
      'admin',
      'letmein',
      'welcome',
      'monkey',
      '1234567890',
      'password1',
      'qwerty123',
      'dragon',
      'master',
    ];

    return commonPasswords.contains(password.toLowerCase());
  }

  /// Sanitize user input
  String sanitizeInput(String input) {
    // Remove potentially dangerous characters
    String sanitized = input;
    sanitized = sanitized.replaceAll('<', '');
    sanitized = sanitized.replaceAll('>', '');
    sanitized = sanitized.replaceAll('"', '');
    sanitized = sanitized.replaceAll("'", '');
    sanitized = sanitized.replaceAll('\\', '');
    sanitized = sanitized.replaceAll('/', '');
    sanitized = sanitized.replaceAll(';', '');
    sanitized = sanitized.replaceAll('|', '');
    sanitized = sanitized.replaceAll('&', '');
    sanitized = sanitized.replaceAll('\$', '');
    sanitized = sanitized.replaceAll('`', '');
    return sanitized.trim();
  }

  /// Validate email format
  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number format
  bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Generate secure token
  String generateSecureToken({int length = 32}) {
    return generateSecureRandomString(length);
  }

  /// Generate API key
  String generateApiKey({String prefix = 'atitia'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = generateSecureRandomString(16);
    return '${prefix}_${timestamp}_$randomPart';
  }

  /// Encrypt file data
  Future<String> encryptFile(List<int> fileData) async {
    try {
      final fileBytes = fileData;
      final encrypted = _encrypter.encryptBytes(fileBytes, iv: _encryptionIV);
      return encrypted.base64;
    } catch (e) {
    // Logger not available: _logger call removed
      rethrow;
    }
  }

  /// Decrypt file data
  Future<List<int>> decryptFile(String encryptedData) async {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
      final decrypted = _encrypter.decryptBytes(encrypted, iv: _encryptionIV);
      return decrypted;
    } catch (e) {
    // Logger not available: _logger call removed
      rethrow;
    }
  }

  /// Generate digital signature
  String generateDigitalSignature(String data) {
    try {
      final bytes = utf8.encode(data);
      final digest = sha256.convert(bytes);
      return base64Encode(digest.bytes);
    } catch (e) {
    // Logger not available: _logger call removed
      rethrow;
    }
  }

  /// Verify digital signature
  bool verifyDigitalSignature(String data, String signature) {
    try {
      final expectedSignature = generateDigitalSignature(data);
      return expectedSignature == signature;
    } catch (e) {
    // Logger not available: _logger call removed
      return false;
    }
  }

  /// Generate secure session ID
  String generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = generateSecureRandomString(24);
    return '${timestamp}_$randomPart';
  }

  /// Check for security vulnerabilities
  SecurityAuditResult performSecurityAudit() {
    final issues = <String>[];
    final recommendations = <String>[];

    // Check encryption status
    if (!_isInitialized) {
      issues.add('Encryption not initialized');
      recommendations.add('Initialize encryption service');
    }

    // Check for debug mode
    if (kDebugMode) {
      issues.add('App running in debug mode');
      recommendations.add('Disable debug mode in production');
    }

    // Check for hardcoded secrets (basic check)
    if (_hasHardcodedSecrets()) {
      issues.add('Potential hardcoded secrets detected');
      recommendations.add('Remove hardcoded secrets and use secure storage');
    }

    // Generate audit result
    final auditResult = SecurityAuditResult(
      issues: issues,
      recommendations: recommendations,
      riskLevel: _calculateRiskLevel(issues.length),
      timestamp: DateTime.now(),
    );

    // Logger not available: _logger.info call removed

    return auditResult;
  }

  /// Check for hardcoded secrets (basic implementation)
  bool _hasHardcodedSecrets() {
    // This is a basic check - in production, you'd use more sophisticated tools
    // like git-secrets, truffleHog, or similar secret scanning tools
    
    // Basic validation: Check if EnvironmentConfig is properly configured
    // and doesn't contain obvious placeholder values
    
    try {
      // Import EnvironmentConfig to check for secrets
      // Note: We can't actually scan source code at runtime, so we check
      // that configuration is properly set up
      
      // Check Firebase project configuration
      final projectId = EnvironmentConfig.firebaseProjectId;
      
      // Common patterns that indicate hardcoded secrets or placeholders:
      // - Empty strings
      // - "example", "test", "placeholder", "your-project-id"
      // - API keys that look like placeholders
      
      final suspiciousPatterns = [
        'example',
        'test',
        'placeholder',
        'your-',
        'demo',
        'sample',
        'changeme',
        'todo',
      ];
      
      // Check if project ID contains suspicious patterns
      final projectIdLower = projectId.toLowerCase();
      for (final pattern in suspiciousPatterns) {
        if (projectIdLower.contains(pattern)) {
          return true; // Suspicious pattern detected
        }
      }
      
      // Check if project ID is empty or too short (likely placeholder)
      if (projectId.isEmpty || projectId.length < 5) {
        return true; // Invalid project ID
      }
      
      // In a full implementation, you would:
      // 1. Scan source code files for API key patterns (e.g., "AIza", "sk-", etc.)
      // 2. Check for hardcoded passwords or tokens
      // 3. Verify no secrets in version control
      // 4. Use static analysis tools to detect secrets
      
      return false; // No obvious hardcoded secrets detected
    } catch (e) {
      // If we can't check, assume there might be issues
      // In production, this should be logged and investigated
      return true;
    }
  }

  /// Calculate risk level
  SecurityRiskLevel _calculateRiskLevel(int issueCount) {
    if (issueCount == 0) {
      return SecurityRiskLevel.low;
    } else if (issueCount <= 2) {
      return SecurityRiskLevel.medium;
    } else {
      return SecurityRiskLevel.high;
    }
  }

  /// Get security statistics
  Map<String, dynamic> getSecurityStats() {
    return {
      'encryption_initialized': _isInitialized,
      'key_length': _keyLength,
      'iv_length': _ivLength,
      'min_password_length': _minPasswordLength,
      'max_password_length': _maxPasswordLength,
      'supported_algorithms': ['AES-256', 'SHA-256'],
    };
  }
}

/// Password strength result
class PasswordStrength {
  final PasswordStrengthLevel strength;
  final int score;
  final List<String> issues;
  final bool isValid;

  PasswordStrength({
    required this.strength,
    required this.score,
    required this.issues,
    required this.isValid,
  });
}

/// Password strength levels
enum PasswordStrengthLevel {
  weak,
  medium,
  strong,
}

/// Security audit result
class SecurityAuditResult {
  final List<String> issues;
  final List<String> recommendations;
  final SecurityRiskLevel riskLevel;
  final DateTime timestamp;

  SecurityAuditResult({
    required this.issues,
    required this.recommendations,
    required this.riskLevel,
    required this.timestamp,
  });
}

/// Security risk levels
enum SecurityRiskLevel {
  low,
  medium,
  high,
  critical,
}
