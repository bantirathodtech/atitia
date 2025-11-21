// lib/feature/guest_dashboard/shared/widgets/guest_tab_navigation_provider.dart

import 'package:flutter/material.dart';

/// Provides tab navigation callback to child widgets
/// Allows drawer and other widgets to directly switch tabs
class GuestTabNavigationProvider extends InheritedWidget {
  final Function(int index) onTabSelected;

  const GuestTabNavigationProvider({
    super.key,
    required this.onTabSelected,
    required super.child,
  });

  static GuestTabNavigationProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GuestTabNavigationProvider>();
  }

  static Function(int)? getTabNavigationCallback(BuildContext context) {
    final provider = of(context);
    return provider?.onTabSelected;
  }

  @override
  bool updateShouldNotify(GuestTabNavigationProvider oldWidget) {
    return onTabSelected != oldWidget.onTabSelected;
  }
}

