/// Validation patterns and rules for user input.
///
/// ## Purpose:
/// - Standardize input validation across forms
/// - Ensure data consistency
/// - Provide clear validation messages
///
/// ## Usage:
/// ```dart
/// if (ValidationConstants.emailPattern.hasMatch(email)) {
///   // Valid email
/// }
/// ```
class ValidationConstants {
  // MARK: - Email Validation
  // ==========================================

  /// Regular expression for validating email addresses
  ///
  /// ## Pattern Explanation:
  /// - Allows letters, numbers, dots, hyphens before @
  /// - Requires domain with at least 2-4 character TLD
  static final RegExp emailPattern =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  /// Alias for emailPattern (for backward compatibility)
  static String get emailRegex => r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // MARK: - Phone Validation
  // ==========================================

  /// Regular expression for validating Indian phone numbers
  ///
  /// ## Pattern Explanation:
  /// - Starts with 6-9 (Indian mobile number range)
  /// - Followed by 9 digits (total 10 digits)
  static final RegExp phonePattern = RegExp(r'^[6-9]\d{9}$');

  /// Alias for phonePattern (for backward compatibility)
  static String get phoneRegex => r'^[6-9]\d{9}$';

  // MARK: - Name Validation
  // ==========================================

  /// Regular expression for validating person names
  ///
  /// ## Pattern Explanation:
  /// - Allows letters (a-z, A-Z) and spaces
  /// - No numbers or special characters
  static final RegExp namePattern = RegExp(r'^[a-zA-Z ]+$');

  // MARK: - Password Validation
  // ==========================================

  /// Regular expression for strong passwords
  ///
  /// ## Pattern Explanation:
  /// - At least 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  /// - At least one special character
  static final RegExp passwordPattern = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  // MARK: - Input Length Limits
  // ==========================================

  /// Maximum length for person names
  static const int maxNameLength = 50;

  /// Minimum length for passwords
  static const int minPasswordLength = 8;

  /// Maximum length for general text fields
  static const int maxTextFieldLength = 500;
}
