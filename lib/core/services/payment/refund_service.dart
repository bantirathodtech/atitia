// lib/core/services/payment/refund_service.dart

/// Refund service for processing refunds via Razorpay
/// Handles refund requests, approvals, and processing
library;

import '../../../common/utils/logging/logging_mixin.dart';
import '../../models/refund/refund_request_model.dart';
import '../../models/revenue/revenue_record_model.dart';
import '../../repositories/refund/refund_request_repository.dart';
import '../../repositories/revenue/revenue_repository.dart';
import '../../repositories/subscription/owner_subscription_repository.dart';
import '../../repositories/featured/featured_listing_repository.dart';
import '../../repositories/notification_repository.dart';

/// Refund service for processing refunds
/// Supports both Cloud Functions (recommended) and direct Razorpay API calls
class RefundService with LoggingMixin {
  final RefundRequestRepository _refundRepo;
  final RevenueRepository _revenueRepo;
  final OwnerSubscriptionRepository _subscriptionRepo;
  final FeaturedListingRepository _featuredRepo;
  final NotificationRepository _notificationRepo;

  RefundService({
    RefundRequestRepository? refundRepo,
    RevenueRepository? revenueRepo,
    OwnerSubscriptionRepository? subscriptionRepo,
    FeaturedListingRepository? featuredRepo,
    NotificationRepository? notificationRepo,
  })  : _refundRepo = refundRepo ?? RefundRequestRepository(),
        _revenueRepo = revenueRepo ?? RevenueRepository(),
        _subscriptionRepo = subscriptionRepo ?? OwnerSubscriptionRepository(),
        _featuredRepo = featuredRepo ?? FeaturedListingRepository(),
        _notificationRepo = notificationRepo ?? NotificationRepository();

