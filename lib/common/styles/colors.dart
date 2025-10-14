// import 'package:flutter/material.dart';
//
// /// Centralized color definitions for consistent theming
// class AppColors {
//   // Light Theme Colors
//   static const Color lightPrimary = Color(0xFF1976D2);
//   static const Color lightAccent = Color(0xFF0288D1);
//   static const Color lightScaffold = Colors.white;
//   static const Color lightText = Colors.black87;
//   static const Color lightInputFill = Color(0xFFF5F5F5);
//
//   // Dark Theme Colors
//   static const Color darkPrimary = Color(0xFF512DA8);
//   static const Color darkAccent = Color(0xFF7E57C2);
//   static const Color darkScaffold = Color(0xFF121212);
//   static const Color darkText = Colors.white70;
//   static const Color darkInputFill = Color(0xFF424242);
// }
import 'package:flutter/material.dart';

/// Centralized color definitions for consistent theming
/// Enhanced with food-specific color palette and semantic colors
class AppColors {
  // ==================== PRIMARY BRAND COLORS ====================
  static const Color primary = Color(0xFF7B61FF); // Vibrant purple
  static const Color primaryDark = Color(0xFF5D43E0);
  static const Color primaryLight = Color(0xFF9E8AFF);
  static const Color primaryContainer = Color(0xFFEAE6FF);

  // ==================== SECONDARY COLORS ====================
  static const Color secondary = Color(0xFFFF6B6B); // Coral red
  static const Color secondaryDark = Color(0xFFE05555);
  static const Color secondaryLight = Color(0xFFFF8E8E);
  static const Color secondaryContainer = Color(0xFFFFE6E6);

  // ==================== ACCENT COLORS ====================
  static const Color accent = Color(0xFF4ECDC4); // Teal
  static const Color accentDark = Color(0xFF36B7AF);
  static const Color accentLight = Color(0xFF7CDFD8);
  static const Color accentContainer = Color(0xFFE0F7F5);

  // ==================== FOOD-SPECIFIC COLORS ====================
  // Breakfast - Warm oranges/yellows
  static const Color breakfast = Color(0xFFFFA726);
  static const Color breakfastContainer = Color(0xFFFFF3E0);

  // Lunch - Fresh greens
  static const Color lunch = Color(0xFF66BB6A);
  static const Color lunchContainer = Color(0xFFE8F5E8);

  // Dinner - Rich purples/blues
  static const Color dinner = Color(0xFF5C6BC0);
  static const Color dinnerContainer = Color(0xFFE8EAF6);

