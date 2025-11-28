// lib/core/services/payment/app_subscription_payment_service.dart

/// Payment service for app subscriptions and featured listings
/// Handles payments using the app's Razorpay account (not owner's account)
/// Used for collecting subscription fees and featured listing payments
library;

import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../common/utils/logging/logging_mixin.dart';
import '../../../common/constants/environment_config.dart';
import '../../models/subscription/subscription_plan_model.dart';
import '../../models/subscription/owner_subscription_model.dart';
import '../../models/featured/featured_listing_model.dart';
import '../../models/revenue/revenue_record_model.dart';
import '../../repositories/subscription/owner_subscription_repository.dart';
import '../../repositories/featured/featured_listing_repository.dart';
import '../../repositories/revenue/revenue_repository.dart';
import '../../../core/services/firebase/remote_config/remote_config_service.dart';

/// Payment type for app payments
enum AppPaymentType {
  subscription,
  featuredListing,
}

/// App subscription payment service
/// Handles Razorpay payments for subscriptions and featured listings
class AppSubscriptionPaymentService with LoggingMixin {
  Razorpay? _razorpay;
  String? _currentOrderId;
  String? _appRazorpayKey;
  AppPaymentType? _currentPaymentType;
  String? _currentPaymentContextId; // subscriptionId or featuredListingId

  // Repositories
  final OwnerSubscriptionRepository _subscriptionRepo =
      OwnerSubscriptionRepository();
  final FeaturedListingRepository _featuredRepo = FeaturedListingRepository();
  final RevenueRepository _revenueRepo = RevenueRepository();
  final RemoteConfigServiceWrapper _remoteConfig = RemoteConfigServiceWrapper();

  /// Callbacks
  Function(String, PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onFailure;

  /// Initialize Razorpay with app's key
  Future<void> initialize() async {
    try {
      if (_razorpay != null) {
        return; // Already initialized
      }

      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      // Get app's Razorpay key from Remote Config or environment
      await _loadAppRazorpayKey();

      logInfo(
        'App subscription payment service initialized',
        feature: 'payment',
      );
    } catch (e) {
      logError(
        'Failed to initialize app subscription payment service',
        feature: 'payment',
        error: e,
      );
      rethrow;
    }
  }

  /// Load app's Razorpay key from Remote Config or environment
  /// Priority: Remote Config > EnvironmentConfig > Error
  Future<void> _loadAppRazorpayKey() async {
    try {
      // Try Remote Config first (allows runtime updates without app rebuild)
      final remoteKey = _remoteConfig.getString('app_razorpay_key');
      if (remoteKey.isNotEmpty && remoteKey != 'app_razorpay_key') {
        _appRazorpayKey = remoteKey;
        logInfo(
          'App Razorpay key loaded from Remote Config',
          feature: 'payment',
        );
        return;
      }

      // Fallback to EnvironmentConfig (single source of truth for all keys)
      final envKey = EnvironmentConfig.razorpayApiKey;
      if (envKey.isNotEmpty && envKey.startsWith('rzp_')) {
        _appRazorpayKey = envKey;
        logInfo(
          'App Razorpay key loaded from EnvironmentConfig',
          feature: 'payment',
        );
        return;
      }

      // If neither source has a valid key, throw error
      throw Exception(
          'App Razorpay key not configured. Please set in Remote Config (app_razorpay_key) or Environment Config (RAZORPAY_API_KEY).');
    } catch (e) {
      logError(
        'Failed to load app Razorpay key',
        feature: 'payment',
        error: e,
      );
      rethrow;
    }
  }

  /// Process subscription payment
  /// Creates subscription record and processes payment
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
    try {
      await initialize();

      if (_appRazorpayKey == null || _appRazorpayKey!.isEmpty) {
        throw Exception('App Razorpay key not configured');
      }

      // Calculate amount based on billing period
      final amount = billingPeriod == BillingPeriod.monthly
          ? plan.monthlyPrice
          : plan.yearlyPrice;

      if (amount <= 0) {
        throw Exception('Invalid subscription amount');
      }

      // Create subscription record first (with pending status)
      final now = DateTime.now();
      final endDate = billingPeriod == BillingPeriod.monthly
          ? now.add(Duration(days: 30))
          : now.add(Duration(days: 365));

      final subscriptionId = 'sub_${ownerId}_${now.millisecondsSinceEpoch}';
      final orderId = 'order_$subscriptionId';

      final subscription = OwnerSubscriptionModel(
        subscriptionId: subscriptionId,
        ownerId: ownerId,
        tier: plan.tier,
        status: SubscriptionStatus.pendingPayment,
        billingPeriod: billingPeriod,
        startDate: now,
        endDate: endDate,
        nextBillingDate: endDate,
        amountPaid: 0.0,
        autoRenew: true,
        orderId: orderId,
      );

      // Create subscription with pending status
      await _subscriptionRepo.createSubscription(subscription);

      // Store context for payment callbacks
      _currentOrderId = orderId;
      _currentPaymentType = AppPaymentType.subscription;
      _currentPaymentContextId = subscriptionId;
      _onSuccess = (orderId, response) async {
        await _handleSubscriptionPaymentSuccess(
          subscriptionId: subscriptionId,
          ownerId: ownerId,
          plan: plan,
          billingPeriod: billingPeriod,
          amount: amount,
          paymentId: response.paymentId ?? '',
          orderId: orderId,
        );
        onSuccess?.call(subscriptionId);
      };
      _onFailure = (response) {
        onFailure?.call(response.message ?? 'Payment failed');
      };

      // Open Razorpay payment
      final options = {
        'key': _appRazorpayKey!,
        'amount': (amount * 100).toInt(), // Convert to paise
        'name': 'Atitia',
        'description':
            '${plan.name} Subscription - ${billingPeriod.displayName}',
        'prefill': {
          'contact': userPhone,
          'email': userEmail,
          'name': userName,
        },
        'external': {
          'wallets': ['paytm'],
        },
      };

      _razorpay!.open(options);

      logInfo(
        'Subscription payment opened',
        feature: 'payment',
        metadata: {
          'subscription_id': subscriptionId,
          'owner_id': ownerId,
          'tier': plan.tier.firestoreValue,
          'amount': amount.toString(),
        },
      );
    } catch (e) {
      logError(
        'Failed to process subscription payment',
        feature: 'payment',
        error: e,
      );
      onFailure?.call(e.toString());
      rethrow;
    }
  }

