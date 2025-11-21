// ============================================================================
// Guest Drawer - Navigation Drawer for Guest Dashboard
// ============================================================================
// Uses AdaptiveDrawer for consistent theme support and platform-specific styling
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/drawers/adaptive_drawer.dart';
import '../../../../common/widgets/dialogs/confirmation_dialog.dart';
import '../../../../core/app/localization/locale_provider.dart';
import '../../../../core/app/theme/theme_provider.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../auth/logic/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';
import 'guest_tab_navigation_provider.dart';

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
    // Close drawer first
    Navigator.of(context).pop();
    
    // Try to get tab navigation callback from provider (preferred method)
    final tabNavigation = GuestTabNavigationProvider.getTabNavigationCallback(context);
    if (tabNavigation != null) {
      debugPrint('✅ GuestDrawer: Using provider callback for: $item');
      switch (item) {
        case 'pgs':
          tabNavigation(0); // Callback handles both tab switch and route navigation
          return;
        case 'foods':
          tabNavigation(1);
          return;
        case 'payments':
          tabNavigation(2);
          return;
        case 'requests':
          tabNavigation(3);
          return;
        case 'complaints':
          tabNavigation(4);
          return;
      }
    } else {
      debugPrint('⚠️ GuestDrawer: Provider not found for: $item, using fallback');
    }
    
    // Fallback: Use callback if provided (for backward compatibility)
    if (onNavigationTap != null) {
      switch (item) {
        case 'pgs':
          onNavigationTap!(0); // PGs tab
          return;
        case 'foods':
          onNavigationTap!(1); // Foods tab
          return;
        case 'payments':
          onNavigationTap!(2); // Payments tab
          return;
        case 'requests':
          onNavigationTap!(3); // Requests tab
          return;
        case 'complaints':
          onNavigationTap!(4); // Complaints tab
          return;
      }
    }
    
    // Final fallback: Route navigation (should not be needed if provider is set up)
    // This should not happen if provider is working correctly
    debugPrint('⚠️ GuestDrawer: Provider not found, using route navigation for: $item');
    final navService = getIt<NavigationService>();
    switch (item) {
      case 'pgs':
        navService.goToGuestPGs();
        break;
      case 'foods':
        navService.goToGuestFoods();
        break;
      case 'payments':
        navService.goToGuestPayments();
        break;
      case 'requests':
        navService.goToRoute('/guest/requests');
        break;
      case 'complaints':
        navService.goToGuestComplaints();
        break;
      case 'profile':
        // Navigate to guest profile screen
        Navigator.of(context).pop(); // Close drawer
        _handleProfileTap(context);
        break;
      case 'notifications':
        // Navigate to notifications
        Navigator.of(context).pop(); // Close drawer
        _handleNotificationsTap(context);
        break;
      case 'settings':
        // Navigate to settings
        Navigator.of(context).pop(); // Close drawer
        _handleSettingsTap(context);
        break;
      case 'help':
        // Navigate to help & support
        Navigator.of(context).pop(); // Close drawer
        navService.goToGuestHelp();
        break;
      case 'logout':
        Navigator.of(context).pop(); // Close drawer
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
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: loc.logout,
        message: loc.areYouSureYouWantToLogout,
        confirmText: loc.logout,
        cancelText: loc.cancel,
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(context); // Close dialog
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          authProvider.signOut();
        },
        onCancel: () {
          Navigator.pop(context); // Close dialog
        },
      ),
    );
  }
}
