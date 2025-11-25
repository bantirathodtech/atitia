// lib/feature/owner_dashboard/subscription/viewmodel/owner_subscription_viewmodel.dart

import 'dart:async';

import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../common/utils/exceptions/exceptions.dart';
import '../../../../../common/utils/logging/logging_mixin.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/models/subscription/subscription_plan_model.dart';
import '../../../../../core/models/subscription/owner_subscription_model.dart';
import '../../../../../core/repositories/subscription/owner_subscription_repository.dart';
import '../../../../../core/services/payment/app_subscription_payment_service.dart';
import '../../profile/data/repository/owner_profile_repository.dart';

/// ViewModel for managing owner subscriptions
/// Extends BaseProviderState for automatic state management
/// Handles subscription loading, purchase, cancellation, and upgrade
class OwnerSubscriptionViewModel extends BaseProviderState with LoggingMixin {
  final OwnerSubscriptionRepository _subscriptionRepo;
  final OwnerProfileRepository _profileRepo;
  final AppSubscriptionPaymentService _paymentService;
  final _authService = getIt.auth;
  final _analyticsService = getIt.analytics;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  /// Constructor with dependency injection
  OwnerSubscriptionViewModel({
    OwnerSubscriptionRepository? subscriptionRepo,
    OwnerProfileRepository? profileRepo,
    AppSubscriptionPaymentService? paymentService,
  })  : _subscriptionRepo = subscriptionRepo ?? OwnerSubscriptionRepository(),
        _profileRepo = profileRepo ?? OwnerProfileRepository(),
        _paymentService = paymentService ?? AppSubscriptionPaymentService();

  OwnerSubscriptionModel? _currentSubscription;
  List<OwnerSubscriptionModel> _subscriptionHistory = [];
  StreamSubscription<OwnerSubscriptionModel?>? _subscriptionStream;
  bool _isProcessingPayment = false;
  bool _isCancelling = false;

  /// Read-only current subscription
  OwnerSubscriptionModel? get currentSubscription => _currentSubscription;

  /// Read-only subscription history
  List<OwnerSubscriptionModel> get subscriptionHistory => _subscriptionHistory;

  /// Check if payment is being processed
  bool get isProcessingPayment => _isProcessingPayment;

  /// Check if subscription is being cancelled
  bool get isCancelling => _isCancelling;

  /// Get current owner ID
  String? get currentOwnerId => _authService.currentUserId;

  /// Check if owner has active subscription
  bool get hasActiveSubscription {
    if (_currentSubscription == null) return false;
    return _currentSubscription!.status == SubscriptionStatus.active &&
        _currentSubscription!.endDate.isAfter(DateTime.now());
  }

  /// Get current subscription tier
  SubscriptionTier get currentTier {
    if (_currentSubscription == null) return SubscriptionTier.free;
    return _currentSubscription!.tier;
  }

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  @override
  void dispose() {
    _subscriptionStream?.cancel();
    _paymentService.dispose();
    super.dispose();
  }

  /// Initialize ViewModel - load current subscription and start streaming
  Future<void> initialize() async {
    try {
      setLoading(true);
      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: _text('ownerIdNotAvailable', 'Owner ID not available'),
          severity: ErrorSeverity.high,
        );
      }

      await _loadCurrentSubscription(ownerId);
      await _loadSubscriptionHistory(ownerId);
      _startSubscriptionStream(ownerId);

