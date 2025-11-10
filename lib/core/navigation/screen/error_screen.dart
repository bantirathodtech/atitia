import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error Icon
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),

            // Error Title
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Error Description
            Text(
              'The page you are looking for doesn\'t exist or has been moved.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Go Home Button (Primary Action)
        ElevatedButton(
          onPressed: _goToHome,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(AppLocalizations.of(context)?.goToHome ?? 'Go to Home'),
        ),
        const SizedBox(height: 12),

        // Go Back Button (Secondary Action)
        OutlinedButton(
          onPressed: _goBack,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(AppLocalizations.of(context)?.goBack ?? 'Go Back'),
        ),
        const SizedBox(height: 12),

        // Sign In Button (Tertiary Action - if not authenticated)
        TextButton(
          onPressed: _goToPhoneAuth,
          child: Text(AppLocalizations.of(context)?.signIn ?? 'Sign In'),
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
