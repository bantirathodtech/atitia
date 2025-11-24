// lib/core/services/booking/booking_lifecycle_service.dart

import '../../../common/utils/constants/firestore.dart';
import '../../../common/utils/date/converter/date_service_converter.dart';
import '../../di/common/unified_service_locator.dart';
import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../interfaces/database/database_service_interface.dart';

/// 🔄 **BOOKING LIFECYCLE SERVICE - REUSABLE CORE SERVICE**
///
/// Handles the complete booking lifecycle:
/// - Booking request approval → Booking creation
/// - Payment received → Guest record creation/activation
/// - Status transitions (Pending → Payment Pending → Active)
///
/// This service ensures data consistency across collections and
/// maintains the booking-to-guest flow automatically.
class BookingLifecycleService {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  BookingLifecycleService({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Creates a booking record from an approved booking request
  /// This should be called when owner approves a booking request
  Future<String> createBookingFromRequest({
    required String requestId,
    required String guestId,
    required String ownerId,
    required String pgId,
    required String pgName,
    required String roomNumber,
    required String bedNumber,
    required DateTime startDate,
    DateTime? endDate,
    double? rentAmount,
    double? depositAmount,
  }) async {
    try {
      final now = DateTime.now();
      final bookingId = 'booking_${requestId}_${now.millisecondsSinceEpoch}';
      final finalEndDate = endDate ?? startDate.add(const Duration(days: 30));

      // Get PG pricing info if rent not provided
      double? finalRentAmount = rentAmount;
      double? finalDepositAmount = depositAmount;

      if (rentAmount == null || depositAmount == null) {
        try {
          final pgDoc =
              await _databaseService.getDocument(FirestoreConstants.pgs, pgId);
          if (pgDoc.exists) {
            final pgData = pgDoc.data() as Map<String, dynamic>?;
            final rentConfig = pgData?['rentConfig'] as Map<String, dynamic>?;
            final deposit = pgData?['depositAmount'];

            // Try to get rent from floor structure
            if (rentAmount == null && rentConfig != null) {
              // Use default rent from config if available
              finalRentAmount = (rentConfig['oneShare'] ?? rentConfig['twoShare'] ?? 0)
                  .toDouble();
            }

            if (depositAmount == null && deposit != null) {
              finalDepositAmount = deposit is num ? deposit.toDouble() : null;
            }
          }
        } catch (e) {
          // If PG fetch fails, use defaults
          _analyticsService.logEvent(
            name: 'booking_lifecycle_pg_fetch_warning',
            parameters: {
              'pg_id': pgId,
              'error': e.toString(),
            },
          );
        }
      }

      final bookingData = {
        'id': bookingId,
        'requestId': requestId, // Link back to original request
        'guestUid': guestId,
        'pgId': pgId,
        'roomNumber': roomNumber,
        'bedNumber': bedNumber,
        'startDate': DateServiceConverter.toService(startDate),
        'endDate': DateServiceConverter.toService(finalEndDate),
        'paymentStatus': 'pending', // Payment pending until guest pays
        'status': 'approved', // Approved by owner
        'rentAmount': finalRentAmount,
        'depositAmount': finalDepositAmount,
        'paidAmount': 0.0,
        'createdAt': DateServiceConverter.toService(now),
        'updatedAt': DateServiceConverter.toService(now),
        'createdBy': ownerId,
        'metadata': {
          'source': 'booking_request_approval',
          'request_id': requestId,
        },
      };

      await _databaseService.setDocument(
        FirestoreConstants.bookings,
        bookingId,
        bookingData,
      );

      await _analyticsService.logEvent(
        name: 'booking_created_from_request',
        parameters: {
          'booking_id': bookingId,
          'request_id': requestId,
          'guest_id': guestId,
          'pg_id': pgId,
          'room_number': roomNumber,
          'bed_number': bedNumber,
        },
      );

      return bookingId;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'booking_creation_error',
        parameters: {
          'request_id': requestId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to create booking from request: $e');
    }
  }

  /// Creates or updates guest record when payment is received
  /// This ensures approved guests appear in guest list after payment
  Future<void> activateGuestFromPayment({
    required String guestId,
    required String ownerId,
    required String pgId,
    required String bookingId,
    required String roomNumber,
    required String bedNumber,
    double? rentAmount,
    double? depositAmount,
  }) async {
    try {
      final now = DateTime.now();

      // Get guest user document
      final guestDoc =
          await _databaseService.getDocument(FirestoreConstants.users, guestId);

      if (!guestDoc.exists) {
        throw Exception('Guest user not found');
      }

      final guestData = guestDoc.data() as Map<String, dynamic>? ?? {};

      // Prepare guest record update/creation
      final guestUpdate = {
        'roomNumber': roomNumber,
        'bedNumber': bedNumber,
        'pgId': pgId,
        'status': 'active', // Mark as active after payment
        'rent': rentAmount,
        'deposit': depositAmount,
        'joiningDate': DateServiceConverter.toService(now),
        'updatedAt': DateServiceConverter.toService(now),
        'metadata': {
          ...Map<String, dynamic>.from(guestData['metadata'] ?? {}),
          'booking_id': bookingId,
          'activated_from_payment': true,
          'activated_at': DateServiceConverter.toService(now),
        },
      };

      // Update guest user document
      await _databaseService.updateDocument(
        FirestoreConstants.users,
        guestId,
        guestUpdate,
      );

      // Also create/update booking status to active
      final bookingUpdate = {
        'paymentStatus': 'collected',
        'status': 'active',
        'paidAmount': (rentAmount ?? 0) + (depositAmount ?? 0),
        'updatedAt': DateServiceConverter.toService(now),
      };

      await _databaseService.updateDocument(
        FirestoreConstants.bookings,
        bookingId,
        bookingUpdate,
      );

      await _analyticsService.logEvent(
        name: 'guest_activated_from_payment',
        parameters: {
          'guest_id': guestId,
          'booking_id': bookingId,
          'pg_id': pgId,
          'room_number': roomNumber,
          'bed_number': bedNumber,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'guest_activation_error',
        parameters: {
          'guest_id': guestId,
          'booking_id': bookingId,
          'error': e.toString(),
        },
      );
      // Don't throw - payment should still succeed even if guest activation fails
      // Owner can manually activate if needed
    }
  }

  /// Updates bed status in PG floor structure when guest is assigned
  /// This ensures bed map shows correct occupancy
  Future<void> updateBedAssignment({
    required String pgId,
    required String roomNumber,
    required String bedNumber,
    required String guestId,
    required bool isOccupied,
  }) async {
    try {
      // Get PG document
      final pgDoc =
          await _databaseService.getDocument(FirestoreConstants.pgs, pgId);

      if (!pgDoc.exists) {
        return; // PG not found, skip bed update
      }

      final pgData = pgDoc.data() as Map<String, dynamic>?;
      final floorStructure = pgData?['floorStructure'] as List<dynamic>?;

      if (floorStructure == null || floorStructure.isEmpty) {
        return; // No floor structure, skip
      }

      // Find and update the bed in floor structure
      bool updated = false;
      final updatedFloors = <Map<String, dynamic>>[];

      for (var floorData in floorStructure) {
        final rooms = floorData['rooms'] as List<dynamic>? ?? [];
        final updatedRooms = <Map<String, dynamic>>[];

        for (var roomData in rooms) {
          if (roomData['roomNumber'] == roomNumber) {
            final beds = roomData['beds'] as List<dynamic>? ?? [];
            final updatedBeds = <Map<String, dynamic>>[];

            for (var bedData in beds) {
              if (bedData['bedNumber'] == bedNumber ||
                  bedData['bedNumber'].toString() == bedNumber) {
                // Update this bed
                updatedBeds.add({
                  ...Map<String, dynamic>.from(bedData),
                  'status': isOccupied ? 'occupied' : 'vacant',
                  'guestId': isOccupied ? guestId : null,
                  'updatedAt': DateTime.now().millisecondsSinceEpoch,
                });
                updated = true;
              } else {
                updatedBeds.add(bedData);
              }
            }

            updatedRooms.add({
              ...Map<String, dynamic>.from(roomData),
              'beds': updatedBeds,
            });
          } else {
            updatedRooms.add(roomData);
          }
        }

        updatedFloors.add({
          ...Map<String, dynamic>.from(floorData),
          'rooms': updatedRooms,
        });
      }

      if (updated) {
        // Update PG document with new floor structure
        await _databaseService.updateDocument(
          FirestoreConstants.pgs,
          pgId,
          {
            'floorStructure': updatedFloors,
            'updatedAt': DateServiceConverter.toService(DateTime.now()),
          },
        );

        await _analyticsService.logEvent(
          name: 'bed_assignment_updated',
          parameters: {
            'pg_id': pgId,
            'room_number': roomNumber,
            'bed_number': bedNumber,
            'guest_id': guestId,
            'is_occupied': isOccupied,
          },
        );
      }
    } catch (e) {
      // Log but don't throw - bed assignment update is non-critical
      await _analyticsService.logEvent(
        name: 'bed_assignment_update_error',
        parameters: {
          'pg_id': pgId,
          'room_number': roomNumber,
          'bed_number': bedNumber,
          'error': e.toString(),
        },
      );
    }
  }
}

