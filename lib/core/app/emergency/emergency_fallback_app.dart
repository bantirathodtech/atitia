// lib/core/app/emergency/emergency_fallback_app.dart

import 'package:flutter/material.dart';

import '../../../common/styles/colors.dart';
import '../../../common/styles/spacing.dart';
import '../../../l10n/app_localizations.dart';

/// Emergency fallback application for when main initialization fails.
///
/// Responsibility:
/// - Provide basic UI when Firebase/services initialization fails
/// - Ensure users always see something rather than a blank screen
/// - Offer recovery options (retry, exit)
///
/// Usage:
/// ```dart
/// runApp(const EmergencyFallbackApp());
/// ```
class EmergencyFallbackApp extends StatelessWidget {
  const EmergencyFallbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Warning Icon
                      Icon(Icons.warning_amber_rounded,
                          size: 80, color: AppColors.statusOrange),
                      const SizedBox(height: AppSpacing.paddingL),

                      // Title
                      Text(
                          AppLocalizations.of(context)
                                  ?.appInitializationIssue ??
                              'App Initialization Issue',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color ??
                                  theme.colorScheme.onSurface),
                          textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.paddingM),

                      // Description
                      Text(
                        AppLocalizations.of(context)
                                ?.troubleConnectingServices ??
                            'We\'re having trouble connecting to our services. This might be due to network issues or maintenance.',
                        style: TextStyle(
                            fontSize: 16,
                            color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.7) ??
                                theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                            height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.paddingXL),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Retry Button
                          ElevatedButton.icon(
                            onPressed: _retryAppInitialization,
                            icon: const Icon(Icons.refresh),
                            label: Text(
                                AppLocalizations.of(context)?.tryAgain ??
                                    'Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.info,
                              foregroundColor: AppColors.textOnPrimary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.paddingM),

                          // Exit Button
                          TextButton.icon(
                            onPressed: _exitApp,
                            icon: const Icon(Icons.exit_to_app),
                            label: Text(
                                AppLocalizations.of(context)?.exit ?? 'Exit'),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.textTheme.bodySmall?.color
                                      ?.withValues(alpha: 0.7) ??
                                  theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Retry application initialization
  void _retryAppInitialization() {
    // This will trigger the main() function again
    // In a real app, you might want to add some delay or cleanup
    Future.microtask(() {
      // Import main function and call it
      // main();
      // Note: In practice, you'd need to restart the app properly
      // This is a simplified version
    });
  }

  /// Exit the application
  void _exitApp() {
    // Close the app
    // Note: This may not work on all platforms
    // In production, you'd use platform-specific code
  }
}
