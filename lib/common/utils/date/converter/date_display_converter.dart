import 'package:atitia/common/utils/date/extensions/datetime_extensions.dart';

import '../../constants/app.dart';

/// Handles conversion, parsing, and validation for display date format (DD/MM/YYYY).
///
/// This converter is specifically designed for user-facing date representations
/// and includes validation logic appropriate for form inputs and display purposes.
class DateDisplayConverter {
  // MARK: - Constants
  // ==========================================

  static const int _minYear = 1900;
  static const String _expectedFormat = 'DD/MM/YYYY';

  // MARK: - Parsing Methods
  // ==========================================

  /// Parse a display format string (DD/MM/YYYY) into a DateTime object.
  ///
  /// [dateString]: Date string in DD/MM/YYYY format
  ///
  /// Throws [FormatException] if the string cannot be parsed or represents an invalid date
  ///
  /// Example:
  /// ```dart
  /// final date = DateDisplayConverter.parse('25/12/2023');
  /// // Returns: DateTime(2023, 12, 25)
  /// ```
  static DateTime parse(String dateString) {
    final parts = dateString.split('/');

    // Validate format structure
    if (parts.length != 3) {
      throw FormatException(
          'Invalid date format. Expected $_expectedFormat but got "$dateString"');
    }

    // Parse components with null safety
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      throw FormatException(
          'Date components must be valid numbers: "$dateString"');
    }

    // Validate component ranges before creating DateTime
    _validateDateComponents(day, month, year);

    // Let DateTime constructor validate the actual calendar date
    try {
      return DateTime(year, month, day);
    } catch (e) {
      throw FormatException('Invalid calendar date: "$dateString"');
    }
  }

  // MARK: - Formatting Methods
  // ==========================================

  /// Format a DateTime object into display format string (DD/MM/YYYY).
  ///
  /// [dateTime]: The DateTime object to format
  ///
  /// Returns: String in DD/MM/YYYY format
  ///
  /// Example:
  /// ```dart
  /// final display = DateDisplayConverter.format(DateTime(2023, 12, 25));
  /// // Returns: '25/12/2023'
  /// ```
  static String format(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    return '$day/$month/$year';
  }

  // MARK: - Validation Methods
  // ==========================================

  /// Validate a display format date string for basic format and calendar validity.
  ///
  /// This method performs format validation only. Business rules (like future date
  /// restrictions) should be handled at the use case level.
  ///
  /// [value]: Date string to validate in DD/MM/YYYY format
  ///
  /// Returns: null if valid, error message string if invalid
  static String? validate(String? value) {
    // Check for empty value
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldError;
    }

    final parts = value.split('/');

    // Validate format structure
    if (parts.length != 3) {
      return 'Enter date as $_expectedFormat';
    }

    try {
      // Parse and validate components
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      // Check for valid numeric components
      if (day == null || month == null || year == null) {
        return 'Date must contain only digits';
      }

      // Validate component ranges
      final componentError = _validateDateComponents(day, month, year);
      if (componentError != null) return componentError;

      // Validate actual calendar date
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return 'Enter a valid calendar date';
      }

      return null;
    } on FormatException catch (e) {
      return e.message;
    } catch (e) {
      return 'Enter a valid date ($_expectedFormat)';
    }
  }

  // MARK: - Business Logic Methods
  // ==========================================

  /// Calculate current age from a date of birth in display format.
  ///
  /// [dobString]: Date of birth string in DD/MM/YYYY format
  ///
  /// Returns: Age in years as integer
  ///
  /// Example:
  /// ```dart
  /// final age = DateDisplayConverter.calculateAge('15/08/1990');
  /// // Returns: 33 (as of 2023)
  /// ```
  static int calculateAge(String dobString) {
    final dob = parse(dobString);
    return dob.age;
  }

  /// Check if a date of birth meets minimum age requirement.
  ///
  /// [dobString]: Date of birth string in DD/MM/YYYY format
  /// [minAge]: Minimum required age (default: 18)
  ///
  /// Returns: true if age meets or exceeds minimum requirement
  static bool meetsMinimumAge(String dobString, {int minAge = 18}) {
    return calculateAge(dobString) >= minAge;
  }

  // MARK: - Private Helper Methods
  // ==========================================

  /// Validate individual date components for reasonable ranges.
  ///
  /// Returns: null if valid, error message if invalid
  static String? _validateDateComponents(int day, int month, int year) {
    // Validate day range
    if (day < 1 || day > 31) {
      return 'Day must be between 1 and 31';
    }

    // Validate month range
    if (month < 1 || month > 12) {
      return 'Month must be between 1 and 12';
    }

    // Validate year range (reasonable bounds for most applications)
    final currentYear = DateTime.now().year;
    if (year < _minYear || year > currentYear) {
      return 'Year must be between $_minYear and $currentYear';
    }

    return null;
  }
}
