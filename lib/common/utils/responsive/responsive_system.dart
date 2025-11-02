import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'responsive_breakpoints.dart';
import 'platform_adaptations.dart';
import 'responsive_layout_builder.dart';

/// Comprehensive responsive system for the Atitia app
/// Handles all platform-specific adaptations and responsive layouts
class ResponsiveSystem {
  // MARK: - System Initialization
  // ==========================================

  /// Initialize the responsive system with platform-specific configurations
  static void initialize() {
    if (kDebugMode) {
      debugPrint('🚀 ResponsiveSystem: Initializing for ${_getPlatformName()}');
    }
  }

  static String _getPlatformName() {
    if (PlatformAdaptations.isIOS) return 'iOS';
    if (PlatformAdaptations.isAndroid) return 'Android';
    if (PlatformAdaptations.isMacOS) return 'macOS';
    if (PlatformAdaptations.isWeb) return 'Web';
    return 'Unknown';
  }

  // MARK: - Responsive Utilities
  // ==========================================

  /// Get responsive configuration for the current context
  static ResponsiveConfig getConfig(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final layoutType = ResponsiveBreakpoints.getLayoutType(screenSize.width);

    return ResponsiveConfig(
      layoutType: layoutType,
      screenSize: screenSize,
      isMobile: layoutType == ResponsiveLayoutType.mobile,
      isTablet: layoutType == ResponsiveLayoutType.tablet,
      isDesktop: layoutType == ResponsiveLayoutType.desktop,
      isLargeDesktop: layoutType == ResponsiveLayoutType.largeDesktop,
    );
  }

  /// Get platform-specific theme configuration
  static ThemeData getPlatformTheme(BuildContext context,
      {bool isDark = false}) {
    return PlatformTheme.getPlatformTheme(context, isDark: isDark);
  }

  /// Get responsive padding for the current screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final config = getConfig(context);
    return _getPaddingForLayoutType(config.layoutType);
  }

  /// Get responsive margin for the current screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final config = getConfig(context);
    return _getMarginForLayoutType(config.layoutType);
  }

  /// Get responsive font scale for the current screen size
  static double getResponsiveFontScale(BuildContext context) {
    final config = getConfig(context);
    return ResponsiveBreakpoints.getFontScale(config.screenSize.width);
  }

  /// Get responsive column count for grid layouts
  static int getResponsiveColumnCount(BuildContext context) {
    final config = getConfig(context);
    return ResponsiveBreakpoints.getColumnCount(config.screenSize.width);
  }

  // MARK: - Layout Type Helpers
  // ==========================================

  static EdgeInsets _getPaddingForLayoutType(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return const EdgeInsets.all(16.0);
      case ResponsiveLayoutType.tablet:
        return const EdgeInsets.all(20.0);
      case ResponsiveLayoutType.desktop:
        return const EdgeInsets.all(24.0);
      case ResponsiveLayoutType.largeDesktop:
        return const EdgeInsets.all(28.0);
    }
  }

  static EdgeInsets _getMarginForLayoutType(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return const EdgeInsets.all(8.0);
      case ResponsiveLayoutType.tablet:
        return const EdgeInsets.all(12.0);
      case ResponsiveLayoutType.desktop:
        return const EdgeInsets.all(16.0);
      case ResponsiveLayoutType.largeDesktop:
        return const EdgeInsets.all(20.0);
    }
  }

  // MARK: - Platform-Specific Adaptations
  // ==========================================

  /// Get platform-specific app bar height
  static double getAppBarHeight(BuildContext context) {
    return PlatformAdaptations.getAppBarHeight(context);
  }

  /// Get platform-specific bottom navigation height
  static double getBottomNavigationHeight(BuildContext context) {
    return PlatformAdaptations.getBottomNavigationHeight(context);
  }

  /// Get platform-specific elevation
  static double getPlatformElevation(BuildContext context) {
    return PlatformAdaptations.getPlatformElevation(context);
  }

  /// Get platform-specific border radius
  static BorderRadius getPlatformBorderRadius(BuildContext context) {
    return PlatformAdaptations.getPlatformBorderRadius(context);
  }

  /// Get platform-specific shadow
  static List<BoxShadow> getPlatformShadow(BuildContext context) {
    return PlatformAdaptations.getPlatformShadow(context);
  }
}

