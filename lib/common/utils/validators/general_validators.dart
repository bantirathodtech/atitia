import 'package:atitia/common/utils/extensions/string_extensions.dart';

import '../constants/app.dart';

/// General-purpose validators for various form inputs.
///
/// ## Purpose:
/// - Validate common form fields (email, text, numbers)
/// - Provide reusable validation logic
/// - Handle general input validation
///
/// ## Usage:
/// ```dart
/// GeneralValidators.validateEmail(email)
/// GeneralValidators.validateRequired(fieldName, value)
/// ```
class GeneralValidators {
  // MARK: - Common Field Validators
  // ==========================================

  /// Validates email address (optional field)
  ///
  /// ## Validation Rules:
  /// - If provided, must be valid email format
  /// - Empty or null is considered valid (optional)
  ///
  /// ## Returns:
  /// - `null` if valid or empty
  /// - Error message string if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return null; // Optional field
    }

    final cleanEmail = email.trim();

    if (!cleanEmail.isValidEmail()) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates required field
  ///
  /// ## Parameters:
  /// - `fieldName`: The display name of the field (for error message)
  /// - `value`: The value to validate
  ///
  /// ## Returns:
  /// - `null` if valid
  /// - Error message string if invalid
  static String? validateRequired(String fieldName, String? value) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // MARK: - Length Validators
  // ==========================================

  /// Validates minimum length requirement
  static String? validateMinLength(String? value, int minLength,
      {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }

    if (value.length < minLength) {
      final name = fieldName ?? 'Field';
      return '$name must be at least $minLength characters';
    }

    return null;
  }

  /// Validates maximum length requirement
  static String? validateMaxLength(String? value, int maxLength,
      {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    if (value.length > maxLength) {
      final name = fieldName ?? 'Field';
      return '$name must be less than $maxLength characters';
    }

    return null;
  }

  // MARK: - Number Validators
  // ==========================================

  /// Validates that string represents a valid number
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    final number = double.tryParse(value);
    if (number == null) {
      final name = fieldName ?? 'Field';
      return '$name must be a valid number';
    }

    return null;
  }

  /// Validates positive number (greater than zero)
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final number = double.parse(value!);
    if (number <= 0) {
      final name = fieldName ?? 'Field';
      return '$name must be greater than zero';
    }

    return null;
  }

  // MARK: - File Validators
  // ==========================================

  /// Validates file size against maximum limit
  static String? validateFileSize(int fileSizeInBytes, int maxSizeInBytes,
      {String? fileType}) {
    if (fileSizeInBytes > maxSizeInBytes) {
      final maxSizeMB = (maxSizeInBytes / (1024 * 1024)).toStringAsFixed(1);
      final fileTypeText = fileType != null ? '$fileType ' : '';
      return '${fileTypeText}File size must be less than ${maxSizeMB}MB';
    }
    return null;
  }

  /// Validates profile photo file size
  static String? validateProfilePhotoSize(int fileSizeInBytes) {
    return validateFileSize(
      fileSizeInBytes,
      AppConstants.maxProfilePhotoSize,
      fileType: 'Profile photo',
    );
  }

  /// Validates Aadhaar document file size
  static String? validateAadhaarFileSize(int fileSizeInBytes) {
    return validateFileSize(
      fileSizeInBytes,
      AppConstants.maxAadhaarFileSize,
      fileType: 'Aadhaar document',
    );
  }
}
