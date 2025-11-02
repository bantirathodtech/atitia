// ============================================================================
// Owner App Bar - Specialized App Bar for Owner Dashboard
// ============================================================================
// Uses generic AdaptiveAppBar with owner-specific configurations:
// - Drawer button (left)
// - PG Selector dropdown (center)
// - Refresh + Theme toggle (right)
// - Optional bottom widget (tabs, filters, etc.)
// ============================================================================

import 'package:flutter/material.dart';
import 'adaptive_app_bar.dart';
import '../../../feature/owner_dashboard/shared/widgets/pg_selector_dropdown.dart';

/// Owner-specific app bar using generic AdaptiveAppBar
class OwnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Tab title to display in app bar (optional)
  final String? tabTitle;

  /// Custom title widget (overrides tabTitle if provided)
  final Widget? titleWidget;

  /// Show PG selector dropdown (default: true)
  final bool showPgSelector;

  /// Show refresh button (default: true)
  final bool showRefreshButton;

  /// Show theme toggle (default: true)
  final bool showThemeToggle;

  /// Refresh callback (called when refresh button is tapped)
  final VoidCallback? onRefresh;

  /// Drawer callback (called when drawer button is tapped)
  final VoidCallback? onDrawerTap;

  /// Custom actions (additional to refresh and theme toggle)
  final List<Widget>? additionalActions;

  /// Bottom widget (tabs, search, filters, etc.)
  final PreferredSizeWidget? bottom;

  const OwnerAppBar({
    super.key,
    this.tabTitle,
    this.titleWidget,
    this.showPgSelector = true,
    this.showRefreshButton = true,
    this.showThemeToggle = true,
    this.onRefresh,
    this.onDrawerTap,
    this.additionalActions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveAppBar(
      // Title: Use titleWidget if provided, otherwise PG selector or tab title
      title: showPgSelector ? null : tabTitle,
      titleWidget: showPgSelector
          ? const PgSelectorDropdown(compact: true)
          : titleWidget,

      // Left: Drawer button
      leadingActions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onDrawerTap ?? () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: 'Menu',
        ),
      ],

      // Actions: Refresh + additional actions + theme toggle
      actions: _buildActions(context),

      // Layout
      centerTitle: true,
      showBackButton: false,
      showThemeToggle: showThemeToggle,

      // Bottom widget
      bottom: bottom,
    );
  }

  /// Build actions (refresh + additional + theme toggle)
  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];

    // Add refresh button if enabled
    if (showRefreshButton) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh ??
              () {
                // Default refresh behavior
              },
          tooltip: 'Refresh',
        ),
      );
    }

    // Add additional actions if provided
    if (additionalActions != null) {
      actions.addAll(additionalActions!);
    }

    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Owner App Bar with drawer integration
///
/// This version automatically integrates with Scaffold's drawer
class OwnerAppBarWithDrawer extends StatelessWidget
    implements PreferredSizeWidget {
  /// Tab title to display in app bar (optional)
  final String? tabTitle;

  /// Custom title widget (overrides tabTitle if provided)
  final Widget? titleWidget;

  /// Show PG selector dropdown (default: true)
  final bool showPgSelector;

  /// Show refresh button (default: true)
  final bool showRefreshButton;

  /// Show theme toggle (default: true)
  final bool showThemeToggle;

  /// Refresh callback (called when refresh button is tapped)
  final VoidCallback? onRefresh;

  /// Custom actions (additional to refresh and theme toggle)
  final List<Widget>? additionalActions;

  /// Bottom widget (tabs, search, filters, etc.)
  final PreferredSizeWidget? bottom;

  const OwnerAppBarWithDrawer({
    super.key,
    this.tabTitle,
    this.titleWidget,
    this.showPgSelector = true,
    this.showRefreshButton = true,
    this.showThemeToggle = true,
    this.onRefresh,
    this.additionalActions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return OwnerAppBar(
      tabTitle: tabTitle,
      titleWidget: titleWidget,
      showPgSelector: showPgSelector,
      showRefreshButton: showRefreshButton,
      showThemeToggle: showThemeToggle,
      onRefresh: onRefresh,
      onDrawerTap: () {
        // Automatically open the drawer
        Scaffold.of(context).openDrawer();
      },
      additionalActions: additionalActions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
