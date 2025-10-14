import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app/localization/locale_provider.dart';
import '../../../core/app/theme/theme_provider.dart';

/// REST API-specific provider configuration.
/// 
/// This file is a placeholder for REST API-based providers.
/// Currently, the app uses Firebase providers (firebase_app_providers.dart).
/// 
/// To use REST API providers:
/// 1. Implement REST API services in core/services/api/
/// 2. Create REST API dependency container in core/di/rest/
/// 3. Wire up ViewModels with REST API services
/// 4. Update main.dart to use RestApiAppProviders instead of FirebaseAppProviders
class RestApiAppProviders {
  /// Returns list of providers for REST API implementation
  /// 
  /// Note: This is a minimal implementation with only core providers.
  /// Add feature-specific providers as you implement REST API services.
  static List<ChangeNotifierProvider> get providers => [
        // Core providers (theme and locale management)
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),

        // TODO: Add REST API-based providers here
        // Example:
        // ChangeNotifierProvider<AuthProvider>(
        //   create: (_) => RestApiDependencyContainer.createAuthProvider(),
        // ),
        // ChangeNotifierProvider<GuestProfileViewModel>(
        //   create: (_) => RestApiDependencyContainer.createGuestProfileViewModel(),
        // ),
      ];

  /// Wraps the app with MultiProvider using REST API providers
  static Widget buildWithProviders({required Widget child}) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
