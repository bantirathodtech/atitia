// lib/features/owner_dashboard/myguest/data/repository/owner_guest_repository.dart

import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../models/owner_guest_model.dart';
import '../../../guests/data/models/owner_complaint_model.dart';

/// Repository for managing owner guest-related Firestore operations
/// Uses interface-based services for dependency injection (swappable backends)
/// Handles guest, booking, and payment data streaming with PG filtering and analytics tracking
class OwnerGuestRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerGuestRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Streams all users with role 'Guest' from Firestore
  /// Returns real-time updates of guest list
  Stream<List<OwnerGuestModel>> streamGuests() {
    return _databaseService
        .getCollectionStreamWithFilter(
            FirestoreConstants.users, 'role', 'guest')
        .map((snapshot) {
      final guests = snapshot.docs
          .map((doc) => OwnerGuestModel.fromFirestore(doc))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_guests_streamed',
        parameters: {'guests_count': guests.length},
      );

      return guests;
    });
  }

  /// Streams complaints across multiple PGs (maps guest complaints to owner view)
  Stream<List<OwnerComplaintModel>> streamComplaintsForMultiplePGs(
      List<String> pgIds) {
    if (pgIds.isEmpty) return Stream.value([]);

    return _databaseService
        .getCollectionStream(FirestoreConstants.complaints)
        .map((snapshot) {
      final complaints = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Map guest complaint schema to owner complaint view
            final String statusRaw = (data['status'] ?? 'Pending').toString();
            String mappedStatus;
            switch (statusRaw.toLowerCase()) {
              case 'resolved':
                mappedStatus = 'resolved';
                break;
              case 'closed':
                mappedStatus = 'closed';
                break;
              case 'in_progress':
                mappedStatus = 'in_progress';
                break;
              default:
                mappedStatus = 'new';
            }

            final mapped = OwnerComplaintModel(
              complaintId: data['complaintId'] ?? doc.id,
              guestId: data['guestId'] ?? '',
              guestName: data['guestName'] ?? '',
              pgId: data['pgId'] ?? '',
              ownerId: data['ownerId'] ?? '',
              roomNumber: data['roomNumber'] ?? '',
              complaintType: (data['complaintType'] ?? 'general').toString(),
              title: (data['subject'] ?? data['title'] ?? '').toString(),
              description: (data['description'] ?? '').toString(),
              status: mappedStatus,
              priority: (data['priority'] ?? 'medium').toString(),
              createdAt: (data['complaintDate'] is int)
                  ? DateTime.fromMillisecondsSinceEpoch(
                      data['complaintDate'] as int)
                  : DateTime.now(),
              updatedAt: DateTime.now(),
              messages: (data['messages'] as List<dynamic>?)?.map((m) {
                    final map = Map<String, dynamic>.from(m as Map);
                    return ComplaintMessage.fromMap(map);
                  }).toList() ??
                  const <ComplaintMessage>[],
              assignedTo: data['assignedTo'],
              resolvedAt: (data['resolvedAt'] is int)
                  ? DateTime.fromMillisecondsSinceEpoch(
                      data['resolvedAt'] as int)
                  : null,
              resolutionNotes: data['resolutionNotes'],
              isActive: (data['isActive'] as bool?) ?? true,
            );
            return mapped;
          })
          .where((c) => pgIds.contains(c.pgId))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_multi_pg_complaints_streamed',
        parameters: {
          'pg_count': pgIds.length,
          'complaints_count': complaints.length,
        },
      );

      return complaints;
    });
  }

  /// Adds a reply to a complaint (stored in the complaint document messages array)
  Future<void> addComplaintReply(
      String complaintId, ComplaintMessage reply) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.complaints,
        complaintId,
      );

      final data = (doc.data() as Map<String, dynamic>?);
      final existing = (data?['messages'] as List<dynamic>? ?? []);
      final updated = [...existing, reply.toMap()];

      await _databaseService.updateDocument(
        FirestoreConstants.complaints,
        complaintId,
        {
          'messages': updated,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        },
      );

      await _analyticsService.logEvent(
        name: 'owner_complaint_reply_added',
        parameters: {'complaint_id': complaintId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_complaint_reply_error',
        parameters: {'complaint_id': complaintId, 'error': e.toString()},
      );
      throw Exception('Failed to add complaint reply: $e');
    }
  }

  /// Updates complaint status (and optional resolution notes)
  Future<void> updateComplaintStatus(String complaintId, String status,
      {String? resolutionNotes}) async {
    try {
      await _databaseService.updateDocument(
        FirestoreConstants.complaints,
        complaintId,
        {
          'status': status,
          if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        },
      );

      await _analyticsService.logEvent(
        name: 'owner_complaint_status_updated',
        parameters: {'complaint_id': complaintId, 'status': status},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_complaint_status_error',
        parameters: {'complaint_id': complaintId, 'error': e.toString()},
      );
      throw Exception('Failed to update complaint status: $e');
    }
  }

  /// Gets specific guest by ID
  Future<OwnerGuestModel?> getGuestById(String guestUid) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.users,
        guestUid,
      );

      if (!doc.exists) return null;

      final guest = OwnerGuestModel.fromFirestore(doc);

      await _analyticsService.logEvent(
        name: 'owner_guest_viewed',
        parameters: {
          'guest_uid': guestUid,
          'guest_name': guest.fullName,
        },
      );

      return guest;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_guest_fetch_error',
        parameters: {
          'guest_uid': guestUid,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch guest: $e');
    }
  }

  /// Updates guest information
  Future<void> updateGuest(OwnerGuestModel guest) async {
    try {
      await _databaseService.updateDocument(
        FirestoreConstants.users,
        guest.uid,
        guest.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_guest_updated',
        parameters: {
          'guest_uid': guest.uid,
          'status': guest.status,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_guest_update_error',
        parameters: {
          'guest_uid': guest.uid,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update guest: $e');
    }
  }

  /// Deletes a guest
  Future<void> deleteGuest(String guestUid) async {
    try {
      await _databaseService.deleteDocument(
        FirestoreConstants.users,
        guestUid,
      );

      await _analyticsService.logEvent(
        name: 'owner_guest_deleted',
        parameters: {'guest_uid': guestUid},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_guest_delete_error',
        parameters: {
          'guest_uid': guestUid,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to delete guest: $e');
    }
  }

  /// Streams all bookings filtered by specific PG ID
  /// Provides real-time booking updates for owner's PG properties
  Stream<List<OwnerBookingModel>> streamBookings(String pgId) {
    return _databaseService
        .getCollectionStreamWithFilter(
            FirestoreConstants.bookings, 'pgId', pgId)
        .map((snapshot) {
      final bookings = snapshot.docs
          .map((doc) => OwnerBookingModel.fromFirestore(doc))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_bookings_streamed',
        parameters: {
          'pg_id': pgId,
          'bookings_count': bookings.length,
        },
      );

      return bookings;
    });
  }

  /// Gets specific booking by ID
  Future<OwnerBookingModel?> getBookingById(String bookingId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.bookings,
        bookingId,
      );

      if (!doc.exists) return null;

      return OwnerBookingModel.fromFirestore(doc);
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_fetch_error',
        parameters: {
          'booking_id': bookingId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch booking: $e');
    }
  }

  /// Creates a new booking
  Future<void> createBooking(OwnerBookingModel booking) async {
    try {
      await _databaseService.setDocument(
        FirestoreConstants.bookings,
        booking.id,
        booking.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_created',
        parameters: {
          'booking_id': booking.id,
          'guest_uid': booking.guestUid,
          'pg_id': booking.pgId,
          'room_number': booking.roomNumber,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_create_error',
        parameters: {
          'booking_id': booking.id,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Updates an existing booking
  Future<void> updateBooking(OwnerBookingModel booking) async {
    try {
      final updatedBooking = booking.copyWith(updatedAt: DateTime.now());
      await _databaseService.setDocument(
        FirestoreConstants.bookings,
        booking.id,
        updatedBooking.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_updated',
        parameters: {
          'booking_id': booking.id,
          'status': booking.status,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_update_error',
        parameters: {
          'booking_id': booking.id,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update booking: $e');
    }
  }

  /// Deletes a booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _databaseService.deleteDocument(
        FirestoreConstants.bookings,
        bookingId,
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_deleted',
        parameters: {'booking_id': bookingId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_delete_error',
        parameters: {
          'booking_id': bookingId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to delete booking: $e');
    }
  }

  /// Streams all payments filtered by specific PG ID
  /// Monitors payment status and collections in real-time
  Stream<List<OwnerPaymentModel>> streamPayments(String pgId) {
    return _databaseService
        .getCollectionStreamWithFilter(
            FirestoreConstants.payments, 'pgId', pgId)
        .map((snapshot) {
      final payments = snapshot.docs
          .map((doc) => OwnerPaymentModel.fromFirestore(doc))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_payments_streamed',
        parameters: {
          'pg_id': pgId,
          'payments_count': payments.length,
        },
      );

      return payments;
    });
  }

  /// Creates a new payment record
  Future<void> createPayment(OwnerPaymentModel payment) async {
    try {
      await _databaseService.setDocument(
        FirestoreConstants.payments,
        payment.id,
        payment.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_payment_created',
        parameters: {
          'payment_id': payment.id,
          'booking_id': payment.bookingId,
          'amount': payment.amountPaid,
          'payment_method': payment.paymentMethod,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_payment_create_error',
        parameters: {
          'payment_id': payment.id,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to create payment: $e');
    }
  }

  /// Updates an existing payment
  Future<void> updatePayment(OwnerPaymentModel payment) async {
    try {
      final updatedPayment = payment.copyWith(updatedAt: DateTime.now());
      await _databaseService.setDocument(
        FirestoreConstants.payments,
        payment.id,
        updatedPayment.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_payment_updated',
        parameters: {
          'payment_id': payment.id,
          'status': payment.status,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_payment_update_error',
        parameters: {
          'payment_id': payment.id,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update payment: $e');
    }
  }

  /// Streams bookings for multiple PG IDs (owner manages multiple properties)
  /// Aggregates bookings across all owner's PG properties
  Stream<List<OwnerBookingModel>> streamBookingsForMultiplePGs(
      List<String> pgIds) {
    if (pgIds.isEmpty) {
      return Stream.value([]);
    }

    return _databaseService
        .getCollectionStream(FirestoreConstants.bookings)
        .map((snapshot) {
      final bookings = snapshot.docs
          .map((doc) => OwnerBookingModel.fromFirestore(doc))
          .where((booking) => pgIds.contains(booking.pgId))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_multi_pg_bookings_streamed',
        parameters: {
          'pg_count': pgIds.length,
          'bookings_count': bookings.length,
        },
      );

      return bookings;
    });
  }

  /// Streams payments for multiple PG IDs
  /// Aggregates payments across all owner's PG properties
  Stream<List<OwnerPaymentModel>> streamPaymentsForMultiplePGs(
      List<String> pgIds) {
    if (pgIds.isEmpty) {
      return Stream.value([]);
    }

    return _databaseService
        .getCollectionStream(FirestoreConstants.payments)
        .map((snapshot) {
      final payments = snapshot.docs
          .map((doc) => OwnerPaymentModel.fromFirestore(doc))
          .where((payment) => pgIds.contains(payment.pgId))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_multi_pg_payments_streamed',
        parameters: {
          'pg_count': pgIds.length,
          'payments_count': payments.length,
        },
      );

      return payments;
    });
  }

  /// Gets guest statistics for dashboard
  Future<Map<String, dynamic>> getGuestStats(String ownerId) async {
    try {
      final guestsSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.users, 'role', 'guest')
          .first;

      final guests = guestsSnapshot.docs
          .map((doc) => OwnerGuestModel.fromFirestore(doc))
          .toList();

      final activeGuests =
          guests.where((g) => g.status.toLowerCase() == 'active').length;
      final pendingGuests =
          guests.where((g) => g.status.toLowerCase() == 'pending').length;

      final stats = {
        'totalGuests': guests.length,
        'activeGuests': activeGuests,
        'pendingGuests': pendingGuests,
        'inactiveGuests': guests.length - activeGuests - pendingGuests,
      };

      await _analyticsService.logEvent(
        name: 'owner_guest_stats_generated',
        parameters: stats,
      );

      return stats;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_guest_stats_error',
        parameters: {'error': e.toString()},
      );
      throw Exception('Failed to fetch guest stats: $e');
    }
  }
}
