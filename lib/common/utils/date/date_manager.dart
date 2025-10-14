import 'package:atitia/common/utils/date/extensions/datetime_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/utils/date/converter/date_service_converter.dart';
import '../constants/app.dart';
import 'converter/date_display_converter.dart';

/// Centralized facade for all date-related operations across the application.
///
/// Provides a unified interface for date conversions, validations, and utilities
/// while delegating specific format handling to specialized converters.
class DateManager {
  // MARK: - Current Time Accessors
  // ==========================================

  /// Current local date and time
  static DateTime get now => DateTime.now();

  /// Current time formatted for display (DD/MM/YYYY)
  static String get nowDisplay => DateDisplayConverter.format(now);

  /// Current time in service format (ISO 8601 UTC)
  static String get nowService => DateServiceConverter.toService(now);

  /// Current time as Firestore Timestamp
  static Timestamp get nowFirestore => Timestamp.fromDate(now);

  // MARK: - Display Format Methods (DD/MM/YYYY)
  // ==========================================

  /// Parse display format string (DD/MM/YYYY) to DateTime object
  static DateTime parseDisplay(String dateString) =>
      DateDisplayConverter.parse(dateString);

  /// Format DateTime to display string (DD/MM/YYYY)
  static String formatDisplay(DateTime dateTime) =>
      DateDisplayConverter.format(dateTime);

  /// Validate display format string with optional business rules
  static String? validateDisplay(String? value) =>
      DateDisplayConverter.validate(value);

  /// Calculate age from date of birth in display format
  static int calculateAge(String dobString) =>
      DateDisplayConverter.calculateAge(dobString);

  /// Check if date meets minimum age requirement
  static bool meetsMinimumAge(String dobString, {int minAge = 18}) =>
      calculateAge(dobString) >= minAge;

  // MARK: - Service Format Methods (ISO 8601)
  // ==========================================

  /// Convert DateTime to service format (ISO 8601 UTC)
  static String toService(DateTime dateTime) =>
      DateServiceConverter.toService(dateTime);

  /// Parse service format string to DateTime (converted to local time)
  static DateTime fromService(String serviceString) =>
      DateServiceConverter.fromService(serviceString);

  /// Validate service format string
  static String? validateService(String? value) =>
      DateServiceConverter.validate(value);

  // MARK: - Firestore Methods
  // ==========================================

  /// Convert DateTime to Firestore Timestamp
  static Timestamp toFirestore(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);

  /// Convert Firestore Timestamp to DateTime
  static DateTime fromFirestore(Timestamp timestamp) => timestamp.toDate();

  // MARK: - Cross-Format Conversion Methods
  // ==========================================

  /// Convert display format to Firestore Timestamp
  static Timestamp displayToFirestore(String dateString) =>
      toFirestore(parseDisplay(dateString));

  /// Convert Firestore Timestamp to display format
  static String firestoreToDisplay(Timestamp timestamp) =>
      formatDisplay(fromFirestore(timestamp));

  /// Convert display format to service format
  static String displayToService(String dateString) =>
      toService(parseDisplay(dateString));

  /// Convert service format to display format
  static String serviceToDisplay(String serviceString) =>
      formatDisplay(fromService(serviceString));

  /// Convert service format to Firestore Timestamp
  static Timestamp serviceToFirestore(String serviceString) =>
      toFirestore(fromService(serviceString));

  /// Convert Firestore Timestamp to service format
  static String firestoreToService(Timestamp timestamp) =>
      toService(fromFirestore(timestamp));

  // MARK: - Business Logic Methods
  // ==========================================

  /// Get human-readable relative time from DateTime
  static String relativeTime(DateTime date) => date.relativeTime;

  /// Get human-readable relative time from Firestore Timestamp
  static String firestoreRelativeTime(Timestamp timestamp) =>
      fromFirestore(timestamp).relativeTime;

  /// Get human-readable relative time from service format string
  static String serviceRelativeTime(String serviceString) =>
      fromService(serviceString).relativeTime;

  /// Get human-readable relative time from display format string
  static String displayRelativeTime(String dateString) =>
      parseDisplay(dateString).relativeTime;

  // MARK: - Date Utility Methods
  // ==========================================

  /// Add specified number of days to a date
  static DateTime addDays(DateTime date, int days) => date.addDays(days);

  /// Subtract specified number of days from a date
  static DateTime subtractDays(DateTime date, int days) =>
      date.subtractDays(days);

  /// Check if two dates represent the same calendar day
  static bool isSameDay(DateTime date1, DateTime date2) =>
      date1.isSameDay(date2);

  /// Check if date is today
  static bool isToday(DateTime date) => date.isToday;

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) =>
      date.isSameDay(DateTime.now().subtractDays(1));

  // MARK: - Form Validation Methods
  // ==========================================

  /// Comprehensive date validation for form inputs with configurable rules
  ///
  /// [value]: The date string to validate in display format (DD/MM/YYYY)
  /// [required]: Whether the field is mandatory
  /// [minAge]: Minimum required age in years
  /// [maxAge]: Maximum allowed age in years
  /// [allowFutureDates]: Whether future dates are permitted
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateFormDate(
    String? value, {
    bool required = true,
    int? minAge,
    int? maxAge,
    bool allowFutureDates = false,
  }) {
    // Handle empty value based on required flag
    if (required && (value == null || value.trim().isEmpty)) {
      return AppConstants.requiredFieldError;
    }

    if (!required && (value == null || value.trim().isEmpty)) {
      return null;
    }

    // Validate basic format and calendar rules
    final formatError = validateDisplay(value);
    if (formatError != null) return formatError;

    // Check future date restriction
    if (!allowFutureDates) {
      final date = parseDisplay(value!);
      if (date.isAfter(DateTime.now())) {
        return 'Date cannot be in the future';
      }
    }

    // Validate age constraints
    if (minAge != null && !meetsMinimumAge(value!, minAge: minAge)) {
      return 'Must be at least $minAge years old';
    }

    if (maxAge != null) {
      final age = calculateAge(value!);
      if (age > maxAge) return 'Must be less than $maxAge years old';
    }

    return null;
  }
}
