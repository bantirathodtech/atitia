// lib/core/adapters/firebase/firebase_analytics_adapter.dart

import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../services/firebase/analytics/firebase_analytics_service.dart';

/// Adapter that wraps Firebase AnalyticsServiceWrapper to implement IAnalyticsService
/// This allows using Firebase implementation through the interface
class FirebaseAnalyticsAdapter implements IAnalyticsService {
  final AnalyticsServiceWrapper _analyticsService;

  FirebaseAnalyticsAdapter(this._analyticsService);

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return _analyticsService.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) {
    return _analyticsService.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) {
    return _analyticsService.setUserProperty(
      name: name,
      value: value,
    );
  }

  @override
  Future<void> setUserId(String? userId) {
    return _analyticsService.setUserId(userId);
  }

  @override
  Future<void> resetAnalyticsData() {
    return _analyticsService.resetAnalyticsData();
  }
}
