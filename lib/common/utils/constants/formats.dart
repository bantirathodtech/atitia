/// Centralized constants for date, time, and number formatting patterns.
///
/// These constants ensure consistent formatting across the entire application
/// and facilitate easy updates for localization or format changes.
class FormatConstants {
  // MARK: - Date Formats
  // ==========================================

  /// Display format for user-facing dates: "25/12/2023"
  /// Suitable for Indian/European date format standards
  static const String dateDisplay = 'dd/MM/yyyy';

  /// Service format for database and API communication: "2023-12-25"
  /// ISO-like format optimized for storage, sorting, and service interoperability
  static const String dateService = 'yyyy-MM-dd';

  // MARK: - Time Formats
  // ==========================================

  /// 12-hour time format with AM/PM indicator: "02:30 PM"
  /// User-friendly format for time display
  static const String time12Hour = 'hh:mm a';

  /// 24-hour time format without AM/PM: "14:30"
  /// Military and international time standard
  static const String time24Hour = 'HH:mm';

  // MARK: - Combined DateTime Formats
  // ==========================================

  /// Combined date and time for user display: "25/12/2023 02:30 PM"
  /// Comprehensive format showing both date and time in user-friendly manner
  static const String dateTimeDisplay = 'dd/MM/yyyy hh:mm a';

  /// Combined date and time for storage and services: "2023-12-25 14:30:00"
  /// Machine-readable format for databases and API payloads
  static const String dateTimeStorage = 'yyyy-MM-dd HH:mm:ss';

  // MARK: - Number Formats
  // ==========================================

  /// Currency format for Indian Rupees: "₹1,234.56"
  /// Includes currency symbol, thousands separators, and two decimal places
  static const String currencyINR = '₹#,##0.00';

  /// Decimal format for general numeric values: "1,234.56"
  /// Standard format with thousands separators and two decimal places
  static const String decimalFormat = '#,##0.00';

  // MARK: - Additional Date Variants
  // ==========================================

  /// Abbreviated month format: "25 Dec 2023"
  /// Compact date format with abbreviated month name
  static const String dateDisplayShort = 'dd MMM yyyy';

  /// Full month name format: "25 December 2023"
  /// Formal date format with full month name
  static const String dateDisplayLong = 'dd MMMM yyyy';

  /// Month and year only: "December 2023"
  /// Useful for calendar views and month-based displays
  static const String monthYear = 'MMMM yyyy';
}
