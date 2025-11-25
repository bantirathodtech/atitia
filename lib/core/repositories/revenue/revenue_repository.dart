// lib/core/repositories/revenue/revenue_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../di/common/unified_service_locator.dart';
import '../../../common/utils/constants/firestore.dart';
import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../models/revenue/revenue_record_model.dart';

/// Repository for tracking app revenue
/// Handles revenue record CRUD operations, queries, and analytics
/// Uses interface-based services for dependency injection (swappable backends)
class RevenueRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  RevenueRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Create a new revenue record
  Future<String> createRevenueRecord(RevenueRecordModel revenue) async {
    try {
      await _databaseService.setDocument(
        FirestoreConstants.revenueRecords,
        revenue.revenueId,
        revenue.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'revenue_record_created',
        parameters: {
          'revenue_id': revenue.revenueId,
          'type': revenue.type.firestoreValue,
          'owner_id': revenue.ownerId,
          'amount': revenue.amount.toString(),
          'status': revenue.status.firestoreValue,
        },
      );

      return revenue.revenueId;
    } catch (e) {
      throw Exception('Failed to create revenue record: $e');
    }
  }

  /// Update an existing revenue record
  Future<void> updateRevenueRecord(RevenueRecordModel revenue) async {
    try {
      await _databaseService.updateDocument(
        FirestoreConstants.revenueRecords,
        revenue.revenueId,
        revenue.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'revenue_record_updated',
        parameters: {
          'revenue_id': revenue.revenueId,
          'status': revenue.status.firestoreValue,
        },
      );
    } catch (e) {
      throw Exception('Failed to update revenue record: $e');
    }
  }

  /// Get revenue record by ID
  Future<RevenueRecordModel?> getRevenueRecord(String revenueId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.revenueRecords,
        revenueId,
      );

      if (!doc.exists) {
        return null;
      }

      return RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get revenue record: $e');
    }
  }

  /// Stream revenue records for an owner
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Stream<List<RevenueRecordModel>> streamOwnerRevenue(String ownerId) {
    // COST OPTIMIZATION: Use direct Firestore query with limit
    // For full pagination, use PaginationController with FirestorePaginationHelper
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.revenueRecords)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('paymentDate', descending: true)
        .limit(20) // COST OPTIMIZATION: Limit to 20 items per page
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RevenueRecordModel.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get revenue records for an owner
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Future<List<RevenueRecordModel>> getOwnerRevenue(String ownerId) async {
    try {
      final revenues = await _databaseService.queryCollection(
        FirestoreConstants.revenueRecords,
        [
          {'field': 'ownerId', 'value': ownerId}
        ],
        orderBy: 'paymentDate',
        descending: true,
        limit: 20, // COST OPTIMIZATION: Limit to 20 items per page
      );

      return revenues.docs
          .map((doc) =>
              RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get owner revenue: $e');
    }
  }

  /// Get completed revenue records for an owner
  Future<List<RevenueRecordModel>> getCompletedRevenue(String ownerId) async {
    try {
      final revenues = await getOwnerRevenue(ownerId);
      return revenues
          .where((revenue) => revenue.status == PaymentStatus.completed)
          .toList();
    } catch (e) {
      throw Exception('Failed to get completed revenue: $e');
    }
  }

  /// Get revenue by type
  Future<List<RevenueRecordModel>> getRevenueByType(RevenueType type) async {
    try {
      final revenues = await _databaseService.queryDocuments(
        FirestoreConstants.revenueRecords,
        field: 'type',
        isEqualTo: type.firestoreValue,
      );

      return revenues.docs
          .map((doc) =>
              RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>))
          .where((revenue) => revenue.status == PaymentStatus.completed)
          .toList()
        ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    } catch (e) {
      throw Exception('Failed to get revenue by type: $e');
    }
  }

  /// Get total revenue (all completed records)
  Future<double> getTotalRevenue() async {
    try {
      final revenues = await _databaseService.queryDocuments(
        FirestoreConstants.revenueRecords,
        field: 'status',
        isEqualTo: PaymentStatus.completed.firestoreValue,
      );

      double total = 0.0;
      for (final doc in revenues.docs) {
        final revenue =
            RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>);
        total += revenue.amount;
      }
      return total;
    } catch (e) {
      throw Exception('Failed to get total revenue: $e');
    }
  }

  /// Get revenue for a specific month
  Future<double> getMonthlyRevenue(int year, int month) async {
    try {
      final revenues = await _databaseService.queryDocuments(
        FirestoreConstants.revenueRecords,
        field: 'status',
        isEqualTo: PaymentStatus.completed.firestoreValue,
      );

      double total = 0.0;
      for (final doc in revenues.docs) {
        final revenue =
            RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>);
        if (revenue.paymentDate.year == year &&
            revenue.paymentDate.month == month) {
          total += revenue.amount;
        }
      }
      return total;
    } catch (e) {
      throw Exception('Failed to get monthly revenue: $e');
    }
  }

  /// Get revenue for a specific year
  Future<double> getYearlyRevenue(int year) async {
    try {
      final revenues = await _databaseService.queryDocuments(
        FirestoreConstants.revenueRecords,
        field: 'status',
        isEqualTo: PaymentStatus.completed.firestoreValue,
      );

      double total = 0.0;
      for (final doc in revenues.docs) {
        final revenue =
            RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>);
        if (revenue.paymentDate.year == year) {
          total += revenue.amount;
        }
      }
      return total;
    } catch (e) {
      throw Exception('Failed to get yearly revenue: $e');
    }
  }

  /// Get revenue breakdown by type
  Future<Map<RevenueType, double>> getRevenueBreakdownByType() async {
    try {
      final revenues = await _databaseService.queryDocuments(
        FirestoreConstants.revenueRecords,
        field: 'status',
        isEqualTo: PaymentStatus.completed.firestoreValue,
      );

      final breakdown = <RevenueType, double>{
        RevenueType.subscription: 0.0,
        RevenueType.featuredListing: 0.0,
        RevenueType.successFee: 0.0,
      };

      for (final doc in revenues.docs) {
        final revenue =
            RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>);
        breakdown[revenue.type] =
            (breakdown[revenue.type] ?? 0.0) + revenue.amount;
      }

      return breakdown;
    } catch (e) {
      throw Exception('Failed to get revenue breakdown: $e');
    }
  }

  /// Get monthly revenue breakdown (for charts)
  Future<Map<String, double>> getMonthlyRevenueBreakdown() async {
    try {
      final revenues = await _databaseService.queryDocuments(
        FirestoreConstants.revenueRecords,
        field: 'status',
        isEqualTo: PaymentStatus.completed.firestoreValue,
      );

      final breakdown = <String, double>{};

      for (final doc in revenues.docs) {
        final revenue =
            RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>);
        final monthYear = revenue.monthYear; // Format: "2025-01"
        breakdown[monthYear] = (breakdown[monthYear] ?? 0.0) + revenue.amount;
      }

      return breakdown;
    } catch (e) {
      throw Exception('Failed to get monthly revenue breakdown: $e');
    }
  }

  /// Stream all revenue records (for admin dashboard)
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Stream<List<RevenueRecordModel>> streamAllRevenue() {
    // COST OPTIMIZATION: Use direct Firestore query with limit
    // For full pagination, use PaginationController with FirestorePaginationHelper
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.revenueRecords)
        .orderBy('paymentDate', descending: true)
        .limit(20) // COST OPTIMIZATION: Limit to 20 items per page
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RevenueRecordModel.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get pending revenue records (payments not yet completed)
  /// OPTIMIZED: Limited to 20 items per page for cost optimization
  Future<List<RevenueRecordModel>> getPendingRevenue() async {
    try {
      final revenues = await _databaseService.queryCollection(
        FirestoreConstants.revenueRecords,
        [
          {'field': 'status', 'value': PaymentStatus.pending.firestoreValue}
        ],
        orderBy: 'paymentDate',
        descending: true,
        limit: 20, // COST OPTIMIZATION: Limit to 20 items per page
      );

      return revenues.docs
          .map((doc) =>
              RevenueRecordModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pending revenue: $e');
    }
  }
}
