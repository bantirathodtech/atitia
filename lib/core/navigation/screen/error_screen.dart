import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
                        .withOpacity(0.7),
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
          child: const Text('Go to Home'),
        ),
        const SizedBox(height: 12),

        // Go Back Button (Secondary Action)
        OutlinedButton(
          onPressed: _goBack,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Go Back'),
        ),
        const SizedBox(height: 12),

        // Sign In Button (Tertiary Action - if not authenticated)
        TextButton(
          onPressed: _goToPhoneAuth,
          child: const Text('Sign In'),
        ),
      ],
    );
  }

  /// Navigate to appropriate home screen based on user role
  void _goToHome() {
    final navigationService = GetIt.I<NavigationService>();

    // TODO: Add logic to determine user role and navigate accordingly
    // For now, navigate to guest home as default
    navigationService.goToGuestHome();

    // Future enhancement: Check user authentication status and role
    // final authProvider = GetIt.I<AuthService>();
    // if (authProvider.isAuthenticated) {
    //   if (authProvider.isOwner) {
    //     navigationService.goToOwnerHome();
    //   } else {
    //     navigationService.goToGuestHome();
    //   }
    // } else {
    //   navigationService.goToSignIn();
    // }
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
