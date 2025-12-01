// lib/feature/owner_dashboard/refunds/viewmodel/owner_refund_viewmodel.dart

import 'package:flutter/foundation.dart';

import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../common/lifecycle/mixin/stream_subscription_mixin.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/repositories/refund/refund_request_repository.dart';
import '../../../../../core/repositories/revenue/revenue_repository.dart';
import '../../../../../core/repositories/subscription/owner_subscription_repository.dart';
import '../../../../../core/repositories/featured/featured_listing_repository.dart';
import '../../../../../core/models/refund/refund_request_model.dart';
import '../../../../../core/models/revenue/revenue_record_model.dart';
import '../../../../../core/models/subscription/owner_subscription_model.dart';
import '../../../../../core/models/featured/featured_listing_model.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/auth/viewmodel_auth_service_interface.dart';
import '../../../../../core/adapters/auth/authentication_service_wrapper_adapter.dart';

/// ViewModel for Owner Refund Management
/// Handles creating refund requests and viewing refund status
class OwnerRefundViewModel extends BaseProviderState
    with StreamSubscriptionMixin {
  final RefundRequestRepository _refundRepo;
  final RevenueRepository _revenueRepo;
  final OwnerSubscriptionRepository _subscriptionRepo;
  final FeaturedListingRepository _featuredRepo;
  final IAnalyticsService _analyticsService;
  final IViewModelAuthService _authService;

  // Refund data
  List<RefundRequestModel> _refundRequests = [];
  List<RevenueRecordModel> _refundableRevenueRecords = [];
  List<OwnerSubscriptionModel> _refundableSubscriptions = [];
  List<FeaturedListingModel> _refundableFeaturedListings = [];

  // Filters
  String _selectedStatusFilter =
      'all'; // all, pending, approved, rejected, completed

  OwnerRefundViewModel({
    RefundRequestRepository? refundRepo,
    RevenueRepository? revenueRepo,
    OwnerSubscriptionRepository? subscriptionRepo,
    FeaturedListingRepository? featuredRepo,
    IAnalyticsService? analyticsService,
    IViewModelAuthService? authService,
  })  : _refundRepo = refundRepo ?? RefundRequestRepository(),
        _revenueRepo = revenueRepo ?? RevenueRepository(),
        _subscriptionRepo = subscriptionRepo ?? OwnerSubscriptionRepository(),
        _featuredRepo = featuredRepo ?? FeaturedListingRepository(),
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics,
        _authService = authService ?? AuthenticationServiceWrapperAdapter();

  // Getters
  List<RefundRequestModel> get refundRequests => _refundRequests;
  List<RefundRequestModel> get filteredRefunds => _getFilteredRefunds();
  List<RevenueRecordModel> get refundableRevenueRecords =>
      _refundableRevenueRecords;
  List<OwnerSubscriptionModel> get refundableSubscriptions =>
      _refundableSubscriptions;
  List<FeaturedListingModel> get refundableFeaturedListings =>
      _refundableFeaturedListings;
  String get selectedStatusFilter => _selectedStatusFilter;

  /// Get current owner ID
  String? get currentOwnerId => _authService.currentUserId;

  /// Initialize ViewModel and load data
  Future<void> initialize() async {
    try {
      setLoading(true);
      clearError();

      final ownerId = currentOwnerId;
      if (ownerId == null) {
        throw Exception('Owner ID not found');
      }

      await _analyticsService.logEvent(
        name: 'owner_refund_dashboard_initialized',
        parameters: {'owner_id': ownerId},
      );

      // Load refund requests and refundable items
      await Future.wait([
        _loadRefundRequests(ownerId),
        _loadRefundableItems(ownerId),
      ]);

      // Start real-time stream
      _startDataStreams(ownerId);

      setLoading(false);
    } catch (e) {
      setError(true, 'Failed to initialize refund dashboard: $e');
      setLoading(false); // Ensure loading is set to false on error
      debugPrint('❌ Error initializing owner refund dashboard: $e');
    }
  }

  /// Start real-time data streams
  void _startDataStreams(String ownerId) {
    addSubscription(
      _refundRepo.streamOwnerRefundRequests(ownerId).listen(
        (refunds) {
          _refundRequests = refunds;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('❌ Error streaming refunds: $error');
          setError(true, 'Failed to stream refund requests: $error');
        },
      ),
    );
  }

  /// Load refund requests for owner
  Future<void> _loadRefundRequests(String ownerId) async {
    try {
      _refundRequests = await _refundRepo.getOwnerRefundRequests(ownerId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading refund requests: $e');
      throw Exception('Failed to load refund requests: $e');
    }
  }

  /// Load refundable items (revenue records that can be refunded)
  Future<void> _loadRefundableItems(String ownerId) async {
    try {
      // Get all revenue records for owner
      final revenueRecords = await _revenueRepo.getOwnerRevenue(ownerId);

      // Filter to only completed payments that haven't been refunded
      _refundableRevenueRecords = revenueRecords
          .where((r) =>
              r.status == PaymentStatus.completed &&
              r.paymentDate
                  .isAfter(DateTime.now().subtract(const Duration(days: 30))))
          .toList();

      // Get active subscriptions that can be refunded
      final subscriptionsStream =
          _subscriptionRepo.streamAllSubscriptions(ownerId);
      final allSubscriptions = await subscriptionsStream.first;
      _refundableSubscriptions = allSubscriptions
          .where((s) =>
              s.status == SubscriptionStatus.active &&
              s.startDate
                  .isAfter(DateTime.now().subtract(const Duration(days: 30))))
          .toList();

      // Get active featured listings that can be refunded
      final featuredListings =
          await _featuredRepo.streamOwnerFeaturedListings(ownerId).first;
      _refundableFeaturedListings = featuredListings
          .where((f) =>
              f.status == FeaturedListingStatus.active &&
              f.startDate
                  .isAfter(DateTime.now().subtract(const Duration(days: 30))))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading refundable items: $e');
      // Don't throw - refundable items are optional
    }
  }

  /// Get filtered refunds based on current filter
  List<RefundRequestModel> _getFilteredRefunds() {
    if (_selectedStatusFilter == 'all') {
      return _refundRequests;
    }

    return _refundRequests.where((r) {
      switch (_selectedStatusFilter) {
        case 'pending':
          return r.status == RefundStatus.pending;
        case 'approved':
          return r.status == RefundStatus.approved;
        case 'rejected':
          return r.status == RefundStatus.rejected;
        case 'completed':
          return r.status == RefundStatus.completed;
        default:
          return true;
      }
    }).toList();
  }

  /// Set status filter
  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  /// Create a refund request
  Future<void> createRefundRequest({
    required RefundType type,
    required String revenueRecordId,
    required double amount,
    required String reason,
    String? subscriptionId,
    String? featuredListingId,
  }) async {
    try {
      setLoading(true);
      clearError();

      final ownerId = currentOwnerId;
      if (ownerId == null) {
        throw Exception('Owner ID not found');
      }

      // Generate refund request ID
      final refundRequestId =
          'refund_${ownerId}_${DateTime.now().millisecondsSinceEpoch}';

      // Create refund request model
      final refundRequest = RefundRequestModel(
        refundRequestId: refundRequestId,
        type: type,
        ownerId: ownerId,
        revenueRecordId: revenueRecordId,
        amount: amount,
        status: RefundStatus.pending,
        reason: reason,
        subscriptionId: subscriptionId,
        featuredListingId: featuredListingId,
        requestedAt: DateTime.now(),
      );

      // Create refund request
      await _refundRepo.createRefundRequest(refundRequest);

      await _analyticsService.logEvent(
        name: 'refund_request_created',
        parameters: {
          'refund_request_id': refundRequestId,
          'type': type.firestoreValue,
          'amount': amount.toString(),
        },
      );

      // Refresh refund requests
      await _loadRefundRequests(ownerId);

      setLoading(false);
      notifyListeners();
    } catch (e) {
      setError(true, 'Failed to create refund request: $e');
      debugPrint('❌ Error creating refund request: $e');
      setLoading(false);
      rethrow;
    }
  }

  /// Check if a revenue record already has a refund request
  Future<bool> hasExistingRefundRequest(String revenueRecordId) async {
    try {
      final existingRequest =
          await _refundRepo.getRefundRequestByRevenueRecordId(revenueRecordId);
      return existingRequest != null &&
          existingRequest.status != RefundStatus.rejected;
    } catch (e) {
      debugPrint('❌ Error checking existing refund request: $e');
      return false;
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await initialize();
  }

  @override
  void dispose() {
    cancelAllSubscriptions();
    super.dispose();
  }
}