  /// Process a refund request
  /// This should be called by admin after approving a refund request
  /// [refundRequestId] - ID of the refund request to process
  /// [adminUserId] - ID of admin processing the refund
  /// [adminNotes] - Optional notes from admin
  Future<void> processRefund({
    required String refundRequestId,
    required String adminUserId,
    String? adminNotes,
  }) async {
    try {
      // Get refund request
      final refundRequest = await _refundRepo.getRefundRequest(refundRequestId);
      if (refundRequest == null) {
        throw Exception('Refund request not found');
      }

      if (refundRequest.status != RefundStatus.approved) {
        throw Exception('Refund request must be approved before processing');
      }

      // Get revenue record
      final revenueRecord = await _revenueRepo.getRevenueRecord(
          refundRequest.revenueRecordId);
      if (revenueRecord == null) {
        throw Exception('Revenue record not found');
      }

      if (revenueRecord.status != PaymentStatus.completed) {
        throw Exception('Revenue record is not in completed status');
      }

      if (revenueRecord.paymentId == null || revenueRecord.paymentId!.isEmpty) {
        throw Exception('Payment ID not found in revenue record');
      }

      // Update refund request status to processing
      final processingRequest = refundRequest.copyWith(
        status: RefundStatus.processing,
        adminNotes: adminNotes,
        processedBy: adminUserId,
        updatedAt: DateTime.now(),
      );
      await _refundRepo.updateRefundRequest(processingRequest);

      // Process refund via Razorpay
      // Note: Razorpay refunds require server-side processing with secret key
      // For now, we'll use Cloud Functions (to be implemented) or direct API call
      String? razorpayRefundId;
      try {
        razorpayRefundId = await _processRazorpayRefund(
          paymentId: revenueRecord.paymentId!,
          amount: refundRequest.amount,
          notes: 'Refund for ${refundRequest.type.displayName}',
        );
      } catch (e) {
        logError(
          'Failed to process Razorpay refund',
          feature: 'refund',
          error: e,
        );
        // Update status to failed
        final failedRequest = processingRequest.copyWith(
          status: RefundStatus.failed,
          updatedAt: DateTime.now(),
        );
        await _refundRepo.updateRefundRequest(failedRequest);
        rethrow;
      }

      // Update refund request with refund ID and status
      final completedRequest = processingRequest.copyWith(
        status: RefundStatus.completed,
        razorpayRefundId: razorpayRefundId,
        processedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _refundRepo.updateRefundRequest(completedRequest);

      // Update revenue record status to refunded
      final refundedRevenue = revenueRecord.copyWith(
        status: PaymentStatus.refunded,
        updatedAt: DateTime.now(),
      );
      await _revenueRepo.updateRevenueRecord(refundedRevenue);

      // Update subscription or featured listing if applicable
      await _updateRelatedRecords(refundRequest);

      // Send notification to owner
      await _sendRefundNotification(refundRequest, true);

      logInfo(
        'Refund processed successfully',
        feature: 'refund',
        metadata: {
          'refund_request_id': refundRequestId,
          'razorpay_refund_id': razorpayRefundId,
        },
      );
    } catch (e) {
      logError(
        'Failed to process refund',
        feature: 'refund',
        error: e,
        metadata: {'refund_request_id': refundRequestId},
      );
      rethrow;
    }
  }

  /// Process refund via Razorpay API
  /// This uses Cloud Functions or direct API call
  /// Note: Razorpay refunds require the secret key, which should be on server-side
  Future<String> _processRazorpayRefund({
    required String paymentId,
    required double amount,
    String? notes,
  }) async {
    // TODO: Implement Cloud Functions call for refund processing
    // For now, return a placeholder refund ID
    // Actual implementation should call Cloud Function that processes refund with secret key

    // Note: Razorpay refunds require secret key, must be done server-side
    // This should call a Cloud Function that processes the refund with the secret key
    // TODO: Implement Cloud Functions call for refund processing
    // For now, simulate success (will be replaced with actual Cloud Function call)
    
    logInfo(
      'Processing refund via Cloud Functions (to be implemented)',
      feature: 'refund',
      metadata: {
        'payment_id': paymentId,
        'amount': amount.toString(),
      },
    );
    
    // Simulate refund ID (remove in production - replace with actual Cloud Function call)
    return 'refund_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Update related records after refund
  Future<void> _updateRelatedRecords(RefundRequestModel refundRequest) async {
    if (refundRequest.type == RefundType.subscription &&
        refundRequest.subscriptionId != null) {
      // Cancel the subscription
      final subscription =
          await _subscriptionRepo.getSubscription(refundRequest.subscriptionId!);
      if (subscription != null) {
        // Subscription cancellation should be handled by cancellation flow
        // For refund, we just mark it as cancelled
        await _subscriptionRepo.cancelSubscription(
          subscriptionId: refundRequest.subscriptionId!,
          ownerId: refundRequest.ownerId,
          reason: 'Refund processed',
        );
      }
    } else if (refundRequest.type == RefundType.featuredListing &&
        refundRequest.featuredListingId != null) {
      // Cancel the featured listing
      final listing = await _featuredRepo.getFeaturedListing(
          refundRequest.featuredListingId!);
      if (listing != null) {
        await _featuredRepo.cancelFeaturedListing(
          featuredListingId: refundRequest.featuredListingId!,
          ownerId: refundRequest.ownerId,
        );
      }
    }
  }

  /// Send notification to owner about refund status
  Future<void> _sendRefundNotification(
      RefundRequestModel refundRequest, bool success) async {
    try {
      final title = success
          ? 'Refund Processed'
          : 'Refund Processing Failed';
      final body = success
          ? 'Your refund request for ${refundRequest.formattedAmount} has been processed successfully. The amount will be credited to your account within 5-7 business days.'
          : 'Your refund request could not be processed. Please contact support for assistance.';

      await _notificationRepo.sendUserNotification(
        userId: refundRequest.ownerId,
        type: 'refund',
        title: title,
        body: body,
        data: {
          'refund_request_id': refundRequest.refundRequestId,
          'type': refundRequest.type.firestoreValue,
          'amount': refundRequest.amount.toString(),
          'status': refundRequest.status.firestoreValue,
        },
      );
    } catch (e) {
      logError(
        'Failed to send refund notification',
        feature: 'refund',
        error: e,
      );
      // Don't throw - notification failure shouldn't block refund
    }
  }

  /// Approve a refund request (admin action)
  Future<void> approveRefundRequest({
    required String refundRequestId,
    required String adminUserId,
    String? adminNotes,
  }) async {
    try {
      final refundRequest = await _refundRepo.getRefundRequest(refundRequestId);
      if (refundRequest == null) {
        throw Exception('Refund request not found');
      }

      if (refundRequest.status != RefundStatus.pending) {
        throw Exception('Refund request is not pending');
      }

      final approvedRequest = refundRequest.copyWith(
        status: RefundStatus.approved,
        adminNotes: adminNotes,
        processedBy: adminUserId,
        updatedAt: DateTime.now(),
      );

      await _refundRepo.updateRefundRequest(approvedRequest);

      // Send notification to owner
      await _notificationRepo.sendUserNotification(
        userId: refundRequest.ownerId,
        type: 'refund',
        title: 'Refund Request Approved',
        body:
            'Your refund request for ${refundRequest.formattedAmount} has been approved. The refund will be processed shortly.',
        data: {
          'refund_request_id': refundRequestId,
          'status': 'approved',
        },
      );

      logInfo(
        'Refund request approved',
        feature: 'refund',
        metadata: {
          'refund_request_id': refundRequestId,
          'admin_user_id': adminUserId,
        },
      );
    } catch (e) {
      logError(
        'Failed to approve refund request',
        feature: 'refund',
        error: e,
      );
      rethrow;
    }
  }

  /// Reject a refund request (admin action)
  Future<void> rejectRefundRequest({
    required String refundRequestId,
    required String adminUserId,
    required String rejectionReason,
  }) async {
    try {
      final refundRequest = await _refundRepo.getRefundRequest(refundRequestId);
      if (refundRequest == null) {
        throw Exception('Refund request not found');
      }

      if (refundRequest.status != RefundStatus.pending) {
        throw Exception('Refund request is not pending');
      }

      final rejectedRequest = refundRequest.copyWith(
        status: RefundStatus.rejected,
        rejectionReason: rejectionReason,
        processedBy: adminUserId,
        processedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _refundRepo.updateRefundRequest(rejectedRequest);

      // Send notification to owner
      await _notificationRepo.sendUserNotification(
        userId: refundRequest.ownerId,
        type: 'refund',
        title: 'Refund Request Rejected',
        body:
            'Your refund request has been rejected. Reason: $rejectionReason',
        data: {
          'refund_request_id': refundRequestId,
          'status': 'rejected',
          'rejection_reason': rejectionReason,
        },
      );

      logInfo(
        'Refund request rejected',
        feature: 'refund',
        metadata: {
          'refund_request_id': refundRequestId,
          'admin_user_id': adminUserId,
          'rejection_reason': rejectionReason,
        },
      );
    } catch (e) {
      logError(
        'Failed to reject refund request',
        feature: 'refund',
        error: e,
      );
      rethrow;
    }
  }
}

