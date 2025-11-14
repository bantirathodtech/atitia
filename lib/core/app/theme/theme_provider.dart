// ============================================================================
// Theme Provider - Complete Theme Management
// ============================================================================
// Manages application theme mode with three options:
// 1. Light Mode (Day Theme) - Manual bright theme
// 2. Dark Mode (Night Theme) - Manual dark theme
// 3. System Mode - Follows device system settings
//
// FEATURES:
// - Persists theme preference (can be enhanced with SharedPreferences)
// - Provides theme data to MaterialApp
// - Notifies listeners on theme changes for UI updates
// - Three-way toggle: Light → Dark → System → Light
//
// USAGE IN APP:
// 1. Wrap with ChangeNotifierProvider in main.dart
// 2. Access via context.watch<ThemeProvider>() to rebuild on changes
// 3. Change theme via context.read<ThemeProvider>().cycleTheme()
//
// USAGE IN WIDGETS:
// - Toggle button: ThemeToggleButton widget (automatically added to app bars)
// - Manual set: provider.setThemeMode(ThemeMode.dark)
// - Cycle through: provider.cycleTheme()
// - Check current: provider.themeMode or provider.isLightMode
// ============================================================================

import 'package:atitia/core/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../services/localization/internationalization_service.dart';

class ThemeProvider extends ChangeNotifier {
  final InternationalizationService _i18n =
      InternationalizationService.instance;
  // ==========================================================================
  // Private State - Current theme mode
  // ==========================================================================
  // Default to system theme to respect user's device settings
  // Can be changed to ThemeMode.light or ThemeMode.dark if you want a default
  // ==========================================================================
  ThemeMode _themeMode = ThemeMode.system;

  // ==========================================================================
  // Public Getters
  // ==========================================================================

  /// Get current theme mode (light, dark, or system)
  ThemeMode get themeMode => _themeMode;

  /// Get light theme data from AppTheme (Day mode)
  ThemeData get lightTheme => AppTheme.light;

  /// Get dark theme data from AppTheme (Night mode)
  ThemeData get darkTheme => AppTheme.dark;

  /// Check if currently in light mode
  /// Note: Returns false for system mode even if system is light
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Check if currently in dark mode
  /// Note: Returns false for system mode even if system is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Check if following system theme
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Get human-readable theme mode name
  String get themeModeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return _i18n.translate('lightMode');
      case ThemeMode.dark:
        return _i18n.translate('darkMode');
      case ThemeMode.system:
        return _i18n.translate('systemDefault');
    }
  }

  /// Get icon for current theme mode
  IconData get themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode; // Sun icon for light mode
      case ThemeMode.dark:
        return Icons.dark_mode; // Moon icon for dark mode
      case ThemeMode.system:
        return Icons.brightness_auto; // Auto icon for system mode
    }
  }

  // ==========================================================================
  // Theme Change Methods
  // ==========================================================================

  /// Toggle between light and dark theme (legacy method)
  /// Note: Doesn't include system mode in toggle
  /// Use cycleTheme() for three-way toggle
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Cycle through all three theme modes: Light → Dark → System → Light
  /// This is the recommended method for theme toggle button
  void cycleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark; // Light → Dark
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system; // Dark → System
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.light; // System → Light
        break;
    }
    notifyListeners();

    // TODO: Persist theme preference to SharedPreferences
    // Example: await _prefs.setString('theme_mode', _themeMode.toString());
  }

  /// Set specific theme mode (light, dark, or system)
  /// Use this when user explicitly selects a theme from settings
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();

      // TODO: Persist theme preference to SharedPreferences
      // Example: await _prefs.setString('theme_mode', mode.toString());
    }
  }

  /// Set light mode explicitly
  void setLightMode() => setThemeMode(ThemeMode.light);

  /// Set dark mode explicitly
  void setDarkMode() => setThemeMode(ThemeMode.dark);

  /// Set system mode explicitly
  void setSystemMode() => setThemeMode(ThemeMode.system);

  // ==========================================================================
  // Initialization Method (optional)
  // ==========================================================================
  // Call this in main.dart after initializing SharedPreferences to load
  // saved theme preference
  // ==========================================================================

  /// Load saved theme preference from SharedPreferences
  /// Call this in main.dart before runApp() to restore user's choice
  Future<void> loadThemePreference() async {
    // TODO: Implement SharedPreferences loading
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // final themeModeStr = prefs.getString('theme_mode');
    // if (themeModeStr != null) {
    //   _themeMode = ThemeMode.values.firstWhere(
    //     (mode) => mode.toString() == themeModeStr,
    //     orElse: () => ThemeMode.system,
    //   );
    //   notifyListeners();
    // }
  }
}
