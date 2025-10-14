import 'package:atitia/common/utils/date/converter/date_service_converter.dart';

import '../../constants/formats.dart';
import '../converter/date_display_converter.dart';

/// Extension methods for DateTime class providing app-specific functionality.
///
/// These extensions enable fluent, readable date operations throughout the application
/// while maintaining consistency in date handling and formatting.
extension DateTimeExtensions on DateTime {
  // MARK: - Formatting Extensions
  // ==========================================

  /// Convert to user-friendly display format (DD/MM/YYYY).
  String get toDisplayFormat => DateDisplayConverter.format(this);

  /// Convert to service format (ISO 8601 UTC) for external communication.
  String get toServiceFormat => DateServiceConverter.toService(this);

  /// Format DateTime using predefined format constants.
  ///
  /// [format]: One of the FormatConstants (dateDisplay, time12Hour, etc.)
  ///
  /// Returns: Formatted string according to the specified format
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().formatWith(FormatConstants.dateTimeDisplay)
  /// ```
  String formatWith(String format) {
    switch (format) {
      case FormatConstants.dateDisplay:
        return toDisplayFormat;
      case FormatConstants.dateService:
        return toServiceFormat;
      case FormatConstants.time12Hour:
        return to12HourFormat;
      case FormatConstants.time24Hour:
        return to24HourFormat;
      case FormatConstants.dateTimeDisplay:
        return '$toDisplayFormat $to12HourFormat';
      case FormatConstants.dateTimeStorage:
        return toServiceFormat.replaceFirst('T', ' ').replaceFirst('Z', '');
      default:
        return toDisplayFormat; // Fallback to display format
    }
  }

  // MARK: - Time Formatting Extensions
  // ==========================================

  /// Format as 12-hour time with AM/PM indicator.
  ///
  /// Example: '02:30 PM', '11:45 AM'
  String get to12HourFormat {
    final hour = this.hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }

  /// Format as 24-hour time without AM/PM indicator.
  ///
  /// Example: '14:30', '23:45'
  String get to24HourFormat {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');

    return '$hourStr:$minuteStr';
  }

  // MARK: - Temporal Validation Extensions
  // ==========================================

  /// Check if this date represents today's date (ignoring time).
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if this date is in the past relative to current time.
  bool get isPast => isBefore(DateTime.now());

  /// Check if this date is in the future relative to current time.
  bool get isFuture => isAfter(DateTime.now());

  /// Check if this date is within the last 7 days from current time.
  bool get isRecent {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return isAfter(weekAgo) && !isFuture;
  }

  /// Check if this date falls on a weekday (Monday through Friday).
  bool get isWeekday {
    return weekday >= DateTime.monday && weekday <= DateTime.friday;
  }

  /// Check if this date falls on a weekend (Saturday or Sunday).
  bool get isWeekend {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  // MARK: - Age Calculation Extensions
  // ==========================================

  /// Calculate current age from this date (assumed to be birth date).
  ///
  /// Returns: Age in years as integer
  int get age {
    final now = DateTime.now();
    int calculatedAge = now.year - year;

    // Adjust age if birthday hasn't occurred yet this year
    if (now.month < month || (now.month == month && now.day < day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }

  /// Check if age from this date meets or exceeds minimum requirement.
  ///
  /// [minAge]: Minimum required age in years
  ///
  /// Returns: true if current age >= minAge
  bool isAtLeastAge(int minAge) => age >= minAge;

  // MARK: - Date Boundary Extensions
  // ==========================================

  /// Get the start of this day (00:00:00.000).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get the end of this day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get the first day of the month for this date.
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get the last day of the month for this date.
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  // MARK: - Date Manipulation Extensions
  // ==========================================

  /// Add specified number of days to this date.
  ///
  /// [days]: Number of days to add (can be negative to subtract)
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract specified number of days from this date.
  ///
  /// [days]: Number of days to subtract
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add specified number of months to this date, handling year rollover.
  ///
  /// [months]: Number of months to add
  DateTime addMonths(int months) => DateTime(year, month + months, day);

  /// Add specified number of years to this date.
  ///
  /// [years]: Number of years to add
  DateTime addYears(int years) => DateTime(year + years, month, day);

  /// Calculate absolute difference in days from another date.
  ///
  /// [other]: DateTime to compare with
  ///
  /// Returns: Absolute number of days difference
  int daysDifference(DateTime other) => difference(other).inDays.abs();

  // MARK: - Date Comparison Extensions
  // ==========================================

  /// Check if this date represents the same calendar day as another date.
  ///
  /// [other]: DateTime to compare with
  ///
  /// Returns: true if year, month, and day are identical
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Check if this date is after another date (ignoring time components).
  ///
  /// [other]: DateTime to compare with
  ///
  /// Returns: true if this date is chronologically after the other date
  bool isAfterDate(DateTime other) {
    return startOfDay.isAfter(other.startOfDay);
  }

  /// Check if this date is before another date (ignoring time components).
  ///
  /// [other]: DateTime to compare with
  ///
  /// Returns: true if this date is chronologically before the other date
  bool isBeforeDate(DateTime other) {
    return startOfDay.isBefore(other.startOfDay);
  }

  // MARK: - Relative Time Formatting Extensions
  // ==========================================

  /// Get human-readable relative time description.
  ///
  /// Examples: 'just now', '5 minutes ago', 'yesterday', '2 weeks ago'
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return toDisplayFormat; // Fall back to absolute date for older dates
    }
  }
}
