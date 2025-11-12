// lib/features/owner_dashboard/overview/data/repository/owner_overview_repository.dart

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
      final propertiesSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.pgs, 'ownerUid', ownerId)
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

      // Fetch payments data (filter by pgId if provided)
      final paymentsSnapshot = await _databaseService
          .getCollectionStream(FirestoreConstants.payments)
          .first;

      double totalRevenue = 0.0;
      double pendingRevenue = 0.0;
      double monthlyRevenue = 0.0;

      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Filter by pgId if specified
        if (pgId != null && data['pgId'] != pgId) continue;

        final amount = (data['amount'] ?? 0).toDouble();
        final status = data['status'] as String? ?? 'pending';
        final date = data['date']?.toDate();

        if (status.toLowerCase() == 'collected') {
          totalRevenue += amount;

          // Calculate monthly revenue
          if (date != null &&
              date.month == currentMonth &&
              date.year == currentYear) {
            monthlyRevenue += amount;
          }
        } else {
          pendingRevenue += amount;
        }
      }

      // Fetch bookings data (filter by pgId if provided)
      final bookingsSnapshot = await _databaseService
          .getCollectionStream(FirestoreConstants.bookings)
          .first;

      int pendingBookings = 0;
      int approvedBookings = 0;
      int activeTenants =
          0; // Count from bookings where status = approved/active

      for (var doc in bookingsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Filter by pgId if specified
        if (pgId != null && data['pgId'] != pgId) continue;

        final status = data['status'] as String? ?? 'pending';

        if (status == 'pending') {
          pendingBookings++;
        } else if (status == 'approved' || status == 'active') {
          approvedBookings++;
          activeTenants++; // Count active tenants
        }
      }

      // Fetch complaints data (filter by pgId if provided)
      final complaintsSnapshot = await _databaseService
          .getCollectionStream(FirestoreConstants.complaints)
          .first;

      int pendingComplaints = 0;
      int resolvedComplaints = 0;

      for (var doc in complaintsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Filter by pgId if specified
        if (pgId != null && data['pgId'] != pgId) continue;

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

  /// Fetches monthly revenue breakdown
  Future<Map<String, double>> getMonthlyRevenueBreakdown(
      String ownerId, int year) async {
    try {
      final paymentsSnapshot = await _databaseService
          .getCollectionStream(FirestoreConstants.payments)
          .first;

      final Map<String, double> breakdown = {};

      for (int month = 1; month <= 12; month++) {
        breakdown['month_$month'] = 0.0;
      }

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] ?? 0).toDouble();
        final status = data['status'] as String? ?? 'pending';
        final date = data['date']?.toDate();

        if (status.toLowerCase() == 'collected' &&
            date != null &&
            date.year == year) {
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
      final propertiesSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.pgs, 'ownerUid', ownerId)
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

        // Fetch payments for this property
        final paymentsSnapshot = await _databaseService
            .getCollectionStreamWithFilter(
                FirestoreConstants.payments, 'pgId', pgId)
            .first;

        double propertyRevenue = 0.0;
        for (var paymentDoc in paymentsSnapshot.docs) {
          final paymentData = paymentDoc.data() as Map<String, dynamic>;
          final amount = (paymentData['amount'] ?? 0).toDouble();
          final status = paymentData['status'] as String? ?? 'pending';

          if (status.toLowerCase() == 'collected') {
            propertyRevenue += amount;
          }
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
}
