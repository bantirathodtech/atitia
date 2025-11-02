// ============================================================================
// Adaptive Drawer - World-Class 4-Platform Navigation Drawer
// ============================================================================
// A perfectly adaptive and responsive navigation drawer for iOS, Android, macOS, and Web.
//
// FEATURES:
// ✨ Platform-specific styling (iOS Cupertino, Android Material, macOS native, Web optimized)
// ✨ 5-section structure: Header, Menu, Switcher, Footer, Design
// ✨ User profile integration with Firebase Auth
// ✨ Role-based navigation (Guest/Owner)
// ✨ Theme and language switching
// ✨ Multi-company/workspace support
// ✨ Responsive design with dynamic content
// ✨ Enhanced accessibility support
// ✨ Web-specific hover states and keyboard navigation
//
// PLATFORM BEHAVIOR:
// - iOS: Cupertino-style drawer with native iOS styling
// - Android: Material Design 3 NavigationDrawer with proper elevation
// - macOS: Native macOS styling with proper spacing and appearance
// - Web: Custom optimized styling with hover effects and keyboard navigation
//
// USAGE EXAMPLES:
//
// 1. Basic adaptive drawer:
//   AdaptiveDrawer(
//     onItemSelected: (item) => _handleNavigation(item),
//     onThemeToggle: () => _toggleTheme(),
//     onLanguageToggle: () => _toggleLanguage(),
//   )
//
// 2. With custom header and role switching:
//   AdaptiveDrawer(
//     onItemSelected: (item) => _handleNavigation(item),
//     onRoleSwitch: (role) => _switchRole(role),
//     showCompanySwitcher: true,
//     currentCompany: 'Atitia PG Management',
//   )
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import '../../../core/app/theme/theme_provider.dart';

class AdaptiveDrawer extends AdaptiveStatelessWidget {
  // ==========================================================================
  // Navigation Callbacks
  // ==========================================================================

  /// Callback when a menu item is selected
  final Function(String item)? onItemSelected;

  /// Callback when role is switched (Guest/Owner)
  final Function(String role)? onRoleSwitch;

  /// Callback when theme is toggled
  final VoidCallback? onThemeToggle;

  /// Callback when language is toggled
  final VoidCallback? onLanguageToggle;

  /// Callback when profile is tapped
  final VoidCallback? onProfileTap;

  /// Callback when notifications are tapped
  final VoidCallback? onNotificationsTap;

  /// Callback when settings are tapped
  final VoidCallback? onSettingsTap;

  /// Callback when company/workspace is switched
  final Function(String company)? onCompanySwitch;

  /// Callback when logout is triggered
  final VoidCallback? onLogout;

  // ==========================================================================
  // Configuration Options
  // ==========================================================================

  /// Show company/workspace switcher section
  final bool showCompanySwitcher;

  /// Current company/workspace name
  final String? currentCompany;

  /// Available companies/workspaces for switching
  final List<String>? availableCompanies;

  /// Show role switcher in header
  final bool showRoleSwitcher;

  /// Show theme toggle in header
  final bool showThemeToggle;

  /// Show language selector in header
  final bool showLanguageSelector;

  /// Custom header widget (overrides default header)
  final Widget? customHeader;

  /// Custom menu items (overrides default role-based menu)
  final List<DrawerMenuItem>? customMenuItems;

  /// Force specific platform styling
  final TargetPlatform? forcePlatform;

  const AdaptiveDrawer({
    super.key,
    this.onItemSelected,
    this.onRoleSwitch,
    this.onThemeToggle,
    this.onLanguageToggle,
    this.onProfileTap,
    this.onNotificationsTap,
    this.onSettingsTap,
    this.onCompanySwitch,
    this.onLogout,
    this.showCompanySwitcher = false,
    this.currentCompany,
    this.availableCompanies,
    this.showRoleSwitcher = true,
    this.showThemeToggle = true,
    this.showLanguageSelector = true,
    this.customHeader,
    this.customMenuItems,
    this.forcePlatform,
  });

  // ==========================================================================
  // Platform Detection Helper Methods
  // ==========================================================================

  /// Get current platform with override support
  TargetPlatform _getCurrentPlatform(BuildContext context) {
    if (forcePlatform != null) return forcePlatform!;
    return Theme.of(context).platform;
  }

  /// Check if running on iOS
  bool _isIOS(BuildContext context) =>
      _getCurrentPlatform(context) == TargetPlatform.iOS;

  /// Check if running on Android
  bool _isAndroid(BuildContext context) =>
      _getCurrentPlatform(context) == TargetPlatform.android;

  /// Check if running on macOS
  bool _isMacOS(BuildContext context) =>
      _getCurrentPlatform(context) == TargetPlatform.macOS;

  /// Check if running on Web
  bool _isWeb(BuildContext context) => kIsWeb;

