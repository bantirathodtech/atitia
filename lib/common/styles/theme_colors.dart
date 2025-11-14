// lib/common/styles/theme_colors.dart

import 'package:flutter/material.dart';

import 'colors.dart';

/// Helper class for theme-aware colors
/// Use this instead of hardcoded Colors.grey, Colors.white, etc.
class ThemeColors {
  const ThemeColors._();

  /// Get secondary text color based on theme
  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context)
            .textTheme
            .bodySmall
            ?.color
            ?.withValues(alpha: 0.8) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8);
  }

  /// Get tertiary text color based on theme (more subtle)
  static Color getTextTertiary(BuildContext context) {
    return Theme.of(context)
            .textTheme
            .bodySmall
            ?.color
            ?.withValues(alpha: 0.7) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
  }

  /// Get divider color based on theme
  static Color getDivider(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  /// Get card background based on theme
  static Color getCardBackground(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Get subtle background based on theme
  static Color getSubtleBackground(BuildContext context) {
    return Theme.of(context).colorScheme.shadow.withValues(
        alpha: Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05);
  }

  /// Get overlay color for images based on theme
  static Color getImageOverlay(BuildContext context) {
    return Theme.of(context).colorScheme.shadow.withValues(alpha: 0.54);
  }

  /// Get status color - available/success
  static Color getSuccessColor() {
    return AppColors.success;
  }

  /// Get status color - occupied/warning
  static Color getWarningColor() {
    return AppColors.statusOrange;
  }

  /// Get status color - error/cancelled
  static Color getErrorColor() {
    return AppColors.error;
  }

  /// Get status color - inactive/disabled
  static Color getInactiveColor() {
    return AppColors.statusGrey;
  }

  /// Get white color for icons on colored backgrounds - theme-aware via BuildContext
  static Color getOnColorText(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimary;
  }
}
