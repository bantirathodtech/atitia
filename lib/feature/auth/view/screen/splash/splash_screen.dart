import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/responsive/responsive_breakpoints.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
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
  /// Uses minimum display time for visual effect while ensuring fast navigation
  Future<void> _initializeApp() async {
    try {
      final authProvider = context.read<AuthProvider>();

      // Minimum display time for splash effect (reduced from 1s to 300ms)
      // This ensures the splash is visible but doesn't unnecessarily delay fast devices
      const minimumDisplayTime = Duration(milliseconds: 300);

      // Start navigation immediately
      final navigationFuture = authProvider.navigateAfterSplash();

      // Wait for both minimum display time and navigation to complete
      // This ensures splash shows for at least 300ms, but proceeds immediately
      // if navigation takes longer (which shouldn't happen, but ensures responsiveness)
      await Future.wait([
        Future.delayed(minimumDisplayTime),
        navigationFuture,
      ]);

      if (!mounted) return;
    } catch (e) {
      // If error, navigate immediately without additional delay
      if (mounted) {
        context.read<AuthProvider>().navigateAfterSplash();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenSize = MediaQuery.of(context).size;
              final responsiveConfig = ResponsiveSystem.getConfig(context);

              // Scale icon size based on screen width
              // Mobile: 80, Tablet: 120, Desktop: 160, Large Desktop: 200
              final iconSize = _getResponsiveIconSize(
                responsiveConfig.layoutType,
                screenSize.width,
              );

              // Responsive spacing
              final spacingBetweenIconAndTitle = _getResponsiveSpacing(
                responsiveConfig.layoutType,
                AppSpacing.paddingL,
              );
              final spacingBetweenTitleAndTagline = _getResponsiveSpacing(
                responsiveConfig.layoutType,
                AppSpacing.paddingS,
              );
              final spacingBetweenTaglineAndLoader = _getResponsiveSpacing(
                responsiveConfig.layoutType,
                AppSpacing.paddingXL,
              );
              final spacingBetweenLoaderAndMessage = _getResponsiveSpacing(
                responsiveConfig.layoutType,
                AppSpacing.paddingM,
              );

              // Max width constraint for larger screens
              final maxContentWidth = responsiveConfig.isMobile
                  ? screenSize.width
                  : responsiveConfig.isTablet
                      ? 600.0
                      : 800.0;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxContentWidth,
                    maxHeight: screenSize.height,
                  ),
                  child: Padding(
                    padding: ResponsiveSystem.getResponsivePadding(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Logo
                        Image.asset(
                          'assets/app_icon.jpeg',
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to icon if asset not found
                            return Icon(
                              Icons.home_work,
                              size: iconSize,
                              color: Colors.white,
                            );
                          },
                        ),
                        SizedBox(height: spacingBetweenIconAndTitle),

                        // App Name
                        const HeadingLarge(
                          text: 'Atitia PG',
                          color: Colors.white,
                        ),
                        SizedBox(height: spacingBetweenTitleAndTagline),

                        // Tagline
                        const BodyText(
                          text: 'Your Home Away From Home',
                          color: Colors.white70,
                        ),
                        SizedBox(height: spacingBetweenTaglineAndLoader),

                        // Loading indicator
                        const AdaptiveLoader(
                          color: Colors.white,
                        ),
                        SizedBox(height: spacingBetweenLoaderAndMessage),

                        // Loading message
                        BodyText(
                          text: authProvider.loading
                              ? 'Initializing...'
                              : authProvider.errorMessage ?? 'Loading...',
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Get responsive icon size based on layout type and screen width
  double _getResponsiveIconSize(
    ResponsiveLayoutType layoutType,
    double screenWidth,
  ) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return 80.0;
      case ResponsiveLayoutType.tablet:
        return 120.0;
      case ResponsiveLayoutType.desktop:
        return 160.0;
      case ResponsiveLayoutType.largeDesktop:
        return 200.0;
    }
  }

  /// Get responsive spacing value, scaling based on layout type
  double _getResponsiveSpacing(
    ResponsiveLayoutType layoutType,
    double baseSpacing,
  ) {
    // Scale spacing proportionally for larger screens
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return baseSpacing;
      case ResponsiveLayoutType.tablet:
        return baseSpacing * 1.25;
      case ResponsiveLayoutType.desktop:
        return baseSpacing * 1.5;
      case ResponsiveLayoutType.largeDesktop:
        return baseSpacing * 1.75;
    }
  }
}
