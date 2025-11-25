// lib/core/repositories/refund/refund_request_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../di/common/unified_service_locator.dart';
import '../../../common/utils/constants/firestore.dart';
import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../models/refund/refund_request_model.dart';

/// Repository for managing refund requests
/// Handles refund request CRUD operations, queries, and real-time streams
/// Uses interface-based services for dependency injection (swappable backends)
class RefundRequestRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  RefundRequestRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Create a new refund request
  Future<String> createRefundRequest(RefundRequestModel refundRequest) async {
    try {
      await _databaseService.setDocument(
        FirestoreConstants.refundRequests,
        refundRequest.refundRequestId,
        refundRequest.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'refund_request_created',
        parameters: {
          'refund_request_id': refundRequest.refundRequestId,
          'type': refundRequest.type.firestoreValue,
          'owner_id': refundRequest.ownerId,
          'amount': refundRequest.amount.toString(),
          'status': refundRequest.status.firestoreValue,
        },
      );

      return refundRequest.refundRequestId;
    } catch (e) {
      throw Exception('Failed to create refund request: $e');
    }
  }

  /// Update an existing refund request
  Future<void> updateRefundRequest(RefundRequestModel refundRequest) async {
    try {
      await _databaseService.updateDocument(
        FirestoreConstants.refundRequests,
        refundRequest.refundRequestId,
        refundRequest.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'refund_request_updated',
        parameters: {
          'refund_request_id': refundRequest.refundRequestId,
          'status': refundRequest.status.firestoreValue,
        },
      );
    } catch (e) {
      throw Exception('Failed to update refund request: $e');
    }
  }

  /// Get refund request by ID
  Future<RefundRequestModel?> getRefundRequest(String refundRequestId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.refundRequests,
        refundRequestId,
      );

      if (!doc.exists) {
        return null;
      }

      return RefundRequestModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get refund request: $e');
    }
  }

  /// Get refund requests for an owner
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Future<List<RefundRequestModel>> getOwnerRefundRequests(
      String ownerId) async {
    try {
      final requests = await _databaseService.queryCollection(
        FirestoreConstants.refundRequests,
        [
          {'field': 'ownerId', 'value': ownerId}
        ],
        orderBy: 'requestedAt',
        descending: true,
        limit: 20, // COST OPTIMIZATION: Limit to 20 items per page
      );

      return requests.docs
          .map((doc) =>
              RefundRequestModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get owner refund requests: $e');
    }
  }

  /// Stream refund requests for an owner (real-time updates)
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Stream<List<RefundRequestModel>> streamOwnerRefundRequests(String ownerId) {
    // COST OPTIMIZATION: Use direct Firestore query with limit
    // For full pagination, use PaginationController with FirestorePaginationHelper
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.refundRequests)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('requestedAt', descending: true)
        .limit(20) // COST OPTIMIZATION: Limit to 20 items per page
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RefundRequestModel.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get pending refund requests (admin-level)
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Future<List<RefundRequestModel>> getPendingRefundRequests() async {
    try {
      final requests = await _databaseService.queryCollection(
        FirestoreConstants.refundRequests,
        [
          {'field': 'status', 'value': RefundStatus.pending.firestoreValue}
        ],
        orderBy: 'requestedAt',
        descending: true,
        limit: 20, // COST OPTIMIZATION: Limit to 20 items per page
      );

      return requests.docs
          .map((doc) =>
              RefundRequestModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pending refund requests: $e');
    }
  }

  /// Stream all refund requests (admin-level)
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Stream<List<RefundRequestModel>> streamAllRefundRequests() {
    // COST OPTIMIZATION: Use direct Firestore query with limit
    // For full pagination, use PaginationController with FirestorePaginationHelper
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.refundRequests)
        .orderBy('requestedAt', descending: true)
        .limit(20) // COST OPTIMIZATION: Limit to 20 items per page
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RefundRequestModel.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get refund requests by status (admin-level)
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Future<List<RefundRequestModel>> getRefundRequestsByStatus(
      RefundStatus status) async {
    try {
      final requests = await _databaseService.queryCollection(
        FirestoreConstants.refundRequests,
        [
          {'field': 'status', 'value': status.firestoreValue}
        ],
        orderBy: 'requestedAt',
        descending: true,
        limit: 20, // COST OPTIMIZATION: Limit to 20 items per page
      );

      return requests.docs
          .map((doc) =>
              RefundRequestModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get refund requests by status: $e');
    }
  }

  /// Get refund request by revenue record ID
  Future<RefundRequestModel?> getRefundRequestByRevenueRecordId(
      String revenueRecordId) async {
    try {
      final requests = await _databaseService.queryDocuments(
        FirestoreConstants.refundRequests,
        field: 'revenueRecordId',
        isEqualTo: revenueRecordId,
      );

      if (requests.docs.isEmpty) {
        return null;
      }

      // Return most recent refund request for this revenue record
      final refundRequests = requests.docs
          .map((doc) =>
              RefundRequestModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      return refundRequests.first;
    } catch (e) {
      throw Exception('Failed to get refund request by revenue record ID: $e');
    }
  }
}
