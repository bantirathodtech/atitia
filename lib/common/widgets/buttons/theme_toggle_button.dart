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

import '../../../core/app/theme/theme_provider.dart';

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
    final modeName = themeProvider.themeModeName;

    // ==========================================================================
    // Determine next theme mode for tooltip
    // ==========================================================================
    String nextModeName;
    switch (currentMode) {
      case ThemeMode.light:
        nextModeName = 'Dark Mode';
        break;
      case ThemeMode.dark:
        nextModeName = 'System Default';
        break;
      case ThemeMode.system:
        nextModeName = 'Light Mode';
        break;
    }

    // ==========================================================================
    // Get icon color based on current theme
    // ==========================================================================
    // In light mode: Use primary color for visibility
    // In dark mode: Use light color for contrast
    // This ensures the icon is always visible regardless of background
    // ==========================================================================
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.amber // Warm amber in dark mode (sun/moon color)
        : Theme.of(context)
            .appBarTheme
            .foregroundColor; // Theme-based white color in light mode

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
              const SizedBox(width: 8),
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
        tooltip: tooltip ?? 'Theme: $modeName\nTap for $nextModeName',
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Text(
              'Theme Mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Light Mode Option
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.light,
              Icons.light_mode,
              'Light Mode',
              'Always use bright theme',
            ),
            const Divider(height: 1),

            // Dark Mode Option
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.dark,
              Icons.dark_mode,
              'Dark Mode',
              'Always use dark theme',
            ),
            const Divider(height: 1),

            // System Mode Option
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.system,
              Icons.brightness_auto,
              'System Default',
              'Follow device settings',
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
            const SizedBox(width: 16),

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
