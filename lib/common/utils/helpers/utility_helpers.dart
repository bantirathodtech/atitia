import 'dart:math';

import 'package:atitia/common/utils/date/extensions/datetime_extensions.dart';
import 'package:atitia/common/utils/extensions/string_extensions.dart';

/// General-purpose utility functions for common operations.
///
/// ## Purpose:
/// - Provide reusable helper functions
/// - Handle common data transformations
/// - Offer utility methods for various use cases
///
/// ## Usage:
/// ```dart
/// UtilityHelpers.formatCurrency(amount)
/// UtilityHelpers.generateId()
/// ```
class UtilityHelpers {
  // MARK: - Text & String Helpers
  // ==========================================

  /// Capitalizes the first letter of each word in a string
  ///
  /// ## Example:
  /// ```dart
  /// UtilityHelpers.capitalizeWords('hello world') // 'Hello World'
  /// ```
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => word.capitalizeFirst()).join(' ');
  }

  /// Checks if a string is null, empty, or only whitespace
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Returns a default value if string is null or empty
  static String valueOrEmpty(String? value, {String defaultValue = ''}) {
    return value?.trim() ?? defaultValue;
  }

  // MARK: - Number & Currency Helpers
  // ==========================================

  /// Converts string to double safely with fallback
  ///
  /// ## Example:
  /// ```dart
  /// UtilityHelpers.toDouble('123.45') // 123.45
  /// UtilityHelpers.toDouble('invalid', 0.0) // 0.0
  /// ```
  static double toDouble(String? value, [double fallback = 0.0]) {
    if (value == null) return fallback;
    return double.tryParse(value) ?? fallback;
  }

  /// Converts string to int safely with fallback
  static int toInt(String? value, [int fallback = 0]) {
    if (value == null) return fallback;
    return int.tryParse(value) ?? fallback;
  }

  /// Formats amount as Indian Rupees currency
  ///
  /// ## Example:
  /// ```dart
  /// UtilityHelpers.formatCurrency(1234.56) // '₹1,234.56'
  /// ```
  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  // MARK: - Date & Time Helpers
  // ==========================================

  /// Parses date from DD/MM/YYYY format
  ///
  /// ## Returns:
  /// - `DateTime` if valid
  /// - `null` if invalid format
  static DateTime? parseDisplayDate(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length != 3) return null;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  /// Calculates age from birth date
  static int calculateAge(DateTime birthDate) {
    return birthDate.age;
  }

  // MARK: - ID & Code Generation
  // ==========================================

  /// Generates a random ID with prefix
  ///
  /// ## Example:
  /// ```dart
  /// UtilityHelpers.generateId('USER') // 'USER_ABC123DEF'
  /// ```
  static String generateId([String prefix = '']) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _generateRandomString(8);
    final id = '${prefix.isNotBlank ? '${prefix}_' : ''}${timestamp}_$random';
    return id.toUpperCase();
  }

  /// Generates a random string of specified length
  static String _generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  // MARK: - File & Storage Helpers
  // ==========================================

  /// Gets file extension from file path or name
  static String getFileExtension(String fileName) {
    final parts = fileName.split('.');
    return parts.length > 1 ? '.${parts.last}' : '';
  }

  /// Validates if file is an image by extension
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
        .contains(extension);
  }

  /// Validates if file is a PDF by extension
  static bool isPdfFile(String fileName) {
    return getFileExtension(fileName).toLowerCase() == '.pdf';
  }

  // MARK: - Validation Helpers
  // ==========================================

  /// Validates multiple validators and returns first error
  static String? validateMultiple(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}
