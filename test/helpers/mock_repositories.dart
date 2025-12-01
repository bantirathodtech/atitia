// test/helpers/mock_repositories.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atitia/core/interfaces/analytics/analytics_service_interface.dart';
import 'package:atitia/core/interfaces/database/database_service_interface.dart';
import 'package:atitia/feature/owner_dashboard/overview/data/repository/owner_overview_repository.dart';
import 'package:atitia/feature/owner_dashboard/overview/data/models/owner_overview_model.dart';
import 'dart:async';

/// Mock implementations of services for testing
class MockDatabaseService implements IDatabaseService {
  @override
  Future<void> initialize() async {}

  @override
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    throw UnimplementedError('Use mock data');
  }

  @override
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {}

  @override
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {}

  @override
  Future<void> deleteDocument(String collection, String docId) async {}

  @override
  Stream<DocumentSnapshot> getDocumentStream(
    String collection,
    String docId,
  ) {
    throw UnimplementedError('Use mock streams');
  }

  @override
  Future<QuerySnapshot> queryCollection(
    String collection,
    List<Map<String, dynamic>> filters, {
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    throw UnimplementedError('Use mock data');
  }

  @override
  Stream<QuerySnapshot> getCollectionStream(String collection, {int? limit}) {
    throw UnimplementedError('Use mock streams');
  }

  @override
  Stream<QuerySnapshot> getCollectionStreamWithCompoundFilter(
    String collection,
    List<Map<String, dynamic>> filters, {
    int? limit,
  }) {
    throw UnimplementedError('Use mock streams');
  }

  @override
  String generateDocumentId() {
    return 'mock_doc_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {}

  @override
  Future<QuerySnapshot> queryDocuments(
    String collection, {
    required String field,
    required dynamic isEqualTo,
    int? limit,
  }) async {
    throw UnimplementedError('Use mock data');
  }

  @override
  Stream<QuerySnapshot> getCollectionStreamWithFilter(
    String collection,
    String field,
    dynamic value, {
    int? limit,
  }) {
    throw UnimplementedError('Use mock streams');
  }
}

class MockAnalyticsService implements IAnalyticsService {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {}

  @override
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> resetAnalyticsData() async {}
}

/// Mock OwnerOverviewRepository for testing
class MockOwnerOverviewRepository extends OwnerOverviewRepository {
  OwnerOverviewModel? _mockOverviewData;
  Map<String, double>? _mockMonthlyBreakdown;
  Map<String, double>? _mockPropertyBreakdown;
  Map<String, dynamic>? _mockPaymentStatusBreakdown;
  List<Map<String, dynamic>>? _mockRecentlyUpdatedGuests;
  Exception? _shouldThrow;

  MockOwnerOverviewRepository()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockOverviewData(OwnerOverviewModel data) {
    _mockOverviewData = data;
  }

  void setMockMonthlyBreakdown(Map<String, double> breakdown) {
    _mockMonthlyBreakdown = breakdown;
  }

  void setMockPropertyBreakdown(Map<String, double> breakdown) {
    _mockPropertyBreakdown = breakdown;
  }

  void setMockPaymentStatusBreakdown(Map<String, dynamic> breakdown) {
    _mockPaymentStatusBreakdown = breakdown;
  }

  void setMockRecentlyUpdatedGuests(List<Map<String, dynamic>> guests) {
    _mockRecentlyUpdatedGuests = guests;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  void clearError() {
    _shouldThrow = null;
  }

  @override
  Future<OwnerOverviewModel> fetchOwnerOverviewData(
    String ownerId, {
    String? pgId,
  }) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockOverviewData ?? OwnerOverviewModel(ownerId: ownerId);
  }

  @override
  Future<Map<String, double>> getMonthlyRevenueBreakdown(
    String ownerId,
    int year,
  ) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockMonthlyBreakdown ?? {};
  }

  @override
  Future<Map<String, double>> getPropertyRevenueBreakdown(
    String ownerId,
  ) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockPropertyBreakdown ?? {};
  }

  @override
  Future<Map<String, dynamic>> getPaymentStatusBreakdown(
    String ownerId, {
    String? pgId,
  }) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockPaymentStatusBreakdown ?? {};
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentlyUpdatedGuests(
    String ownerId, {
    String? pgId,
    int days = 7,
  }) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockRecentlyUpdatedGuests ?? [];
  }

  @override
  Stream<OwnerOverviewModel> getOverviewDataStream(String ownerId) {
    return Stream.value(
      _mockOverviewData ?? OwnerOverviewModel(ownerId: ownerId),
    );
  }
}