  /// Process featured listing payment
  /// Creates featured listing record and processes payment
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
    try {
      await initialize();

      if (_appRazorpayKey == null || _appRazorpayKey!.isEmpty) {
        throw Exception('App Razorpay key not configured');
      }

      // Calculate amount
      final amount = FeaturedListingModel.getPriceForDuration(durationMonths);

      if (amount <= 0) {
        throw Exception('Invalid featured listing amount');
      }

      // Create featured listing record first (with pending status)
      final now = DateTime.now();
      final endDate = now.add(Duration(days: durationMonths * 30));

      final featuredListingId = 'feat_${pgId}_${now.millisecondsSinceEpoch}';
      final orderId = 'order_$featuredListingId';

      final featuredListing = FeaturedListingModel(
        featuredListingId: featuredListingId,
        pgId: pgId,
        ownerId: ownerId,
        status: FeaturedListingStatus.pending,
        startDate: now,
        endDate: endDate,
        durationMonths: durationMonths,
        amountPaid: 0.0,
        orderId: orderId,
      );

      // Create featured listing with pending status
      await _featuredRepo.createFeaturedListing(featuredListing);

      // Store context for payment callbacks
      _currentOrderId = orderId;
      _currentPaymentType = AppPaymentType.featuredListing;
      _currentPaymentContextId = featuredListingId;
      _onSuccess = (orderId, response) async {
        await _handleFeaturedListingPaymentSuccess(
          featuredListingId: featuredListingId,
          ownerId: ownerId,
          pgId: pgId,
          amount: amount,
          paymentId: response.paymentId ?? '',
          orderId: orderId,
        );
        onSuccess?.call(featuredListingId);
      };
      _onFailure = (response) {
        onFailure?.call(response.message ?? 'Payment failed');
      };

      // Open Razorpay payment
      final options = {
        'key': _appRazorpayKey!,
        'amount': (amount * 100).toInt(), // Convert to paise
        'name': 'Atitia',
        'description':
            'Featured Listing - $durationMonths Month${durationMonths > 1 ? 's' : ''}',
        'prefill': {
          'contact': userPhone,
          'email': userEmail,
          'name': userName,
        },
        'external': {
          'wallets': ['paytm'],
        },
      };

      _razorpay!.open(options);

      logInfo(
        'Featured listing payment opened',
        feature: 'payment',
        metadata: {
          'featured_listing_id': featuredListingId,
          'owner_id': ownerId,
          'pg_id': pgId,
          'duration_months': durationMonths.toString(),
          'amount': amount.toString(),
        },
      );
    } catch (e) {
      logError(
        'Failed to process featured listing payment',
        feature: 'payment',
        error: e,
      );
      onFailure?.call(e.toString());
      rethrow;
    }
  }

  /// Handle subscription payment success
  Future<void> _handleSubscriptionPaymentSuccess({
    required String subscriptionId,
    required String ownerId,
    required SubscriptionPlanModel plan,
    required BillingPeriod billingPeriod,
    required double amount,
    required String paymentId,
    required String orderId,
  }) async {
    try {
      // Update subscription status to active
      final subscription =
          await _subscriptionRepo.getSubscription(subscriptionId);
      if (subscription == null) {
        throw Exception('Subscription not found');
      }

      final updatedSubscription = subscription.copyWith(
        status: SubscriptionStatus.active,
        amountPaid: amount,
        paymentId: paymentId,
        orderId: orderId,
      );

      await _subscriptionRepo.updateSubscription(updatedSubscription);

      // Create revenue record
      final revenueId =
          'rev_${subscriptionId}_${DateTime.now().millisecondsSinceEpoch}';
      final revenue = RevenueRecordModel(
        revenueId: revenueId,
        type: RevenueType.subscription,
        ownerId: ownerId,
        amount: amount,
        status: PaymentStatus.completed,
        paymentDate: DateTime.now(),
        paymentId: paymentId,
        orderId: orderId,
        subscriptionId: subscriptionId,
        metadata: {
          'tier': plan.tier.firestoreValue,
          'billing_period': billingPeriod.firestoreValue,
        },
      );

      await _revenueRepo.createRevenueRecord(revenue);

      logInfo(
        'Subscription payment processed successfully',
        feature: 'payment',
        metadata: {
          'subscription_id': subscriptionId,
          'owner_id': ownerId,
          'amount': amount.toString(),
        },
      );

      _clearCallbacks();
    } catch (e) {
      logError(
        'Failed to handle subscription payment success',
        feature: 'payment',
        error: e,
      );
      rethrow;
    }
  }

  /// Handle featured listing payment success
  Future<void> _handleFeaturedListingPaymentSuccess({
    required String featuredListingId,
    required String ownerId,
    required String pgId,
    required double amount,
    required String paymentId,
    required String orderId,
  }) async {
    try {
      // Update featured listing status to active
      final featuredListing =
          await _featuredRepo.getFeaturedListing(featuredListingId);
      if (featuredListing == null) {
        throw Exception('Featured listing not found');
      }

      final updatedListing = featuredListing.copyWith(
        status: FeaturedListingStatus.active,
        amountPaid: amount,
        paymentId: paymentId,
        orderId: orderId,
      );

      await _featuredRepo.updateFeaturedListing(updatedListing);

      // Create revenue record
      final revenueId =
          'rev_${featuredListingId}_${DateTime.now().millisecondsSinceEpoch}';
      final revenue = RevenueRecordModel(
        revenueId: revenueId,
        type: RevenueType.featuredListing,
        ownerId: ownerId,
        amount: amount,
        status: PaymentStatus.completed,
        paymentDate: DateTime.now(),
        paymentId: paymentId,
        orderId: orderId,
        featuredListingId: featuredListingId,
        metadata: {
          'pg_id': pgId,
          'duration_months': featuredListing.durationMonths.toString(),
        },
      );

      await _revenueRepo.createRevenueRecord(revenue);

      logInfo(
        'Featured listing payment processed successfully',
        feature: 'payment',
        metadata: {
          'featured_listing_id': featuredListingId,
          'owner_id': ownerId,
          'amount': amount.toString(),
        },
      );

      _clearCallbacks();
    } catch (e) {
      logError(
        'Failed to handle featured listing payment success',
        feature: 'payment',
        error: e,
      );
      rethrow;
    }
  }

  /// Handle Razorpay payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    logInfo(
      'App payment successful',
      feature: 'payment',
      metadata: {
        'payment_id': response.paymentId,
        'order_id': _currentOrderId,
        'signature': response.signature,
      },
    );

    if (_onSuccess != null && _currentOrderId != null) {
      _onSuccess!(_currentOrderId!, response);
    }
  }

  /// Handle Razorpay payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    logError(
      'App payment failed',
      feature: 'payment',
      error: Exception(response.message),
      metadata: {
        'code': response.code.toString(),
        'message': response.message,
        'order_id': _currentOrderId,
      },
    );

    // Update subscription/featured listing status to failed
    _handlePaymentFailure();

    _onFailure?.call(response);
    _clearCallbacks();
  }

  /// Handle payment failure - update records
  Future<void> _handlePaymentFailure() async {
    try {
      if (_currentPaymentType == AppPaymentType.subscription &&
          _currentPaymentContextId != null) {
        final subscription =
            await _subscriptionRepo.getSubscription(_currentPaymentContextId!);
        if (subscription != null &&
            subscription.status == SubscriptionStatus.pendingPayment) {
          // Keep as pending payment for retry, or mark as cancelled
          // For now, we'll leave it as pending so user can retry
        }
      } else if (_currentPaymentType == AppPaymentType.featuredListing &&
          _currentPaymentContextId != null) {
        final listing =
            await _featuredRepo.getFeaturedListing(_currentPaymentContextId!);
        if (listing != null &&
            listing.status == FeaturedListingStatus.pending) {
          // Keep as pending for retry, or mark as cancelled
          // For now, we'll leave it as pending so user can retry
        }
      }
    } catch (e) {
      logError(
        'Failed to handle payment failure',
        feature: 'payment',
        error: e,
      );
    }
  }

  /// Handle external wallet selection
  void _handleExternalWallet(ExternalWalletResponse response) {
    logInfo(
      'External wallet selected',
      feature: 'payment',
      metadata: {
        'wallet_name': response.walletName,
        'order_id': _currentOrderId,
      },
    );
    // External wallets are handled by Razorpay
  }

  /// Clear callbacks
  void _clearCallbacks() {
    _currentOrderId = null;
    _currentPaymentType = null;
    _currentPaymentContextId = null;
    _onSuccess = null;
    _onFailure = null;
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
    _clearCallbacks();
    _appRazorpayKey = null;
  }
}
