import 'package:atitia/common/utils/extensions/string_extensions.dart';

import '../../../core/services/localization/internationalization_service.dart';
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
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  static String _msg(
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

  static String _fieldLabel(String? fieldName) {
    if (fieldName != null && fieldName.trim().isNotEmpty) {
      return fieldName;
    }
    return _msg('validationFieldDefaultName', 'Field');
  }

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
      return _msg(
        'validationEmailInvalidAddress',
        'Please enter a valid email address',
      );
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
      return _msg(
        'validationFieldNameRequired',
        '{field} is required',
        parameters: {'field': fieldName},
      );
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
          ? _msg(
              'validationFieldNameRequired',
              '{field} is required',
              parameters: {'field': fieldName},
            )
          : _msg('validationFieldRequired', 'This field is required');
    }

    if (value.length < minLength) {
      final name = _fieldLabel(fieldName);
      return _msg(
        'validationFieldMinLength',
        '{field} must be at least {min} characters',
        parameters: {
          'field': name,
          'min': minLength.toString(),
        },
      );
    }

    return null;
  }

  /// Validates maximum length requirement
  static String? validateMaxLength(String? value, int maxLength,
      {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    if (value.length > maxLength) {
      final name = _fieldLabel(fieldName);
      return _msg(
        'validationFieldMaxLength',
        '{field} must be less than {max} characters',
        parameters: {
          'field': name,
          'max': maxLength.toString(),
        },
      );
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
      final name = _fieldLabel(fieldName);
      return _msg(
        'validationFieldMustBeNumber',
        '{field} must be a valid number',
        parameters: {'field': name},
      );
    }

    return null;
  }

  /// Validates positive number (greater than zero)
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final number = double.parse(value!);
    if (number <= 0) {
      final name = _fieldLabel(fieldName);
      return _msg(
        'validationFieldMustBeGreaterThanZero',
        '{field} must be greater than zero',
        parameters: {'field': name},
      );
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
      final fileTypeText = fileType != null && fileType.isNotEmpty
          ? '$fileType '
          : '';
      return _msg(
        'validationFileSizeExceededDetailed',
        '{fileType}File size must be less than {max}MB',
        parameters: {
          'fileType': fileTypeText,
          'max': maxSizeMB,
        },
      );
    }
    return null;
  }

  /// Validates profile photo file size
  static String? validateProfilePhotoSize(int fileSizeInBytes) {
    return validateFileSize(
      fileSizeInBytes,
      AppConstants.maxProfilePhotoSize,
      fileType: _msg('fileTypeProfilePhoto', 'Profile photo'),
    );
  }

  /// Validates Aadhaar document file size
  static String? validateAadhaarFileSize(int fileSizeInBytes) {
    return validateFileSize(
      fileSizeInBytes,
      AppConstants.maxAadhaarFileSize,
      fileType: _msg('fileTypeAadhaarDocument', 'Aadhaar document'),
    );
  }
}
