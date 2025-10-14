import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../buttons/secondary_button.dart';
import '../dialogs/confirmation_dialog.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';
import '../text/heading_medium.dart';
import '../text/heading_small.dart';

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
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'About App',
                    onTap: () => _showAboutApp(context),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.business,
                    title: 'About Developer',
                    onTap: () => _showAboutDeveloper(context),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.swap_horiz,
                    title: 'Switch Account',
                    subtitle: user?.isOwner == true
                        ? 'Switch to Guest'
                        : 'Switch to Owner',
                    onTap: () => _showSwitchAccountDialog(context),
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: Colors.red,
                    onTap: () => _showLogoutDialog(context),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
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
                    colors: [Colors.white, Colors.white.withOpacity(0.7)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: user?.hasProfilePhoto == true
                      ? ClipOval(
                          child: Image.network(
                            user!.profilePhotoUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(user),
                          ),
                        )
                      : _buildDefaultAvatar(user),
                ),
              ),
              const SizedBox(width: 16),
              
              // Enhanced User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    HeadingMedium(
                      text: user?.displayName ?? 'User',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    // Phone with icon
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        BodyText(
                          text: user?.phoneNumber ?? '',
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            user?.isOwner == true ? Icons.business : Icons.person,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          BodyText(
                            text: user?.roleDisplay ?? 'User',
                            color: Colors.white,
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    user?.isVerified == true ? Icons.verified : Icons.pending,
                    size: 16,
                    color: user?.isVerified == true 
                        ? Colors.greenAccent 
                        : Colors.orangeAccent,
                  ),
                  const SizedBox(width: 6),
                  CaptionText(
                    text: user?.isVerified == true ? 'Verified Owner' : 'Pending Verification',
                    color: Colors.white,
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
  Widget _buildDefaultAvatar(dynamic user) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          user?.initials ?? 'U',
          style: AppTypography.headingLarge.copyWith(
            color: Colors.blue,
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
              const CaptionText(text: 'Powered by Charyatani'),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const CaptionText(text: 'Version 1.0.0'),
        ],
      ),
    );
  }

  /// Shows about app dialog
  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            const HeadingMedium(text: 'About Atitia'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                text: 'Atitia is a comprehensive PG management platform that '
                    'connects PG owners with guests, streamlining bookings, '
                    'payments, and daily operations.',
              ),
              SizedBox(height: AppSpacing.md),
              HeadingSmall(text: 'Features:'),
              SizedBox(height: AppSpacing.sm),
              BodyText(text: '• Easy PG property management'),
              BodyText(text: '• Secure online payments'),
              BodyText(text: '• Real-time notifications'),
              BodyText(text: '• Menu management'),
              BodyText(text: '• Complaint tracking'),
              BodyText(text: '• Visitor management'),
              SizedBox(height: AppSpacing.md),
              CaptionText(text: 'Version 1.0.0'),
              CaptionText(text: '© 2025 Atitia. All rights reserved.'),
            ],
          ),
        ),
        actions: [
          SecondaryButton(
            label: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Shows about developer dialog
  void _showAboutDeveloper(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.business, color: Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            const HeadingMedium(text: 'About Developer'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(text: 'Charyatani Technologies'),
              SizedBox(height: AppSpacing.sm),
              BodyText(
                text: 'We are a leading software development company '
                    'specializing in mobile and web applications for '
                    'hospitality and property management.',
              ),
              SizedBox(height: AppSpacing.md),
              HeadingSmall(text: 'Contact Us:'),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.email, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  BodyText(text: 'contact@charyatani.com'),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.phone, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  BodyText(text: '+91 98765 43210'),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.language, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  BodyText(text: 'www.charyatani.com'),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              CaptionText(text: '© 2025 Charyatani Technologies Pvt. Ltd.'),
              CaptionText(text: 'All rights reserved.'),
            ],
          ),
        ),
        actions: [
          SecondaryButton(
            label: 'Close',
            onPressed: () => Navigator.pop(context),
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

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Switch Account',
        message:
            'Are you sure you want to switch from ${currentRole == 'owner' ? 'Owner' : 'Guest'} '
            'to ${newRole == 'owner' ? 'Owner' : 'Guest'} account?\n\n'
            'You will need to complete registration for the new role.',
        confirmText: 'Switch',
        cancelText: 'Cancel',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: 'Switched to ${newRole == 'owner' ? 'Owner' : 'Guest'} account. '
                  'Please complete your registration.',
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: 'Failed to switch account: $e',
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Shows logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        cancelText: 'Cancel',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: BodyText(
              text: 'Logged out successfully',
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: 'Logout failed: $e',
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

