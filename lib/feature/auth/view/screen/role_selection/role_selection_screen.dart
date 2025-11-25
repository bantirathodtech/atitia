// ============================================================================
// Role Selection Screen - Choose Your Role
// ============================================================================
// User selects whether they are a Guest or Owner with theme toggle support.
//
// FEATURES:
// - Beautiful role cards with icons
// - Theme toggle for comfortable viewing
// - Smooth navigation to phone auth
// - Analytics tracking
// - Theme-aware colors for day/night modes
//
// THEME TOGGLE:
// - Positioned in top-right corner as floating button
// - User can switch themes before signing in
// - Helps users choose comfortable viewing mode early
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/widgets/buttons/theme_toggle_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/utils/constants/routes.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/auth_provider.dart';

/// Role selection screen where users choose between Guest and Owner roles
/// Enhanced with modern UI using common widgets
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // =======================================================================
      // Stack Layout with Theme Toggle
      // =======================================================================
      // Stack allows theme toggle to float over content in top-right corner
      // Main content scrolls normally while theme toggle stays in position
      // =======================================================================
      body: Stack(
        children: [
          // Main content - fits screen without scrolling
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final responsiveConfig = ResponsiveSystem.getConfig(context);

                // Determine layout: single column for mobile/tablet, two columns for desktop+
                final useTwoColumns = responsiveConfig.isDesktop ||
                    responsiveConfig.isLargeDesktop;

                // Max width constraint for cards
                final maxCardWidth = responsiveConfig.isMobile
                    ? double.infinity
                    : responsiveConfig.isTablet
                        ? 600.0
                        : 500.0; // Smaller for two-column layout

                // Responsive padding
                final horizontalPadding =
                    ResponsiveSystem.getResponsivePadding(context).horizontal;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSpacing.paddingS,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo with theme-aware color - Reduced size
                      Icon(
                        Icons.home_work,
                        size: 48.0, // Reduced from responsive size
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: AppSpacing.paddingS),

                      // Welcome Text - Reduced size
                      const HeadingSmall(
                        text: 'Welcome to Atitia PG',
                        align: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.xs),

                      const CaptionText(
                        text: 'Your Home Away From Home',
                        align: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.paddingM),

                      // Role Selection Title - Reduced size
                      Semantics(
                        header: true,
                        child: const HeadingSmall(
                          text: 'Select Your Role',
                          align: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),

                      Semantics(
                        label: 'Choose how you want to use the app',
                        child: const CaptionText(
                          text: 'Choose how you want to use the app',
                          align: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: AppSpacing.paddingM),

                      // Role Cards - Responsive Layout
                      Flexible(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: useTwoColumns ? 1200.0 : maxCardWidth,
                            ),
                            child: useTwoColumns
                                ? _buildTwoColumnLayout(
                                    context: context,
                                    authProvider: authProvider,
                                    maxCardWidth: maxCardWidth,
                                  )
                                : _buildSingleColumnLayout(
                                    context: context,
                                    authProvider: authProvider,
                                    maxCardWidth: maxCardWidth,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // =================================================================
          // Top Bar with Admin Access and Theme Toggle
          // =================================================================
          // Admin access (3-dot menu) on top-left
          // Theme toggle on top-right
          // =================================================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Admin Access Button (3-dot menu) - Top Left
                  Builder(
                    builder: (context) {
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      final colorScheme = Theme.of(context).colorScheme;

                      return Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? colorScheme.outline.withValues(alpha: 0.3)
                                : colorScheme.outline.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.4)
                                  : Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_vert),
                          tooltip: 'Admin Access',
                          onPressed: () => _handleAdminAccess(context),
                        ),
                      );
                    },
                  ),

                  // Theme Toggle Button - Top Right
                  Builder(
                    builder: (context) {
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      final colorScheme = Theme.of(context).colorScheme;

                      return Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? colorScheme.outline.withValues(alpha: 0.3)
                                : colorScheme.outline.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.4)
                                  : Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const ThemeToggleButton(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds single column layout for mobile/tablet
  Widget _buildSingleColumnLayout({
    required BuildContext context,
    required AuthProvider authProvider,
    required double maxCardWidth,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Guest Role Card
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: _buildRoleCard(
              context: context,
              title: 'Guest',
              description: 'Find and book PG accommodations',
              icon: Icons.person,
              color: AppColors.info,
              onTap: () => _handleGuestRoleSelection(context, authProvider),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.paddingS), // Reduced spacing
        // Owner Role Card
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: _buildRoleCard(
              context: context,
              title: 'Owner',
              description: 'Manage your PG properties and guests',
              icon: Icons.business,
              color: AppColors.success,
              onTap: () => _handleOwnerRoleSelection(context, authProvider),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds two-column layout for desktop/large desktop
  Widget _buildTwoColumnLayout({
    required BuildContext context,
    required AuthProvider authProvider,
    required double maxCardWidth,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Guest Role Card
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: _buildRoleCard(
              context: context,
              title: 'Guest',
              description: 'Find and book PG accommodations',
              icon: Icons.person,
              color: AppColors.info,
              onTap: () => _handleGuestRoleSelection(context, authProvider),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.paddingM),
        // Owner Role Card
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: _buildRoleCard(
              context: context,
              title: 'Owner',
              description: 'Manage your PG properties and guests',
              icon: Icons.business,
              color: AppColors.success,
              onTap: () => _handleOwnerRoleSelection(context, authProvider),
            ),
          ),
        ),
      ],
    );
  }

  /// Handles guest role selection logic
  void _handleGuestRoleSelection(
      BuildContext context, AuthProvider authProvider) {
    authProvider.setRole('guest');

    // Check if user is already authenticated (Google Sign-In)
    if (authProvider.user != null && authProvider.user!.userId.isNotEmpty) {
      // Validate that stored role matches selected role
      if (authProvider.user!.role == 'guest') {
        // User is already authenticated with guest role, navigate to dashboard
        getIt<NavigationService>().goToGuestHome();
      } else if (authProvider.user!.role == 'owner') {
        // User is registered as owner, cannot switch to guest without proper flow
        // For now, still navigate to phone auth for role validation
        getIt<NavigationService>().goToPhoneAuth();
      } else {
        // No role set, proceed with auth
        getIt<NavigationService>().goToPhoneAuth();
      }
    } else {
      // User needs to authenticate, go to phone auth
      getIt<NavigationService>().goToPhoneAuth();
    }
  }

  /// Handles owner role selection logic
  void _handleOwnerRoleSelection(
      BuildContext context, AuthProvider authProvider) {
    authProvider.setRole('owner');

    // Check if user is already authenticated (Google Sign-In)
    if (authProvider.user != null && authProvider.user!.userId.isNotEmpty) {
      // Validate that stored role matches selected role
      if (authProvider.user!.role == 'owner') {
        // User is already authenticated with owner role, navigate to dashboard
        getIt<NavigationService>().goToOwnerHome();
      } else if (authProvider.user!.role == 'guest') {
        // User is registered as guest, cannot switch to owner without proper flow
        // For now, still navigate to phone auth for role validation
        getIt<NavigationService>().goToPhoneAuth();
      } else {
        // No role set, proceed with auth
        getIt<NavigationService>().goToPhoneAuth();
      }
    } else {
      // User needs to authenticate, go to phone auth
      getIt<NavigationService>().goToPhoneAuth();
    }
  }

  /// Builds role selection card
  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: '$title role. $description',
      hint: 'Double tap to select $title role and continue',
      child: AdaptiveCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingM), // Reduced padding
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(
                    AppSpacing.paddingS), // Reduced padding
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(10), // Slightly smaller radius
                ),
                child: Icon(
                  icon,
                  size: 28, // Reduced icon size
                  color: color,
                ),
              ),
              SizedBox(width: AppSpacing.paddingS), // Reduced spacing
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingSmall(
                      // Reduced from HeadingMedium
                      text: title,
                      color: color,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    CaptionText(text: description), // Reduced from BodyText
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16, // Reduced arrow size
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle admin access - navigate to admin access screen
  void _handleAdminAccess(BuildContext context) {
    context.go(AppRoutes.adminAccess);
  }
}
