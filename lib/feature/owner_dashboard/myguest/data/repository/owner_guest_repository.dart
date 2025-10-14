// lib/features/owner_dashboard/myguest/data/repository/owner_guest_repository.dart

import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../models/owner_guest_model.dart';

/// Repository for managing owner guest-related Firestore operations
/// Uses Firebase service locator for dependency injection
/// Handles guest, booking, and payment data streaming with PG filtering and analytics tracking
class OwnerGuestRepository {
  // Get Firebase services through service locator
  final _firestoreService = getIt.firestore;
  final _analyticsService = getIt.analytics;

  /// Streams all users with role 'Guest' from Firestore
  /// Returns real-time updates of guest list
  Stream<List<OwnerGuestModel>> streamGuests() {
    return _firestoreService
        .getCollectionStreamWithFilter(FirestoreConstants.users, 'role', 'guest')
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

  /// Gets specific guest by ID
  Future<OwnerGuestModel?> getGuestById(String guestUid) async {
    try {
      final doc = await _firestoreService.getDocument(
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
      await _firestoreService.updateDocument(
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
      await _firestoreService.deleteDocument(
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
    return _firestoreService
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
      final doc = await _firestoreService.getDocument(
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
      await _firestoreService.setDocument(
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
      await _firestoreService.setDocument(
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
      await _firestoreService.deleteDocument(
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
    return _firestoreService
        .getCollectionStreamWithFilter(FirestoreConstants.payments, 'pgId', pgId)
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
      await _firestoreService.setDocument(
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
      await _firestoreService.setDocument(
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

    return _firestoreService
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

    return _firestoreService
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
      final guestsSnapshot = await _firestoreService
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

