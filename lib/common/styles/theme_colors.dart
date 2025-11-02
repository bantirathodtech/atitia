// lib/common/styles/theme_colors.dart

import 'package:flutter/material.dart';

/// Helper class for theme-aware colors
/// Use this instead of hardcoded Colors.grey, Colors.white, etc.
class ThemeColors {
  const ThemeColors._();
  
  /// Get secondary text color based on theme
  static Color getTextSecondary(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey.shade700;
  }
  
  /// Get tertiary text color based on theme (more subtle)
  static Color getTextTertiary(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? const Color(0xFF808080) : Colors.grey.shade600;
  }
  
  /// Get divider color based on theme
  static Color getDivider(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey.shade300;
  }
  
  /// Get card background based on theme
  static Color getCardBackground(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }
  
  /// Get subtle background based on theme
  static Color getSubtleBackground(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.black.withOpacity(0.05);
  }
  
  /// Get overlay color for images based on theme
  static Color getImageOverlay(BuildContext context) {
    return Colors.black54;
  }
  
  /// Get status color - available/success
  static Color getSuccessColor() {
    return Colors.green;
  }
  
  /// Get status color - occupied/warning
  static Color getWarningColor() {
    return Colors.orange;
  }
  
  /// Get status color - error/cancelled
  static Color getErrorColor() {
    return Colors.red;
  }
  
  /// Get status color - inactive/disabled
  static Color getInactiveColor() {
    return Colors.grey;
  }
  
  /// Get white color for icons on colored backgrounds
  static Color getOnColorText() {
    return Colors.white;
  }
}