      logInfo(
        'Subscription ViewModel initialized',
        feature: 'subscription',
        metadata: {'owner_id': ownerId},
      );
    } catch (e) {
      final exception = AppException(
        message: _text('subscriptionLoadFailed', 'Failed to load subscription'),
        details: e.toString(),
      );
      setError(true, exception.toString());
      logError(
        'Failed to initialize subscription ViewModel',
        feature: 'subscription',
        error: e,
      );
    } finally {
      setLoading(false);
    }
  }

  /// Load current active subscription
  Future<void> _loadCurrentSubscription(String ownerId) async {
    try {
      _currentSubscription =
          await _subscriptionRepo.getActiveSubscription(ownerId);
      notifyListeners();
    } catch (e) {
      logError(
        'Failed to load current subscription',
        feature: 'subscription',
        error: e,
      );
      rethrow;
    }
  }

  /// Load subscription history
  Future<void> _loadSubscriptionHistory(String ownerId) async {
    try {
      _subscriptionHistory =
          await _subscriptionRepo.getAllSubscriptions(ownerId);
      notifyListeners();
    } catch (e) {
      logError(
        'Failed to load subscription history',
        feature: 'subscription',
        error: e,
      );
      // Don't rethrow - history loading failure shouldn't block the screen
    }
  }

  /// Start real-time subscription stream
  void _startSubscriptionStream(String ownerId) {
    _subscriptionStream?.cancel();
    _subscriptionStream = _subscriptionRepo.streamSubscription(ownerId).listen(
      (subscription) {
        _currentSubscription = subscription;
        notifyListeners();
      },
      onError: (error) {
        logError(
          'Subscription stream error',
          feature: 'subscription',
          error: error,
        );
      },
    );
  }

  /// Purchase subscription
  Future<void> purchaseSubscription({
    required SubscriptionPlanModel plan,
    required BillingPeriod billingPeriod,
    Function(String)? onSuccess,
    Function(String)? onFailure,
  }) async {
    try {
      if (_isProcessingPayment) {
        throw AppException(
          message: _text('paymentInProgress', 'Payment already in progress'),
          severity: ErrorSeverity.medium,
        );
      }

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: _text('ownerIdNotAvailable', 'Owner ID not available'),
          severity: ErrorSeverity.high,
        );
      }

      // Get owner profile for payment details
      final profile = await _profileRepo.getOwnerProfile(ownerId);
      if (profile == null) {
        throw AppException(
          message: _text('profileNotFound', 'Profile not found'),
          severity: ErrorSeverity.high,
        );
      }

      _isProcessingPayment = true;
      notifyListeners();

      _analyticsService.logEvent(
        name: 'subscription_purchase_initiated',
        parameters: {
          'owner_id': ownerId,
          'tier': plan.tier.firestoreValue,
          'billing_period': billingPeriod.firestoreValue,
          'amount': (billingPeriod == BillingPeriod.monthly
                  ? plan.monthlyPrice
                  : plan.yearlyPrice)
              .toString(),
        },
      );

      await _paymentService.initialize();

      await _paymentService.processSubscriptionPayment(
        ownerId: ownerId,
        plan: plan,
        billingPeriod: billingPeriod,
        userName: profile.fullName,
        userEmail: profile.email,
        userPhone: profile.phoneNumber,
        onSuccess: (subscriptionId) async {
          _isProcessingPayment = false;
          notifyListeners();

          _analyticsService.logEvent(
            name: 'subscription_purchase_success',
            parameters: {
              'owner_id': ownerId,
              'subscription_id': subscriptionId,
              'tier': plan.tier.firestoreValue,
            },
          );

          // Reload subscription data
          await _loadCurrentSubscription(ownerId);
          await _loadSubscriptionHistory(ownerId);

          onSuccess?.call(subscriptionId);
        },
        onFailure: (error) async {
          _isProcessingPayment = false;
          notifyListeners();

          _analyticsService.logEvent(
            name: 'subscription_purchase_failed',
            parameters: {
              'owner_id': ownerId,
              'tier': plan.tier.firestoreValue,
              'error': error,
            },
          );

          onFailure?.call(error);
        },
      );
    } catch (e) {
      _isProcessingPayment = false;
      notifyListeners();

      final exception = AppException(
        message: _text(
            'subscriptionPurchaseFailed', 'Failed to purchase subscription'),
        details: e.toString(),
      );
      setError(true, exception.toString());
      logError(
        'Failed to purchase subscription',
        feature: 'subscription',
        error: e,
      );
      onFailure?.call(exception.toString());
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription({
    String? reason,
    Function()? onSuccess,
    Function(String)? onFailure,
  }) async {
    try {
      if (_isCancelling) {
        throw AppException(
          message: _text(
              'cancellationInProgress', 'Cancellation already in progress'),
          severity: ErrorSeverity.medium,
        );
      }

      if (_currentSubscription == null) {
        throw AppException(
          message: _text('noSubscriptionFound', 'No active subscription found'),
          severity: ErrorSeverity.medium,
        );
      }

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: _text('ownerIdNotAvailable', 'Owner ID not available'),
          severity: ErrorSeverity.high,
        );
      }

      _isCancelling = true;
      notifyListeners();

      await _analyticsService.logEvent(
        name: 'subscription_cancellation_initiated',
        parameters: {
          'owner_id': ownerId,
          'subscription_id': _currentSubscription!.subscriptionId,
          'tier': _currentSubscription!.tier.firestoreValue,
        },
      );

      final updatedSubscription = _currentSubscription!.copyWith(
        status: SubscriptionStatus.cancelled,
        autoRenew: false,
        cancelledAt: DateTime.now(),
        cancellationReason: reason,
      );

      await _subscriptionRepo.updateSubscription(updatedSubscription);

      _currentSubscription = updatedSubscription;
      _isCancelling = false;
      notifyListeners();

      await _analyticsService.logEvent(
        name: 'subscription_cancelled',
        parameters: {
          'owner_id': ownerId,
          'subscription_id': _currentSubscription!.subscriptionId,
        },
      );

      onSuccess?.call();
    } catch (e) {
      _isCancelling = false;
      notifyListeners();

      final exception = AppException(
        message: _text(
            'subscriptionCancellationFailed', 'Failed to cancel subscription'),
        details: e.toString(),
      );
      setError(true, exception.toString());
      logError(
        'Failed to cancel subscription',
        feature: 'subscription',
        error: e,
      );
      onFailure?.call(exception.toString());
    }
  }

  /// Refresh subscription data
  Future<void> refresh() async {
    final ownerId = currentOwnerId;
    if (ownerId != null && ownerId.isNotEmpty) {
      await _loadCurrentSubscription(ownerId);
      await _loadSubscriptionHistory(ownerId);
    }
  }

  /// Check if owner can add more PGs based on current subscription
  bool canAddPG(int currentPGCount) {
    if (_currentSubscription == null) {
      // Free tier allows 1 PG
      return currentPGCount < 1;
    }

    final plan =
        SubscriptionPlanModel.getPlanByTier(_currentSubscription!.tier);
    if (plan == null) return false;

    return plan.canAddPG(currentPGCount);
  }

  /// Get subscription plan by tier
  SubscriptionPlanModel? getPlanByTier(SubscriptionTier tier) {
    return SubscriptionPlanModel.getPlanByTier(tier);
  }

  /// Get all available subscription plans
  List<SubscriptionPlanModel> get availablePlans =>
      SubscriptionPlanModel.allPlans;
}
