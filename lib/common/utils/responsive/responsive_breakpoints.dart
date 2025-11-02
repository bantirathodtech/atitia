/// Comprehensive responsive breakpoint system for all platforms
/// Supports iOS, macOS, Android, and Web with adaptive layouts
class ResponsiveBreakpoints {
  // MARK: - Screen Size Breakpoints
  // ==========================================

  /// Mobile breakpoint (phones)
  static const double mobile = 600;

  /// Tablet breakpoint (tablets)
  static const double tablet = 900;

  /// Desktop breakpoint (desktop/laptop)
  static const double desktop = 1200;

  /// Large desktop breakpoint (large screens)
  static const double largeDesktop = 1600;

  // MARK: - Platform-Specific Breakpoints
  // ==========================================

  /// iOS-specific breakpoints
  static const Map<String, double> ios = {
    'iPhone_SE': 375,
    'iPhone_12': 390,
    'iPhone_12_Pro_Max': 428,
    'iPad': 768,
    'iPad_Pro': 1024,
  };

  /// Android-specific breakpoints
  static const Map<String, double> android = {
    'small_phone': 360,
    'medium_phone': 414,
    'large_phone': 480,
    'tablet': 768,
    'large_tablet': 1024,
  };

  /// macOS-specific breakpoints
  static const Map<String, double> macos = {
    'macbook_air': 1440,
    'macbook_pro': 1680,
    'imac': 1920,
    'mac_studio': 2560,
  };

  /// Web-specific breakpoints
  static const Map<String, double> web = {
    'mobile': 480,
    'tablet': 768,
    'laptop': 1024,
    'desktop': 1440,
    'large_desktop': 1920,
  };

  // MARK: - Responsive Helper Methods
  // ==========================================

  /// Returns true if screen width is mobile size
  static bool isMobile(double width) => width < mobile;

  /// Returns true if screen width is tablet size
  static bool isTablet(double width) => width >= mobile && width < tablet;

  /// Returns true if screen width is desktop size
  static bool isDesktop(double width) => width >= tablet && width < desktop;

  /// Returns true if screen width is large desktop size
  static bool isLargeDesktop(double width) => width >= desktop;

  /// Returns the appropriate layout type based on screen width
  static ResponsiveLayoutType getLayoutType(double width) {
    if (isMobile(width)) return ResponsiveLayoutType.mobile;
    if (isTablet(width)) return ResponsiveLayoutType.tablet;
    if (isDesktop(width)) return ResponsiveLayoutType.desktop;
    return ResponsiveLayoutType.largeDesktop;
  }

  /// Returns appropriate column count for grid layouts
  static int getColumnCount(double width) {
    if (isMobile(width)) return 1;
    if (isTablet(width)) return 2;
    if (isDesktop(width)) return 3;
    return 4;
  }

  /// Returns appropriate padding based on screen size
  static double getPadding(double width) {
    if (isMobile(width)) return 16.0;
    if (isTablet(width)) return 24.0;
    if (isDesktop(width)) return 32.0;
    return 48.0;
  }

  /// Returns appropriate font scale based on screen size
  static double getFontScale(double width) {
    if (isMobile(width)) return 1.0;
    if (isTablet(width)) return 1.1;
    if (isDesktop(width)) return 1.2;
    return 1.3;
  }
}

/// Enum for responsive layout types
enum ResponsiveLayoutType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Extension methods for responsive breakpoints
extension ResponsiveBreakpointsExtension on double {
  bool get isMobile => ResponsiveBreakpoints.isMobile(this);
  bool get isTablet => ResponsiveBreakpoints.isTablet(this);
  bool get isDesktop => ResponsiveBreakpoints.isDesktop(this);
  bool get isLargeDesktop => ResponsiveBreakpoints.isLargeDesktop(this);

  ResponsiveLayoutType get layoutType =>
      ResponsiveBreakpoints.getLayoutType(this);
  int get columnCount => ResponsiveBreakpoints.getColumnCount(this);
  double get responsivePadding => ResponsiveBreakpoints.getPadding(this);
  double get fontScale => ResponsiveBreakpoints.getFontScale(this);
}
