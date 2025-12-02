// test/helpers/test_setup.dart

import 'package:get_it/get_it.dart';
import 'package:atitia/core/services/firebase/analytics/firebase_analytics_service.dart';

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

  @override
  Future<void> logUserRegistration({String method = 'phone'}) async {}

  @override
  Future<void> logPropertySearch({
    required String query,
    int? resultsCount,
  }) async {}

  @override
  Future<void> logBookingInitiated(
      String propertyId, String bookingType) async {}

  @override
  Future<void> logPaymentCompleted(double amount, String paymentMethod) async {}

  @override
  Future<void> logPropertyView({
    required String propertyId,
    required String propertyType,
    double? price,
    String? location,
  }) async {}

  @override
  Future<void> logBookingCompleted({
    required String propertyId,
    required double amount,
    required int durationDays,
    String? paymentMethod,
  }) async {}

  @override
  Future<void> logUserProfileUpdate({
    required String updateType,
    bool? hasPhoto,
  }) async {}

  @override
  Future<void> logAppOpened() async {}

  @override
  Future<void> logAppBackgrounded() async {}

  @override
  Future<void> logError({
    required String errorType,
    required String message,
    String? screenName,
  }) async {}

  @override
  Future<void> resetAnalyticsData() async {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}
}
