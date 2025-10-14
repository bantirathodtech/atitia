/// Handles conversion between DateTime and service format (ISO 8601) for all external services.
///
/// This converter serves as the single source of truth for date formatting when
/// communicating with external services including Firebase, REST APIs, and GraphQL.
/// All dates are converted to UTC for consistent service communication.
class DateServiceConverter {
  // MARK: - Service Format Methods (ISO 8601)
  // ==========================================

  /// Convert DateTime to ISO 8601 format in UTC timezone for service communication.
  ///
  /// Used by:
  /// - Firebase Firestore (as string representation)
  /// - REST APIs
  /// - GraphQL APIs
  /// - Any external service requiring standardized date format
  ///
  /// [dateTime]: DateTime object to convert (local or UTC)
  ///
  /// Returns: ISO 8601 string in UTC timezone
  ///
  /// Example:
  /// ```dart
  /// final serviceDate = DateServiceConverter.toService(DateTime.now());
  /// // Returns: '2023-12-25T14:30:00.000Z'
  /// ```
  static String toService(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// Parse ISO 8601 service format string to DateTime in local timezone.
  ///
  /// [serviceString]: ISO 8601 format string from any external service
  ///
  /// Returns: DateTime object converted to local timezone
  ///
  /// Example:
  /// ```dart
  /// final localDate = DateServiceConverter.fromService('2023-12-25T14:30:00Z');
  /// // Returns: DateTime representing local time equivalent
  /// ```
  static DateTime fromService(String serviceString) {
    return DateTime.parse(serviceString).toLocal();
  }

  /// Parse ISO 8601 service format string to DateTime in UTC timezone.
  ///
  /// Use this method when you need to preserve the original UTC time
  /// without conversion to local timezone.
  ///
  /// [serviceString]: ISO 8601 format string from any external service
  ///
  /// Returns: DateTime object in UTC timezone
  static DateTime fromServiceUtc(String serviceString) {
    return DateTime.parse(serviceString).toUtc();
  }

  // MARK: - Validation Methods
  // ==========================================

  /// Validate ISO 8601 format string for service communication.
  ///
  /// [value]: Date string to validate in ISO 8601 format
  ///
  /// Returns: null if valid, error message if invalid
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date is required for service communication';
    }

    try {
      DateTime.parse(value);
      return null;
    } on FormatException {
      return 'Invalid ISO 8601 date format. Expected: YYYY-MM-DDTHH:MM:SS.mmmZ';
    } catch (e) {
      return 'Invalid date format';
    }
  }

  // MARK: - Utility Methods
  // ==========================================

  /// Get current time in service format (ISO 8601 UTC).
  ///
  /// Returns: Current time as ISO 8601 string in UTC
  static String now() {
    return toService(DateTime.now());
  }

  /// Check if service string represents a date in the future.
  ///
  /// [serviceString]: ISO 8601 format string to check
  ///
  /// Returns: true if the date is after current time
  static bool isFuture(String serviceString) {
    return fromService(serviceString).isAfter(DateTime.now());
  }

  /// Check if service string represents a date in the past.
  ///
  /// [serviceString]: ISO 8601 format string to check
  ///
  /// Returns: true if the date is before current time
  static bool isPast(String serviceString) {
    return fromService(serviceString).isBefore(DateTime.now());
  }

  /// Check if service string represents a date in UTC timezone.
  ///
  /// [serviceString]: ISO 8601 format string to check
  ///
  /// Returns: true if the string ends with 'Z' indicating UTC time
  static bool isUtc(String serviceString) {
    return serviceString.toUpperCase().endsWith('Z');
  }
}
