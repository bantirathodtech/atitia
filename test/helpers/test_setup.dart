// test/helpers/test_setup.dart

import 'package:get_it/get_it.dart';
import 'package:atitia/core/di/firebase/di/firebase_service_locator.dart';
import 'package:atitia/core/services/analytics/firebase_analytics_service.dart';
import '../mocks/mock_services.dart';

/// Test setup helper for initializing GetIt with mock services
/// This allows ViewModels to be tested without actual Firebase connections
class TestSetup {
  static bool _isInitialized = false;

  /// Initialize GetIt with mock services for testing
  /// Call this in setUpAll() of test files
  static void initializeGetIt() {
    if (_isInitialized) return;

    // Reset GetIt if already initialized
    if (GetIt.instance.isRegistered<GetIt>()) {
      GetIt.instance.reset();
    }

    // Register mock analytics service
    if (!GetIt.instance.isRegistered<AnalyticsServiceWrapper>()) {
      GetIt.instance.registerSingleton<AnalyticsServiceWrapper>(
        MockAnalyticsServiceWrapper() as AnalyticsServiceWrapper,
      );
    }

    // Register other mock services as needed
    // Note: We're using type casting to work around GetIt's type system
    // In real tests, you might need to create proper mock implementations

    _isInitialized = true;
  }

  /// Reset GetIt after tests
  /// Call this in tearDownAll() of test files
  static void resetGetIt() {
    if (GetIt.instance.isRegistered<GetIt>()) {
      GetIt.instance.reset();
    }
    _isInitialized = false;
  }
}

/// Mock Analytics Service that implements AnalyticsServiceWrapper interface
class MockAnalyticsServiceWrapper implements AnalyticsServiceWrapper {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {}

  @override
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {}
}

