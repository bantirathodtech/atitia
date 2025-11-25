// lib/features/owner_dashboard/mypg/data/repositories/owner_pg_management_repository.dart

import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../common/utils/exceptions/exceptions.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/services/cache/pg_details_cache_service.dart';
import '../../../../../core/services/cache/static_data_cache_service.dart';
import '../models/owner_pg_management_model.dart';
import '../../../../../common/utils/date/converter/date_service_converter.dart';

/// Repository for PG management Firestore operations
/// Uses interface-based services for dependency injection (swappable backends)
/// Handles beds, rooms, floors, bookings with analytics tracking
class OwnerPgManagementRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerPgManagementRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Stream beds real-time by PG ID with validation and analytics
  Stream<List<OwnerBed>> streamBeds(String pgId) {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for streamBeds');
    }

    return _databaseService
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
      // Generate a new document ID using interface
      final String pgId = _databaseService.generateDocumentId();

      final now = DateTime.now();
      final dataWithMeta = {
        ...pgData,
        'pgId': pgId,
        'createdAt': pgData['createdAt'] ?? DateServiceConverter.toService(now),
        'updatedAt': DateServiceConverter.toService(now),
      };

      await _databaseService.setDocument(
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
      throw AppException(
        message: _text(
          'ownerPgCreateFailed',
          'Failed to create PG: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Stream rooms real-time by PG ID with validation and analytics
  Stream<List<OwnerRoom>> streamRooms(String pgId) {
    if (pgId.isEmpty) {
      throw ArgumentError('PG ID cannot be empty for streamRooms');
    }

    return _databaseService
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

    return _databaseService
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

    // COST OPTIMIZATION: Limit to 30 bookings per PG
    return _databaseService
        .getCollectionStreamWithFilter(
            FirestoreConstants.bookings, 'pgId', pgId,
            limit: 30)
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
      final paymentsSnapshot = await _databaseService
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
      throw AppException(
        message: _text(
          'ownerPgRevenueReportFailed',
          'Failed to get revenue report: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
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
      throw AppException(
        message: _text(
          'ownerPgOccupancyReportFailed',
          'Failed to get occupancy report: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Approve booking request
  Future<void> approveBooking(String bookingId) async {
    if (bookingId.isEmpty) {
      throw ArgumentError('Booking ID cannot be empty for approveBooking');
    }

    try {
      await _databaseService.updateDocument(
        FirestoreConstants.bookings,
        bookingId,
        {
          'status': 'approved',
          'updatedAt': DateServiceConverter.toService(DateTime.now())
        },
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
      throw AppException(
        message: _text(
          'ownerPgApproveBookingFailed',
          'Failed to approve booking: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Reject booking request
  Future<void> rejectBooking(String bookingId) async {
    if (bookingId.isEmpty) {
      throw ArgumentError('Booking ID cannot be empty for rejectBooking');
    }

    try {
      await _databaseService.updateDocument(
        FirestoreConstants.bookings,
        bookingId,
        {
          'status': 'rejected',
          'updatedAt': DateServiceConverter.toService(DateTime.now())
        },
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
      throw AppException(
        message: _text(
          'ownerPgRejectBookingFailed',
          'Failed to reject booking: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Reschedule booking request
  Future<void> rescheduleBooking(
      String bookingId, DateTime newStartDate, DateTime newEndDate) async {
    if (bookingId.isEmpty) {
      throw ArgumentError('Booking ID cannot be empty for rescheduleBooking');
    }

    try {
      await _databaseService.updateDocument(
        FirestoreConstants.bookings,
        bookingId,
        {
          'startDate': DateServiceConverter.toService(newStartDate),
          'endDate': DateServiceConverter.toService(newEndDate),
          'status': 'pending',
          'updatedAt': DateServiceConverter.toService(DateTime.now()),
        },
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_rescheduled',
        parameters: {
          'booking_id': bookingId,
          'new_start': DateServiceConverter.toService(newStartDate),
          'new_end': DateServiceConverter.toService(newEndDate),
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
      throw AppException(
        message: _text(
          'ownerPgRescheduleBookingFailed',
          'Failed to reschedule booking: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Update bed status
  Future<void> updateBedStatus(String pgId, String bedId, String status) async {
    try {
      await _databaseService.updateDocument(
        'pgs/$pgId/beds',
        bedId,
        {
          'status': status,
          'updatedAt': DateServiceConverter.toService(DateTime.now())
        },
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
      throw AppException(
        message: _text(
          'ownerPgUpdateBedStatusFailed',
          'Failed to update bed status: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Creates or updates a PG property in the main 'pgs' collection
  /// This makes the PG visible to guests immediately
  Future<void> createOrUpdatePG(dynamic pgModel) async {
    try {
      await _databaseService.setDocument(
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
      throw AppException(
        message: _text(
          'ownerPgSaveFailed',
          'Failed to save PG: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Deletes a PG property
  Future<void> deletePG(String pgId) async {
    try {
      await _databaseService.deleteDocument(
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
      throw AppException(
        message: _text(
          'ownerPgDeleteFailed',
          'Failed to delete PG: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
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
      await _databaseService.updateDocument(
        FirestoreConstants.pgs,
        pgId,
        {
          ...updates,
          'updatedAt': DateServiceConverter.toService(DateTime.now()),
        },
      );

      // Invalidate caches when PG is updated
      await PgDetailsCacheService.instance.invalidatePGDetails(pgId);
      await StaticDataCacheService.instance
          .invalidateAll(); // Cities/amenities may have changed

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
      throw AppException(
        message: _text(
          'ownerPgUpdateFailed',
          'Failed to update PG: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Fetches owner's PG properties
  Future<List<dynamic>> fetchOwnerPGs(String ownerId) async {
    try {
      final snapshot = await _databaseService.queryCollection(
        FirestoreConstants.pgs,
        [
          {'field': 'ownerUid', 'value': ownerId},
        ],
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
      throw AppException(
        message: _text(
          'ownerPgFetchListFailed',
          'Failed to fetch PGs: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Fetches a single PG's complete details by pgId
  /// Returns full PG document with all fields (name, address, amenities, floors structure, etc.)
  /// Uses cache first to reduce Firestore reads (60-80% reduction)
  Future<Map<String, dynamic>?> fetchPGDetails(String pgId) async {
    try {
      // Check cache first
      final cacheService = PgDetailsCacheService.instance;
      final cachedData = await cacheService.getCachedPGDetails(pgId);

      if (cachedData != null) {
        // Cache hit - return cached data
        await _analyticsService.logEvent(
          name: 'owner_pg_details_cache_hit',
          parameters: {
            'pg_id': pgId,
            'pg_name': cachedData['pgName'] ?? 'Unknown',
          },
        );
        return cachedData;
      }

      // Cache miss - fetch from Firestore
      final doc = await _databaseService.getDocument(
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

      // Cache the fetched PG details
      await cacheService.cachePGDetails(pgId, pgData);

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
      throw AppException(
        message: _text(
          'ownerPgFetchDetailsFailed',
          'Failed to fetch PG details: {error}',
          parameters: {'error': e.toString()},
        ),
        details: e.toString(),
      );
    }
  }

  /// Streams a single PG's details for real-time updates
  Stream<Map<String, dynamic>?> streamPGDetails(String pgId) {
    return _databaseService
        .getDocumentStream(FirestoreConstants.pgs, pgId)
        .map((doc) {
      if (!doc.exists) return null;
      return doc.data() as Map<String, dynamic>;
    });
  }

  /// Fetch the latest draft PG for an owner (isDraft == true), ordered by updatedAt desc
  Future<Map<String, dynamic>?> fetchLatestDraftForOwner(String ownerId) async {
    try {
      final snapshot =
          await _databaseService.queryCollection(FirestoreConstants.pgs, [
        {'field': 'ownerUid', 'value': ownerId},
        {'field': 'isDraft', 'value': true},
      ]).then((qs) async {
        // If interface lacks order/limit, emulate by picking max updatedAt
        final docs = qs.docs.map((d) => d).toList();
        if (docs.isEmpty) return null;
        docs.sort((a, b) {
          final am = (a.data() as Map<String, dynamic>);
          final bm = (b.data() as Map<String, dynamic>);
          final au = am['updatedAt'];
          final bu = bm['updatedAt'];
          return (bu?.toString() ?? '').compareTo(au?.toString() ?? '');
        });
        return docs.first;
      });

      if (snapshot == null) return null;
      final data = snapshot.data() as Map<String, dynamic>;
      return {
        ...data,
        'pgId': snapshot.id,
      };
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_latest_draft_fetch_error',
        parameters: {'owner_id': ownerId, 'error': e.toString()},
      );
      return null;
    }
  }
}
