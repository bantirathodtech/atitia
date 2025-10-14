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
import '../../../../../common/widgets/buttons/theme_toggle_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
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
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  
                  // App Logo with theme-aware color
                  Icon(
                    Icons.home_work,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Welcome Text
                  const HeadingLarge(
                    text: 'Welcome to Atitia PG',
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  const BodyText(
                    text: 'Your Home Away From Home',
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Role Selection Title
                  const HeadingMedium(
                    text: 'Select Your Role',
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  const CaptionText(
                    text: 'Choose how you want to use the app',
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Guest Role Card with theme-aware colors
                  _buildRoleCard(
                    context: context,
                    title: 'Guest',
                    description: 'Find and book PG accommodations',
                    icon: Icons.person,
                    color: AppColors.info,  // Theme-aware blue
                    onTap: () {
                      authProvider.setRole('guest');
                      getIt<NavigationService>().goToPhoneAuth();
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Owner Role Card with theme-aware colors
                  _buildRoleCard(
                    context: context,
                    title: 'Owner',
                    description: 'Manage your PG properties and guests',
                    icon: Icons.business,
                    color: AppColors.success,  // Theme-aware green
                    onTap: () {
                      authProvider.setRole('owner');
                      getIt<NavigationService>().goToPhoneAuth();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // =================================================================
          // Floating Theme Toggle Button (Top-Right Corner)
          // =================================================================
          // Positioned absolutely in top-right for easy access
          // User can change theme before selecting role
          // =================================================================
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const ThemeToggleButton(),
              ),
            ),
          ),
        ],
      ),
    );
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
    return AdaptiveCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingMedium(
                    text: title,
                    color: color,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  BodyText(text: description),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

