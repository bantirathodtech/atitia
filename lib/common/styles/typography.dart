import 'package:flutter/material.dart';

import 'colors.dart';

/// Enhanced typography system with premium font scaling and food-specific styles
class AppTypography {
  // Font Families
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'OpenSans';
  static const String accentFont = 'Lato';

  // ============ PREMIUM TEXT SCALES ============

  // Display Text (Large Headers)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Title Text
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Label Text
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ============ FOOD-SPECIFIC TYPOGRAPHY ============

  // Meal Type Headers
  static const TextStyle mealHeaderLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle mealHeaderMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.3,
  );

  // Food Item Text
  static const TextStyle foodItemLarge = TextStyle(
    fontFamily: accentFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle foodItemMedium = TextStyle(
    fontFamily: accentFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle foodItemSmall = TextStyle(
    fontFamily: accentFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ============ BUTTON TEXT ============
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  // ============ COMPATIBILITY ALIASES ============

  // App Bar (Backward Compatibility)
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Buttons (Backward Compatibility)
  static const TextStyle button = buttonMedium;
  static const TextStyle buttonBold = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.1,
  );

  // Headings (Backward Compatibility)
  static const TextStyle headingLarge = displaySmall;
  static const TextStyle headingMedium = headlineMedium;
  static const TextStyle headingSmall = headlineSmall;

  // Body Text (Backward Compatibility)
  static TextStyle bodyText([bool medium = false, bool small = false]) {
    if (small) return bodySmall;
    if (medium) return bodyMedium;
    return bodyLarge;
  }

  // Input Fields
  static const TextStyle input = bodyLarge;
  static const TextStyle inputLabel = labelLarge;

  // Captions & Overlines
  static const TextStyle caption = TextStyle(
    fontFamily: accentFont,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.5,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: accentFont,
    fontSize: 10,
    fontWeight: FontWeight.w300,
    height: 1.4,
    letterSpacing: 1.5,
  );

  // ============ OPENSANS (Secondary) - Backward Compatibility ============

  static const TextStyle openSansLight = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle openSansRegular = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle openSansMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle openSansBold = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle openSansItalic = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  // ============ LATO (Accent) - Backward Compatibility ============

  static const TextStyle latoLight = TextStyle(
    fontFamily: accentFont,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle latoRegular = TextStyle(
    fontFamily: accentFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle latoBold = TextStyle(
    fontFamily: accentFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle latoItalic = TextStyle(
    fontFamily: accentFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  // ============ UTILITY METHODS ============

  /// Get text style for meal type with appropriate color
  static TextStyle getMealStyle(String mealType, {bool isHeader = false}) {
    final color = AppColors.getMealColor(mealType);
    if (isHeader) {
      return mealHeaderMedium.copyWith(color: color);
    }
    return foodItemMedium.copyWith(color: AppColors.textPrimary);
  }

  /// Get text style for day with appropriate color
  static TextStyle getDayStyle(int dayIndex, {bool isHeader = false}) {
    final color = AppColors.getDayColor(dayIndex);
    if (isHeader) {
      return displaySmall.copyWith(color: color);
    }
    return titleLarge.copyWith(color: color);
  }
}
