import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';
import '../buttons/secondary_button.dart';
import '../dialogs/confirmation_dialog.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';
import '../text/heading_medium.dart';
import '../text/heading_small.dart';

const _appVersion = '1.0.0';

/// Production-ready app drawer with user info, navigation, and settings
///
/// Features:
/// - User profile header with photo and details
/// - About app information
/// - Developer/company information
/// - Logout functionality
/// - Switch account (Owner ↔ Guest)
/// - Elegant animations and modern UI
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // User Profile Header
            _buildProfileHeader(context, user, theme),

            const Divider(height: 1),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Builder(
                    builder: (context) {
                      final loc = AppLocalizations.of(context);
                      if (loc == null) return const SizedBox.shrink();
                      return Column(
                        children: [
                          _buildDrawerItem(
                            context: context,
                            icon: Icons.info_outline,
                            title: loc.aboutApp,
                            onTap: () => _showAboutApp(context),
                          ),
                          _buildDrawerItem(
                            context: context,
                            icon: Icons.business,
                            title: loc.aboutDeveloper,
                            onTap: () => _showAboutDeveloper(context),
                          ),
                          _buildDrawerItem(
                            context: context,
                            icon: Icons.swap_horiz,
                            title: loc.switchAccount,
                            subtitle: user?.isOwner == true
                                ? loc.switchToGuest
                                : loc.switchToOwner,
                            onTap: () => _showSwitchAccountDialog(context),
                          ),
                          const Divider(),
                          _buildDrawerItem(
                            context: context,
                            icon: Icons.logout,
                            title: loc.logout,
                            iconColor: AppColors.error,
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Footer
            _buildFooter(context, theme),
          ],
        ),
      ),
    );
  }

  /// Builds premium user profile header with enhanced styling
  Widget _buildProfileHeader(
      BuildContext context, dynamic user, ThemeData theme) {
    final loc = AppLocalizations.of(context);
    final displayName =
        user?.displayName ?? loc?.drawerDefaultUserName ?? 'User';
    final roleText = user?.roleDisplay ??
        (user?.isOwner == true ? loc?.owner ?? 'Owner' : loc?.guest ?? 'Guest');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withValues(alpha: 0.7)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Premium Profile Photo with gradient border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.onPrimary, Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.paddingXXS),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: user?.hasProfilePhoto == true
                      ? ClipOval(
                          child: Image.network(
                            user!.profilePhotoUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(context, user),
                          ),
                        )
                      : _buildDefaultAvatar(context, user),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),

              // Enhanced User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    HeadingMedium(
                      text: displayName,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: AppSpacing.paddingS),
                    // Phone with icon
                    Row(
                      children: [
                        Icon(Icons.phone,
                            size: 14, color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7)),
                        const SizedBox(width: AppSpacing.paddingXS),
                        BodyText(
                          text: user?.phoneNumber ?? '',
                          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.paddingS),
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            user?.isOwner == true
                                ? Icons.business
                                : Icons.person,
                            size: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(width: AppSpacing.paddingXS),
                          BodyText(
                            text: roleText,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Verification status badge (if owner)
          if (user?.isOwner == true) ...[
            const SizedBox(height: AppSpacing.paddingS),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    user?.isVerified == true ? Icons.verified : Icons.pending,
                    size: 16,
                    color: user?.isVerified == true
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Builder(
                    builder: (context) {
                      final loc = AppLocalizations.of(context);
                      return CaptionText(
                        text: user?.isVerified == true
                            ? (loc?.verifiedOwner ?? 'Verified Owner')
                            : (loc?.pendingVerification ??
                                'Pending Verification'),
                        color: Theme.of(context).colorScheme.onPrimary,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds default avatar with initials
  Widget _buildDefaultAvatar(BuildContext context, dynamic user) {
    final loc = AppLocalizations.of(context);
    final initials = (user?.initials as String?)?.trim();
    final fallbackInitial = loc?.drawerDefaultInitial ?? 'U';
    final displayInitial =
        (initials == null || initials.isEmpty) ? fallbackInitial : initials;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          displayInitial,
          style: AppTypography.headingLarge.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  /// Builds drawer menu item
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: BodyText(text: title),
      subtitle: subtitle != null ? CaptionText(text: subtitle) : null,
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
    );
  }

  /// Builds footer with app version and company info
  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.apartment,
                size: 16,
                color: theme.primaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Builder(
                builder: (context) {
                  final loc = AppLocalizations.of(context);
                  if (loc == null) {
                    return const SizedBox.shrink();
                  }
                  return CaptionText(text: loc.poweredByCharyatani);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Builder(
            builder: (context) {
              final loc = AppLocalizations.of(context);
              if (loc == null) {
                return const SizedBox.shrink();
              }
              return CaptionText(text: loc.drawerVersionLabel(_appVersion));
            },
          ),
        ],
      ),
    );
  }

  /// Shows about app dialog
  void _showAboutApp(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            HeadingMedium(text: '${loc.aboutApp} - ${loc.appTitle}'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                text: loc.atitiaIsAComprehensivePgManagementPlatform,
              ),
              SizedBox(height: AppSpacing.md),
              HeadingSmall(text: loc.features),
              SizedBox(height: AppSpacing.sm),
              BodyText(text: loc.easyPgPropertyManagement),
              BodyText(text: loc.secureOnlinePayments),
              BodyText(text: loc.realTimeNotifications),
              BodyText(text: loc.menuManagement),
              BodyText(text: loc.complaintTracking),
              BodyText(text: loc.visitorManagement),
              SizedBox(height: AppSpacing.md),
              CaptionText(text: '${loc.version} 1.0.0'),
              CaptionText(text: loc.copyrightAtitiaAllRightsReserved),
            ],
          ),
        ),
        actions: [
          SecondaryButton(
            label: loc.close,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Shows about developer dialog
  void _showAboutDeveloper(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.business, color: Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            HeadingMedium(text: loc.aboutDeveloper),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(text: loc.charyataniTechnologies),
              SizedBox(height: AppSpacing.sm),
              BodyText(
                text: loc.weAreALeadingSoftwareDevelopmentCompany,
              ),
              SizedBox(height: AppSpacing.md),
              HeadingSmall(text: loc.contactUs),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.email, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  BodyText(text: loc.drawerContactEmail),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.phone, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  BodyText(text: loc.drawerContactPhone),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.language, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  BodyText(text: loc.drawerContactWebsite),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              CaptionText(text: loc.copyrightCharyataniTechnologies),
              CaptionText(text: loc.allRightsReserved),
            ],
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              final loc = AppLocalizations.of(context);
              if (loc == null) {
                return const SizedBox.shrink();
              }
              return SecondaryButton(
                label: loc.close,
                onPressed: () => Navigator.pop(context),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Shows switch account confirmation dialog
  void _showSwitchAccountDialog(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final currentRole = authProvider.user?.role ?? 'guest';
    final newRole = currentRole == 'owner' ? 'guest' : 'owner';
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    final currentRoleDisplay = currentRole == 'owner' ? loc.owner : loc.guest;
    final newRoleDisplay = newRole == 'owner' ? loc.owner : loc.guest;

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: loc.switchAccount,
        message:
            loc.switchAccountConfirmation(currentRoleDisplay, newRoleDisplay),
        confirmText: loc.switchButton,
        cancelText: loc.cancel,
        onConfirm: () async {
          Navigator.pop(context); // Close dialog
          await _switchAccount(context, newRole);
        },
      ),
    );
  }

  /// Handles account switching
  Future<void> _switchAccount(BuildContext context, String newRole) async {
    try {
      final authProvider = context.read<AuthProvider>();
      final navigationService = getIt<NavigationService>();

      // Update role
      authProvider.setRole(newRole);

      // Navigate to registration for new role
      navigationService.goToRegistration();

      if (context.mounted) {
        final loc = AppLocalizations.of(context);
        if (loc != null) {
          final roleDisplay = newRole == 'owner' ? loc.owner : loc.guest;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: BodyText(
                text: loc.switchedToAccount(roleDisplay),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        final loc = AppLocalizations.of(context);
        if (loc == null) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: '${loc.failedToSwitchAccount}: $e',
                color: Theme.of(context).colorScheme.onPrimary,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Shows logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
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
        onConfirm: () async {
          Navigator.pop(context); // Close dialog
          await _handleLogout(context);
        },
      ),
    );
  }

  /// Handles logout
  Future<void> _handleLogout(BuildContext context) async {
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.signOut();

      if (context.mounted) {
        final loc = AppLocalizations.of(context);
        if (loc == null) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: loc.loggedOutSuccessfully,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final loc = AppLocalizations.of(context);
        if (loc == null) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: '${loc.logoutFailed}: $e',
                color: Theme.of(context).colorScheme.onPrimary,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
