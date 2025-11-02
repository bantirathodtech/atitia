import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

/// Platform-specific adaptations for iOS, macOS, Android, and Web
class PlatformAdaptations {
  // MARK: - Platform Detection
  // ==========================================

  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isWeb => kIsWeb;
  static bool get isMobile => isIOS || isAndroid;
  static bool get isDesktop => isMacOS || (isWeb && !kIsWeb);

  // MARK: - Platform-Specific UI Adaptations
  // ==========================================

  /// Returns platform-specific app bar height
  static double getAppBarHeight(BuildContext context) {
    if (isIOS) return 44.0;
    if (isAndroid) return 56.0;
    if (isMacOS) return 28.0;
    if (isWeb) return 56.0;
    return 56.0;
  }

  /// Returns platform-specific bottom navigation height
  static double getBottomNavigationHeight(BuildContext context) {
    if (isIOS) return 83.0; // Includes safe area
    if (isAndroid) return 56.0;
    if (isMacOS) return 0.0; // No bottom navigation on macOS
    if (isWeb) return 56.0;
    return 56.0;
  }

  /// Returns platform-specific padding
  static EdgeInsets getPlatformPadding(BuildContext context) {
    if (isIOS) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    }
    if (isAndroid) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    }
    if (isMacOS) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
    }
    if (isWeb) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
    }
    return const EdgeInsets.all(16.0);
  }

  /// Returns platform-specific border radius
  static BorderRadius getPlatformBorderRadius(BuildContext context) {
    if (isIOS) {
      return BorderRadius.circular(8.0);
    }
    if (isAndroid) {
      return BorderRadius.circular(4.0);
    }
    if (isMacOS) {
      return BorderRadius.circular(6.0);
    }
    if (isWeb) {
      return BorderRadius.circular(8.0);
    }
    return BorderRadius.circular(8.0);
  }

  /// Returns platform-specific elevation/shadow
  static double getPlatformElevation(BuildContext context) {
    if (isIOS) return 0.0; // iOS uses shadows, not elevation
    if (isAndroid) return 2.0;
    if (isMacOS) return 1.0;
    if (isWeb) return 2.0;
    return 2.0;
  }

  /// Returns platform-specific shadow
  static List<BoxShadow> getPlatformShadow(BuildContext context) {
    if (isIOS) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];
    }
    if (isAndroid) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    }
    if (isMacOS) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 1),
        ),
      ];
    }
    if (isWeb) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return [];
  }

  // MARK: - Platform-Specific Navigation
  // ==========================================

  /// Returns platform-specific page transition
  static Widget getPlatformPageTransition({
    required Widget child,
    required BuildContext context,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
  }) {
    if (isIOS) {
      return SlideTransition(
        position: animation.drive(
          Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: child,
      );
    }
    if (isAndroid) {
      return SlideTransition(
        position: animation.drive(
          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: child,
      );
    }
    if (isMacOS) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
    if (isWeb) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
    return child;
  }

  /// Returns platform-specific drawer behavior
  static bool getUseDrawer(BuildContext context) {
    if (isMobile) return true;
    if (isDesktop) return false;
    return true;
  }

  /// Returns platform-specific navigation type
  static NavigationType getNavigationType(BuildContext context) {
    if (isMobile) return NavigationType.bottomNavigation;
    if (isDesktop) return NavigationType.sideNavigation;
    return NavigationType.bottomNavigation;
  }

  // MARK: - Platform-Specific Input Adaptations
  // ==========================================

  /// Returns platform-specific text input style
  static InputDecorationTheme getPlatformInputDecoration(BuildContext context) {
    if (isIOS) {
      return const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      );
    }
    if (isAndroid) {
      return const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      );
    }
    if (isMacOS) {
      return const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      );
    }
    if (isWeb) {
      return const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      );
    }
    return const InputDecorationTheme();
  }

  // MARK: - Platform-Specific Button Adaptations
  // ==========================================

  /// Returns platform-specific button style
  static ButtonStyle getPlatformButtonStyle(BuildContext context) {
    if (isIOS) {
      return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      );
    }
    if (isAndroid) {
      return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      );
    }
    if (isMacOS) {
      return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      );
    }
    if (isWeb) {
      return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      );
    }
    return ElevatedButton.styleFrom();
  }
}

/// Enum for navigation types
enum NavigationType {
  bottomNavigation,
  sideNavigation,
  topNavigation,
}

/// Platform-aware widget that adapts its behavior based on the platform
class PlatformAwareWidget extends StatelessWidget {
  final Widget ios;
  final Widget android;
  final Widget? macos;
  final Widget? web;
  final Widget? fallback;

  const PlatformAwareWidget({
    super.key,
    required this.ios,
    required this.android,
    this.macos,
    this.web,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformAdaptations.isIOS) return ios;
    if (PlatformAdaptations.isAndroid) return android;
    if (PlatformAdaptations.isMacOS) return macos ?? fallback ?? ios;
    if (PlatformAdaptations.isWeb) return web ?? fallback ?? android;
    return fallback ?? ios;
  }
}

/// Platform-specific theme extensions
class PlatformTheme {
  static ThemeData getPlatformTheme(BuildContext context,
      {bool isDark = false}) {
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();

    if (PlatformAdaptations.isIOS) {
      return baseTheme.copyWith(
        platform: TargetPlatform.iOS,
        inputDecorationTheme:
            PlatformAdaptations.getPlatformInputDecoration(context),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: PlatformAdaptations.getPlatformButtonStyle(context),
        ),
      );
    }
    if (PlatformAdaptations.isAndroid) {
      return baseTheme.copyWith(
        platform: TargetPlatform.android,
        inputDecorationTheme:
            PlatformAdaptations.getPlatformInputDecoration(context),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: PlatformAdaptations.getPlatformButtonStyle(context),
        ),
      );
    }
    if (PlatformAdaptations.isMacOS) {
      return baseTheme.copyWith(
        platform: TargetPlatform.macOS,
        inputDecorationTheme:
            PlatformAdaptations.getPlatformInputDecoration(context),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: PlatformAdaptations.getPlatformButtonStyle(context),
        ),
      );
    }
    if (PlatformAdaptations.isWeb) {
      return baseTheme.copyWith(
        platform: TargetPlatform.linux,
        inputDecorationTheme:
            PlatformAdaptations.getPlatformInputDecoration(context),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: PlatformAdaptations.getPlatformButtonStyle(context),
        ),
      );
    }

    return baseTheme;
  }
}
