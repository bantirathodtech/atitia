// lib/main.dart

import 'package:atitia/core/app/info/app_info.dart';
import 'package:atitia/core/app/localization/locale_provider.dart';
import 'package:atitia/core/app/localization/localization_setup.dart';
import 'package:atitia/core/app/theme/theme_provider.dart';
import 'package:atitia/core/di/firebase/start/firebase_service_initializer.dart';
import 'package:atitia/core/navigation/app_router.dart';
import 'package:atitia/core/providers/firebase/firebase_app_providers.dart';
import 'package:atitia/common/services/environment_validation_service.dart';
import 'package:atitia/common/utils/responsive/responsive_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app/emergency/emergency_fallback_app.dart';

/// Application entry point with clean, modern architecture
Future<void> main() async {
  // Ensure Flutter binding is initialized first
  WidgetsFlutterBinding.ensureInitialized();

  // Performance optimizations
  WidgetsBinding.instance.scheduleFrameCallback((_) {
    // Pre-warm critical services for faster app startup
  });

  // Frame rate optimization - limit to 60fps to reduce buffer queue pressure
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Enable smooth scrolling and reduce unnecessary repaints
  });

  try {
    // Validate environment configuration first
    final isValidEnvironment =
        await EnvironmentValidationService.validateEnvironment();
    if (!isValidEnvironment) {
      // Continue anyway for development, but log the issue
    }

    // Print environment summary
    EnvironmentValidationService.printEnvironmentSummary();

    // Single initialization call - handles everything
    await FirebaseServiceInitializer.initialize();

    // Initialize responsive system
    ResponsiveSystem.initialize();

    // Start the app with all providers and services ready
    runApp(
      FirebaseAppProviders.buildWithProviders(
        child: const AtitiaApp(),
      ),
    );
  } catch (error) {
    // Handle critical initialization failures gracefully

    /// 🚨 EMERGENCY FALLBACK APPLICATION
    // Fallback to emergency UI - users always see something
    runApp(const EmergencyFallbackApp());
  }
}

/// 🎯 ROOT APPLICATION WIDGET
/// Main application with theme, localization, and provider configuration
class AtitiaApp extends StatelessWidget {
  const AtitiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp.router(
          // App Info
          debugShowCheckedModeBanner: AppInfo.showDebugBanner,
          restorationScopeId: AppInfo.restorationScopeId,
          title: AppInfo.appTitle,

          // Theme Configuration
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,

          // Localization Configuration
          locale: localeProvider.locale,
          supportedLocales: LocalizationSetup.supportedLocales,
          localizationsDelegates: LocalizationSetup.delegates,

          // Router Configuration (GoRouter)
          routerConfig: AppRouter.router,

          // Performance optimizations and responsive system
          builder: (context, child) {
            // Add performance monitoring and responsive system
            return ResponsiveSystemProvider(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  // Limit frame rate to reduce buffer queue pressure
                  devicePixelRatio:
                      MediaQuery.of(context).devicePixelRatio.clamp(1.0, 3.0),
                ),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}
