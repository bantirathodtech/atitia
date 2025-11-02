import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../../../common/utils/date/converter/date_service_converter.dart';

/// Firebase Crashlytics service for error monitoring and crash reporting.
///
/// ## Responsibilities:
/// - Track fatal crashes and non-fatal errors
/// - Monitor application stability
/// - Provide detailed crash reports for debugging
class CrashlyticsServiceWrapper {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  CrashlyticsServiceWrapper._privateConstructor();
  static final CrashlyticsServiceWrapper _instance =
      CrashlyticsServiceWrapper._privateConstructor();
  factory CrashlyticsServiceWrapper() => _instance;

  /// Initialize Crashlytics service with default configuration.
  ///
  /// ## Purpose:
  /// - Enable crash reporting by default
  /// - Set up basic configuration
  /// - Ensure service is ready for error monitoring
  ///
  /// ## Usage:
  /// Called automatically during Firebase service initialization via FirebaseServiceRegistry
  Future<void> initialize() async {
    try {
      // Enable crash reporting by default for better production monitoring
      await _crashlytics.setCrashlyticsCollectionEnabled(true);

      // Set initial configuration
      await _setInitialConfiguration();
    } catch (error) {
      // Don't throw error - crashlytics should not block app startup
      // App should continue functioning even if crash reporting fails
    }
  }

  /// Set initial configuration for Crashlytics.
  ///
  /// ## Purpose:
  /// - Configure basic settings
  /// - Set up default user context (if available)
  /// - Prepare for error tracking
  Future<void> _setInitialConfiguration() async {
    // Set initial custom keys for better crash context
    await _crashlytics.setCustomKey(
        'app_start_time', DateServiceConverter.toService(DateTime.now()));
    await _crashlytics.setCustomKey('crashlytics_initialized', true);

    // Log initialization event for tracking
    await _crashlytics.log('Crashlytics service initialized');
  }

  /// Enable crash reporting and error monitoring.
  ///
  /// ## Usage:
  /// Call this during app initialization to start crash collection.
  Future<void> enableCrashReporting() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
  }

  /// Disable crash reporting (useful for debug builds).
  Future<void> disableCrashReporting() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(false);
  }

  /// Record a custom error with stack trace for monitoring.
  ///
  /// ## Parameters:
  /// - `exception`: The error that occurred
  /// - `stackTrace`: Stack trace for debugging
  /// - `reason`: Optional error description
  /// - `fatal`: Whether the error is fatal
  Future<void> recordError({
    required dynamic exception,
    required StackTrace stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Log a custom message to crash reports for context.
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// Set custom key-value pairs for enhanced crash reporting.
  ///
  /// ## Usage:
  /// Add user context, feature flags, or app state to crash reports.
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Set user identifier for user-centric crash reporting.
  ///
  /// ## Usage:
  /// Associate crashes with specific users for better debugging.
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// Manually control crashlytics collection enabled state.
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  /// Check if crashlytics collection is currently enabled.
  Future<bool> isCrashlyticsCollectionEnabled() async {
    return _crashlytics.isCrashlyticsCollectionEnabled;
  }
}
