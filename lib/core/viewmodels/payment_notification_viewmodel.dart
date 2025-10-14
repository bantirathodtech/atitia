// lib/core/viewmodels/payment_notification_viewmodel.dart

import 'package:flutter/foundation.dart';

import '../di/firebase/di/firebase_service_locator.dart';
import '../models/payment_notification_model.dart';
import '../repositories/payment_notification_repository.dart';

/// ViewModel for managing payment notifications
/// Used by both guests (to send) and owners (to confirm/reject)
class PaymentNotificationViewModel extends ChangeNotifier {
  final PaymentNotificationRepository _repository = PaymentNotificationRepository();
  final _analyticsService = getIt.analytics;
  final _storageService = getIt.storage;

  List<PaymentNotificationModel> _notifications = [];
  bool _loading = false;
  bool _sending = false;
  String? _error;

  // Getters
  List<PaymentNotificationModel> get notifications => _notifications;
  List<PaymentNotificationModel> get pendingNotifications =>
      _notifications.where((n) => n.isPending).toList();
  bool get loading => _loading;
  bool get sending => _sending;
  String? get error => _error;
  bool get hasNotifications => _notifications.isNotEmpty;
  bool get hasPendingNotifications => pendingNotifications.isNotEmpty;

  /// Stream owner's pending payment notifications
  void streamOwnerNotifications(String ownerId) {
    _loading = true;
    notifyListeners();

    _repository.streamOwnerPendingNotifications(ownerId).listen(
      (notifications) {
        _notifications = notifications;
        _loading = false;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _loading = false;
        notifyListeners();
        debugPrint('❌ Error streaming owner notifications: $error');
      },
    );
  }

  /// Stream guest's payment notifications
  void streamGuestNotifications(String guestId) {
    _loading = true;
    notifyListeners();

    _repository.streamGuestNotifications(guestId).listen(
      (notifications) {
        _notifications = notifications;
        _loading = false;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _loading = false;
        notifyListeners();
        debugPrint('❌ Error streaming guest notifications: $error');
      },
    );
  }

  /// Send payment notification (guest action)
  Future<bool> sendPaymentNotification({
    required String guestId,
    required String ownerId,
    required String pgId,
    required String bookingId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
    dynamic paymentScreenshot,
    String? paymentNote,
  }) async {
    _sending = true;
    _error = null;
    notifyListeners();

    try {
      // Upload payment screenshot if provided
      String? screenshotUrl;
      if (paymentScreenshot != null) {
        final filename = 'payment_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final folderPath = 'payment_screenshots/$guestId';
        screenshotUrl = await _storageService.uploadFile(paymentScreenshot, folderPath, filename);
      }

      // Create notification
      final notification = PaymentNotificationModel(
        notificationId: '${guestId}_${DateTime.now().millisecondsSinceEpoch}',
        guestId: guestId,
        ownerId: ownerId,
        pgId: pgId,
        bookingId: bookingId,
        amount: amount,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        paymentScreenshotUrl: screenshotUrl,
        paymentNote: paymentNote,
        status: 'pending',
      );

      await _repository.createPaymentNotification(notification);

      await _analyticsService.logEvent(
        name: 'guest_payment_notification_sent',
        parameters: {
          'guest_id': guestId,
          'owner_id': ownerId,
          'amount': amount,
          'method': paymentMethod,
        },
      );

      _sending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _sending = false;
      notifyListeners();
      debugPrint('❌ Error sending payment notification: $e');
      return false;
    }
  }

  /// Confirm payment (owner action)
  Future<bool> confirmPayment(String notificationId, String ownerId) async {
    _error = null;
    notifyListeners();

    try {
      await _repository.confirmPayment(notificationId, ownerId);

      // Update local state
      final index = _notifications.indexWhere((n) => n.notificationId == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          status: 'confirmed',
          confirmedAt: DateTime.now(),
        );
        notifyListeners();
      }

      await _analyticsService.logEvent(
        name: 'owner_payment_confirmed',
        parameters: {
          'notification_id': notificationId,
          'owner_id': ownerId,
        },
      );

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      debugPrint('❌ Error confirming payment: $e');
      return false;
    }
  }

  /// Reject payment (owner action)
  Future<bool> rejectPayment(String notificationId, String ownerId, String reason) async {
    _error = null;
    notifyListeners();

    try {
      await _repository.rejectPayment(notificationId, ownerId, reason);

      // Update local state
      final index = _notifications.indexWhere((n) => n.notificationId == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          status: 'rejected',
          confirmedAt: DateTime.now(),
          rejectionReason: reason,
        );
        notifyListeners();
      }

      await _analyticsService.logEvent(
        name: 'owner_payment_rejected',
        parameters: {
          'notification_id': notificationId,
          'owner_id': ownerId,
          'reason': reason,
        },
      );

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      debugPrint('❌ Error rejecting payment: $e');
      return false;
    }
  }

  /// Get payment history for a booking
  Future<void> loadBookingPaymentHistory(String bookingId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _repository.getBookingPaymentHistory(bookingId);
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      debugPrint('❌ Error loading payment history: $e');
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _notifications = [];
    _loading = false;
    _sending = false;
    _error = null;
    notifyListeners();
  }
}

