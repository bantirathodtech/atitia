// lib/core/services/payment/payment_reminder_service.dart

import '../../../common/utils/logging/logging_mixin.dart';
import '../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../../common/utils/constants/firestore.dart';
import '../../../feature/guest_dashboard/payments/data/models/guest_payment_model.dart';
import '../../repositories/notification_repository.dart';

/// 🎨 **PAYMENT REMINDER SERVICE - PRODUCTION READY**
///
/// Automatically sends payment reminders to guests for pending/overdue payments
/// Checks for payments due within 3 days or overdue payments
class PaymentReminderService with LoggingMixin {
  final IDatabaseService _databaseService =
      getIt.firestore as IDatabaseService;
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  /// Check and send reminders for all guests with pending/overdue payments
  Future<void> checkAndSendReminders() async {
    try {
      logInfo('Checking for payments that need reminders', feature: 'payment_reminders');

      // Get all pending payments
      // COST OPTIMIZATION: Limit to 200 pending payments for reminder check
      final pendingPaymentsSnapshot = await _databaseService.queryCollection(
        FirestoreConstants.payments,
        [
          {'field': 'status', 'value': 'Pending'},
        ],
        limit: 200,
      );

      final now = DateTime.now();

      for (final doc in pendingPaymentsSnapshot.docs) {
        final paymentData = doc.data() as Map<String, dynamic>;
        final payment = GuestPaymentModel.fromMap(paymentData);

        // Check if payment is due soon or overdue
        final dueDate = payment.dueDate;
        final daysUntilDue = dueDate.difference(now).inDays;

        // Send reminder if due within 3 days or overdue
        if (daysUntilDue <= 3 && daysUntilDue >= -7) {
          await _sendPaymentReminder(payment);
        } else if (payment.isOverdue) {
          // Send reminder for overdue payments
          await _sendPaymentReminder(payment);
        }
      }

      logInfo('Payment reminder check completed', feature: 'payment_reminders');
    } catch (e) {
      logError(
        'Failed to check and send payment reminders',
        feature: 'payment_reminders',
        error: e,
      );
    }
  }

  /// Send payment reminder notification to guest
  Future<void> _sendPaymentReminder(GuestPaymentModel payment) async {
    try {
      // Check if reminder was already sent today
      final lastReminderDateStr = payment.metadata?['lastReminderDate'] as String?;
      if (lastReminderDateStr != null) {
        try {
          final lastReminderDate = DateTime.parse(lastReminderDateStr);
          final daysSinceLastReminder =
              DateTime.now().difference(lastReminderDate).inDays;
          if (daysSinceLastReminder < 1) {
            // Already sent reminder today, skip
            return;
          }
        } catch (e) {
          // Invalid date format, continue with sending reminder
        }
      }

      // Prepare reminder message
      String reminderMessage;
      final dueDate = payment.dueDate;
      if (payment.isOverdue) {
        final daysOverdue = DateTime.now().difference(dueDate).inDays;
        reminderMessage =
            'Your payment of ₹${payment.amount} is overdue by $daysOverdue day(s). Please make the payment as soon as possible.';
      } else {
        final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
        reminderMessage =
            'Your payment of ₹${payment.amount} is due in $daysUntilDue day(s). Please make the payment on time.';
      }

      // Send notification
      await _notificationRepository.sendUserNotification(
        userId: payment.guestId,
        title: 'Payment Reminder',
        body: reminderMessage,
        type: 'payment_reminder',
        data: {
          'paymentId': payment.paymentId,
          'amount': payment.amount,
          'dueDate': dueDate.toIso8601String(),
          'isOverdue': payment.isOverdue.toString(),
        },
      );

      // Update last reminder date in payment document
      final currentReminderCount = payment.metadata?['reminderCount'] ?? 0;
      await _databaseService.updateDocument(
        FirestoreConstants.payments,
        payment.paymentId,
        {
          'metadata': {
            ...?payment.metadata,
            'lastReminderDate': DateTime.now().toIso8601String(),
            'reminderCount': currentReminderCount + 1,
          },
        },
      );

      logInfo(
        'Payment reminder sent to guest',
        feature: 'payment_reminders',
        metadata: {
          'guestId': payment.guestId,
          'paymentId': payment.paymentId,
          'amount': payment.amount,
        },
      );
    } catch (e) {
      logError(
        'Failed to send payment reminder',
        feature: 'payment_reminders',
        error: e,
        metadata: {'paymentId': payment.paymentId},
      );
    }
  }

  /// Send reminder for a specific payment
  Future<void> sendReminderForPayment(String paymentId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.payments,
        paymentId,
      );

      if (!doc.exists) {
        logError(
          'Payment not found for reminder',
          feature: 'payment_reminders',
          metadata: {'paymentId': paymentId},
        );
        return;
      }

      final paymentData = doc.data() as Map<String, dynamic>;
      final payment = GuestPaymentModel.fromMap(paymentData);

      if (payment.status == 'Pending' || payment.isOverdue) {
        await _sendPaymentReminder(payment);
      }
    } catch (e) {
      logError(
        'Failed to send reminder for specific payment',
        feature: 'payment_reminders',
        error: e,
        metadata: {'paymentId': paymentId},
      );
    }
  }
}

