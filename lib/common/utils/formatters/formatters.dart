/// Data formatting utilities for consistent display (excluding dates)
///
/// ## Purpose:
/// - Format numbers, currencies, text for display
/// - Handle localization-aware formatting
/// - Provide reusable formatting methods (non-date)
///
/// ## Usage:
/// ```dart
/// Formatters.formatCurrency(1500.75)
/// Formatters.formatPhoneNumber('9876543210')
/// ```
class Formatters {
  // MARK: - Number Formatting
  // ==========================================

  /// Formats amount as Indian Rupees
  static String formatCurrency(double amount) {
    if (amount % 1 == 0) {
      // Whole number
      return '₹${amount.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          )}';
    } else {
      // Decimal number
      return '₹${amount.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          )}';
    }
  }

  /// Formats number with thousands separators
  static String formatNumber(num value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Formats file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // MARK: - Text Formatting
  // ==========================================

  /// Formats phone number for display (XXX-XXX-XXXX)
  static String formatPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length != 10) return phone;

    return '${cleanPhone.substring(0, 3)}-${cleanPhone.substring(3, 6)}-${cleanPhone.substring(6)}';
  }

  /// Capitalizes first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Formats user name for display (Title Case)
  static String formatUserName(String name) {
    return capitalizeWords(name.trim());
  }

  /// Formats address for consistent display
  static String formatAddress({
    String? street,
    String? city,
    String? state,
    String? pincode,
  }) {
    final parts = [
      street?.trim(),
      city?.trim(),
      state?.trim(),
      pincode?.trim(),
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.join(', ');
  }

  // MARK: - Status Formatting
  // ==========================================

  /// Formats booking status for display
  static String formatBookingStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return capitalizeWords(status);
    }
  }

  /// Formats payment status for display
  static String formatPaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return capitalizeWords(status);
    }
  }

  // MARK: - Utility Formatting
  // ==========================================

  /// Formats duration in minutes to readable format
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hr';
      }
      return '$hours hr $remainingMinutes min';
    }
  }

  /// Formats distance in meters to readable format
  static String formatDistance(int meters) {
    if (meters < 1000) {
      return '${meters}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }

  /// Formats rating with star symbol
  static String formatRating(double rating) {
    return '★ ${rating.toStringAsFixed(1)}';
  }
}
