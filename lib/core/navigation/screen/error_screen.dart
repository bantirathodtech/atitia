import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../common/styles/spacing.dart';
import '../../../common/widgets/buttons/primary_button.dart';
import '../../../common/widgets/buttons/secondary_button.dart';
import '../../../common/widgets/text/body_text.dart';
import '../../../common/widgets/text/heading_medium.dart';
import '../../../l10n/app_localizations.dart';
import '../navigation_service.dart';

/// Universal error screen for handling navigation errors and unknown routes.
///
/// Displays when:
/// - User navigates to an undefined route
/// - Route cannot be resolved
/// - Navigation errors occur
///
/// Features:
/// - User-friendly error message
/// - Multiple navigation options
/// - Responsive design
/// - Reusable across the entire app
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Semantics(
        label: 'Page not found error',
        hint:
            'The page you are looking for does not exist. Use the buttons below to navigate.',
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Error Icon
              Semantics(
                label: 'Error icon',
                excludeSemantics: true,
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: AppSpacing.paddingL),

              // Error Title
              Semantics(
                header: true,
                child: HeadingMedium(
                  text: 'Page Not Found',
                  align: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),

              // Error Description - More actionable message
              BodyText(
                text:
                    'The page you are looking for doesn\'t exist or has been moved. You can go back to the previous page or return to the home screen.',
                align: TextAlign.center,
                small: true,
              ),
              const SizedBox(height: AppSpacing.paddingXL),

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Column(
      children: [
        // Go Home Button (Primary Action)
        PrimaryButton(
          onPressed: _goToHome,
          label: loc?.goToHome ?? 'Go to Home',
          icon: Icons.home,
        ),
        const SizedBox(height: AppSpacing.paddingS),

        // Go Back Button (Secondary Action)
        SecondaryButton(
          onPressed: _goBack,
          label: loc?.goBack ?? 'Go Back',
          icon: Icons.arrow_back,
        ),
        const SizedBox(height: AppSpacing.paddingS),

        // Sign In Button (Tertiary Action - if not authenticated)
        TextButton.icon(
          onPressed: _goToPhoneAuth,
          icon: const Icon(Icons.login),
          label: Text(loc?.signIn ?? 'Sign In'),
        ),
      ],
    );
  }

  /// Navigate to appropriate home screen based on user role
  /// STRICT: Uses role-based navigation - NO DEFAULT FALLBACK
  void _goToHome() {
    final navigationService = GetIt.I<NavigationService>();

    // STRICT: Try to get user role from context/Provider
    // If role cannot be determined, redirect to role selection (not guest as default)
    try {
      // Note: This requires BuildContext access to Provider, but since this is a StatelessWidget,
      // we'll use the navigation service's role-based method or redirect to role selection
      // The safest approach is to redirect to role selection if we can't determine role
      navigationService.goToRoleSelection();
    } catch (e) {
      // If we can't determine role, always redirect to role selection
      navigationService.goToRoleSelection();
    }
  }

  /// Navigate back to previous screen
  void _goBack() {
    GetIt.I<NavigationService>().goBack();
  }

  /// Navigate to sign in screen
  void _goToPhoneAuth() {
    GetIt.I<NavigationService>().goToPhoneAuth();
  }
}
