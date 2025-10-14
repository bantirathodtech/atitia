import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../logic/auth_provider.dart';

/// Splash screen that handles auto-login and initial navigation
/// Shows loading state while checking authentication status
/// Navigates to appropriate screen based on user role and authentication state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _initializeApp();
    }
  }

  /// Initialize app and handle auto-login
  Future<void> _initializeApp() async {
    try {
      final authProvider = context.read<AuthProvider>();
      
      // Wait a bit for splash effect
      await Future.delayed(const Duration(seconds: 1));
      
      // Try auto-login
      final isLoggedIn = await authProvider.tryAutoLogin();
      
      if (!mounted) return;
      
      // Navigate based on result
      await authProvider.navigateAfterSplash();
    } catch (e) {
      // If error, navigate to phone auth
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.read<AuthProvider>().navigateAfterSplash();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Icon
                Icon(
                  Icons.home_work,
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // App Name
                const HeadingLarge(
                  text: 'Atitia PG',
                  color: Colors.white,
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Tagline
                const BodyText(
                  text: 'Your Home Away From Home',
                  color: Colors.white70,
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Loading indicator
                const AdaptiveLoader(
                  color: Colors.white,
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Loading message
                BodyText(
                  text: authProvider.loading
                      ? 'Initializing...'
                      : authProvider.errorMessage ?? 'Loading...',
                  color: Colors.white70,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
