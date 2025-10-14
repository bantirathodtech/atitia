// lib/main.dart

import 'package:atitia/core/app/info/app_info.dart';
import 'package:atitia/core/app/localization/locale_provider.dart';
import 'package:atitia/core/app/localization/localization_setup.dart';
import 'package:atitia/core/app/theme/theme_provider.dart';
import 'package:atitia/core/di/firebase/start/firebase_service_initializer.dart';
import 'package:atitia/core/navigation/app_router.dart';
import 'package:atitia/core/providers/firebase/firebase_app_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app/emergency/emergency_fallback_app.dart';

/// Application entry point with clean, modern architecture
Future<void> main() async {
  // Ensure Flutter binding is initialized first
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Single initialization call - handles everything
    await FirebaseServiceInitializer.initialize();

    // Start the app with all providers and services ready
    runApp(
      FirebaseAppProviders.buildWithProviders(
        child: const AtitiaApp(),
      ),
    );
  } catch (error) {
    // Handle critical initialization failures gracefully
    print('❌ App initialization failed: $error');

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

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
    );
  }
}
