// ============================================================================
// Owner Drawer - Navigation Drawer for Owner Dashboard
// ============================================================================
// Uses AdaptiveDrawer for consistent theme support and platform-specific styling
// Same implementation as Guest Drawer for consistency
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/drawers/adaptive_drawer.dart';
import '../../../../common/widgets/buttons/text_button.dart';
import '../../../../common/widgets/text/heading_medium.dart';
import '../../../../common/widgets/text/body_text.dart';
import '../../../../common/styles/spacing.dart';
import '../../../../common/utils/extensions/context_extensions.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/app/theme/theme_provider.dart';
import '../../../../core/app/localization/locale_provider.dart';
import '../../../auth/logic/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';

class OwnerDrawer extends StatelessWidget {
  /// Navigation callback when drawer items are tapped
  final Function(int)? onNavigationTap;

  /// Current selected tab index
  final int currentTabIndex;

  const OwnerDrawer({
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
      case 'dashboard':
        // Navigate to owner dashboard home (Overview tab)
        if (onNavigationTap != null) {
          onNavigationTap!(0); // Overview tab
        }
        break;
      case 'food':
        // Navigate to Food tab
        if (onNavigationTap != null) {
          onNavigationTap!(1); // Food tab
        }
        break;
      case 'pgs':
        // Navigate to PGs tab
        if (onNavigationTap != null) {
          onNavigationTap!(2); // PGs tab
        }
        break;
      case 'guest':
        // Navigate to Guest tab
        if (onNavigationTap != null) {
          onNavigationTap!(3); // Guest tab
        }
        break;
      case 'profile':
        // Navigate to owner profile screen
        _handleProfileTap(context);
        break;
      case 'notifications':
        // Navigate to notifications screen
        _handleNotificationsTap(context);
        break;
      case 'settings':
        // Navigate to settings screen
        _handleSettingsTap(context);
        break;
      case 'help':
        getIt<NavigationService>().goToOwnerHelp();
        break;
      case 'analytics':
        getIt<NavigationService>().goToOwnerAnalytics();
        break;
      case 'reports':
        getIt<NavigationService>().goToOwnerReports();
        break;
      case 'subscription':
        getIt<NavigationService>().goToOwnerSubscriptionPlans();
        break;
      case 'featured':
        getIt<NavigationService>().goToOwnerFeaturedListingManagement();
        break;
      case 'refundRequest':
        getIt<NavigationService>().goToOwnerRefundRequest();
        break;
      case 'refundHistory':
        getIt<NavigationService>().goToOwnerRefundHistory();
        break;
      case 'logout':
        _handleLogout(context);
        break;
    }
  }

  void _handleRoleSwitch(BuildContext context, String role) {
    // STRICT: Role switching requires re-authentication with new role
    // For security, we should sign out and require user to select role and authenticate again
    // However, if user is already authenticated with the requested role, navigate directly
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentRole = authProvider.user?.role.toLowerCase().trim();
    final navigationService = getIt<NavigationService>();

    final targetRole = role.toLowerCase().trim();

    // STRICT: Only allow navigation if roles match exactly
    if (targetRole == 'guest' && currentRole == 'guest') {
      navigationService.goToGuestHome();
    } else if (targetRole == 'owner' && currentRole == 'owner') {
      // Already on owner dashboard, no navigation needed
    } else {
      // Role mismatch - require re-authentication
      // For security, sign out and redirect to role selection
      debugPrint(
          '⚠️ OwnerDrawer: Role switch requires re-authentication. Current: $currentRole, Requested: $targetRole');
      // Note: Proper role switching would require sign out and re-auth
      // For now, show message that user must sign out and sign in with different role
    }
  }

  void _handleThemeToggle(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  void _handleLanguageToggle(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.toggleLanguage();
  }

  void _handleProfileTap(BuildContext context) {
    // Navigate to owner profile screen
    getIt<NavigationService>().goToOwnerProfile();
  }

  void _handleNotificationsTap(BuildContext context) {
    getIt<NavigationService>().goToOwnerNotifications();
  }

  void _handleSettingsTap(BuildContext context) {
    getIt<NavigationService>().goToOwnerSettings();
  }

  void _handleLogout(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    final isDarkMode = context.isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    
    // Capture the auth provider from the original context
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        backgroundColor: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.logout),
              const SizedBox(height: AppSpacing.paddingM),
              BodyText(text: loc.areYouSureYouWantToLogout),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    text: loc.cancel,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  TextButtonWidget(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      authProvider.signOut();
                    },
                    text: loc.logout,
                    color: isDarkMode ? Colors.redAccent : Colors.red,
                    bold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
