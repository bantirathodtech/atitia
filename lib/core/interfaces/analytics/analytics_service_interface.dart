// lib/core/interfaces/analytics/analytics_service_interface.dart

/// Abstract interface for analytics operations
/// Implementations: Firebase Analytics, REST API analytics, custom analytics
abstract class IAnalyticsService {
  /// Logs an event with parameters
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  /// Logs a screen view
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  });

  /// Sets a user property
  Future<void> setUserProperty({
    required String name,
    required String value,
  });

  /// Sets user ID for analytics
  Future<void> setUserId(String? userId);

  /// Resets analytics data (for logout)
  Future<void> resetAnalyticsData();
}
