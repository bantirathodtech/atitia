import '../constants/validation.dart';

/// String extension methods for common operations
extension StringExtensions on String {
  // MARK: - Validation Extensions
  // ==========================================

  bool isValidEmail() {
    return ValidationConstants.emailPattern.hasMatch(this);
  }

  bool isValidPhone() {
    return ValidationConstants.phonePattern.hasMatch(this);
  }

  bool isValidName() {
    return ValidationConstants.namePattern.hasMatch(this);
  }

  bool isValidPassword() {
    return ValidationConstants.passwordPattern.hasMatch(this);
  }

  // MARK: - Transformation Extensions
  // ==========================================

  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirst()).join(' ');
  }

  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  // MARK: - Convenience Extensions
  // ==========================================

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  String get digitsOnly => replaceAll(RegExp(r'[^0-9]'), '');

  String maskEmail() {
    if (!isValidEmail()) return this;
    final parts = split('@');
    if (parts.length != 2) return this;

    final username = parts[0];
    final domain = parts[1];

    if (username.length == 1) return '$username***@$domain';
    return '${username[0]}***@$domain';
  }

  String maskPhone() {
    final digits = digitsOnly;
    if (digits.length != 10) return this;
    return '${digits.substring(0, 5)}*****';
  }

  // MARK: - New Extensions
  // ==========================================

  /// Returns true if string contains only digits
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Returns string with first n characters
  String first(int n) {
    if (n >= length) return this;
    return substring(0, n);
  }

  /// Returns string with last n characters
  String last(int n) {
    if (n >= length) return this;
    return substring(length - n);
  }

  /// Removes all whitespace from string
  String removeWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Converts string to title case (Each Word Capitalized)
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Wraps string in parentheses
  String inParentheses() => '($this)';

  /// Wraps string in quotes
  String inQuotes() => '"$this"';

  /// Returns initials from name (e.g., "John Doe" -> "JD")
  String get initials {
    if (isEmpty) return '';
    final words = split(' ');
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
