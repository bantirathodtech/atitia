// ============================================================================
// Adaptive App Bar - World-Class Reusable App Bar
// ============================================================================
// A highly customizable app bar with advanced features for professional apps.
//
// FEATURES:
// ✨ Automatic theme toggle button (Light/Dark/System modes)
// ✨ Flexible title (String or custom Widget for dropdowns, logos, etc.)
// ✨ Left actions (leadingActions) + Right actions
// ✨ Bottom widget support (for tabs, search bars, filters, etc.)
// ✨ Smart back button handling
// ✨ Adaptive styling based on platform
// ✨ Gradient backgrounds support
// ✨ Dynamic height based on bottom content
//
// USAGE EXAMPLES:
//
// 1. Basic app bar with dropdown title:
//   AdaptiveAppBar(
//     titleWidget: PgSelectorDropdown(),
//     centerTitle: true,
//   )
//
// 2. With left icon + center dropdown + right actions:
//   AdaptiveAppBar(
//     leadingActions: [Icon(Icons.dashboard)],
//     titleWidget: PgSelectorDropdown(),
//     centerTitle: true,
//     actions: [IconButton(...)],
//   )
//
// 3. With bottom section (tabs, filters, etc.):
//   AdaptiveAppBar(
//     title: 'My Screen',
//     bottom: PreferredSize(
//       preferredSize: Size.fromHeight(60),
//       child: CustomBottomWidget(),
//     ),
//   )
// ============================================================================

import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../buttons/theme_toggle_button.dart';

class AdaptiveAppBar extends AdaptiveStatelessWidget
    implements PreferredSizeWidget {
  // ==========================================================================
  // Title Parameters (use one or the other)
  // ==========================================================================
  
  /// App bar title text (simple string)
  final String? title;
  
  /// Custom title widget (for dropdowns, logos, complex titles)
  /// Takes precedence over 'title' if both provided
  final Widget? titleWidget;

  // ==========================================================================
  // Action Parameters
  // ==========================================================================
  
  /// Left-side action buttons (before title)
  /// Example: [Icon(Icons.menu), Icon(Icons.dashboard)]
  final List<Widget>? leadingActions;
  
  /// Right-side action buttons (theme toggle automatically added at end)
  final List<Widget>? actions;
  
  /// Custom leading widget (overrides leadingActions and back button)
  final Widget? leading;
  
  // ==========================================================================
  // Layout Parameters
  // ==========================================================================
  
  /// Center the title (default: false - left-aligned)
  final bool centerTitle;
  
  /// App bar elevation/shadow (default: medium elevation)
  final double elevation;
  
  /// Custom background color (if null, uses theme's app bar color)
  final Color? backgroundColor;
  
  /// Gradient background (overrides backgroundColor if provided)
  final Gradient? backgroundGradient;
  
  /// Show automatic back button when route can pop (default: true)
  final bool showBackButton;
  
  /// Show theme toggle button in actions (default: true)
  final bool showThemeToggle;
  
  /// Bottom widget (for tabs, search, filters, etc.)
  final PreferredSizeWidget? bottom;

  const AdaptiveAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leadingActions,
    this.leading,
    this.centerTitle = false,
    this.elevation = AppSpacing.elevationMedium,
    this.backgroundColor,
    this.backgroundGradient,
    this.showBackButton = true,
    this.showThemeToggle = true,
    this.bottom,
  }) : assert(
          title != null || titleWidget != null,
          'Either title or titleWidget must be provided',
        );

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final appBarBg = backgroundColor ?? theme.appBarTheme.backgroundColor ?? theme.primaryColor;

    // Use gradient background if provided
    Widget? flexibleSpace;
    if (backgroundGradient != null) {
      flexibleSpace = Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
      );
    }

    return AppBar(
      // Title: Use titleWidget if provided, otherwise Text
      title: titleWidget ?? Text(title!, style: AppTypography.appBarTitle),
      
      // Leading: Custom leading, or leadingActions row, or back button
      leading: _buildLeading(context),
      
      // Leading width adjustment when using leadingActions
      leadingWidth: leadingActions != null && leadingActions!.isNotEmpty 
          ? (leadingActions!.length * 48.0) + 8 
          : null,
      
      // Actions: Right-side buttons with auto theme toggle
      actions: _buildActions(),
      
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: appBarBg,
      foregroundColor: theme.appBarTheme.foregroundColor,
      automaticallyImplyLeading: showBackButton && leading == null && (leadingActions == null || leadingActions!.isEmpty),
      flexibleSpace: flexibleSpace,
      
      // Bottom widget support
      bottom: bottom,
    );
  }

  // ==========================================================================
  // Build Leading Widget (Left Side)
  // ==========================================================================
  // Priority order:
  // 1. Custom leading widget (if provided)
  // 2. Leading actions row (if provided)
  // 3. Automatic back button (if route can pop)
  // 4. Nothing (null)
  // ==========================================================================
  Widget? _buildLeading(BuildContext context) {
    // 1. Custom leading widget takes highest precedence
    if (leading != null) return leading;
    
    // 2. Leading actions (multiple icons/buttons on left)
    if (leadingActions != null && leadingActions!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: leadingActions!,
      );
    }
    
    // 3. Don't show back button if explicitly disabled
    if (!showBackButton) return null;

    // 4. Only show back button if route can be popped
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    if (!canPop) return null;

    // 5. Show automatic back button
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  // ==========================================================================
  // Build Actions List (Right Side Actions + Theme Toggle)
  // ==========================================================================
  // Combines custom actions with automatic theme toggle button:
  // 1. Custom actions first (if provided)
  // 2. Theme toggle button at end (if enabled)
  //
  // RESULT: [...custom actions, ThemeToggleButton]
  // ==========================================================================
  List<Widget>? _buildActions() {
    // If no actions and no theme toggle, return null
    if (actions == null && !showThemeToggle) {
      return null;
    }

    // Build combined actions list
    final combinedActions = <Widget>[
      // Add custom actions first (if provided)
      if (actions != null) ...actions!,
      
      // Add theme toggle button at the end (if enabled)
      if (showThemeToggle) const ThemeToggleButton(),
    ];

    return combinedActions;
  }
}
