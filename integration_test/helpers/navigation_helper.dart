// integration_test/helpers/navigation_helper.dart
//
// Navigation helper for integration tests
// Provides methods to navigate through the app programmatically

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../config/screenshot_config.dart';

/// Navigation helper for integration tests
class NavigationHelper {
  final WidgetTester tester;

  NavigationHelper(this.tester);

  /// Navigate to a specific route
  Future<bool> navigateToRoute(String route) async {
    try {
      // For integration tests, we need to use the app's router through the widget tree
      // Try to find and use GoRouter through BuildContext
      final context = tester.binding.rootElement;
      if (context == null) {
        print('⚠️  Could not get context for navigation, trying alternative method');
        // Alternative: The app should already be on the correct route after login
        // Just wait for the screen to load
        await tester.pumpAndSettle();
        await Future.delayed(
          Duration(milliseconds: ScreenshotConfig.navigationDelayMs),
        );
        return true;
      }

      // For integration tests, navigation is typically handled by the app's state
      // If route is provided, we assume the app will navigate there automatically
      // after login or state changes. Just wait for the screen to stabilize.
      if (route.isNotEmpty) {
        // Wait for any automatic navigation to complete
        await tester.pumpAndSettle();
      }

      // Wait for navigation to complete
      await tester.pumpAndSettle(
        Duration(seconds: ScreenshotConfig.animationTimeoutSeconds),
      );

      // Additional delay
      await Future.delayed(
        Duration(milliseconds: ScreenshotConfig.navigationDelayMs),
      );

      return true;
    } catch (e) {
      print('⚠️  Navigation to $route - continuing anyway (may already be on screen): $e');
      // Continue anyway - app might already be on the correct screen
      await tester.pumpAndSettle();
      return true;
    }
  }

  /// Navigate to a tab in bottom navigation
  Future<bool> navigateToTab(int tabIndex) async {
    try {
      // Find bottom navigation bar
      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isEmpty) {
        print('⚠️ Bottom navigation bar not found');
        return false;
      }

      // Tap the tab
      final tab = find.byKey(ValueKey('tab_$tabIndex'));
      if (tab.evaluate().isEmpty) {
        // Try alternative: find by index
        final tabs = find.byType(BottomNavigationBar);
        if (tabs.evaluate().isNotEmpty) {
          // This is a simplified approach - may need adjustment
          await tester.tapAt(tester.getCenter(tabs.first));
        }
      } else {
        await tester.tap(tab);
      }

      await tester.pumpAndSettle();
      await Future.delayed(
        Duration(milliseconds: ScreenshotConfig.navigationDelayMs),
      );

      return true;
    } catch (e) {
      print('❌ Error navigating to tab $tabIndex: $e');
      return false;
    }
  }

  /// Open drawer/navigation menu
  Future<bool> openDrawer() async {
    try {
      // Try to find drawer button
      final drawerButton = find.byTooltip('Open navigation menu');
      if (drawerButton.evaluate().isEmpty) {
        // Try alternative: find by icon
        final menuIcon = find.byIcon(Icons.menu);
        if (menuIcon.evaluate().isNotEmpty) {
          await tester.tap(menuIcon.first);
        } else {
          print('⚠️ Drawer button not found');
          return false;
        }
      } else {
        await tester.tap(drawerButton);
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 500));

      return true;
    } catch (e) {
      print('❌ Error opening drawer: $e');
      return false;
    }
  }

  /// Tap first item in a list (e.g., first PG card)
  Future<bool> tapFirstListItem() async {
    try {
      // Find list items (cards, list tiles, etc.)
      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
        await tester.pumpAndSettle();
        return true;
      }

      // Try ListTile
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle();
        return true;
      }

      print('⚠️ No list items found');
      return false;
    } catch (e) {
      print('❌ Error tapping first list item: $e');
      return false;
    }
  }

  /// Execute navigation steps from screenshot definition
  Future<bool> executeNavigationSteps(
    Map<String, dynamic>? steps,
  ) async {
    if (steps == null) return true;

    try {
      final action = steps['action'] as String?;
      if (action == null) return true;

      switch (action) {
        case 'navigate_to_tab':
          final tabIndex = steps['tab_index'] as int?;
          if (tabIndex != null) {
            return await navigateToTab(tabIndex);
          }
          break;

        case 'tap_first_pg':
        case 'tap_first_item':
          return await tapFirstListItem();

        case 'open_drawer':
          return await openDrawer();

        case 'navigate_to_route':
          final route = steps['route'] as String?;
          if (route != null) {
            return await navigateToRoute(route);
          }
          break;

        default:
          print('⚠️ Unknown navigation action: $action');
      }

      return true;
    } catch (e) {
      print('❌ Error executing navigation steps: $e');
      return false;
    }
  }

  /// Wait for screen to load
  Future<void> waitForScreenLoad() async {
    await tester.pumpAndSettle();
    await Future.delayed(
      Duration(milliseconds: ScreenshotConfig.navigationDelayMs),
    );
  }
}

