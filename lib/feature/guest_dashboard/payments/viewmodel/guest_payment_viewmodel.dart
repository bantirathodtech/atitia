// lib/features/guest_dashboard/payments/viewmodel/guest_payment_viewmodel.dart

import 'dart:async';

import '../../../../common/lifecycle/mixin/stream_subscription_mixin.dart';
import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../data/models/guest_payment_model.dart';
import '../data/repository/guest_payment_repository.dart';

/// ViewModel for managing guest payments UI state and business logic
/// Extends BaseProviderState for automatic service access and state management
/// Coordinates between UI layer and Repository layer
class GuestPaymentViewModel extends BaseProviderState
    with StreamSubscriptionMixin {
  final GuestPaymentRepository _repository;
  final _authService = getIt.auth;
  final _analyticsService = getIt.analytics;

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  GuestPaymentViewModel({
    GuestPaymentRepository? repository,
  }) : _repository = repository ?? GuestPaymentRepository();

  StreamSubscription<List<GuestPaymentModel>>? _paymentsSubscription;
  StreamSubscription<List<GuestPaymentModel>>? _pendingPaymentsSubscription;
  StreamSubscription<List<GuestPaymentModel>>? _overduePaymentsSubscription;

  List<GuestPaymentModel> _payments = [];
  List<GuestPaymentModel> _pendingPayments = [];
  List<GuestPaymentModel> _overduePayments = [];
  Map<String, dynamic> _paymentStats = {};
  String _selectedFilter = 'All'; // All, Pending, Paid, Overdue

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
      name: 'payment_filter_changed',
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
        setError(true, 'Failed to load payments: ${error.toString()}');
        setLoading(false);
        notifyListeners();
        _analyticsService.logEvent(
          name: 'payment_load_error',
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
          name: 'pending_payments_load_error',
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
          name: 'overdue_payments_load_error',
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
        name: 'payment_stats_load_error',
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
        name: 'payment_added_successfully',
        parameters: {
          'payment_type': payment.paymentType,
          'amount': payment.amount,
        },
      );
    } catch (e) {
      setError(true, 'Failed to add payment: $e');

      // Track failed payment creation
      await _analyticsService.logEvent(
        name: 'payment_add_failed',
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
        name: 'payment_updated_successfully',
        parameters: {
          'payment_id': payment.paymentId,
          'status': payment.status,
        },
      );
    } catch (e) {
      setError(true, 'Failed to update payment: $e');

      // Track failed payment update
      await _analyticsService.logEvent(
        name: 'payment_update_failed',
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
        name: 'payment_status_updated_successfully',
        parameters: {
          'payment_id': paymentId,
          'new_status': status,
        },
      );
    } catch (e) {
      setError(true, 'Failed to update payment status: $e');

      // Track failed status update
      await _analyticsService.logEvent(
        name: 'payment_status_update_failed',
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
      setError(true, 'Failed to fetch payment: $e');
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
        name: 'payment_deleted_successfully',
        parameters: {
          'payment_id': paymentId,
        },
      );
    } catch (e) {
      setError(true, 'Failed to delete payment: $e');

      // Track failed deletion
      await _analyticsService.logEvent(
        name: 'payment_deletion_failed',
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

  /// Process payment (simulate payment gateway integration)
  Future<bool> processPayment(String paymentId, String paymentMethod) async {
    try {
      setLoading(true);

      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate payment success (90% success rate)
      final isSuccess = DateTime.now().millisecond % 10 < 9;

      if (isSuccess) {
        // Generate mock transaction ID
        final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
        final upiReferenceId = paymentMethod == 'UPI'
            ? 'UPI${DateTime.now().millisecondsSinceEpoch}'
            : null;

        await updatePaymentStatus(
          paymentId,
          'Paid',
          transactionId: transactionId,
          upiReferenceId: upiReferenceId,
        );

        // Track successful payment
        await _analyticsService.logEvent(
          name: 'payment_processed_successfully',
          parameters: {
            'payment_id': paymentId,
            'payment_method': paymentMethod,
            'transaction_id': transactionId,
          },
        );

        return true;
      } else {
        await updatePaymentStatus(paymentId, 'Failed');

        // Track failed payment
        await _analyticsService.logEvent(
          name: 'payment_processing_failed',
          parameters: {
            'payment_id': paymentId,
            'payment_method': paymentMethod,
          },
        );

        return false;
      }
    } catch (e) {
      setError(true, 'Payment processing failed: $e');

      // Track payment processing error
      await _analyticsService.logEvent(
        name: 'payment_processing_error',
        parameters: {
          'error': e.toString(),
          'payment_id': paymentId,
          'payment_method': paymentMethod,
        },
      );

      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Refresh payment data
  Future<void> refreshPayments([String? guestId]) async {
    await _analyticsService.logEvent(
      name: 'payments_refreshed',
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
