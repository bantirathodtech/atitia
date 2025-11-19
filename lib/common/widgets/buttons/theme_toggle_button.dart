// ============================================================================
// Theme Toggle Button - Universal Theme Switcher
// ============================================================================
// A beautiful, animated button for switching between Light, Dark, and System themes.
//
// FEATURES:
// - Three-way toggle: Light Mode → Dark Mode → System Mode → repeat
// - Animated icon transitions with smooth color changes
// - Tooltip showing current and next theme mode
// - Can be placed in any app bar or toolbar
// - Automatically rebuilds when theme changes
//
// HOW IT WORKS:
// 1. User taps button
// 2. Cycles through: Light → Dark → System → Light
// 3. Icon and color animate to reflect new mode
// 4. Entire app rebuilds with new theme
//
// ICONS:
// - Light Mode: ☀️ Sun icon (Icons.light_mode)
// - Dark Mode: 🌙 Moon icon (Icons.dark_mode)
// - System Mode: 🔄 Auto icon (Icons.brightness_auto)
//
// USAGE:
// Simply add to any app bar actions:
//   AppBar(
//     actions: [
//       ThemeToggleButton(),  // That's it!
//     ],
//   )
//
// Or use standalone in any widget tree:
//   ThemeToggleButton(size: 24.0)  // Custom icon size
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/styles/spacing.dart';
import '../../../core/app/theme/theme_provider.dart';
import '../../../l10n/app_localizations.dart';

class ThemeToggleButton extends StatelessWidget {
  // ==========================================================================
  // Optional Parameters
  // ==========================================================================

  /// Icon size (default: 24.0 for standard app bar icons)
  final double size;

  /// Custom tooltip text (if null, auto-generates based on current mode)
  final String? tooltip;

  /// Show theme mode name next to icon (useful for settings screens)
  final bool showLabel;

  /// Enable haptic feedback on tap (optional tactile response)
  final bool enableHapticFeedback;

  const ThemeToggleButton({
    super.key,
    this.size = 24.0,
    this.tooltip,
    this.showLabel = false,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    // ==========================================================================
    // Watch ThemeProvider to rebuild when theme changes
    // ==========================================================================
    // Using context.watch ensures this widget rebuilds when user changes theme
    // This keeps the icon and colors in sync with current theme mode
    // ==========================================================================
    final themeProvider = context.watch<ThemeProvider>();

    // ==========================================================================
    // Get current theme info
    // ==========================================================================
    final currentMode = themeProvider.themeMode;
    final icon = themeProvider.themeModeIcon;

    String localizedModeName(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.light:
          return AppLocalizations.of(context)?.lightMode ?? 'Light Mode';
        case ThemeMode.dark:
          return AppLocalizations.of(context)?.darkMode ?? 'Dark Mode';
        case ThemeMode.system:
          return AppLocalizations.of(context)?.systemDefault ??
              'System Default';
      }
    }

    ThemeMode nextThemeMode(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.light:
          return ThemeMode.dark;
        case ThemeMode.dark:
          return ThemeMode.system;
        case ThemeMode.system:
          return ThemeMode.light;
      }
    }

    final modeName = localizedModeName(currentMode);
    final nextMode = nextThemeMode(currentMode);
    final nextModeName = localizedModeName(nextMode);

    // ==========================================================================
    // Get icon color based on current theme
    // ==========================================================================
    // Fully theme-aware icon color that adapts to day/night modes
    // Uses theme's color scheme for proper contrast and visibility
    // ==========================================================================
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? colorScheme.primary // Primary color in dark mode for visibility
        : colorScheme.onSurface; // On-surface color in light mode for contrast

    // ==========================================================================
    // Build button based on showLabel parameter
    // ==========================================================================
    if (showLabel) {
      // WITH LABEL - For settings screens or expanded toolbars
      return InkWell(
        onTap: () {
          if (enableHapticFeedback) {
            // Optional: Add haptic feedback
            // HapticFeedback.lightImpact();
          }
          themeProvider.cycleTheme();
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon with color transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  icon,
                  key: ValueKey<IconData>(icon), // Key for animation
                  color: iconColor,
                  size: size,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              // Theme mode name text
              Text(
                modeName,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // ICON ONLY - Standard button for app bars
      return IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            // Smooth rotation and fade transition between icons
            return RotationTransition(
              turns: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            icon,
            key: ValueKey<IconData>(icon), // Key ensures animation triggers
            color: iconColor,
            size: size,
          ),
        ),
        tooltip: tooltip ??
            AppLocalizations.of(context)
                ?.themeTooltip(modeName, nextModeName) ??
            'Theme: $modeName\nTap for $nextModeName',
        onPressed: () {
          if (enableHapticFeedback) {
            // Optional: Add haptic feedback
            // HapticFeedback.lightImpact();
          }
          themeProvider.cycleTheme();
        },
      );
    }
  }
}

// ============================================================================
// Theme Mode Selector - For Settings Screens
// ============================================================================
// A more detailed theme selector with all three options visible at once.
// Use this in settings/preferences screens where user wants to see all options.
//
// USAGE:
//   ThemeModeSelector()  // Shows all three options with radio buttons
// ============================================================================

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final loc = AppLocalizations.of(context);

    final title = loc?.themeModeTitle ?? 'Theme Mode';
    final lightModeLabel = loc?.lightMode ?? 'Light Mode';
    final darkModeLabel = loc?.darkMode ?? 'Dark Mode';
    final systemDefaultLabel = loc?.systemDefault ?? 'System Default';
    final lightModeDescription =
        loc?.themeLightDescription ?? 'Always use bright theme';
    final darkModeDescription =
        loc?.themeDarkDescription ?? 'Always use dark theme';
    final systemModeDescription =
        loc?.themeSystemDescription ?? 'Follow device settings';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.paddingS),

            // Light Mode Option
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.light,
              Icons.light_mode,
              lightModeLabel,
              lightModeDescription,
            ),
            const Divider(height: 1),

            // Dark Mode Option
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.dark,
              Icons.dark_mode,
              darkModeLabel,
              darkModeDescription,
            ),
            const Divider(height: 1),

            // System Mode Option
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.system,
              Icons.brightness_auto,
              systemDefaultLabel,
              systemModeDescription,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single theme option radio tile
  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider provider,
    ThemeMode mode,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = provider.themeMode == mode;

    return InkWell(
      onTap: () => provider.setThemeMode(mode),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Icon
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: AppSpacing.paddingM),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Radio button indicator
            // TODO: Update to RadioGroup when Flutter version supports it
            // ignore: deprecated_member_use
            Radio<ThemeMode>(
              value: mode,
              // ignore: deprecated_member_use
              groupValue: provider.themeMode,
              // ignore: deprecated_member_use
              onChanged: (value) {
                if (value != null) {
                  provider.setThemeMode(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
