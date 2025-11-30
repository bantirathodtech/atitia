// lib/features/guest_dashboard/payments/viewmodel/guest_payment_viewmodel.dart

import 'dart:async';

import '../../../../common/lifecycle/mixin/stream_subscription_mixin.dart';
import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../data/models/guest_payment_model.dart';
import '../data/repository/guest_payment_repository.dart';
import '../../../../core/services/localization/internationalization_service.dart';
import '../../../../core/interfaces/auth/viewmodel_auth_service_interface.dart';
import '../../../../core/adapters/auth/authentication_service_wrapper_adapter.dart';

/// ViewModel for managing guest payments UI state and business logic
/// Extends BaseProviderState for automatic service access and state management
/// Coordinates between UI layer and Repository layer
class GuestPaymentViewModel extends BaseProviderState
    with StreamSubscriptionMixin {
  final GuestPaymentRepository _repository;
  final IViewModelAuthService _authService;
  final _analyticsService = getIt.analytics;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  GuestPaymentViewModel({
    GuestPaymentRepository? repository,
    IViewModelAuthService? authService,
  })  : _repository = repository ?? GuestPaymentRepository(),
        _authService = authService ?? AuthenticationServiceWrapperAdapter();

  StreamSubscription<List<GuestPaymentModel>>? _paymentsSubscription;
  StreamSubscription<List<GuestPaymentModel>>? _pendingPaymentsSubscription;
  StreamSubscription<List<GuestPaymentModel>>? _overduePaymentsSubscription;

  List<GuestPaymentModel> _payments = [];
  List<GuestPaymentModel> _pendingPayments = [];
  List<GuestPaymentModel> _overduePayments = [];
  Map<String, dynamic> _paymentStats = {};
  String _selectedFilter = 'all'; // all, pending, paid, overdue, failed

  /// Read-only list of guest payments for UI consumption
  List<GuestPaymentModel> get payments => _payments;

  /// Read-only list of pending payments
  List<GuestPaymentModel> get pendingPayments => _pendingPayments;

  /// Read-only list of overdue payments
  List<GuestPaymentModel> get overduePayments => _overduePayments;

  /// Payment statistics for dashboard
  Map<String, dynamic> get paymentStats => _paymentStats;

  /// Current filter selection
  String get selectedFilter => _selectedFilter;

  /// Filtered payments based on current selection
  List<GuestPaymentModel> get filteredPayments {
    switch (_selectedFilter.toLowerCase()) {
      case 'pending':
        return _pendingPayments;
      case 'overdue':
        return _overduePayments;
      case 'paid':
        return _payments.where((p) => p.status == 'Paid').toList();
      default:
        return _payments;
    }
  }

  /// Total pending amount
  double get totalPendingAmount {
    return _pendingPayments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Total overdue amount
  double get totalOverdueAmount {
    return _overduePayments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Set filter for payments
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();

    // Track filter usage analytics
    _analyticsService.logEvent(
      name: _i18n.translate('paymentFilterChangedEvent'),
      parameters: {
        'filter': filter,
      },
    );
  }

  /// Loads payments for the current authenticated guest user
  /// Sets up real-time stream listener for payment updates
  void loadPayments([String? guestId]) {
    // Cancel existing subscriptions
    _paymentsSubscription?.cancel();
    _pendingPaymentsSubscription?.cancel();
    _overduePaymentsSubscription?.cancel();

    // Get guestId from auth service if not provided
    final userId = guestId ?? _authService.currentUserId ?? '';

    if (userId.isEmpty) {
      _payments = [];
      _pendingPayments = [];
      _overduePayments = [];
      notifyListeners();
      return;
    }

    setLoading(true);
    clearError();

    // Listen to real-time payment updates
    _paymentsSubscription = _repository.getPaymentsForGuest(userId).listen(
      (paymentList) {
        _payments = paymentList;
        _loadPaymentStats(userId);
        setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        setError(
            true,
            _i18n.translate('failedToLoadPayments', parameters: {
              'error': error.toString(),
            }));
        setLoading(false);
        notifyListeners();
        _analyticsService.logEvent(
          name: _i18n.translate('paymentLoadErrorEvent'),
          parameters: {'error': error.toString()},
        );
      },
    );

    // Listen to pending payments
    _pendingPaymentsSubscription =
        _repository.getPendingPaymentsForGuest(userId).listen(
      (pendingList) {
        _pendingPayments = pendingList;
        notifyListeners();
      },
      onError: (error) {
        // Don't set error state for pending payments as it's supplementary data
        _analyticsService.logEvent(
          name: _i18n.translate('pendingPaymentsLoadErrorEvent'),
          parameters: {'error': error.toString()},
        );
      },
    );

    // Listen to overdue payments
    _overduePaymentsSubscription =
        _repository.getOverduePaymentsForGuest(userId).listen(
      (overdueList) {
        _overduePayments = overdueList;
        notifyListeners();
      },
      onError: (error) {
        // Don't set error state for overdue payments as it's supplementary data
        _analyticsService.logEvent(
          name: _i18n.translate('overduePaymentsLoadErrorEvent'),
          parameters: {'error': error.toString()},
        );
      },
    );

    // Register all subscriptions for automatic cleanup
    if (_paymentsSubscription != null) addSubscription(_paymentsSubscription!);
    if (_pendingPaymentsSubscription != null) {
      addSubscription(_pendingPaymentsSubscription!);
    }
    if (_overduePaymentsSubscription != null) {
      addSubscription(_overduePaymentsSubscription!);
    }
  }

  /// Load payment statistics
  Future<void> _loadPaymentStats(String guestId) async {
    try {
      _paymentStats = await _repository.getPaymentStatsForGuest(guestId);
      notifyListeners();
    } catch (e) {
      _analyticsService.logEvent(
        name: _i18n.translate('paymentStatsLoadErrorEvent'),
        parameters: {'error': e.toString()},
      );
    }
  }

  /// Adds a new payment to the repository
  /// Handles loading state during submission process
  Future<void> addPayment(GuestPaymentModel payment) async {
    try {
      setLoading(true);
      await _repository.addPayment(payment);

      // Track successful payment creation
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentAddedSuccessfullyEvent'),
        parameters: {
          'payment_type': payment.paymentType,
          'amount': payment.amount,
        },
      );
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToAddPayment', parameters: {
            'error': e.toString(),
          }));

      // Track failed payment creation
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentAddFailedEvent'),
        parameters: {
          'error': e.toString(),
          'payment_type': payment.paymentType,
        },
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Updates an existing payment in the repository
  /// Used for status changes or payment modifications
  Future<void> updatePayment(GuestPaymentModel payment) async {
    try {
      setLoading(true);
      await _repository.updatePayment(payment);

      // Track successful payment update
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentUpdatedSuccessfullyEvent'),
        parameters: {
          'payment_id': payment.paymentId,
          'status': payment.status,
        },
      );
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUpdatePayment', parameters: {
            'error': e.toString(),
          }));

      // Track failed payment update
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentUpdateFailedEvent'),
        parameters: {
          'error': e.toString(),
          'payment_id': payment.paymentId,
        },
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Updates payment status (for payment processing)
  Future<void> updatePaymentStatus(String paymentId, String status,
      {String? transactionId, String? upiReferenceId}) async {
    try {
      setLoading(true);
      await _repository.updatePaymentStatus(
        paymentId,
        status,
        transactionId: transactionId,
        upiReferenceId: upiReferenceId,
      );

      // Track successful status update
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentStatusUpdatedSuccessfullyEvent'),
        parameters: {
          'payment_id': paymentId,
          'new_status': status,
        },
      );
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUpdatePaymentStatus', parameters: {
            'error': e.toString(),
          }));

      // Track failed status update
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentStatusUpdateFailedEvent'),
        parameters: {
          'error': e.toString(),
          'payment_id': paymentId,
        },
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Gets a specific payment by ID
  Future<GuestPaymentModel?> getPaymentById(String paymentId) async {
    try {
      return await _repository.getPaymentById(paymentId);
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToFetchPayment', parameters: {
            'error': e.toString(),
          }));
      return null;
    }
  }

  /// Deletes a payment
  Future<void> deletePayment(String paymentId) async {
    try {
      setLoading(true);
      await _repository.deletePayment(paymentId);

      // Track successful deletion
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentDeletedSuccessfullyEvent'),
        parameters: {
          'payment_id': paymentId,
        },
      );
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToDeletePayment', parameters: {
            'error': e.toString(),
          }));

      // Track failed deletion
      await _analyticsService.logEvent(
        name: _i18n.translate('paymentDeletionFailedEvent'),
        parameters: {
          'error': e.toString(),
          'payment_id': paymentId,
        },
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Process payment (DEPRECATED - Use real payment gateways instead)
  ///
  /// **⚠️ DEPRECATED:** This method used simulation and has been replaced with
  /// real payment gateway integration (Razorpay, UPI, Cash).
  ///
  /// **Migration:** Use the payment method selection dialog in payment screens
  /// which handles real payment gateways:
  /// - Razorpay: For online payments (if enabled by owner)
  /// - UPI: With screenshot upload and owner confirmation
  /// - Cash: With owner confirmation
  ///
  /// This method is kept for backward compatibility but should not be used
  /// in new code. All payment processing now uses real gateways.
  @Deprecated(
      'Use real payment gateways (Razorpay/UPI/Cash) instead of simulation')
  Future<bool> processPayment(String paymentId, String paymentMethod) async {
    // This method is deprecated - real payment gateways should be used
    // For backward compatibility, this now throws an exception
    throw UnimplementedError(
      '${_i18n.translate('paymentSimulationDeprecated')} '
      '${_i18n.translate('paymentSimulationRecommendation')}',
    );
  }

  /// Refresh payment data
  Future<void> refreshPayments([String? guestId]) async {
    await _analyticsService.logEvent(
      name: _i18n.translate('paymentsRefreshedEvent'),
      parameters: {},
    );
    loadPayments(guestId);
  }

  @override
  void dispose() {
    disposeAll(); // Clean up all subscriptions and timers
    super.dispose();
  }

  /// Gets total amount of all payments for summary display
  double get totalPaymentAmount {
    return _payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Gets payments filtered by status for organized display
  List<GuestPaymentModel> getPaymentsByStatus(String status) {
    return _payments.where((payment) => payment.status == status).toList();
  }

  /// Gets recent payments for quick overview
  List<GuestPaymentModel> getRecentPayments({int count = 5}) {
    final sortedPayments = List<GuestPaymentModel>.from(_payments)
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));

    return sortedPayments.take(count).toList();
  }
}
