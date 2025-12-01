// test/helpers/mock_app_subscription_payment_service.dart

import 'package:atitia/core/models/subscription/subscription_plan_model.dart';
import 'package:atitia/core/models/subscription/owner_subscription_model.dart';

/// Mock implementation of AppSubscriptionPaymentService for unit tests
/// This avoids the UnifiedServiceLocator dependency issue
/// Note: Cannot extend AppSubscriptionPaymentService because it creates repositories in constructor
/// So we create a simple mock that can be passed to ViewModels
class MockAppSubscriptionPaymentService {
  bool _shouldFail = false;
  String? _mockSubscriptionId;
  String? _mockFeaturedListingId;

  MockAppSubscriptionPaymentService();

  void setShouldFail(bool fail) {
    _shouldFail = fail;
  }

  void setMockSubscriptionId(String id) {
    _mockSubscriptionId = id;
  }

  void setMockFeaturedListingId(String id) {
    _mockFeaturedListingId = id;
  }

  Future<void> initialize() async {
    // Mock implementation - no-op
  }

  Future<void> processSubscriptionPayment({
    required String ownerId,
    required SubscriptionPlanModel plan,
    required BillingPeriod billingPeriod,
    required String userName,
    required String userEmail,
    required String userPhone,
    Function(String)? onSuccess,
    Function(String)? onFailure,
  }) async {
    if (_shouldFail) {
      onFailure?.call('Payment failed');
    } else {
      onSuccess?.call(_mockSubscriptionId ?? 'mock_subscription_123');
    }
  }

  Future<void> processFeaturedListingPayment({
    required String ownerId,
    required String pgId,
    required int durationMonths,
    required String userName,
    required String userEmail,
    required String userPhone,
    Function(String)? onSuccess,
    Function(String)? onFailure,
  }) async {
    if (_shouldFail) {
      onFailure?.call('Payment failed');
    } else {
      onSuccess?.call(_mockFeaturedListingId ?? 'mock_featured_listing_123');
    }
  }

  void dispose() {
    // Mock implementation - no-op
  }
}
