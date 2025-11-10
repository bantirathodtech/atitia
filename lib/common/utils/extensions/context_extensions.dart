import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../constants/app.dart';
import '../constants/platform.dart';

/// Extension methods for BuildContext for common operations
///
/// ## Usage:
/// ```dart
/// context.showSnackBar('Operation successful')
/// context.isDarkMode
/// ```
extension ContextExtensions on BuildContext {
  // MARK: - Theme & Styling
  // ==========================================

  /// Returns current theme data
  ThemeData get theme => Theme.of(this);

  /// Returns current color scheme
  ColorScheme get colors => theme.colorScheme;

  /// Returns current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Returns true if dark mode is enabled
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Returns primary color from theme
  Color get primaryColor => theme.primaryColor;

  // MARK: - Media Query Helpers
  // ==========================================

  /// Returns media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns screen width
  double get screenWidth => mediaQuery.size.width;

  /// Returns screen height
  double get screenHeight => mediaQuery.size.height;

  /// Returns true if screen is in landscape orientation
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Returns true if screen is small (mobile)
  bool get isMobile => screenWidth < 600;

  /// Returns true if screen is medium (tablet)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Returns true if screen is large (desktop)
  bool get isDesktop => screenWidth >= 1200;

  // MARK: - Navigation Helpers
  // ==========================================

  /// Navigates to a new screen
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Navigates to a new screen and replace current
  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Pops current screen
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Returns true if can pop current screen
  bool get canPop => Navigator.of(this).canPop();

  // MARK: - Dialog & Snackbar Helpers
  // ==========================================

  /// Shows a snackbar with consistent styling
  void showSnackBar(
    String message, {
    Duration duration = PlatformConstants.snackbarDuration,
    SnackBarAction? action,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        duration: duration,
        action: action,
        backgroundColor: isError ? colors.error : colors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool destructive = false,
  }) async {
    final loc = AppLocalizations.of(this);
    final confirmLabel = confirmText ?? loc?.confirm ?? 'Confirm';
    final cancelLabel = cancelText ?? loc?.cancel ?? 'Cancel';

    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: destructive ? colors.error : colors.primary,
            ),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  // MARK: - Platform & Device Helpers
  // ==========================================

  /// Returns true if app is running in debug mode
  bool get isDebugMode => PlatformConstants.isDebug;

  /// Returns true if app is running in release mode
  bool get isReleaseMode => PlatformConstants.isRelease;

  /// Returns safe area padding
  EdgeInsets get safeAreaPadding => mediaQuery.padding;

  /// Returns status bar height
  double get statusBarHeight => mediaQuery.padding.top;

  /// Returns bottom safe area height
  double get bottomSafeArea => mediaQuery.padding.bottom;
}
