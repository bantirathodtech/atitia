/// Enhanced spacing and dimensions for premium UI/UX
class AppSpacing {
  // ==================== PADDING & MARGIN ====================
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Short aliases for padding
  static const double xxs = paddingXXS;
  static const double xs = paddingXS;
  static const double sm = paddingS;
  static const double md = paddingM;
  static const double lg = paddingL;
  static const double xl = paddingXL;
  static const double xxl = paddingXXL;

  // ==================== BORDER RADIUS ====================
  static const double borderRadiusXS = 4.0;
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 20.0;
  static const double borderRadiusXXL = 24.0;

  // Component-specific border radius
  static const double buttonBorderRadius = borderRadiusM;
  static const double cardBorderRadius = borderRadiusL;
  static const double inputBorderRadius = borderRadiusM;
  static const double fabBorderRadius = borderRadiusXL;

  // ==================== ELEVATION ====================
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationXHigh = 16.0;

  // ==================== DIMENSIONS ====================
  static const double iconSizeXS = 16.0;
  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 40.0;

  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  static const double appBarHeight = 64.0;
  static const double tabBarHeight = 48.0;
  static const double bottomNavBarHeight = 80.0;

  // ==================== ANIMATION DURATIONS ====================
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);
}
