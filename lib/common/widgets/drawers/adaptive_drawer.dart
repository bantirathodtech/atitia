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

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../../utils/constants/app.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import '../../../core/app/theme/theme_provider.dart';
import '../../../core/app/localization/locale_provider.dart';
import '../../../l10n/app_localizations.dart';

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
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
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
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
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
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
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

  /// Build Header Section with User Profile
  Widget _buildHeader(BuildContext context) {
    if (customHeader != null) return customHeader!;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + AppSpacing.paddingM,
            left: AppSpacing.paddingM,
            right: AppSpacing.paddingM,
            bottom: AppSpacing.paddingM,
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
                  Semantics(
                    button: true,
                    label: 'User profile',
                    hint: 'Tap to view or edit profile',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onProfileTap,
                        borderRadius: BorderRadius.circular(30),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              AppColors.textOnPrimary.withValues(alpha: 0.2),
                          backgroundImage: user?.profilePhotoUrl != null
                              ? NetworkImage(user!.profilePhotoUrl!)
                              : null,
                          child: user?.profilePhotoUrl == null
                              ? Builder(
                                  builder: (context) {
                                    final loc = AppLocalizations.of(context);
                                    final fallbackInitial =
                                        loc?.drawerDefaultInitial ?? 'U';
                                    return Text(
                                      user?.initials ?? fallbackInitial,
                                      style:
                                          AppTypography.headlineMedium.copyWith(
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingM),

                  // User Info
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final loc = AppLocalizations.of(context);
                        final displayName = user?.displayName ??
                            loc?.drawerDefaultUserName ??
                            'User';
                        final roleLabel = user?.roleDisplay ??
                            (user?.isOwner == true
                                ? loc?.owner ?? 'Owner'
                                : loc?.guest ?? 'Guest');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.paddingXS),
                            Text(
                              roleLabel,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textOnPrimary
                                    .withValues(alpha: 0.8),
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
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.paddingL),

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
                      child: _buildLanguageSelector(context),
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
        final menuItems =
            customMenuItems ?? _getRoleBasedMenuItems(role, context);

        return SingleChildScrollView(
          child: Column(
            children: [
              // User Menu Section
              Builder(
                builder: (context) {
                  final loc = AppLocalizations.of(context);
                  return _buildMenuSection(
                    context,
                    title: loc?.userMenu ?? 'User Menu',
                    items: menuItems
                        .where((item) => item.section == 'user')
                        .toList(),
                  );
                },
              ),

              // System Menu Section
              Builder(
                builder: (context) {
                  final loc = AppLocalizations.of(context);
                  return _buildMenuSection(
                    context,
                    title: loc?.system ?? 'System',
                    items: menuItems
                        .where((item) => item.section == 'system')
                        .toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Company/Workspace Switcher Section
  Widget _buildCompanySwitcher(BuildContext context) {
    final loc = AppLocalizations.of(context);

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
            loc?.workspaceTitle ?? 'Workspace',
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
                    currentCompany ??
                        (loc?.defaultCompanyName ?? 'Atitia PG Management'),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                    Builder(
                      builder: (context) {
                        final loc = AppLocalizations.of(context);
                        return Text(
                          loc?.appTitle ?? 'Atitia',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final loc = AppLocalizations.of(context);
                        return Text(
                          loc?.pgManagementSystem ?? 'PG Management System',
                          style: AppTypography.bodySmall.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.paddingM),

          // Version & Legal Links
          LayoutBuilder(
            builder: (context, constraints) {
              final loc = AppLocalizations.of(context);

              final versionText = Text(
                '${loc?.version ?? 'Version'} 1.0.0',
                style: AppTypography.bodySmall.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              );

              final links = Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.paddingM,
                runSpacing: AppSpacing.paddingXS,
                children: [
                  Semantics(
                    button: true,
                    label: loc?.privacyPolicy ?? 'Privacy Policy',
                    hint: 'Opens privacy policy in browser',
                    child: InkWell(
                      onTap: () async => await _showPrivacyPolicy(context),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.paddingXS,
                          vertical: AppSpacing.paddingXS / 2,
                        ),
                        child: Text(
                          loc?.privacyPolicy ?? 'Privacy',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: loc?.termsOfService ?? 'Terms of Service',
                    hint: 'Opens terms of service dialog',
                    child: InkWell(
                      onTap: () => _showTermsOfService(context),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.paddingXS,
                          vertical: AppSpacing.paddingXS / 2,
                        ),
                        child: Text(
                          loc?.termsOfService ?? 'Terms',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );

              if (constraints.maxWidth <= 320) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    versionText,
                    const SizedBox(height: AppSpacing.paddingXS),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: links,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: versionText),
                  const SizedBox(width: AppSpacing.paddingS),
                  Flexible(child: links),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.paddingS),

          // Made with love
          Builder(
            builder: (context) {
              final loc = AppLocalizations.of(context);
              return Text(
                loc?.madeWithLoveByAtitiaTeam ?? 'Made with ❤️ by Atitia Team',
                style: AppTypography.bodySmall.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontStyle: FontStyle.italic,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Helper Widget Builders
  // ==========================================================================

  /// Build Toggle Button
  Widget _buildToggleButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Semantics(
      button: true,
      label: label,
      hint: 'Tap to toggle $label',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
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
                const SizedBox(width: AppSpacing.paddingXS),
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
        ),
      ),
    );
  }

  /// Build Language Selector
  Widget _buildLanguageSelector(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final localizations = AppLocalizations.of(context);

    if (localizations == null) {
      return const SizedBox.shrink();
    }

    // Get current language display name
    final currentLang = localeProvider.locale.languageCode == 'te'
        ? localizations.telugu
        : localizations.english;

    return Semantics(
      button: true,
      label: 'Language selector',
      hint: 'Current language: $currentLang. Tap to change language',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Show language selection dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(localizations.language),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      button: true,
                      label: 'English',
                      selected: localeProvider.locale.languageCode == 'en',
                      child: ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(localizations.english),
                        trailing: localeProvider.locale.languageCode == 'en'
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () {
                          localeProvider.setLocale(const Locale('en'));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Telugu',
                      selected: localeProvider.locale.languageCode == 'te',
                      child: ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(localizations.telugu),
                        trailing: localeProvider.locale.languageCode == 'te'
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () {
                          localeProvider.setLocale(const Locale('te'));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localizations.close),
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
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
                const Icon(
                  Icons.language,
                  size: 16,
                  color: AppColors.textOnPrimary,
                ),
                const SizedBox(width: AppSpacing.paddingXS),
                Flexible(
                  child: Text(
                    currentLang,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textOnPrimary,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
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
              const SizedBox(width: AppSpacing.paddingS),
              Builder(
                builder: (context) {
                  final loc = AppLocalizations.of(context);
                  return Text(
                    '${loc?.role ?? 'Role'}: ${currentRole.toUpperCase()}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              const Spacer(),
              Semantics(
                button: true,
                label: 'Switch role',
                hint: 'Switch between guest and owner role',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final newRole =
                          currentRole == 'guest' ? 'owner' : 'guest';
                      onRoleSwitch?.call(newRole);
                    },
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusXS),
                    child: Builder(
                      builder: (context) {
                        final loc = AppLocalizations.of(context);
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingXS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textOnPrimary,
                            borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusXS),
                          ),
                          child: Text(
                            (loc?.switchButton ?? 'SWITCH').toUpperCase(),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
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
      child: Semantics(
        button: true,
        label: item.label,
        selected: isSelected,
        hint: item.badge != null ? 'Has ${item.badge} notifications' : null,
          child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // If this is the logout item, call onLogout directly
              if (item.id == 'logout') {
                onLogout?.call();
              } else {
                onItemSelected?.call(item.id);
              }
            },
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
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1)
                    : null,
              ),
              child: Row(
                children: [
                  // Icon
                  Icon(
                    item.icon,
                    size: 24,
                    color:
                        isSelected ? AppColors.primary : theme.iconTheme.color,
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
      ),
    );
  }

  // ==========================================================================
  // Helper Methods
  // ==========================================================================

  /// Get role-based menu items
  List<DrawerMenuItem> _getRoleBasedMenuItems(
      String role, BuildContext context) {
    final loc = AppLocalizations.of(context);

    // Base items for all roles
    final commonItems = <DrawerMenuItem>[];

    // Owner-specific items (dashboard tabs)
    final ownerItems = role.toLowerCase() == 'owner'
        ? [
            DrawerMenuItem(
              id: 'food',
              label: loc?.food ?? 'Food',
              icon: Icons.restaurant_menu,
              section: 'user',
            ),
            DrawerMenuItem(
              id: 'pgs',
              label: loc?.pgs ?? 'PGs',
              icon: Icons.home,
              section: 'user',
            ),
            DrawerMenuItem(
              id: 'guest',
              label: loc?.guests ?? 'Guest',
              icon: Icons.people,
              section: 'user',
            ),
          ]
        : [
            // Guest dashboard tabs - remove My Profile, Notifications, Settings (already in header)
            DrawerMenuItem(
              id: 'pgs',
              label: loc?.pgs ?? 'PGs',
              icon: Icons.apartment,
              section: 'user',
            ),
            DrawerMenuItem(
              id: 'foods',
              label: loc?.foods ?? 'Foods',
              icon: Icons.restaurant_menu,
              section: 'user',
            ),
            DrawerMenuItem(
              id: 'payments',
              label: loc?.payments ?? 'Payments',
              icon: Icons.payment,
              section: 'user',
            ),
            DrawerMenuItem(
              id: 'requests',
              label: loc?.requests ?? 'Requests',
              icon: Icons.request_page,
              section: 'user',
            ),
            DrawerMenuItem(
              id: 'complaints',
              label: loc?.complaints ?? 'Complaints',
              icon: Icons.report_problem,
              section: 'user',
            ),
          ];

    final systemItems = [
      DrawerMenuItem(
        id: 'profile',
        label: loc?.profile ?? 'Profile',
        icon: Icons.person_outline,
        section: 'system',
      ),
      DrawerMenuItem(
        id: 'notifications',
        label: loc?.notifications ?? 'Notifications',
        icon: Icons.notifications_outlined,
        section: 'system',
      ),
      DrawerMenuItem(
        id: 'settings',
        label: loc?.settings ?? 'Settings',
        icon: Icons.settings_outlined,
        section: 'system',
      ),
      DrawerMenuItem(
        id: 'help',
        label: loc?.helpSupport ?? 'Help & Support',
        icon: Icons.help_outline,
        section: 'system',
      ),
      DrawerMenuItem(
        id: 'logout',
        label: loc?.logout ?? 'Logout',
        icon: Icons.logout,
        section: 'system',
        trailingIcon: Icons.arrow_forward_ios,
      ),
    ];

    final items = <DrawerMenuItem>[];
    items.addAll(commonItems);
    items.addAll(ownerItems);
    items.addAll(systemItems);

    return items;
  }

  /// Show Privacy Policy
  Future<void> _showPrivacyPolicy(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && loc != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.privacyPolicyOpenLinkError)),
      );
    }
  }

  /// Show Terms of Service
  void _showTermsOfService(BuildContext context) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc?.termsOfService ?? 'Terms of Service'),
        content: Text(
            loc?.termsOfService ?? 'Terms of Service content goes here...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc?.close ?? 'Close'),
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
