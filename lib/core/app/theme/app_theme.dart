import 'package:flutter/material.dart';

import '../../../common/styles/colors.dart';
import '../../../common/styles/spacing.dart';
import '../../../common/styles/typography.dart';

/// Enhanced theme system with premium design tokens
class AppTheme {
  /// Light (Day) theme configuration
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    primaryColorDark: AppColors.primaryDark,
    primaryColorLight: AppColors.primaryLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: Color(0xFFFF5252), // Decorative red for light mode
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnSecondary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textOnPrimary,
    ),
    fontFamily: AppTypography.primaryFont,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.surface,

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: AppSpacing.elevationMedium,
      centerTitle: false,
      titleTextStyle: AppTypography.appBarTitle,
      iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
      actionsIconTheme: const IconThemeData(color: AppColors.textOnPrimary),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      elevation: AppSpacing.elevationMedium,
      type: BottomNavigationBarType.fixed,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: AppSpacing.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.fabBorderRadius),
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
      ),
      margin: EdgeInsets.zero,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        textStyle: AppTypography.buttonMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingL,
          vertical: AppSpacing.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
        elevation: AppSpacing.elevationLow,
        minimumSize: const Size(64, AppSpacing.buttonHeightM),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.buttonMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
        minimumSize: const Size(64, AppSpacing.buttonHeightM),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.buttonMedium,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingL,
          vertical: AppSpacing.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
        minimumSize: const Size(64, AppSpacing.buttonHeightM),
      ),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding: const EdgeInsets.all(AppSpacing.paddingM),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: AppTypography.inputLabel.copyWith(color: AppColors.textSecondary),
      hintStyle: AppTypography.input.copyWith(color: AppColors.textTertiary),
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: AppSpacing.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
      ),
      titleTextStyle: AppTypography.headlineMedium,
      contentTextStyle: AppTypography.bodyMedium,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primaryContainer,
      secondarySelectedColor: AppColors.secondaryContainer,
      disabledColor: AppColors.textDisabled,
      labelStyle: AppTypography.labelMedium,
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.textOnPrimary),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.outline),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.outline,
      thickness: 1,
      space: 1,
    ),

    // Comprehensive Text Theme
    textTheme: TextTheme(
      // Display
      displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimary),
      displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textPrimary),
      displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.textPrimary),

      // Headline
      headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimary),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary),
      headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),

      // Title
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
      titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),

      // Body
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),

      // Label
      labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
      labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
    ),
  );

  /// Dark (Night) theme configuration with enhanced visibility
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryLight,
    primaryColorDark: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      tertiary: Color(0xFFFF6B6B), // Brighter decorative red for dark mode
      surface: AppColors.darkCard,
      error: Color(0xFFFF6B6B),  // Brighter error color for dark mode
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE0E0E0),  // Lighter text for better contrast
      onError: Colors.white,
    ),
    fontFamily: AppTypography.primaryFont,
    scaffoldBackgroundColor: AppColors.darkScaffold,
    canvasColor: AppColors.darkCard,

    // App Bar - Enhanced for dark mode visibility
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),  // Slightly lighter than scaffold for contrast
      foregroundColor: const Color(0xFFE0E0E0),  // Bright text for readability
      elevation: AppSpacing.elevationMedium,
      centerTitle: false,
      titleTextStyle: AppTypography.appBarTitle.copyWith(
        color: const Color(0xFFE0E0E0),  // Bright white-ish for title
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFE0E0E0),  // Bright icons
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: Color(0xFFE0E0E0),  // Bright action icons
        size: 24,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textTertiary,
      elevation: AppSpacing.elevationMedium,
      type: BottomNavigationBarType.fixed,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.textOnPrimary,
      elevation: AppSpacing.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.fabBorderRadius),
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
      ),
      margin: EdgeInsets.zero,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textOnPrimary,
        textStyle: AppTypography.buttonMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingL,
          vertical: AppSpacing.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
        elevation: AppSpacing.elevationLow,
        minimumSize: const Size(64, AppSpacing.buttonHeightM),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        textStyle: AppTypography.buttonMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
        minimumSize: const Size(64, AppSpacing.buttonHeightM),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        textStyle: AppTypography.buttonMedium,
        side: const BorderSide(color: AppColors.primaryLight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingL,
          vertical: AppSpacing.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
        minimumSize: const Size(64, AppSpacing.buttonHeightM),
      ),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInputFill,
      contentPadding: const EdgeInsets.all(AppSpacing.paddingM),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: AppTypography.inputLabel.copyWith(color: AppColors.darkText),
      hintStyle: AppTypography.input.copyWith(color: AppColors.textTertiary),
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkCard,
      elevation: AppSpacing.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
      ),
      titleTextStyle: AppTypography.headlineMedium.copyWith(color: AppColors.darkText),
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.darkText),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkInputFill,
      selectedColor: AppColors.primaryContainer,
      secondarySelectedColor: AppColors.secondaryContainer,
      disabledColor: AppColors.textDisabled,
      labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.darkText),
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.textOnPrimary),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.darkDivider),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
      space: 1,
    ),

    // Comprehensive Text Theme - Enhanced contrast for dark mode
    textTheme: TextTheme(
      // Display - Large headers with high contrast
      displayLarge: AppTypography.displayLarge.copyWith(
        color: const Color(0xFFFFFFFF),  // Pure white for maximum visibility
      ),
      displayMedium: AppTypography.displayMedium.copyWith(
        color: const Color(0xFFFFFFFF),
      ),
      displaySmall: AppTypography.displaySmall.copyWith(
        color: const Color(0xFFF5F5F5),
      ),

      // Headline - Section headers with good contrast
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: const Color(0xFFF0F0F0),
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: const Color(0xFFF0F0F0),
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: const Color(0xFFEEEEEE),
      ),

      // Title - Card titles and labels with clear visibility
      titleLarge: AppTypography.titleLarge.copyWith(
        color: const Color(0xFFE8E8E8),
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: const Color(0xFFE0E0E0),
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: const Color(0xFFD0D0D0),
      ),

      // Body - Main content text with comfortable reading contrast
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: const Color(0xFFE0E0E0),  // Bright enough to read easily
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: const Color(0xFFD0D0D0),  // Slightly dimmer but still clear
      ),
      bodySmall: AppTypography.bodySmall.copyWith(
        color: const Color(0xFFC0C0C0),  // Secondary text still readable
      ),

      // Label - UI labels and buttons with good contrast
      labelLarge: AppTypography.labelLarge.copyWith(
        color: const Color(0xFFE0E0E0),
      ),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: const Color(0xFFD0D0D0),
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: const Color(0xFFC0C0C0),
      ),
    ),
  );
}
