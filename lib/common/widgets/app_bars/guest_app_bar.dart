// ============================================================================
// Guest App Bar - Specialized App Bar for Guest Dashboard
// ============================================================================
// Uses generic AdaptiveAppBar with guest-specific configurations:
// - Drawer button (left)
// - Current PG display (center)
// - Refresh + Theme toggle (right)
// - Optional bottom widget (tabs, search, filters, etc.)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'adaptive_app_bar.dart';
import '../../../feature/owner_dashboard/shared/viewmodel/selected_pg_provider.dart';

/// Guest-specific app bar using generic AdaptiveAppBar
class GuestAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Tab title to display in app bar (optional)
  final String? tabTitle;

  /// Custom title widget (overrides tabTitle if provided)
  final Widget? titleWidget;

  /// Show current PG display (default: true)
  final bool showCurrentPg;

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

  const GuestAppBar({
    super.key,
    this.tabTitle,
    this.titleWidget,
    this.showCurrentPg = true,
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
      // Title: Use titleWidget if provided, otherwise current PG or tab title
      title: showCurrentPg ? null : tabTitle,
      titleWidget:
          showCurrentPg ? _buildCurrentPgDisplay(context) : titleWidget,

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

  /// Build current PG display widget
  Widget _buildCurrentPgDisplay(BuildContext context) {
    return Consumer<SelectedPgProvider>(
      builder: (context, selectedPgProvider, child) {
        final selectedPg = selectedPgProvider.selectedPg;

        if (selectedPg != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.home,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  selectedPg.pgName,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  'No PG Selected',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }
      },
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

/// Guest App Bar with drawer integration
///
/// This version automatically integrates with Scaffold's drawer
class GuestAppBarWithDrawer extends StatelessWidget
    implements PreferredSizeWidget {
  /// Tab title to display in app bar (optional)
  final String? tabTitle;

  /// Custom title widget (overrides tabTitle if provided)
  final Widget? titleWidget;

  /// Show current PG display (default: true)
  final bool showCurrentPg;

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

  const GuestAppBarWithDrawer({
    super.key,
    this.tabTitle,
    this.titleWidget,
    this.showCurrentPg = true,
    this.showRefreshButton = true,
    this.showThemeToggle = true,
    this.onRefresh,
    this.additionalActions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return GuestAppBar(
      tabTitle: tabTitle,
      titleWidget: titleWidget,
      showCurrentPg: showCurrentPg,
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