  // ==================== SEMANTIC COLORS ====================
  static const Color success = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFE8F5E8);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningContainer = Color(0xFFFFF3E0);

  static const Color error = Color(0xFFF44336);
  static const Color errorContainer = Color(0xFFFFEBEE);

  static const Color info = Color(0xFF2196F3);
  static const Color infoContainer = Color(0xFFE3F2FD);

  static const Color purple = Color(0xFFAB47BC);
  static const Color purpleContainer = Color(0xFFF3E5F5);

  // ==================== NEUTRAL COLORS ====================
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFEEEEEE);

  // ==================== TEXT COLORS ====================
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textDisabled = Color(0xFFCCCCCC);

  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // ==================== STATE COLORS ====================
  static const Color hover = Color(0x0A000000);
  static const Color focus = Color(0x1F000000);
  static const Color pressed = Color(0x14000000);
  static const Color dragged = Color(0x29000000);

  // ==================== ELEVATION COLORS ====================
  static const Color shadow = Color(0x33000000);
  static const Color scrim = Color(0x52000000);

  // ==================== LIGHT THEME ====================
  static const Color lightPrimary = Color(0xFF7B61FF);
  static const Color lightAccent = Color(0xFFFF6B6B);
  static const Color lightScaffold = Color(0xFFFAFAFA);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightInputFill = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // ==================== DARK THEME ====================
  static const Color darkPrimary = Color(0xFF9E8AFF);
  static const Color darkAccent = Color(0xFFFF8E8E);
  static const Color darkScaffold = Color(0xFF121212);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkInputFill = Color(0xFF2A2A2A);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkDivider = Color(0xFF333333);
  static const Color darkSurface = Color(0xFF2A2A2A);
  static const Color borderDark = Color(0xFF333333);
  static const Color border = Color(0xFFE0E0E0);

  // ==================== GRADIENT COLORS ====================
  static const List<Color> primaryGradient = [
    Color(0xFF7B61FF),
    Color(0xFF9E8AFF),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFF8E8E),
  ];

  static const List<Color> breakfastGradient = [
    Color(0xFFFFA726),
    Color(0xFFFFB74D),
  ];

  static const List<Color> lunchGradient = [
    Color(0xFF66BB6A),
    Color(0xFF81C784),
  ];

  static const List<Color> dinnerGradient = [
    Color(0xFF5C6BC0),
    Color(0xFF7986CB),
  ];

  // ==================== DAY-SPECIFIC COLORS ====================
  static const List<Color> dayColors = [
    Color(0xFF7B61FF), // Monday - Primary Purple
    Color(0xFFFF6B6B), // Tuesday - Coral Red
    Color(0xFF4ECDC4), // Wednesday - Teal
    Color(0xFF66BB6A), // Thursday - Green
    Color(0xFFFFA726), // Friday - Orange
    Color(0xFFAB47BC), // Saturday - Violet
    Color(0xFF29B6F6), // Sunday - Sky Blue
  ];

  static const List<Color> dayContainerColors = [
    Color(0xFFEAE6FF), // Monday
    Color(0xFFFFE6E6), // Tuesday
    Color(0xFFE0F7F5), // Wednesday
    Color(0xFFE8F5E8), // Thursday
    Color(0xFFFFF3E0), // Friday
    Color(0xFFF3E5F5), // Saturday
    Color(0xFFE1F5FE), // Sunday
  ];

  // ==================== UTILITY METHODS ====================

  /// Get day-specific color by index (0-6 for Monday-Sunday)
  static Color getDayColor(int dayIndex) {
    return dayColors[dayIndex % dayColors.length];
  }

  /// Get day-specific container color by index
  static Color getDayContainerColor(int dayIndex) {
    return dayContainerColors[dayIndex % dayContainerColors.length];
  }

  /// Get meal-specific color by meal type
  static Color getMealColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return breakfast;
      case 'lunch':
        return lunch;
      case 'dinner':
        return dinner;
      default:
        return primary;
    }
  }

  /// Get meal-specific gradient by meal type
  static List<Color> getMealGradient(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return breakfastGradient;
      case 'lunch':
        return lunchGradient;
      case 'dinner':
        return dinnerGradient;
      default:
        return primaryGradient;
    }
  }

  /// Get semantic color by status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'active':
      case 'completed':
        return success;
      case 'warning':
      case 'pending':
        return warning;
      case 'error':
      case 'failed':
      case 'inactive':
        return error;
      case 'info':
      case 'processing':
        return info;
      default:
        return textSecondary;
    }
  }

  /// Get container color for status
  static Color getStatusContainerColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'active':
      case 'completed':
        return successContainer;
      case 'warning':
      case 'pending':
        return warningContainer;
      case 'error':
      case 'failed':
      case 'inactive':
        return errorContainer;
      case 'info':
      case 'processing':
        return infoContainer;
      default:
        return surfaceVariant;
    }
  }

  /// Darken a color by [percent] (0-100)
  static Color darken(Color color, [int percent = 10]) {
    assert(percent >= 0 && percent <= 100);
    final factor = 1 - percent / 100;
    return Color.fromARGB(
      color.alpha,
      (color.red * factor).round(),
      (color.green * factor).round(),
      (color.blue * factor).round(),
    );
  }

  /// Lighten a color by [percent] (0-100)
  static Color lighten(Color color, [int percent = 10]) {
    assert(percent >= 0 && percent <= 100);
    final factor = 1 + percent / 100;
    return Color.fromARGB(
      color.alpha,
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255),
    );
  }

  /// Get contrasting text color for background
  static Color getContrastText(Color backgroundColor) {
    // Calculate the perceptive luminance
    final luminance = (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    // Return black or white depending on luminance
    return luminance > 0.5 ? textPrimary : textInverse;
  }
}
