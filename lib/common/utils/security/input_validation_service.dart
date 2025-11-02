// lib/common/utils/security/input_validation_service.dart

import 'dart:io';

/// Comprehensive input validation and sanitization service
/// Provides security-focused validation for all user inputs
class InputValidationService {
  static final InputValidationService _instance =
      InputValidationService._internal();
  factory InputValidationService() => _instance;
  InputValidationService._internal();

  /// Validate and sanitize email input
  ValidationResult validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return ValidationResult.invalid('Email is required');
    }

    final sanitizedEmail = _sanitizeInput(email.trim());

    if (_isSuspiciousInput(sanitizedEmail)) {
      return ValidationResult.invalid('Invalid email format');
    }

    if (!_isValidEmail(sanitizedEmail)) {
      return ValidationResult.invalid('Please enter a valid email address');
    }

    if (sanitizedEmail.length > 254) {
      return ValidationResult.invalid('Email address is too long');
    }

    return ValidationResult.valid(sanitizedEmail);
  }

  /// Validate and sanitize phone number input
  ValidationResult validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return ValidationResult.invalid('Phone number is required');
    }

    final sanitizedPhone = _sanitizeInput(phone.trim());

    if (_isSuspiciousInput(sanitizedPhone)) {
      return ValidationResult.invalid('Invalid phone number format');
    }

    final digitsOnly = sanitizedPhone.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length != 10) {
      return ValidationResult.invalid('Phone number must be 10 digits');
    }

    if (!_isValidPhone(digitsOnly)) {
      return ValidationResult.invalid(
          'Please enter a valid Indian phone number');
    }

    return ValidationResult.valid(digitsOnly);
  }

  /// Validate and sanitize name input
  ValidationResult validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return ValidationResult.invalid('Name is required');
    }

    final sanitizedName = _sanitizeInput(name.trim());

    if (_isSuspiciousInput(sanitizedName)) {
      return ValidationResult.invalid('Invalid name format');
    }

    if (sanitizedName.length < 2) {
      return ValidationResult.invalid('Name must be at least 2 characters');
    }

    if (sanitizedName.length > 50) {
      return ValidationResult.invalid('Name must be less than 50 characters');
    }

    if (!_isValidName(sanitizedName)) {
      return ValidationResult.invalid(
          'Name can only contain letters and spaces');
    }

    return ValidationResult.valid(sanitizedName);
  }

  /// Validate and sanitize password input
  ValidationResult validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return ValidationResult.invalid('Password is required');
    }

    if (_isSuspiciousInput(password)) {
      return ValidationResult.invalid('Invalid password format');
    }

    if (password.length < 8) {
      return ValidationResult.invalid('Password must be at least 8 characters');
    }

    if (password.length > 128) {
      return ValidationResult.invalid('Password is too long');
    }

    if (!_hasUpperCase(password)) {
      return ValidationResult.invalid(
          'Password must contain at least one uppercase letter');
    }

    if (!_hasLowerCase(password)) {
      return ValidationResult.invalid(
          'Password must contain at least one lowercase letter');
    }

    if (!_hasDigit(password)) {
      return ValidationResult.invalid(
          'Password must contain at least one number');
    }

    if (!_hasSpecialChar(password)) {
      return ValidationResult.invalid(
          'Password must contain at least one special character');
    }

    return ValidationResult.valid(password);
  }

  /// Validate and sanitize OTP input
  ValidationResult validateOTP(String? otp) {
    if (otp == null || otp.trim().isEmpty) {
      return ValidationResult.invalid('OTP is required');
    }

    final sanitizedOTP = _sanitizeInput(otp.trim());

    if (_isSuspiciousInput(sanitizedOTP)) {
      return ValidationResult.invalid('Invalid OTP format');
    }

    if (sanitizedOTP.length != 6) {
      return ValidationResult.invalid('OTP must be 6 digits');
    }

    if (!_isNumeric(sanitizedOTP)) {
      return ValidationResult.invalid('OTP must contain only digits');
    }

    return ValidationResult.valid(sanitizedOTP);
  }

  /// Validate and sanitize address input
  ValidationResult validateAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return ValidationResult.invalid('Address is required');
    }

    final sanitizedAddress = _sanitizeInput(address.trim());

    if (_isSuspiciousInput(sanitizedAddress)) {
      return ValidationResult.invalid('Invalid address format');
    }

    if (sanitizedAddress.length < 10) {
      return ValidationResult.invalid('Address must be at least 10 characters');
    }

    if (sanitizedAddress.length > 200) {
      return ValidationResult.invalid(
          'Address must be less than 200 characters');
    }

    return ValidationResult.valid(sanitizedAddress);
  }

  /// Validate and sanitize Aadhaar number input
  ValidationResult validateAadhaar(String? aadhaar) {
    if (aadhaar == null || aadhaar.trim().isEmpty) {
      return ValidationResult.invalid('Aadhaar number is required');
    }

    final sanitizedAadhaar = _sanitizeInput(aadhaar.trim());

    if (_isSuspiciousInput(sanitizedAadhaar)) {
      return ValidationResult.invalid('Invalid Aadhaar number format');
    }

    final digitsOnly = sanitizedAadhaar.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length != 12) {
      return ValidationResult.invalid('Aadhaar number must be 12 digits');
    }

    return ValidationResult.valid(digitsOnly);
  }

  /// Validate and sanitize PAN number input
  ValidationResult validatePAN(String? pan) {
    if (pan == null || pan.trim().isEmpty) {
      return ValidationResult.invalid('PAN number is required');
    }

    final sanitizedPAN = _sanitizeInput(pan.trim().toUpperCase());

    if (_isSuspiciousInput(sanitizedPAN)) {
      return ValidationResult.invalid('Invalid PAN number format');
    }

    if (!_isValidPAN(sanitizedPAN)) {
      return ValidationResult.invalid('Please enter a valid PAN number');
    }

    return ValidationResult.valid(sanitizedPAN);
  }

  /// Validate file upload
  ValidationResult validateFile(File? file,
      {int maxSizeInMB = 10, List<String>? allowedExtensions}) {
    if (file == null) {
      return ValidationResult.invalid('File is required');
    }

    if (!file.existsSync()) {
      return ValidationResult.invalid('File does not exist');
    }

    final fileSizeInBytes = file.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > maxSizeInMB) {
      return ValidationResult.invalid(
          'File size must be less than ${maxSizeInMB}MB');
    }

    if (allowedExtensions != null) {
      final extension = file.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        return ValidationResult.invalid(
            'File type not allowed. Allowed types: ${allowedExtensions.join(', ')}');
      }
    }

    return ValidationResult.valid(file.path);
  }

  /// Validate and sanitize general text input
  ValidationResult validateText(String? text,
      {int? maxLength, int? minLength, bool allowEmpty = false}) {
    if (text == null || text.trim().isEmpty) {
      if (allowEmpty) {
        return ValidationResult.valid('');
      }
      return ValidationResult.invalid('This field is required');
    }

    if (_isSuspiciousInput(text.trim())) {
      return ValidationResult.invalid('Invalid text format');
    }

    final sanitizedText = _sanitizeInput(text.trim());

    if (minLength != null && sanitizedText.length < minLength) {
      return ValidationResult.invalid(
          'Text must be at least $minLength characters');
    }

    if (maxLength != null && sanitizedText.length > maxLength) {
      return ValidationResult.invalid(
          'Text must be less than $maxLength characters');
    }

    return ValidationResult.valid(sanitizedText);
  }

  /// Sanitize input to prevent injection attacks
  String _sanitizeInput(String input) {
    return input
        .replaceAll(
            RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '')
        .trim();
  }

  /// Check for suspicious patterns in input
  bool _isSuspiciousInput(String input) {
    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'union\s+select', caseSensitive: false),
      RegExp(r'drop\s+table', caseSensitive: false),
      RegExp(r'delete\s+from', caseSensitive: false),
      RegExp(r'insert\s+into', caseSensitive: false),
      RegExp(r'update\s+set', caseSensitive: false),
      RegExp(r'exec\s*\(', caseSensitive: false),
      RegExp(r'eval\s*\(', caseSensitive: false),
    ];

    for (final pattern in suspiciousPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone format
  bool _isValidPhone(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  /// Validate name format
  bool _isValidName(String name) {
    return RegExp(r'^[a-zA-Z ]+$').hasMatch(name);
  }

  /// Validate PAN format
  bool _isValidPAN(String pan) {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(pan);
  }

  /// Check if string contains uppercase letter
  bool _hasUpperCase(String text) {
    return RegExp(r'[A-Z]').hasMatch(text);
  }

  /// Check if string contains lowercase letter
  bool _hasLowerCase(String text) {
    return RegExp(r'[a-z]').hasMatch(text);
  }

  /// Check if string contains digit
  bool _hasDigit(String text) {
    return RegExp(r'[0-9]').hasMatch(text);
  }

  /// Check if string contains special character
  bool _hasSpecialChar(String text) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);
  }

  /// Check if string is numeric
  bool _isNumeric(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? sanitizedValue;

  ValidationResult._(this.isValid, this.errorMessage, this.sanitizedValue);

  factory ValidationResult.valid(String value) {
    return ValidationResult._(true, null, value);
  }

  factory ValidationResult.invalid(String error) {
    return ValidationResult._(false, error, null);
  }

  /// Get the sanitized value or throw error
  String get value {
    if (!isValid) {
      throw ValidationException(errorMessage ?? 'Invalid input');
    }
    return sanitizedValue ?? '';
  }

  /// Get the sanitized value or return default
  String get valueOrEmpty => sanitizedValue ?? '';

  /// Get the sanitized value or return default value
  String getValueOrDefault(String defaultValue) =>
      sanitizedValue ?? defaultValue;
}

/// Custom exception for validation errors
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}
