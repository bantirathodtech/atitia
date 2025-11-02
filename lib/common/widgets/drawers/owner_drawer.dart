// ============================================================================
// Owner Drawer - Navigation Drawer for Owner Dashboard
// ============================================================================
// Displays owner information and navigation options:
// - Header: Avatar, name, role, current PG
// - Navigation: Dashboard items
// - Footer: Personal details, settings, logout
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../images/adaptive_image.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import '../../../feature/owner_dashboard/shared/viewmodel/selected_pg_provider.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.surface,
      child: Column(
        children: [
          // Header Section
          _buildHeader(context, isDark),

          // Navigation Section
          Expanded(
            child: _buildNavigation(context, isDark),
          ),

          // Footer Section
          _buildFooter(context, isDark),
        ],
      ),
    );
  }

  /// Build header section with owner info
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Consumer2<AuthProvider, SelectedPgProvider>(
      builder: (context, authProvider, selectedPgProvider, child) {
        final user = authProvider.user;
        final selectedPg = selectedPgProvider.selectedPg;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.primary.withValues(alpha: 0.8),
                      AppColors.primary.withValues(alpha: 0.6)
                    ]
                  : [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8)
                    ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar and basic info
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: user?.profilePhotoUrl != null
                            ? AdaptiveImage(
                                imageUrl: user!.profilePhotoUrl!,
                                fit: BoxFit.cover,
                                placeholder: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.paddingM),

                    // Name and role
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Owner',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Role: Owner',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Current PG info
                if (selectedPg != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM,
                      vertical: AppSpacing.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.home,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedPg.pgName,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM,
                      vertical: AppSpacing.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No PG Selected',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build navigation section
  Widget _buildNavigation(BuildContext context, bool isDark) {
    final navigationItems = [
      _DrawerItem(
        icon: Icons.dashboard,
        title: 'Overview',
        index: 0,
      ),
      _DrawerItem(
        icon: Icons.restaurant_menu,
        title: 'Food Management',
        index: 1,
      ),
      _DrawerItem(
        icon: Icons.home,
        title: 'My PGs',
        index: 2,
      ),
      _DrawerItem(
        icon: Icons.people,
        title: 'Guest Management',
        index: 3,
      ),
      _DrawerItem(
        icon: Icons.analytics,
        title: 'Reports & Analytics',
        index: -1, // Special item
      ),
      _DrawerItem(
        icon: Icons.payment,
        title: 'Payments',
        index: -2, // Special item
      ),
      _DrawerItem(
        icon: Icons.notifications,
        title: 'Notifications',
        index: -3, // Special item
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
      itemCount: navigationItems.length,
      itemBuilder: (context, index) {
        final item = navigationItems[index];
        final isSelected = item.index == currentTabIndex;

        return ListTile(
          leading: Icon(
            item.icon,
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.textSecondary : AppColors.textTertiary),
            size: 24,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textPrimary : AppColors.textPrimary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          selected: isSelected,
          selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
          onTap: () {
            Navigator.of(context).pop(); // Close drawer

            if (item.index >= 0 && onNavigationTap != null) {
              // Navigate to tab
              onNavigationTap!(item.index);
            } else {
              // Handle special navigation items
              _handleSpecialNavigation(context, item.index);
            }
          },
        );
      },
    );
  }

  /// Build footer section with actions
  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Personal Details
          ListTile(
            leading: Icon(
              Icons.person_outline,
              color: isDark ? AppColors.textSecondary : AppColors.textTertiary,
            ),
            title: Text(
              'Personal Details',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to personal details screen
            },
          ),

          // Settings
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: isDark ? AppColors.textSecondary : AppColors.textTertiary,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to settings screen
            },
          ),

          // Switch Role
          ListTile(
            leading: Icon(
              Icons.swap_horiz,
              color: isDark ? AppColors.textSecondary : AppColors.textTertiary,
            ),
            title: Text(
              'Switch Role',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _showSwitchRoleDialog(context);
            },
          ),

          // Help & Support
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: isDark ? AppColors.textSecondary : AppColors.textTertiary,
            ),
            title: Text(
              'Help & Support',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to help & support screen
            },
          ),

          const SizedBox(height: AppSpacing.paddingM),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Logout',
              onPressed: () {
                Navigator.of(context).pop();
                _showLogoutDialog(context);
              },
              backgroundColor: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle special navigation items
  void _handleSpecialNavigation(BuildContext context, int index) {
    switch (index) {
      case -1: // Reports & Analytics
        // TODO: Navigate to reports screen
        debugPrint('📊 Navigate to Reports & Analytics');
        break;
      case -2: // Payments
        // TODO: Navigate to payments screen
        debugPrint('💰 Navigate to Payments');
        break;
      case -3: // Notifications
        // TODO: Navigate to notifications screen
        debugPrint('🔔 Navigate to Notifications');
        break;
    }
  }

  /// Show switch role dialog
  void _showSwitchRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Role'),
        content: const Text('Are you sure you want to switch to Guest role?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement role switching logic
            },
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }

  /// Show logout dialog
  void _showLogoutDialog(BuildContext context) {
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
              // TODO: Implement logout logic
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

/// Helper class for drawer navigation items
class _DrawerItem {
  final IconData icon;
  final String title;
  final int index; // -1 for special items, 0+ for tabs

  _DrawerItem({
    required this.icon,
    required this.title,
    required this.index,
  });
}
