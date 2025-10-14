// lib/features/owner_dashboard/mypg/data/repositories/owner_pg_management_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../models/owner_pg_management_model.dart';

/// Repository for PG management Firestore operations
/// Uses Firebase service locator for dependency injection
/// Handles beds, rooms, floors, bookings with analytics tracking
class OwnerPgManagementRepository {
  final _firestoreService = getIt.firestore;
  final _analyticsService = getIt.analytics;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream beds real-time by PG ID with validation and analytics
  Stream<List<OwnerBed>> streamBeds(String pgId) {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for streamBeds');
    }

    return _firestoreService
        .getCollectionStream('pgs/$pgId/beds')
        .map((snapshot) {
      final beds =
          snapshot.docs.map((doc) => OwnerBed.fromFirestore(doc)).toList();

      _analyticsService.logEvent(
        name: 'owner_beds_streamed',
        parameters: {
          'pg_id': pgId,
          'beds_count': beds.length,
        },
      );

      return beds;
    });
  }

  /// Create a new PG document with a generated ID
  /// Returns the created pgId
  Future<String> createPG(Map<String, dynamic> pgData) async {
    try {
      // Generate a new document ID
      final String pgId =
          _firestore.collection(FirestoreConstants.pgs).doc().id;

      final now = DateTime.now();
      final dataWithMeta = {
        ...pgData,
        'pgId': pgId,
        'createdAt': pgData['createdAt'] ?? now,
        'updatedAt': now,
      };

      await _firestoreService.setDocument(
        FirestoreConstants.pgs,
        pgId,
        dataWithMeta,
      );

      await _analyticsService.logEvent(
        name: 'owner_pg_created',
        parameters: {
          'pg_id': pgId,
          'owner_uid': pgData['ownerUid'] ?? 'unknown',
          'pg_name': pgData['pgName'] ?? 'Unknown',
          'city': pgData['city'] ?? '',
        },
      );

      return pgId;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_pg_create_error',
        parameters: {'error': e.toString()},
      );
      throw Exception('Failed to create PG: $e');
    }
  }

  /// Stream rooms real-time by PG ID with validation and analytics
  Stream<List<OwnerRoom>> streamRooms(String pgId) {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for streamRooms');
    }

    return _firestoreService
        .getCollectionStream('pgs/$pgId/rooms')
        .map((snapshot) {
      final rooms =
          snapshot.docs.map((doc) => OwnerRoom.fromFirestore(doc)).toList();

      _analyticsService.logEvent(
        name: 'owner_rooms_streamed',
        parameters: {
          'pg_id': pgId,
          'rooms_count': rooms.length,
        },
      );

      return rooms;
    });
  }

  /// Stream floors real-time by PG ID with validation and analytics
  Stream<List<OwnerFloor>> streamFloors(String pgId) {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for streamFloors');
    }

    return _firestoreService
        .getCollectionStream('pgs/$pgId/floors')
        .map((snapshot) {
      final floors =
          snapshot.docs.map((doc) => OwnerFloor.fromFirestore(doc)).toList();

      _analyticsService.logEvent(
        name: 'owner_floors_streamed',
        parameters: {
          'pg_id': pgId,
          'floors_count': floors.length,
        },
      );

      return floors;
    });
  }

  /// Stream bookings for PG ID with validation and analytics
  Stream<List<OwnerBooking>> streamBookings(String pgId) {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for streamBookings');
    }

    return _firestoreService
        .getCollectionStreamWithFilter(
            FirestoreConstants.bookings, 'pgId', pgId)
        .map((snapshot) {
      final bookings =
          snapshot.docs.map((doc) => OwnerBooking.fromFirestore(doc)).toList();

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

  /// Get revenue report for PG with validation and analytics
  Future<OwnerRevenueReport> getRevenueReport(String pgId) async {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for getRevenueReport');
    }

    try {
      final paymentsSnapshot = await _firestoreService
          .getCollectionStreamWithFilter(
              FirestoreConstants.payments, 'pgId', pgId)
          .first;

      double collected = 0;
      double pending = 0;
      int collectedCount = 0;
      int pendingCount = 0;

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = data['amountPaid']?.toDouble() ?? 0;
        final status = data['status'] as String? ?? 'pending';

        if (status.toLowerCase() == 'collected') {
          collected += amount;
          collectedCount++;
        } else {
          pending += amount;
          pendingCount++;
        }
      }

      final report = OwnerRevenueReport(
        collectedAmount: collected,
        pendingAmount: pending,
        totalPayments: collectedCount + pendingCount,
        collectedPayments: collectedCount,
        pendingPayments: pendingCount,
      );

      await _analyticsService.logEvent(
        name: 'owner_revenue_report_generated',
        parameters: {
          'pg_id': pgId,
          'collected': collected,
          'pending': pending,
          'total_payments': report.totalPayments,
        },
      );

      return report;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_revenue_report_error',
        parameters: {
          'pg_id': pgId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to get revenue report: $e');
    }
  }

  /// Get occupancy report for PG
  Future<OwnerOccupancyReport> getOccupancyReport(List<OwnerBed> beds) async {
    try {
      final totalBeds = beds.length;
      final occupiedBeds = beds.where((b) => b.isOccupied).length;
      final vacantBeds = beds.where((b) => b.isVacant).length;
      final pendingBeds = beds.where((b) => b.isPending).length;
      final maintenanceBeds = beds.where((b) => b.isUnderMaintenance).length;

      final report = OwnerOccupancyReport(
        totalBeds: totalBeds,
        occupiedBeds: occupiedBeds,
        vacantBeds: vacantBeds,
        pendingBeds: pendingBeds,
        maintenanceBeds: maintenanceBeds,
      );

      await _analyticsService.logEvent(
        name: 'owner_occupancy_report_generated',
        parameters: {
          'total_beds': totalBeds,
          'occupied': occupiedBeds,
          'vacant': vacantBeds,
          'occupancy_percentage': report.occupancyPercentage,
        },
      );

      return report;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_occupancy_report_error',
        parameters: {'error': e.toString()},
      );
      throw Exception('Failed to get occupancy report: $e');
    }
  }

  /// Approve booking request
  Future<void> approveBooking(String bookingId) async {
    if (bookingId.isEmpty) {
      throw ArgumentError('Booking ID cannot be empty for approveBooking');
    }

    try {
      await _firestoreService.updateDocument(
        FirestoreConstants.bookings,
        bookingId,
        {'status': 'approved', 'updatedAt': DateTime.now()},
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_approved',
        parameters: {'booking_id': bookingId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_approve_error',
        parameters: {
          'booking_id': bookingId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to approve booking: $e');
    }
  }

  /// Reject booking request
  Future<void> rejectBooking(String bookingId) async {
    if (bookingId.isEmpty) {
      throw ArgumentError('Booking ID cannot be empty for rejectBooking');
    }

    try {
      await _firestoreService.updateDocument(
        FirestoreConstants.bookings,
        bookingId,
        {'status': 'rejected', 'updatedAt': DateTime.now()},
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_rejected',
        parameters: {'booking_id': bookingId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_reject_error',
        parameters: {
          'booking_id': bookingId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to reject booking: $e');
    }
  }

  /// Reschedule booking request
  Future<void> rescheduleBooking(
      String bookingId, DateTime newStartDate, DateTime newEndDate) async {
    if (bookingId.isEmpty) {
      throw ArgumentError('Booking ID cannot be empty for rescheduleBooking');
    }

    try {
      await _firestoreService.updateDocument(
        FirestoreConstants.bookings,
        bookingId,
        {
          'startDate': newStartDate,
          'endDate': newEndDate,
          'status': 'pending',
          'updatedAt': DateTime.now(),
        },
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_rescheduled',
        parameters: {
          'booking_id': bookingId,
          'new_start': newStartDate.toIso8601String(),
          'new_end': newEndDate.toIso8601String(),
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_reschedule_error',
        parameters: {
          'booking_id': bookingId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to reschedule booking: $e');
    }
  }

  /// Update bed status
  Future<void> updateBedStatus(String pgId, String bedId, String status) async {
    try {
      await _firestoreService.updateDocument(
        'pgs/$pgId/beds',
        bedId,
        {'status': status, 'updatedAt': DateTime.now()},
      );

      await _analyticsService.logEvent(
        name: 'owner_bed_status_updated',
        parameters: {
          'pg_id': pgId,
          'bed_id': bedId,
          'status': status,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_bed_status_update_error',
        parameters: {
          'bed_id': bedId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update bed status: $e');
    }
  }

  /// Creates or updates a PG property in the main 'pgs' collection
  /// This makes the PG visible to guests immediately
  Future<void> createOrUpdatePG(dynamic pgModel) async {
    try {
      await _firestoreService.setDocument(
        FirestoreConstants.pgs,
        pgModel.pgId,
        pgModel.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_pg_saved',
        parameters: {
          'pg_id': pgModel.pgId,
          'owner_uid': pgModel.ownerUid,
          'pg_name': pgModel.pgName,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_pg_save_error',
        parameters: {'error': e.toString()},
      );
      throw Exception('Failed to save PG: $e');
    }
  }

  /// Deletes a PG property
  Future<void> deletePG(String pgId) async {
    try {
      await _firestoreService.deleteDocument(
        FirestoreConstants.pgs,
        pgId,
      );

      await _analyticsService.logEvent(
        name: 'owner_pg_deleted',
        parameters: {'pg_id': pgId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_pg_delete_error',
        parameters: {'error': e.toString()},
      );
      throw Exception('Failed to delete PG: $e');
    }
  }

  /// Updates a PG document with partial fields
  /// Only the provided fields will be updated in the `pgs/{pgId}` document
  Future<void> updatePGDetails(
      String pgId, Map<String, dynamic> updates) async {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for updatePGDetails');
    }

    try {
      await _firestoreService.updateDocument(
        FirestoreConstants.pgs,
        pgId,
        {
          ...updates,
          'updatedAt': DateTime.now(),
        },
      );

      await _analyticsService.logEvent(
        name: 'owner_pg_updated',
        parameters: {
          'pg_id': pgId,
          'updated_fields': updates.keys.join(','),
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_pg_update_error',
        parameters: {
          'pg_id': pgId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update PG: $e');
    }
  }

  /// Fetches owner's PG properties
  Future<List<dynamic>> fetchOwnerPGs(String ownerId) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        FirestoreConstants.pgs,
        field: 'ownerUid',
        isEqualTo: ownerId,
      );

      final pgs = snapshot.docs.map((doc) => doc.data()).toList();

      await _analyticsService.logEvent(
        name: 'owner_pgs_fetched',
        parameters: {
          'owner_id': ownerId,
          'pgs_count': pgs.length,
        },
      );

      return pgs;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_pgs_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch PGs: $e');
    }
  }

  /// Fetches a single PG's complete details by pgId
  /// Returns full PG document with all fields (name, address, amenities, floors structure, etc.)
  Future<Map<String, dynamic>?> fetchPGDetails(String pgId) async {
    try {
      final doc = await _firestoreService.getDocument(
        FirestoreConstants.pgs,
        pgId,
      );

      if (!doc.exists) {
        await _analyticsService.logEvent(
          name: 'owner_pg_not_found',
          parameters: {'pg_id': pgId},
        );
        return null;
      }

      final pgData = doc.data() as Map<String, dynamic>;

      await _analyticsService.logEvent(
        name: 'owner_pg_details_fetched',
        parameters: {
          'pg_id': pgId,
          'pg_name': pgData['pgName'] ?? 'Unknown',
        },
      );

      return pgData;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_pg_details_fetch_error',
        parameters: {
          'pg_id': pgId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch PG details: $e');
    }
  }

  /// Streams a single PG's details for real-time updates
  Stream<Map<String, dynamic>?> streamPGDetails(String pgId) {
    return _firestoreService
        .getDocumentStream(FirestoreConstants.pgs, pgId)
        .map((doc) {
      if (!doc.exists) return null;
      return doc.data() as Map<String, dynamic>;
    });
  }
}