/// Configuration class for responsive system
class ResponsiveConfig {
  final ResponsiveLayoutType layoutType;
  final Size screenSize;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isLargeDesktop;

  const ResponsiveConfig({
    required this.layoutType,
    required this.screenSize,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isLargeDesktop,
  });

  /// Get responsive padding for this configuration
  EdgeInsets get padding =>
      ResponsiveSystem._getPaddingForLayoutType(layoutType);

  /// Get responsive margin for this configuration
  EdgeInsets get margin => ResponsiveSystem._getMarginForLayoutType(layoutType);

  /// Get responsive font scale for this configuration
  double get fontScale => ResponsiveBreakpoints.getFontScale(screenSize.width);

  /// Get responsive column count for this configuration
  int get columnCount => ResponsiveBreakpoints.getColumnCount(screenSize.width);

  /// Get responsive max width for this configuration
  double get maxWidth {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return screenSize.width;
      case ResponsiveLayoutType.tablet:
        return 800.0;
      case ResponsiveLayoutType.desktop:
        return 1200.0;
      case ResponsiveLayoutType.largeDesktop:
        return 1600.0;
    }
  }
}

/// Extension methods for BuildContext to access responsive system
extension ResponsiveSystemExtension on BuildContext {
  /// Get responsive configuration for this context
  ResponsiveConfig get responsive => ResponsiveSystem.getConfig(this);

  /// Get responsive padding for this context
  EdgeInsets get responsivePadding =>
      ResponsiveSystem.getResponsivePadding(this);

  /// Get responsive margin for this context
  EdgeInsets get responsiveMargin => ResponsiveSystem.getResponsiveMargin(this);

  /// Get responsive font scale for this context
  double get responsiveFontScale =>
      ResponsiveSystem.getResponsiveFontScale(this);

  /// Get responsive column count for this context
  int get responsiveColumnCount =>
      ResponsiveSystem.getResponsiveColumnCount(this);

  /// Get platform-specific app bar height for this context
  double get appBarHeight => ResponsiveSystem.getAppBarHeight(this);

  /// Get platform-specific bottom navigation height for this context
  double get bottomNavigationHeight =>
      ResponsiveSystem.getBottomNavigationHeight(this);

  /// Get platform-specific elevation for this context
  double get platformElevation => ResponsiveSystem.getPlatformElevation(this);

  /// Get platform-specific border radius for this context
  BorderRadius get platformBorderRadius =>
      ResponsiveSystem.getPlatformBorderRadius(this);

  /// Get platform-specific shadow for this context
  List<BoxShadow> get platformShadow =>
      ResponsiveSystem.getPlatformShadow(this);
}

/// Responsive system provider widget
class ResponsiveSystemProvider extends StatelessWidget {
  final Widget child;

  const ResponsiveSystemProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: child,
    );
  }
}

/// Responsive system initialization mixin
mixin ResponsiveSystemMixin<T extends StatefulWidget> on State<T> {
  ResponsiveConfig? _responsiveConfig;

  ResponsiveConfig get responsiveConfig => _responsiveConfig!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsiveConfig = ResponsiveSystem.getConfig(context);
  }

  /// Check if current layout is mobile
  bool get isMobile => _responsiveConfig?.isMobile ?? false;

  /// Check if current layout is tablet
  bool get isTablet => _responsiveConfig?.isTablet ?? false;

  /// Check if current layout is desktop
  bool get isDesktop => _responsiveConfig?.isDesktop ?? false;

  /// Check if current layout is large desktop
  bool get isLargeDesktop => _responsiveConfig?.isLargeDesktop ?? false;

  /// Get responsive padding
  EdgeInsets get responsivePadding =>
      _responsiveConfig?.padding ?? EdgeInsets.zero;

  /// Get responsive margin
  EdgeInsets get responsiveMargin =>
      _responsiveConfig?.margin ?? EdgeInsets.zero;

  /// Get responsive font scale
  double get responsiveFontScale => _responsiveConfig?.fontScale ?? 1.0;

  /// Get responsive column count
  int get responsiveColumnCount => _responsiveConfig?.columnCount ?? 1;
}
