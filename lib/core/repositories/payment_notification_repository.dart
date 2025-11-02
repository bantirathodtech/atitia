// lib/core/repositories/payment_notification_repository.dart

import '../di/common/unified_service_locator.dart';
import '../../common/utils/constants/firestore.dart';
import '../interfaces/analytics/analytics_service_interface.dart';
import '../interfaces/database/database_service_interface.dart';
import '../models/payment_notification_model.dart';
import '../../common/utils/date/converter/date_service_converter.dart';

/// Repository for managing payment notifications
/// Handles CRUD operations for payment confirmations between guests and owners
/// Uses interface-based services for dependency injection (swappable backends)
class PaymentNotificationRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  PaymentNotificationRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Create a new payment notification
  Future<void> createPaymentNotification(
      PaymentNotificationModel notification) async {
    try {
      await _databaseService.setDocument(
        FirestoreConstants.paymentNotifications,
        notification.notificationId,
        notification.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'payment_notification_created',
        parameters: {
          'notification_id': notification.notificationId,
          'owner_id': notification.ownerId,
          'guest_id': notification.guestId,
          'amount': notification.amount,
        },
      );
    } catch (e) {
      throw Exception('Failed to create payment notification: $e');
    }
  }

  /// Get payment notifications for an owner (pending confirmations)
  Stream<List<PaymentNotificationModel>> streamOwnerPendingNotifications(
      String ownerId) {
    return _databaseService
        .getCollectionStreamWithFilter(
          FirestoreConstants.paymentNotifications,
          'ownerId',
          ownerId,
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentNotificationModel.fromMap(
                doc.data() as Map<String, dynamic>))
            .where((notif) => notif.isPending)
            .toList());
  }

  /// Get payment notifications for a guest
  Stream<List<PaymentNotificationModel>> streamGuestNotifications(
      String guestId) {
    return _databaseService
        .getCollectionStreamWithFilter(
          FirestoreConstants.paymentNotifications,
          'guestId',
          guestId,
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentNotificationModel.fromMap(
                doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Confirm a payment notification (owner accepts)
  Future<void> confirmPayment(String notificationId, String ownerId) async {
    try {
      final notification = await _databaseService.getDocument(
        FirestoreConstants.paymentNotifications,
        notificationId,
      );

      final notifModel = PaymentNotificationModel.fromMap(
          notification.data() as Map<String, dynamic>);

      if (notifModel.ownerId != ownerId) {
        throw Exception('Unauthorized: Not the owner of this notification');
      }

      await _databaseService.updateDocument(
        FirestoreConstants.paymentNotifications,
        notificationId,
        {
          'status': 'confirmed',
          'confirmedAt': DateServiceConverter.toService(DateTime.now()),
        },
      );

      await _analyticsService.logEvent(
        name: 'payment_confirmed',
        parameters: {
          'notification_id': notificationId,
          'owner_id': ownerId,
          'amount': notifModel.amount,
        },
      );
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }

  /// Reject a payment notification (owner rejects)
  Future<void> rejectPayment(
      String notificationId, String ownerId, String reason) async {
    try {
      final notification = await _databaseService.getDocument(
        FirestoreConstants.paymentNotifications,
        notificationId,
      );

      final notifModel = PaymentNotificationModel.fromMap(
          notification.data() as Map<String, dynamic>);

      if (notifModel.ownerId != ownerId) {
        throw Exception('Unauthorized: Not the owner of this notification');
      }

      await _databaseService.updateDocument(
        FirestoreConstants.paymentNotifications,
        notificationId,
        {
          'status': 'rejected',
          'confirmedAt': DateServiceConverter.toService(DateTime.now()),
          'rejectionReason': reason,
        },
      );

      await _analyticsService.logEvent(
        name: 'payment_rejected',
        parameters: {
          'notification_id': notificationId,
          'owner_id': ownerId,
          'reason': reason,
        },
      );
    } catch (e) {
      throw Exception('Failed to reject payment: $e');
    }
  }

  /// Get payment history for a booking
  Future<List<PaymentNotificationModel>> getBookingPaymentHistory(
      String bookingId) async {
    try {
      final snapshot = await _databaseService
          .getCollectionStreamWithFilter(
            FirestoreConstants.paymentNotifications,
            'bookingId',
            bookingId,
          )
          .first;

      return snapshot.docs
          .map((doc) => PaymentNotificationModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get payment history: $e');
    }
  }
}
