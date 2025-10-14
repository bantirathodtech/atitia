import 'package:atitia/common/utils/extensions/string_extensions.dart';

import '../constants/app.dart';
import '../constants/validation.dart';

/// Authentication-specific validators for user input.
///
/// ## Purpose:
/// - Validate auth-related forms (login, signup, OTP)
/// - Provide consistent validation messages
/// - Handle auth-specific business rules
///
/// ## Usage:
/// ```dart
/// AuthValidators.validatePhone(phoneNumber)
/// AuthValidators.validateOtp(otpCode)
/// ```
class AuthValidators {
  // MARK: - Phone Validation
  // ==========================================

  /// Validates phone number for authentication
  ///
  /// ## Validation Rules:
  /// - Required field
  /// - Exactly 10 digits
  /// - Only numeric characters
  /// - Valid Indian mobile prefix (6-9)
  ///
  /// ## Returns:
  /// - `null` if valid
  /// - Error message string if invalid
  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return AppConstants.requiredFieldError;
    }

    final cleanPhone = phone.trim().digitsOnly;

    if (cleanPhone.length != 10) {
      return 'Phone number must be 10 digits';
    }

    if (!cleanPhone.isValidPhone()) {
      return AppConstants.invalidPhoneError;
    }

    return null;
  }

  // MARK: - OTP Validation
  // ==========================================

  /// Validates OTP code
  ///
  /// ## Validation Rules:
  /// - Required field
  /// - Exactly 6 digits
  /// - Only numeric characters
  ///
  /// ## Returns:
  /// - `null` if valid
  /// - Error message string if invalid
  static String? validateOtp(String? otp) {
    if (otp == null || otp.trim().isEmpty) {
      return 'OTP is required';
    }

    final cleanOtp = otp.trim().digitsOnly;

    if (cleanOtp.length != 6) {
      return 'OTP must be 6 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleanOtp)) {
      return 'OTP must contain only digits';
    }

    return null;
  }

  // MARK: - Password Validation
  // ==========================================

  /// Validates password strength
  ///
  /// ## Validation Rules:
  /// - Required field
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  /// - At least one special character
  ///
  /// ## Returns:
  /// - `null` if valid
  /// - Error message string if invalid
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < ValidationConstants.minPasswordLength) {
      return 'Password must be at least ${ValidationConstants.minPasswordLength} characters';
    }

    if (!password.isValidPassword()) {
      return 'Password must include uppercase, lowercase, number, and special character';
    }

    return null;
  }

  // MARK: - Name Validation
  // ==========================================

  /// Validates user name
  ///
  /// ## Validation Rules:
  /// - Required field
  /// - Only letters and spaces
  /// - Maximum 50 characters
  ///
  /// ## Returns:
  /// - `null` if valid
  /// - Error message string if invalid
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }

    final cleanName = name.trim();

    if (cleanName.length > ValidationConstants.maxNameLength) {
      return 'Name must be less than ${ValidationConstants.maxNameLength} characters';
    }

    if (!cleanName.isValidName()) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // MARK: - Date of Birth Validation
  // ==========================================

  /// Validates date of birth in DD/MM/YYYY format
  ///
  /// ## Validation Rules:
  /// - Required field
  /// - Valid DD/MM/YYYY format
  /// - Must be in the past
  /// - User must be at least 18 years old
  ///
  /// ## Returns:
  /// - `null` if valid
  /// - Error message string if invalid
  static String? validateDateOfBirth(String? dob) {
    if (dob == null || dob.trim().isEmpty) {
      return 'Date of birth is required';
    }

    // Validate format (DD/MM/YYYY)
    final dateRegex = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    if (!dateRegex.hasMatch(dob)) {
      return 'Please enter date in DD/MM/YYYY format';
    }

    // Parse the date
    final parts = dob.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'Invalid date format';
    }

    // Check if date is valid
    try {
      final birthDate = DateTime(year, month, day);

      // Check if date is in future
      if (birthDate.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      // Check if user is at least 18 years old
      final minimumAgeDate =
          DateTime.now().subtract(const Duration(days: 365 * 18));
      if (birthDate.isAfter(minimumAgeDate)) {
        return 'You must be at least 18 years old';
      }

      return null;
    } catch (e) {
      return 'Invalid date';
    }
  }
}
