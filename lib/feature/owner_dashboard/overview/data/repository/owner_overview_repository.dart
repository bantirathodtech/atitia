// lib/features/owner_dashboard/overview/data/repository/owner_overview_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../common/utils/exceptions/exceptions.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../models/owner_overview_model.dart';

/// Repository to fetch owner overview data from Firestore
/// Uses interface-based services for dependency injection (swappable backends)
/// Handles owner dashboard analytics, summary data operations, and data aggregation
class OwnerOverviewRepository {
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
  OwnerOverviewRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Fetches owner overview data including properties, revenue, and tenants
  /// Aggregates data from multiple sources for comprehensive dashboard view
  ///
  /// If pgId is provided, shows data for that specific PG only
  /// If pgId is null, aggregates data across all owner's PGs
  Future<OwnerOverviewModel> fetchOwnerOverviewData(String ownerId,
      {String? pgId}) async {
    try {
      // Aggregate data from multiple collections
      final overview = await _aggregateOwnerData(ownerId, pgId: pgId);

      await _analyticsService.logEvent(
        name: 'owner_overview_data_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'total_properties': overview.totalProperties,
          'total_revenue': overview.totalRevenue,
          'active_tenants': overview.activeTenants,
        },
      );

      return overview;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_overview_data_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerOverviewFetchFailed',
          'Failed to fetch owner overview data',
        ),
        details: e.toString(),
      );
    }
  }

  /// Aggregates data from multiple collections
  /// If pgId is provided, filters all data by that specific PG
  /// NOTE: totalProperties always shows ALL owner's properties, not filtered by pgId
  Future<OwnerOverviewModel> _aggregateOwnerData(String ownerId,
      {String? pgId}) async {
    try {
      // Fetch properties count and calculate total beds
      // COST OPTIMIZATION: Limit to 50 properties per owner (reasonable limit)
      final propertiesSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.pgs, 'ownerUid', ownerId, limit: 50)
          .first;

      // Filter out drafts - only count published/active properties
      final publishedProperties = propertiesSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final isDraft = data['isDraft'] == true;
        return !isDraft; // Only count non-draft properties
      }).toList();

      // Always count ALL published properties for the owner (not filtered by selected PG)
      int totalProperties = publishedProperties.length;
      int totalBeds = 0;
      // int totalRooms = 0;

      // If specific PG selected, filter beds calculation to that PG only
      // But keep totalProperties as all published properties count
      if (pgId != null) {
        final pgDoc =
            publishedProperties.where((doc) => doc.id == pgId).firstOrNull;
        if (pgDoc != null) {
          // Don't change totalProperties - keep it as all published properties count
          // totalProperties remains = publishedProperties.length
          final pgData = pgDoc.data() as Map<String, dynamic>;

          // Calculate total beds from floorStructure
          final floorStructure =
              pgData['floorStructure'] as List<dynamic>? ?? [];
          for (var floor in floorStructure) {
            final rooms = floor['rooms'] as List<dynamic>? ?? [];
            // totalRooms += rooms.length;
            for (var room in rooms) {
              totalBeds += (room['bedsCount'] as int?) ?? 0;
            }
          }
        }
        // Note: If PG not found (pgDoc == null), we still show all properties
        // totalProperties remains as all properties count
      } else {
        // Calculate total beds across all published PGs (excluding drafts)
        for (var pgDoc in publishedProperties) {
          final pgData = pgDoc.data() as Map<String, dynamic>;
          final floorStructure =
              pgData['floorStructure'] as List<dynamic>? ?? [];
          for (var floor in floorStructure) {
            final rooms = floor['rooms'] as List<dynamic>? ?? [];
            // totalRooms += rooms.length;
            for (var room in rooms) {
              totalBeds += (room['bedsCount'] as int?) ?? 0;
            }
          }
        }
      }

      // Fetch payments data - OPTIMIZED: Filter at DB level
      // Get owner ID from bookings or use ownerId parameter
      final now = DateTime.now();

      // Use optimized queries - fetch collected and pending separately for better performance
      final collectedPayments = await _queryPaymentsOptimized(
        ownerId: ownerId,
        pgId: pgId,
        status: 'collected',
      );
      final pendingPayments = await _queryPaymentsOptimized(
        ownerId: ownerId,
        pgId: pgId,
        status: 'pending',
      );

      double totalRevenue = 0.0;
      double pendingRevenue = 0.0;
      double monthlyRevenue = 0.0;

      for (var doc in collectedPayments.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] ?? 0).toDouble();
        final date = data['date']?.toDate();

        totalRevenue += amount;

        // Calculate monthly revenue - filter at query level in future
        if (date != null &&
            date.month == now.month &&
            date.year == now.year) {
          monthlyRevenue += amount;
        }
      }

      for (var doc in pendingPayments.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] ?? 0).toDouble();
        pendingRevenue += amount;
      }

      // Fetch bookings data - OPTIMIZED: Filter at DB level
      final bookingsSnapshot = await _queryBookingsOptimized(
        ownerId: ownerId,
        pgId: pgId,
      );

      int pendingBookings = 0;
      int approvedBookings = 0;
      int activeTenants = 0;

      for (var doc in bookingsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] as String? ?? 'pending';

        if (status == 'pending') {
          pendingBookings++;
        } else if (status == 'approved' || status == 'active') {
          approvedBookings++;
          activeTenants++;
        }
      }

      // Fetch complaints data - OPTIMIZED: Filter at DB level
      final complaintsSnapshot = await _queryComplaintsOptimized(
        ownerId: ownerId,
        pgId: pgId,
      );

      int pendingComplaints = 0;
      int resolvedComplaints = 0;

      for (var doc in complaintsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] as String? ?? 'pending';

        if (status == 'pending') {
          pendingComplaints++;
        } else if (status == 'resolved') {
          resolvedComplaints++;
        }
      }

      // Calculate occupancy
      final occupiedBeds = activeTenants; // Each active tenant = 1 bed
      final vacantBeds = totalBeds > 0 ? (totalBeds - occupiedBeds) : 0;

      return OwnerOverviewModel(
        ownerId: ownerId,
        totalProperties: totalProperties,
        totalRevenue: totalRevenue,
        pendingRevenue: pendingRevenue,
        activeTenants: activeTenants,
        totalTenants: activeTenants, // For now, active = total
        pendingBookings: pendingBookings,
        approvedBookings: approvedBookings,
        monthlyRevenue: monthlyRevenue,
        yearlyRevenue: totalRevenue, // Can be refined with year filtering
        pendingComplaints: pendingComplaints,
        resolvedComplaints: resolvedComplaints,
        totalBeds: totalBeds, // Calculated from floorStructure
        occupiedBeds: occupiedBeds,
        vacantBeds: vacantBeds,
      );
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerOverviewAggregateFailed',
          'Failed to aggregate owner data',
        ),
        details: e.toString(),
      );
    }
  }

  /// Fetches real-time overview data stream for live dashboard updates
  /// Provides continuous data updates for reactive UI
  Stream<OwnerOverviewModel> getOverviewDataStream(String ownerId) {
    // For simplicity, we'll poll the data periodically
    // In production, you might want to use Cloud Functions to maintain aggregated data
    return Stream.periodic(const Duration(seconds: 30), (_) async {
      return await fetchOwnerOverviewData(ownerId);
    }).asyncMap((future) => future);
  }

  /// Fetches monthly revenue breakdown - OPTIMIZED with DB-level filtering
  Future<Map<String, double>> getMonthlyRevenueBreakdown(
      String ownerId, int year) async {
    try {
      // OPTIMIZED: Filter at DB level - query only collected payments for this owner
      final paymentsSnapshot = await _queryPaymentsOptimized(
        ownerId: ownerId,
        status: 'collected',
      );

      final Map<String, double> breakdown = {};

      for (int month = 1; month <= 12; month++) {
        breakdown['month_$month'] = 0.0;
      }

      // Filter by year in code (can be optimized further with date range queries)
      final yearStart = DateTime(year, 1, 1);
      final yearEnd = DateTime(year, 12, 31, 23, 59, 59);

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final date = data['date']?.toDate();

        if (date != null && date.isAfter(yearStart.subtract(const Duration(days: 1))) && date.isBefore(yearEnd.add(const Duration(days: 1)))) {
          final amount = (data['amount'] ?? 0).toDouble();
          final monthKey = 'month_${date.month}';
          breakdown[monthKey] = (breakdown[monthKey] ?? 0) + amount;
        }
      }

      await _analyticsService.logEvent(
        name: 'owner_monthly_breakdown_fetched',
        parameters: {
          'owner_id': ownerId,
          'year': year,
        },
      );

      return breakdown;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_monthly_breakdown_error',
        parameters: {
          'owner_id': ownerId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerMonthlyBreakdownFailed',
          'Failed to fetch monthly breakdown',
        ),
        details: e.toString(),
      );
    }
  }

  /// Fetches property-wise revenue breakdown
  /// Only includes published properties (excludes drafts)
  Future<Map<String, double>> getPropertyRevenueBreakdown(
      String ownerId) async {
    try {
      // COST OPTIMIZATION: Limit to 50 properties per owner
      final propertiesSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.pgs, 'ownerUid', ownerId, limit: 50)
          .first;

      // Filter out drafts - only include published properties
      final publishedProperties = propertiesSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final isDraft = data['isDraft'] == true;
        return !isDraft; // Only process non-draft properties
      }).toList();

      final Map<String, double> breakdown = {};

      for (var propertyDoc in publishedProperties) {
        final pgId = propertyDoc.id;
        final pgData = propertyDoc.data() as Map<String, dynamic>;
        final pgName = pgData['pgName'] ??
            _text(
              'ownerPropertyFallbackName',
              'Property {pgId}',
              parameters: {'pgId': pgId},
            );

        // OPTIMIZED: Fetch payments for this property with DB-level filtering
        final paymentsSnapshot = await _queryPaymentsOptimized(
          pgId: pgId,
          status: 'collected', // Only get collected payments for revenue
        );

        double propertyRevenue = 0.0;
        // Already filtered by status='collected' at DB level, so just sum amounts
        for (var paymentDoc in paymentsSnapshot.docs) {
          final paymentData = paymentDoc.data() as Map<String, dynamic>;
          final amount = (paymentData['amount'] ?? 0).toDouble();
          propertyRevenue += amount;
        }

        breakdown[pgName] = propertyRevenue;
      }

      await _analyticsService.logEvent(
        name: 'owner_property_breakdown_fetched',
        parameters: {
          'owner_id': ownerId,
          'properties_count': breakdown.length,
        },
      );

      return breakdown;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_property_breakdown_error',
        parameters: {
          'owner_id': ownerId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerPropertyBreakdownFailed',
          'Failed to fetch property breakdown',
        ),
        details: e.toString(),
      );
    }
  }

  /// Fetches payment status breakdown (paid, pending, partial counts and amounts)
  /// If pgId is provided, filters by that specific PG only
  Future<Map<String, dynamic>> getPaymentStatusBreakdown(
      String ownerId, {String? pgId}) async {
    try {
      // OPTIMIZED: Get bookings filtered at DB level
      final bookingsSnapshot = await _queryBookingsOptimized(
        ownerId: ownerId,
        pgId: pgId,
      );

      int paidCount = 0;
      int pendingCount = 0;
      int partialCount = 0;
      double paidAmount = 0.0;
      double pendingAmount = 0.0;
      double partialAmount = 0.0;

      // Get unique guest IDs from bookings for this owner/PG
      final guestIds = <String>{};
      for (var doc in bookingsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final bookingPgId = data['pgId'] as String?;
        final ownerIdFromBooking = data['ownerId'] as String?;
        
        // Filter by owner and optionally by PG
        if (ownerIdFromBooking == ownerId &&
            (pgId == null || bookingPgId == pgId)) {
          final guestUid = data['guestUid'] as String?;
          if (guestUid != null) {
            guestIds.add(guestUid);
          }
        }
      }

      // Count payment status from bookings
      for (var doc in bookingsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final bookingPgId = data['pgId'] as String?;
        final ownerIdFromBooking = data['ownerId'] as String?;
        
        if (ownerIdFromBooking == ownerId &&
            (pgId == null || bookingPgId == pgId)) {
          final paymentStatus = (data['paymentStatus'] as String? ?? 'pending').toLowerCase();
          final bookingRentAmount = (data['rentAmount'] ?? 0).toDouble();
          final bookingDepositAmount = (data['depositAmount'] ?? 0).toDouble();
          final bookingPaidAmount = (data['paidAmount'] ?? 0).toDouble();
          final totalAmount = bookingRentAmount + bookingDepositAmount;

          if (paymentStatus == 'collected' || bookingPaidAmount >= totalAmount) {
            paidCount++;
            paidAmount += totalAmount;
          } else if (paymentStatus == 'partial' || (bookingPaidAmount > 0 && bookingPaidAmount < totalAmount)) {
            partialCount++;
            partialAmount += bookingPaidAmount;
          } else {
            pendingCount++;
            pendingAmount += totalAmount;
          }
        }
      }

      // Also check guests with payment_pending status
      // COST OPTIMIZATION: Limit to 200 guests for stats calculation
      final guestsSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.users, 'role', 'guest', limit: 200)
          .first;

      for (var doc in guestsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final guestId = doc.id;
        final guestPgId = data['pgId'] as String?;
        final guestStatus = data['status'] as String? ?? 'active';

        // Only count if guest is linked to this owner's PG(s)
        if (pgId != null && guestPgId != pgId) continue;
        if (!guestIds.contains(guestId) && guestStatus != 'payment_pending') continue;

        if (guestStatus == 'payment_pending') {
          pendingCount++;
          // Try to get amount from booking
          final guestBookings = bookingsSnapshot.docs.where((b) {
            final bData = b.data() as Map<String, dynamic>;
            return bData['guestUid'] == guestId;
          });
          
          if (guestBookings.isNotEmpty) {
            final bookingData = guestBookings.first.data() as Map<String, dynamic>;
            final rent = (bookingData['rentAmount'] ?? 0).toDouble();
            final deposit = (bookingData['depositAmount'] ?? 0).toDouble();
            pendingAmount += rent + deposit;
          }
        }
      }

      final breakdown = {
        'paidCount': paidCount,
        'pendingCount': pendingCount,
        'partialCount': partialCount,
        'paidAmount': paidAmount,
        'pendingAmount': pendingAmount,
        'partialAmount': partialAmount,
        'totalCount': paidCount + pendingCount + partialCount,
      };

      await _analyticsService.logEvent(
        name: 'owner_payment_status_breakdown_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          ...breakdown,
        },
      );

      return breakdown;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_payment_status_breakdown_error',
        parameters: {
          'owner_id': ownerId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerPaymentStatusBreakdownFailed',
          'Failed to fetch payment status breakdown',
        ),
        details: e.toString(),
      );
    }
  }

  /// Fetches recently updated guests (within last N days)
  /// If pgId is provided, filters by that specific PG only
  Future<List<Map<String, dynamic>>> getRecentlyUpdatedGuests(
      String ownerId, {String? pgId, int days = 7}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      // OPTIMIZED: Get bookings filtered at DB level
      final bookingsSnapshot = await _queryBookingsOptimized(
        ownerId: ownerId,
        pgId: pgId,
      );

      final guestIds = <String>{};
      for (var doc in bookingsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final bookingPgId = data['pgId'] as String?;
        final ownerIdFromBooking = data['ownerId'] as String?;
        
        if (ownerIdFromBooking == ownerId &&
            (pgId == null || bookingPgId == pgId)) {
          final guestUid = data['guestUid'] as String?;
          if (guestUid != null) {
            guestIds.add(guestUid);
          }
        }
      }

      // Get guests
      // COST OPTIMIZATION: Limit to 200 guests for recent updates check
      final guestsSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.users, 'role', 'guest', limit: 200)
          .first;

      final recentGuests = <Map<String, dynamic>>[];

      for (var doc in guestsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final guestId = doc.id;
        final guestPgId = data['pgId'] as String?;
        final updatedAt = data['updatedAt']?.toDate();
        final createdAt = data['createdAt']?.toDate();

        // Filter by PG if specified
        if (pgId != null && guestPgId != pgId) continue;

        // Check if guest is linked to owner's PG(s) or has matching PG
        if (!guestIds.contains(guestId) && guestPgId == null) continue;

        final lastUpdate = updatedAt ?? createdAt;
        if (lastUpdate != null && lastUpdate.isAfter(cutoffDate)) {
          recentGuests.add({
            'uid': guestId,
            'fullName': data['fullName'] ?? data['name'] ?? 'Unknown',
            'phoneNumber': data['phoneNumber'] ?? '',
            'email': data['email'],
            'profilePhotoUrl': data['profilePhotoUrl'],
            'roomNumber': data['roomNumber'],
            'bedNumber': data['bedNumber'],
            'status': data['status'] ?? 'active',
            'updatedAt': lastUpdate.millisecondsSinceEpoch,
            'createdAt': (createdAt ?? lastUpdate).millisecondsSinceEpoch,
          });
        }
      }

      // Sort by most recently updated first
      recentGuests.sort((a, b) {
        final aUpdated = a['updatedAt'] as int? ?? 0;
        final bUpdated = b['updatedAt'] as int? ?? 0;
        return bUpdated.compareTo(aUpdated);
      });

      await _analyticsService.logEvent(
        name: 'owner_recently_updated_guests_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'days': days,
          'count': recentGuests.length,
        },
      );

      return recentGuests;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_recently_updated_guests_error',
        parameters: {
          'owner_id': ownerId,
          'error': e.toString(),
        },
      );
      // Return empty list on error rather than throwing
      return [];
    }
  }

  /// Helper: Query payments optimized with DB-level filtering
  Future<QuerySnapshot> _queryPaymentsOptimized({
    String? ownerId,
    String? pgId,
    String? status,
  }) async {
    final filters = <Map<String, dynamic>>[];
    if (ownerId != null) {
      filters.add({'field': 'ownerId', 'value': ownerId});
    }
    if (pgId != null) {
      filters.add({'field': 'pgId', 'value': pgId});
    }
    if (status != null) {
      filters.add({'field': 'status', 'value': status});
    }

    if (filters.isEmpty) {
      // Use queryCollection interface method
      // COST OPTIMIZATION: Limit to 100 payments for stats calculation
      return await _databaseService.queryCollection(
        FirestoreConstants.payments,
        [],
        limit: 100,
      );
    } else {
      // COST OPTIMIZATION: Limit to 100 payments for stats calculation
      return await _databaseService.queryCollection(
        FirestoreConstants.payments,
        filters,
        limit: 100,
      );
    }
  }

  /// Helper: Query bookings optimized with DB-level filtering
  Future<QuerySnapshot> _queryBookingsOptimized({
    String? ownerId,
    String? pgId,
  }) async {
    final filters = <Map<String, dynamic>>[];
    if (ownerId != null) {
      filters.add({'field': 'ownerId', 'value': ownerId});
    }
    if (pgId != null) {
      filters.add({'field': 'pgId', 'value': pgId});
    }

    if (filters.isEmpty) {
      // COST OPTIMIZATION: Limit to 100 bookings for stats calculation
      return await _databaseService.queryCollection(
        FirestoreConstants.bookings,
        [],
        limit: 100,
      );
    } else {
      // COST OPTIMIZATION: Limit to 100 bookings for stats calculation
      return await _databaseService.queryCollection(
        FirestoreConstants.bookings,
        filters,
        limit: 100,
      );
    }
  }

  /// Helper: Query complaints optimized with DB-level filtering
  Future<QuerySnapshot> _queryComplaintsOptimized({
    String? ownerId,
    String? pgId,
  }) async {
    final filters = <Map<String, dynamic>>[];
    if (ownerId != null) {
      filters.add({'field': 'ownerId', 'value': ownerId});
    }
    if (pgId != null) {
      filters.add({'field': 'pgId', 'value': pgId});
    }

    if (filters.isEmpty) {
      // COST OPTIMIZATION: Limit to 100 complaints for stats calculation
      return await _databaseService.queryCollection(
        FirestoreConstants.complaints,
        [],
        limit: 100,
      );
    } else {
      // COST OPTIMIZATION: Limit to 100 complaints for stats calculation
      return await _databaseService.queryCollection(
        FirestoreConstants.complaints,
        filters,
        limit: 100,
      );
    }
  }
}
