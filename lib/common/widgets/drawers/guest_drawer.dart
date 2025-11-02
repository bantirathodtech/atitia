// ============================================================================
// Guest Drawer - Navigation Drawer for Guest Dashboard
// ============================================================================
// Uses AdaptiveDrawer for consistent theme support and platform-specific styling
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adaptive_drawer.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import '../../../core/app/theme/theme_provider.dart';
import '../../../core/app/localization/locale_provider.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/di/firebase/di/firebase_service_locator.dart';

class GuestDrawer extends StatelessWidget {
  /// Navigation callback when drawer items are tapped
  final Function(int)? onNavigationTap;

  /// Current selected tab index
  final int currentTabIndex;

  const GuestDrawer({
    super.key,
    this.onNavigationTap,
    this.currentTabIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveDrawer(
      onItemSelected: (item) => _handleDrawerNavigation(context, item),
      onRoleSwitch: (role) => _handleRoleSwitch(context, role),
      onThemeToggle: () => _handleThemeToggle(context),
      onLanguageToggle: () => _handleLanguageToggle(context),
      onProfileTap: () => _handleProfileTap(context),
      onNotificationsTap: () => _handleNotificationsTap(context),
      onSettingsTap: () => _handleSettingsTap(context),
      onLogout: () => _handleLogout(context),
      showRoleSwitcher: true,
      showThemeToggle: true,
      showLanguageSelector: true,
    );
  }

  void _handleDrawerNavigation(BuildContext context, String item) {
    switch (item) {
      case 'home':
        // Navigate to guest dashboard home
        if (onNavigationTap != null) {
          onNavigationTap!(0); // PG List tab
        }
        break;
      case 'profile':
        // Navigate to guest profile screen
        _handleProfileTap(context);
        break;
      case 'notifications':
        // Navigate to notifications
        _handleNotificationsTap(context);
        break;
      case 'settings':
        // Navigate to settings
        _handleSettingsTap(context);
        break;
      case 'help':
        // Navigate to help & support
        getIt<NavigationService>().goToGuestHelp();
        break;
      case 'logout':
        _handleLogout(context);
        break;
    }
  }

  void _handleRoleSwitch(BuildContext context, String role) {
    if (role == 'owner') {
      // Navigate to owner dashboard
      final navService = getIt<NavigationService>();
      navService.goToOwnerHome();
    }
  }

  void _handleThemeToggle(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  void _handleLanguageToggle(BuildContext context) {
    // Toggle language using LocaleProvider
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.toggleLanguage();
  }

  void _handleProfileTap(BuildContext context) {
    // Navigate to guest profile screen
    getIt<NavigationService>().goToGuestProfile();
  }

  void _handleNotificationsTap(BuildContext context) {
    getIt<NavigationService>().goToGuestNotifications();
  }

  void _handleSettingsTap(BuildContext context) {
    // Navigate to guest settings screen
    getIt<NavigationService>().goToGuestSettings();
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