  @override
  Widget buildAdaptive(BuildContext context) {
    // Platform-specific drawer implementation
    if (_isIOS(context)) {
      return _buildIOSDrawer(context);
    } else if (_isAndroid(context)) {
      return _buildAndroidDrawer(context);
    } else if (_isMacOS(context)) {
      return _buildMacOSDrawer(context);
    } else if (_isWeb(context)) {
      return _buildWebDrawer(context);
    } else {
      // Fallback to Material Drawer
      return _buildMaterialDrawer(context);
    }
  }

  // ==========================================================================
  // Platform-Specific Drawer Builders
  // ==========================================================================

  /// Build iOS-style Cupertino Drawer
  Widget _buildIOSDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark
            ? CupertinoColors.systemGrey6
            : CupertinoColors.systemBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildMenu(context)),
          if (showCompanySwitcher) _buildCompanySwitcher(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Build Android-style Material NavigationDrawer
  Widget _buildAndroidDrawer(BuildContext context) {
    return NavigationDrawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      surfaceTintColor: Colors.transparent,
      children: [
        _buildHeader(context),
        _buildMenu(context),
        if (showCompanySwitcher) _buildCompanySwitcher(context),
        _buildFooter(context),
      ],
    );
  }

  /// Build macOS-style Drawer
  Widget _buildMacOSDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildMenu(context)),
          if (showCompanySwitcher) _buildCompanySwitcher(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Build Web-optimized Drawer
  Widget _buildWebDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildMenu(context)),
          if (showCompanySwitcher) _buildCompanySwitcher(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Build fallback Material Drawer
  Widget _buildMaterialDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildMenu(context)),
          if (showCompanySwitcher) _buildCompanySwitcher(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  // ==========================================================================
  // Section Builders
  // ==========================================================================

  /// Build Header Section with User Profile & Quick Actions
  Widget _buildHeader(BuildContext context) {
    if (customHeader != null) return customHeader!;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + AppSpacing.paddingL,
            left: AppSpacing.paddingL,
            right: AppSpacing.paddingL,
            bottom: AppSpacing.paddingL,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Row(
                children: [
                  // Profile Photo
                  GestureDetector(
                    onTap: onProfileTap,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          AppColors.textOnPrimary.withValues(alpha: 0.2),
                      backgroundImage: user?.profilePhotoUrl != null
                          ? NetworkImage(user!.profilePhotoUrl!)
                          : null,
                      child: user?.profilePhotoUrl == null
                          ? Text(
                              user?.initials ?? 'U',
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingM),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'User',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.roleDisplay ?? 'Guest',
                          style: AppTypography.bodyMedium.copyWith(
                            color:
                                AppColors.textOnPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                        if (user?.email != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            user!.email!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textOnPrimary
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.paddingL),

              // Quick Actions Row
              Row(
                children: [
                  // Profile Button
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      icon: Icons.person_outline,
                      label: 'Profile',
                      onTap: onProfileTap,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),

                  // Notifications Button
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: onNotificationsTap,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),

                  // Settings Button
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: onSettingsTap,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.paddingM),

              // Role Switcher (if enabled)
              if (showRoleSwitcher) _buildRoleSwitcher(context),

              const SizedBox(height: AppSpacing.paddingS),

              // Theme & Language Toggles
              Row(
                children: [
                  if (showThemeToggle) ...[
                    // Dynamic theme icon and label using ThemeProvider
                    Builder(
                      builder: (context) {
                        final themeProvider = context.watch<ThemeProvider>();
                        final themeIcon = themeProvider.themeModeIcon;
                        final themeLabel = themeProvider.themeModeName;
                        return Expanded(
                          child: _buildToggleButton(
                            context,
                            icon: themeIcon,
                            label: themeLabel,
                            onTap: onThemeToggle,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                  ],
                  if (showLanguageSelector) ...[
                    Expanded(
                      child: _buildToggleButton(
                        context,
                        icon: Icons.language,
                        label: 'Language',
                        onTap: onLanguageToggle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Menu Section with Core Navigation
  Widget _buildMenu(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final role = user?.role ?? 'guest';

        // Use custom menu items if provided, otherwise use role-based menu
        final menuItems = customMenuItems ?? _getRoleBasedMenuItems(role);

        return SingleChildScrollView(
          child: Column(
            children: [
              // User Menu Section
              _buildMenuSection(
                context,
                title: 'User Menu',
                items:
                    menuItems.where((item) => item.section == 'user').toList(),
              ),

              // System Menu Section
              _buildMenuSection(
                context,
                title: 'System',
                items: menuItems
                    .where((item) => item.section == 'system')
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Company/Workspace Switcher Section
  Widget _buildCompanySwitcher(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workspace',
            style: AppTypography.labelLarge.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingM,
              vertical: AppSpacing.paddingS,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.business,
                  size: 20,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: Text(
                    currentCompany ?? 'Atitia PG Management',
                    style: AppTypography.bodyMedium,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
          if (availableCompanies != null && availableCompanies!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingS),
            Wrap(
              spacing: AppSpacing.paddingS,
              runSpacing: AppSpacing.paddingXS,
              children: availableCompanies!.take(3).map((company) {
                return GestureDetector(
                  onTap: () => onCompanySwitch?.call(company),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS,
                      vertical: AppSpacing.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: company == currentCompany
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                      border: company == currentCompany
                          ? Border.all(color: AppColors.primary, width: 1)
                          : null,
                    ),
                    child: Text(
                      company,
                      style: AppTypography.bodySmall.copyWith(
                        color: company == currentCompany
                            ? AppColors.primary
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Build Footer Section with App Info & Legal
  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // App Branding
          Row(
            children: [
              Icon(
                Icons.apartment,
                size: 24,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atitia',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'PG Management System',
                      style: AppTypography.bodySmall.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.paddingM),

          // Version & Legal Links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'v1.0.0',
                style: AppTypography.bodySmall.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showPrivacyPolicy(context),
                    child: Text(
                      'Privacy',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingM),
                  GestureDetector(
                    onTap: () => _showTermsOfService(context),
                    child: Text(
                      'Terms',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.paddingS),

          // Made with love
          Text(
            'Made with ❤️ by Atitia Team',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Helper Widget Builders
  // ==========================================================================

  /// Build Quick Action Button
  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.paddingS,
          horizontal: AppSpacing.paddingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Toggle Button
  Widget _buildToggleButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.paddingS,
          horizontal: AppSpacing.paddingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Role Switcher
  Widget _buildRoleSwitcher(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final currentRole = authProvider.user?.role ?? 'guest';

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingS,
            vertical: AppSpacing.paddingXS,
          ),
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
          ),
          child: Row(
            children: [
              Icon(
                Icons.swap_horiz,
                size: 16,
                color: AppColors.textOnPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                'Role: ${currentRole.toUpperCase()}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final newRole = currentRole == 'guest' ? 'owner' : 'guest';
                  onRoleSwitch?.call(newRole);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingXS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusXS),
                  ),
                  child: Text(
                    'SWITCH',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Menu Section
  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<DrawerMenuItem> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.paddingL,
            AppSpacing.paddingL,
            AppSpacing.paddingL,
            AppSpacing.paddingS,
          ),
          child: Text(
            title,
            style: AppTypography.labelMedium.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(context, item)),
        const SizedBox(height: AppSpacing.paddingS),
      ],
    );
  }

  /// Build Individual Menu Item
  Widget _buildMenuItem(BuildContext context, DrawerMenuItem item) {
    final theme = Theme.of(context);
    final isSelected = item.isSelected;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected?.call(item.id),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingM,
              vertical: AppSpacing.paddingM,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: isSelected
                  ? Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected ? AppColors.primary : theme.iconTheme.color,
                ),
                const SizedBox(width: AppSpacing.paddingM),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : theme.textTheme.bodyLarge?.color,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),

                // Badge (if any)
                if (item.badge != null) ...[
                  const SizedBox(width: AppSpacing.paddingS),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingXS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                    ),
                    child: Text(
                      item.badge!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                // Trailing icon
                if (item.trailingIcon != null) ...[
                  const SizedBox(width: AppSpacing.paddingS),
                  Icon(
                    item.trailingIcon,
                    size: 20,
                    color: theme.iconTheme.color?.withValues(alpha: 0.6),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // Helper Methods
  // ==========================================================================

  /// Get role-based menu items
  List<DrawerMenuItem> _getRoleBasedMenuItems(String role) {
    final commonItems = [
      DrawerMenuItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        section: 'user',
      ),
      DrawerMenuItem(
        id: 'profile',
        label: 'My Profile',
        icon: Icons.person_outline,
        section: 'user',
      ),
      DrawerMenuItem(
        id: 'notifications',
        label: 'Notifications',
        icon: Icons.notifications_outlined,
        section: 'user',
        badge: '3', // Example badge
      ),
      DrawerMenuItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        section: 'user',
      ),
    ];

    final systemItems = [
      DrawerMenuItem(
        id: 'help',
        label: 'Help & Support',
        icon: Icons.help_outline,
        section: 'system',
      ),
      DrawerMenuItem(
        id: 'logout',
        label: 'Logout',
        icon: Icons.logout,
        section: 'system',
        trailingIcon: Icons.arrow_forward_ios,
      ),
    ];

    final items = <DrawerMenuItem>[];
    items.addAll(commonItems);

    // Owner items removed - no longer needed

    items.addAll(systemItems);

    return items;
  }

  /// Show Privacy Policy
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy Policy content goes here...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show Terms of Service
  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const Text('Terms of Service content goes here...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Model class for drawer menu items
class DrawerMenuItem {
  final String id;
  final String label;
  final IconData icon;
  final String section; // 'user', 'owner', 'system'
  final String? badge;
  final IconData? trailingIcon;
  final bool isSelected;

  const DrawerMenuItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.section,
    this.badge,
    this.trailingIcon,
    this.isSelected = false,
  });

  DrawerMenuItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    String? section,
    String? badge,
    IconData? trailingIcon,
    bool? isSelected,
  }) {
    return DrawerMenuItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      section: section ?? this.section,
      badge: badge ?? this.badge,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
