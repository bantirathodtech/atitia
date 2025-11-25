// lib/feature/admin_dashboard/refunds/viewmodel/admin_refund_viewmodel.dart

import 'package:flutter/foundation.dart';

import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../common/lifecycle/mixin/stream_subscription_mixin.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/repositories/refund/refund_request_repository.dart';
import '../../../../../core/services/payment/refund_service.dart';
import '../../../../../core/models/refund/refund_request_model.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';

/// ViewModel for Admin Refund Management
/// Handles refund request approval, rejection, and processing
class AdminRefundViewModel extends BaseProviderState
    with StreamSubscriptionMixin {
  final RefundRequestRepository _refundRepo;
  final RefundService _refundService;
  final IAnalyticsService _analyticsService;

  // Refund data
  List<RefundRequestModel> _allRefundRequests = [];
  List<RefundRequestModel> _pendingRefunds = [];
  List<RefundRequestModel> _approvedRefunds = [];
  List<RefundRequestModel> _rejectedRefunds = [];
  List<RefundRequestModel> _completedRefunds = [];

  // Filters
  String _selectedStatusFilter =
      'all'; // all, pending, approved, rejected, completed
  String _selectedTypeFilter = 'all'; // all, subscription, featuredListing

  AdminRefundViewModel({
    RefundRequestRepository? refundRepo,
    RefundService? refundService,
    IAnalyticsService? analyticsService,
  })  : _refundRepo = refundRepo ?? RefundRequestRepository(),
        _refundService = refundService ?? RefundService(),
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  // Getters
  List<RefundRequestModel> get allRefundRequests => _allRefundRequests;
  List<RefundRequestModel> get pendingRefunds => _pendingRefunds;
  List<RefundRequestModel> get approvedRefunds => _approvedRefunds;
  List<RefundRequestModel> get rejectedRefunds => _rejectedRefunds;
  List<RefundRequestModel> get completedRefunds => _completedRefunds;
  List<RefundRequestModel> get filteredRefunds => _getFilteredRefunds();
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedTypeFilter => _selectedTypeFilter;

  int get totalPendingCount => _pendingRefunds.length;
  int get totalApprovedCount => _approvedRefunds.length;
  int get totalRejectedCount => _rejectedRefunds.length;
  int get totalCompletedCount => _completedRefunds.length;

  /// Initialize ViewModel and load refund requests
  Future<void> initialize() async {
    try {
      setLoading(true);
      clearError();

      await _analyticsService.logEvent(
        name: 'admin_refund_dashboard_initialized',
        parameters: {},
      );

      // Start real-time stream
      _startDataStreams();

      setLoading(false);
    } catch (e) {
      setError(true, 'Failed to initialize admin refund dashboard: $e');
      debugPrint('❌ Error initializing admin refund dashboard: $e');
    }
  }

  /// Start real-time data streams
  void _startDataStreams() {
    addSubscription(
      _refundRepo.streamAllRefundRequests().listen(
        (refunds) {
          _updateRefundsFromStream(refunds);
        },
        onError: (error) {
          debugPrint('❌ Error streaming refunds: $error');
          setError(true, 'Failed to stream refund requests: $error');
        },
      ),
    );
  }

  /// Update refunds from stream
  void _updateRefundsFromStream(List<RefundRequestModel> refunds) {
    _allRefundRequests = refunds;

    // Categorize by status
    _pendingRefunds =
        refunds.where((r) => r.status == RefundStatus.pending).toList();
    _approvedRefunds =
        refunds.where((r) => r.status == RefundStatus.approved).toList();
    _rejectedRefunds =
        refunds.where((r) => r.status == RefundStatus.rejected).toList();
    _completedRefunds =
        refunds.where((r) => r.status == RefundStatus.completed).toList();

    notifyListeners();
  }

  /// Get filtered refunds based on current filters
  List<RefundRequestModel> _getFilteredRefunds() {
    List<RefundRequestModel> filtered = List.from(_allRefundRequests);

    // Filter by status
    if (_selectedStatusFilter != 'all') {
      filtered = filtered.where((r) {
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

    // Filter by type
    if (_selectedTypeFilter != 'all') {
      filtered = filtered.where((r) {
        switch (_selectedTypeFilter) {
          case 'subscription':
            return r.type == RefundType.subscription;
          case 'featuredListing':
            return r.type == RefundType.featuredListing;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  /// Set status filter
  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  /// Set type filter
  void setTypeFilter(String type) {
    _selectedTypeFilter = type;
    notifyListeners();
  }

  /// Approve a refund request
  Future<void> approveRefundRequest({
    required String refundRequestId,
    required String adminUserId,
    String? adminNotes,
  }) async {
    try {
      setLoading(true);
      clearError();

      await _refundService.approveRefundRequest(
        refundRequestId: refundRequestId,
        adminUserId: adminUserId,
        adminNotes: adminNotes,
      );

      await _analyticsService.logEvent(
        name: 'refund_request_approved',
        parameters: {
          'refund_request_id': refundRequestId,
          'admin_user_id': adminUserId,
        },
      );

      setLoading(false);
      notifyListeners();
    } catch (e) {
      setError(true, 'Failed to approve refund request: $e');
      debugPrint('❌ Error approving refund: $e');
      setLoading(false);
      rethrow;
    }
  }

  /// Reject a refund request
  Future<void> rejectRefundRequest({
    required String refundRequestId,
    required String adminUserId,
    required String rejectionReason,
  }) async {
    try {
      setLoading(true);
      clearError();

      await _refundService.rejectRefundRequest(
        refundRequestId: refundRequestId,
        adminUserId: adminUserId,
        rejectionReason: rejectionReason,
      );

      await _analyticsService.logEvent(
        name: 'refund_request_rejected',
        parameters: {
          'refund_request_id': refundRequestId,
          'admin_user_id': adminUserId,
        },
      );

      setLoading(false);
      notifyListeners();
    } catch (e) {
      setError(true, 'Failed to reject refund request: $e');
      debugPrint('❌ Error rejecting refund: $e');
      setLoading(false);
      rethrow;
    }
  }

  /// Process an approved refund (actually execute the refund)
  Future<void> processRefund({
    required String refundRequestId,
    required String adminUserId,
    String? adminNotes,
  }) async {
    try {
      setLoading(true);
      clearError();

      await _refundService.processRefund(
        refundRequestId: refundRequestId,
        adminUserId: adminUserId,
        adminNotes: adminNotes,
      );

      await _analyticsService.logEvent(
        name: 'refund_processed',
        parameters: {
          'refund_request_id': refundRequestId,
          'admin_user_id': adminUserId,
        },
      );

      setLoading(false);
      notifyListeners();
    } catch (e) {
      setError(true, 'Failed to process refund: $e');
      debugPrint('❌ Error processing refund: $e');
      setLoading(false);
      rethrow;
    }
  }

  /// Refresh refund requests
  Future<void> refresh() async {
    await initialize();
  }

  @override
  void dispose() {
    cancelAllSubscriptions();
    super.dispose();
  }
}
