// lib/core/repositories/booking_repository.dart

import '../../core/di/common/unified_service_locator.dart';
import '../../common/utils/date/converter/date_service_converter.dart';
import '../../core/interfaces/database/database_service_interface.dart';
import '../models/booking_model.dart';

/// 🏠 **BOOKING REPOSITORY - PRODUCTION READY**
///
/// **Responsibilities:**
/// - CRUD operations for bookings
/// - Real-time booking streams
/// - Query bookings by guest/owner/PG
/// - Update booking status
/// Uses interface-based services for dependency injection (swappable backends)
class BookingRepository {
  final IDatabaseService _databaseService;
  static const String _bookingsCollection = 'bookings';

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  BookingRepository({
    IDatabaseService? databaseService,
  }) : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database;

  /// Creates a new booking
  Future<String> createBooking(BookingModel booking) async {
    try {
      await _databaseService.setDocument(
        _bookingsCollection,
        booking.bookingId,
        booking.toMap(),
      );
      return booking.bookingId;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Updates an existing booking
  Future<void> updateBooking(BookingModel booking) async {
    try {
      await _databaseService.updateDocument(
        _bookingsCollection,
        booking.bookingId,
        booking.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  /// Gets a specific booking by ID
  Future<BookingModel?> getBooking(String bookingId) async {
    try {
      final doc = await _databaseService.getDocument(
        _bookingsCollection,
        bookingId,
      );
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>;
      return BookingModel.fromMap(data);
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  /// Streams guest's bookings
  Stream<List<BookingModel>> streamGuestBookings(String guestId) {
    return _databaseService
        .getCollectionStreamWithFilter(_bookingsCollection, 'guestId', guestId)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BookingModel.fromMap(data);
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  /// Streams owner's bookings for a specific PG
  Stream<List<BookingModel>> streamOwnerBookings(String ownerId,
      {String? pgId}) {
    if (pgId != null) {
      // Use compound filter for both ownerId and pgId
      return _databaseService
          .getCollectionStreamWithCompoundFilter(_bookingsCollection, [
        {'field': 'ownerId', 'value': ownerId},
        {'field': 'pgId', 'value': pgId},
      ]).map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return BookingModel.fromMap(data);
        }).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } else {
      // Use single filter for ownerId only
      return _databaseService
          .getCollectionStreamWithFilter(
              _bookingsCollection, 'ownerId', ownerId)
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return BookingModel.fromMap(data);
        }).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    }
  }

  /// Gets guest's active booking
  Future<BookingModel?> getGuestActiveBooking(String guestId) async {
    try {
      final bookings = await _databaseService.queryDocuments(
        _bookingsCollection,
        field: 'guestId',
        isEqualTo: guestId,
      );

      if (bookings.docs.isEmpty) return null;

      // Find active booking
      for (var doc in bookings.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final booking = BookingModel.fromMap(data);
        if (booking.status.toLowerCase() == 'active' ||
            booking.status.toLowerCase() == 'confirmed') {
          return booking;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get active booking: $e');
    }
  }

  /// Cancels a booking
  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await _databaseService.updateDocument(
        _bookingsCollection,
        bookingId,
        {
          'status': 'cancelled',
          'cancellationReason': reason,
          'cancellationDate': DateServiceConverter.toService(DateTime.now()),
          'updatedAt': DateServiceConverter.toService(DateTime.now()),
        },
      );
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Updates booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _databaseService.updateDocument(
        _bookingsCollection,
        bookingId,
        {
          'status': status,
          'updatedAt': DateServiceConverter.toService(DateTime.now()),
        },
      );
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }
}
