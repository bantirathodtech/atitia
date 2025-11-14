// lib/core/services/analytics/enhanced_analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 📊 **ENHANCED ANALYTICS SERVICE - PRODUCTION READY**
///
/// **Features:**
/// - User journey tracking
/// - Performance metrics
/// - Custom event tracking
/// - User behavior analytics
/// - Business intelligence
/// - A/B testing support
class EnhancedAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static const String _userJourneyKey = 'user_journey';
  static const String _sessionStartKey = 'session_start';
  static const String _performanceMetricsKey = 'performance_metrics';

  /// Initialize enhanced analytics
  Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    await _trackSessionStart();
  }

  /// Track session start
  Future<void> _trackSessionStart() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionStart = DateTime.now();
    await prefs.setString(_sessionStartKey, sessionStart.toIso8601String());

    await _analytics.logEvent(
      name: 'session_start',
      parameters: {
        'timestamp': sessionStart.millisecondsSinceEpoch,
      },
    );
  }

  /// Track user journey step
  Future<void> trackUserJourneyStep({
    required String step,
    required String screen,
    Map<String, Object>? parameters,
  }) async {
    final journey = await _getUserJourney();
    final stepData = {
      'step': step,
      'screen': screen,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'parameters': parameters ?? {},
    };

    journey.add(stepData);
    await _saveUserJourney(journey);

    await _analytics.logEvent(
      name: 'user_journey_step',
      parameters: {
        'step': step,
        'screen': screen,
        'step_number': journey.length,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track screen view with enhanced metrics
  Future<void> trackScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );

    await trackUserJourneyStep(
      step: 'screen_view',
      screen: screenName,
      parameters: parameters,
    );

    // Track screen engagement time
    _trackScreenEngagement(screenName);
  }

  /// Track screen engagement time
  DateTime? _screenStartTime;
  String? _currentScreen;

  void _trackScreenEngagement(String screenName) {
    // End previous screen engagement
    if (_currentScreen != null && _screenStartTime != null) {
      final engagementTime =
          DateTime.now().difference(_screenStartTime!).inSeconds;
      _analytics.logEvent(
        name: 'screen_engagement_time',
        parameters: {
          'screen_name': _currentScreen!,
          'engagement_seconds': engagementTime,
        },
      );
    }

    // Start new screen engagement
    _currentScreen = screenName;
    _screenStartTime = DateTime.now();
  }

  /// Track user actions
  Future<void> trackUserAction({
    required String action,
    required String screen,
    Map<String, Object>? parameters,
    String? category,
  }) async {
    await _analytics.logEvent(
      name: 'user_action',
      parameters: {
        'action': action,
        'screen': screen,
        'category': category ?? 'general',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );

    await trackUserJourneyStep(
      step: 'action',
      screen: screen,
      parameters: {
        'action': action,
        'category': category ?? 'unknown',
        ...(parameters ?? {}),
      },
    );
  }

  /// Track performance metrics
  Future<void> trackPerformanceMetric({
    required String metricName,
    required double value,
    String? unit,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'performance_metric',
      parameters: {
        'metric_name': metricName,
        'value': value,
        'unit': unit ?? 'seconds',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );

    // Store performance metrics for analysis
    await _storePerformanceMetric(metricName, value, unit, parameters);
  }

  /// Track business events
  Future<void> trackBusinessEvent({
    required String eventName,
    required String eventType, // conversion, engagement, retention
    Map<String, Object>? parameters,
    double? value,
  }) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: {
        'event_type': eventType,
        'value': value ?? 0.0,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );

    await trackUserJourneyStep(
      step: 'business_event',
      screen: 'unknown',
      parameters: {
        'event_name': eventName,
        'event_type': eventType,
        'value': value ?? 0.0,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track conversion events
  Future<void> trackConversion({
    required String conversionType,
    required double value,
    String? screenName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'conversion',
      parameters: {
        'conversion_type': conversionType,
        'conversion_value': value,
        'screen': screenName ?? 'unknown',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track A/B test events
  Future<void> trackABTestEvent({
    required String experimentName,
    required String variant,
    required String action,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'ab_test_event',
      parameters: {
        'experiment_name': experimentName,
        'variant': variant,
        'action': action,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track error events
  Future<void> trackError({
    required String errorType,
    required String errorMessage,
    String? screenName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'error_occurred',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
        'screen': screenName ?? 'unknown',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track feature usage
  Future<void> trackFeatureUsage({
    required String featureName,
    required String usageType,
    String? screenName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'feature_usage',
      parameters: {
        'feature_name': featureName,
        'usage_type': usageType,
        'screen': screenName ?? 'unknown',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track search events
  Future<void> trackSearch({
    required String query,
    required String category,
    required int resultsCount,
    String? screenName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'search_performed',
      parameters: {
        'search_query': query,
        'search_category': category,
        'results_count': resultsCount,
        'screen': screenName ?? 'unknown',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track filter usage
  Future<void> trackFilterUsage({
    required String filterType,
    required String filterValue,
    String? screenName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'filter_used',
      parameters: {
        'filter_type': filterType,
        'filter_value': filterValue,
        'screen': screenName ?? 'unknown',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track onboarding progress
  Future<void> trackOnboardingProgress({
    required String step,
    required double progressPercentage,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'onboarding_progress',
      parameters: {
        'step': step,
        'progress_percentage': progressPercentage,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Track retention events
  Future<void> trackRetentionEvent({
    required String eventType,
    required int daysSinceSignup,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: 'retention_event',
      parameters: {
        'event_type': eventType,
        'days_since_signup': daysSinceSignup,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        ...(parameters ?? {}),
      },
    );
  }

  /// Get user journey data
  Future<List<Map<String, dynamic>>> _getUserJourney() async {
    final prefs = await SharedPreferences.getInstance();
    final journeyString = prefs.getString(_userJourneyKey);

    if (journeyString != null) {
      final List<dynamic> journeyList = jsonDecode(journeyString);
      return journeyList.cast<Map<String, dynamic>>();
    }

    return [];
  }

  /// Save user journey data
  Future<void> _saveUserJourney(List<Map<String, dynamic>> journey) async {
    final prefs = await SharedPreferences.getInstance();

    // Keep only last 100 steps
    if (journey.length > 100) {
      journey = journey.sublist(journey.length - 100);
    }

    await prefs.setString(_userJourneyKey, jsonEncode(journey));
  }

  /// Store performance metric
  Future<void> _storePerformanceMetric(
    String metricName,
    double value,
    String? unit,
    Map<String, Object>? parameters,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var metrics = await getPerformanceMetrics();

    metrics.add(
      {
        'metric_name': metricName,
        'value': value,
        'unit': unit ?? 'seconds',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'parameters': parameters ?? {},
      },
    );

    // Keep only last 50 metrics
    if (metrics.length > 50) {
      metrics = metrics.sublist(metrics.length - 50);
    }

    await prefs.setString(_performanceMetricsKey, jsonEncode(metrics));
  }

  /// Get performance metrics
  Future<List<Map<String, dynamic>>> getPerformanceMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    final metricsString = prefs.getString(_performanceMetricsKey);

    if (metricsString != null) {
      final List<dynamic> metricsList = jsonDecode(metricsString);
      return metricsList.cast<Map<String, dynamic>>();
    }

    return [];
  }

  /// Clear analytics data
  Future<void> clearAnalyticsData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userJourneyKey);
    await prefs.remove(_performanceMetricsKey);
    await prefs.remove(_sessionStartKey);
  }

  /// Standard logEvent method for backward compatibility
  Future<void> logEvent(String eventName,
      {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  /// Set user ID
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Reset analytics data
  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }
}

// Global instance
final enhancedAnalyticsService = EnhancedAnalyticsService();
