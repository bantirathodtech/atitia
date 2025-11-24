// lib/features/guest_dashboard/payments/repository/guest_payment_repository.dart
import 'package:intl/intl.dart';

import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/repositories/notification_repository.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/services/booking/booking_lifecycle_service.dart';
import '../models/guest_payment_model.dart';

/// Repository layer for guest payments data operations
/// Uses interface-based services for dependency injection (swappable backends)
/// Handles Firestore operations for payment data
class GuestPaymentRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;
  final NotificationRepository _notificationRepository;
  final BookingLifecycleService _bookingLifecycleService;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  GuestPaymentRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
    NotificationRepository? notificationRepository,
    BookingLifecycleService? bookingLifecycleService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics,
        _notificationRepository =
            notificationRepository ?? NotificationRepository(),
        _bookingLifecycleService =
            bookingLifecycleService ?? BookingLifecycleService();

  /// Streams payments for a specific guest with real-time updates
  /// Uses Firestore query to filter payments by guestId, ordered by payment date
  Stream<List<GuestPaymentModel>> getPaymentsForGuest(String guestId) {
    return _databaseService
        .getCollectionStreamWithFilter(
      FirestoreConstants.payments, // Collection name from constants
      'guestId',
      guestId,
    )
        .map((snapshot) {
      final payments = snapshot.docs
          .map((doc) => GuestPaymentModel.fromMap(
                doc.data()! as Map<String, dynamic>,
              ))
          .toList();

      // Sort by payment date (newest first)
      payments.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
      return payments;
    });
  }

  /// Streams pending payments for a specific guest
  Stream<List<GuestPaymentModel>> getPendingPaymentsForGuest(String guestId) {
    return _databaseService.getCollectionStreamWithCompoundFilter(
      FirestoreConstants.payments,
      [
        {'field': 'guestId', 'value': guestId},
        {'field': 'status', 'value': 'Pending'},
      ],
    ).map((snapshot) => snapshot.docs
        .map((doc) => GuestPaymentModel.fromMap(
              doc.data()! as Map<String, dynamic>,
            ))
        .toList());
  }

  /// Streams overdue payments for a specific guest
  Stream<List<GuestPaymentModel>> getOverduePaymentsForGuest(String guestId) {
    // final now = DateTime.now();
    return _databaseService.getCollectionStreamWithCompoundFilter(
      FirestoreConstants.payments,
      [
        {'field': 'guestId', 'value': guestId},
        {'field': 'status', 'value': 'Pending'},
      ],
    ).map((snapshot) => snapshot.docs
        .map((doc) => GuestPaymentModel.fromMap(
              doc.data()! as Map<String, dynamic>,
            ))
        .where((payment) => payment.isOverdue)
        .toList());
  }

  /// Adds a new payment document to Firestore
  /// Uses paymentId as the document ID for direct access
  Future<void> addPayment(GuestPaymentModel payment) async {
    try {
      final paymentData = payment
          .copyWith(
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
          .toMap();

      await _databaseService.setDocument(
        FirestoreConstants.payments,
        payment.paymentId,
        paymentData,
      );

      // Track payment creation analytics
      await _analyticsService.logEvent(
        name: 'payment_created',
        parameters: {
          'payment_type': payment.paymentType,
          'amount': payment.amount,
          'payment_method': payment.paymentMethod,
        },
      );

      // Activate guest and notify owner when payment is received
      if (payment.ownerId.isNotEmpty && payment.status == 'Paid') {
        // Activate guest from payment (if booking exists)
        if (payment.bookingId.isNotEmpty) {
          try {
            // Get booking details to get room/bed info
            final bookingDoc = await _databaseService.getDocument(
              FirestoreConstants.bookings,
              payment.bookingId,
            );

            if (bookingDoc.exists) {
              final bookingData = bookingDoc.data() as Map<String, dynamic>?;
              final roomNumber = bookingData?['roomNumber'] as String? ?? '';
              final bedNumber = bookingData?['bedNumber'] as String? ?? '';
              final rentAmount = bookingData?['rentAmount']?.toDouble();
              final depositAmount = bookingData?['depositAmount']?.toDouble();

              if (roomNumber.isNotEmpty && bedNumber.isNotEmpty) {
                // Activate guest record
                await _bookingLifecycleService.activateGuestFromPayment(
                  guestId: payment.guestId,
                  ownerId: payment.ownerId,
                  pgId: payment.pgId,
                  bookingId: payment.bookingId,
                  roomNumber: roomNumber,
                  bedNumber: bedNumber,
                  rentAmount: rentAmount,
                  depositAmount: depositAmount,
                );
              }
            }
          } catch (e) {
            // Log error but don't fail payment creation
            await _analyticsService.logEvent(
              name: 'guest_activation_from_payment_failed',
              parameters: {
                'payment_id': payment.paymentId,
                'booking_id': payment.bookingId,
                'error': e.toString(),
              },
            );
          }
        }

        // Notify owner about payment received
        final locale = _i18n.currentLocale;
        final symbol = NumberFormat.simpleCurrency(locale: locale.toString())
            .currencySymbol;
        final formattedAmount = NumberFormat.currency(
          locale: locale.toString(),
          symbol: symbol,
          decimalDigits: 0,
        ).format(payment.amount);

        final title = _i18n.translate('paymentNotificationReceivedTitle');
        final body = _i18n.translate(
          'paymentNotificationReceivedBody',
          parameters: {'amount': formattedAmount},
        );

        await _notificationRepository.sendUserNotification(
          userId: payment.ownerId,
          type: 'payment_received',
          title: title,
          body: body,
          data: {
            'paymentId': payment.paymentId,
            'bookingId': payment.bookingId,
            'guestId': payment.guestId,
            'pgId': payment.pgId,
            'amount': payment.amount,
            'paymentType': payment.paymentType,
            'paymentMethod': payment.paymentMethod,
          },
        );
      }
    } catch (e) {
      // Track error analytics
      await _analyticsService.logEvent(
        name: 'payment_creation_failed',
        parameters: {
          'error': e.toString(),
          'payment_type': payment.paymentType,
        },
      );
      rethrow;
    }
  }

  /// Updates an existing payment document in Firestore
  /// Overwrites entire document with updated payment data
  Future<void> updatePayment(GuestPaymentModel payment) async {
    try {
      final paymentData = payment
          .copyWith(
            updatedAt: DateTime.now(),
          )
          .toMap();

      await _databaseService.updateDocument(
        FirestoreConstants.payments,
        payment.paymentId,
        paymentData,
      );

      // Activate guest when payment status changes to 'Paid'
      if (payment.status == 'Paid' && payment.bookingId.isNotEmpty) {
        try {
          // Get old payment status before update to check if status changed
          final oldPaymentDoc = await _databaseService.getDocument(
            FirestoreConstants.payments,
            payment.paymentId,
          );

          String? oldStatus;
          if (oldPaymentDoc.exists) {
            final oldData = oldPaymentDoc.data() as Map<String, dynamic>?;
            oldStatus = oldData?['status'] as String?;
          }

          // Only activate if status changed to 'Paid'
          if (oldStatus != 'Paid') {
            // Get booking details
            final bookingDoc = await _databaseService.getDocument(
              FirestoreConstants.bookings,
              payment.bookingId,
            );

            if (bookingDoc.exists) {
              final bookingData = bookingDoc.data() as Map<String, dynamic>?;
              final roomNumber = bookingData?['roomNumber'] as String? ?? '';
              final bedNumber = bookingData?['bedNumber'] as String? ?? '';
              final rentAmount = bookingData?['rentAmount']?.toDouble();
              final depositAmount = bookingData?['depositAmount']?.toDouble();

              if (roomNumber.isNotEmpty && bedNumber.isNotEmpty) {
                // Activate guest record
                await _bookingLifecycleService.activateGuestFromPayment(
                  guestId: payment.guestId,
                  ownerId: payment.ownerId,
                  pgId: payment.pgId,
                  bookingId: payment.bookingId,
                  roomNumber: roomNumber,
                  bedNumber: bedNumber,
                  rentAmount: rentAmount,
                  depositAmount: depositAmount,
                );
              }
            }
          }
        } catch (e) {
          // Log error but don't fail payment update
          await _analyticsService.logEvent(
            name: 'guest_activation_from_payment_update_failed',
            parameters: {
              'payment_id': payment.paymentId,
              'booking_id': payment.bookingId,
              'error': e.toString(),
            },
          );
        }
      }

      // Track payment update analytics
      await _analyticsService.logEvent(
        name: 'payment_updated',
        parameters: {
          'payment_id': payment.paymentId,
          'status': payment.status,
          'payment_type': payment.paymentType,
        },
      );
    } catch (e) {
      // Track error analytics
      await _analyticsService.logEvent(
        name: 'payment_update_failed',
        parameters: {
          'error': e.toString(),
          'payment_id': payment.paymentId,
        },
      );
      rethrow;
    }
  }

  /// Gets a specific payment by ID
  Future<GuestPaymentModel?> getPaymentById(String paymentId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.payments,
        paymentId,
      );

      if (doc.exists) {
        return GuestPaymentModel.fromMap(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // Track error analytics
      await _analyticsService.logEvent(
        name: 'payment_fetch_failed',
        parameters: {
          'error': e.toString(),
          'payment_id': paymentId,
        },
      );
      rethrow;
    }
  }

  /// Updates payment status (for payment processing)
  Future<void> updatePaymentStatus(String paymentId, String status,
      {String? transactionId, String? upiReferenceId}) async {
    try {
      final payment = await getPaymentById(paymentId);
      if (payment != null) {
        final updatedPayment = payment.copyWith(
          status: status,
          transactionId: transactionId ?? payment.transactionId,
          upiReferenceId: upiReferenceId ?? payment.upiReferenceId,
          updatedAt: DateTime.now(),
        );

        await updatePayment(updatedPayment);

        // Track payment status change analytics
        await _analyticsService.logEvent(
          name: 'payment_status_changed',
          parameters: {
            'payment_id': paymentId,
            'old_status': payment.status,
            'new_status': status,
            'payment_type': payment.paymentType,
          },
        );
      }
    } catch (e) {
      // Track error analytics
      await _analyticsService.logEvent(
        name: 'payment_status_update_failed',
        parameters: {
          'error': e.toString(),
          'payment_id': paymentId,
        },
      );
      rethrow;
    }
  }

  /// Deletes a payment document from Firestore
  Future<void> deletePayment(String paymentId) async {
    try {
      await _databaseService.deleteDocument(
        FirestoreConstants.payments,
        paymentId,
      );

      // Track payment deletion analytics
      await _analyticsService.logEvent(
        name: 'payment_deleted',
        parameters: {
          'payment_id': paymentId,
        },
      );
    } catch (e) {
      // Track error analytics
      await _analyticsService.logEvent(
        name: 'payment_deletion_failed',
        parameters: {
          'error': e.toString(),
          'payment_id': paymentId,
        },
      );
      rethrow;
    }
  }

  /// Gets payment statistics for a guest
  Future<Map<String, dynamic>> getPaymentStatsForGuest(String guestId) async {
    try {
      final payments = await _databaseService
          .getCollectionStreamWithFilter(
            FirestoreConstants.payments,
            'guestId',
            guestId,
          )
          .first;

      double totalPaid = 0;
      double totalPending = 0;
      double totalOverdue = 0;
      int paidCount = 0;
      int pendingCount = 0;
      int overdueCount = 0;

      for (final doc in payments.docs) {
        final payment =
            GuestPaymentModel.fromMap(doc.data()! as Map<String, dynamic>);

        if (payment.status == 'Paid') {
          totalPaid += payment.amount;
          paidCount++;
        } else if (payment.status == 'Pending') {
          totalPending += payment.amount;
          pendingCount++;

          if (payment.isOverdue) {
            totalOverdue += payment.amount;
            overdueCount++;
          }
        }
      }

      return {
        'totalPaid': totalPaid,
        'totalPending': totalPending,
        'totalOverdue': totalOverdue,
        'paidCount': paidCount,
        'pendingCount': pendingCount,
        'overdueCount': overdueCount,
        'totalPayments': payments.docs.length,
      };
    } catch (e) {
      // Track error analytics
      await _analyticsService.logEvent(
        name: 'payment_stats_fetch_failed',
        parameters: {
          'error': e.toString(),
          'guest_id': guestId,
        },
      );
      rethrow;
    }
  }
}
