// lib/core/services/firebase/database/enhanced_database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../common/utils/constants/firestore.dart';
import 'firestore_cache_service.dart';
import 'optimized_firestore_service.dart';

/// 🚀 **ENHANCED DATABASE SERVICE - OPTIMIZED QUERIES & CACHING**
///
/// Wraps OptimizedFirestoreService with caching layer
/// Provides DB-level filtering, caching, and batch operations
class EnhancedDatabaseService {
  final OptimizedFirestoreService _firestoreService;
  final FirestoreCacheService _cacheService;

  EnhancedDatabaseService({
    OptimizedFirestoreService? firestoreService,
    FirestoreCacheService? cacheService,
  })  : _firestoreService =
            firestoreService ?? OptimizedFirestoreService(),
        _cacheService = cacheService ?? FirestoreCacheService();

  /// Query payments with caching and DB-level filtering
  Future<QuerySnapshot> queryPayments({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    bool useCache = true,
  }) async {
    final cacheKey = FirestoreCacheService.generateCacheKey(
      collection: FirestoreConstants.payments,
      filters: {
        if (ownerId != null) 'ownerId': ownerId,
        if (pgId != null) 'pgId': pgId,
        if (guestId != null) 'guestId': guestId,
        if (status != null) 'status': status,
      },
      limit: limit,
    );

    if (useCache) {
      final cached = await _cacheService.getCachedQuery(cacheKey);
      if (cached != null) {
        if (kDebugMode) debugPrint('✅ Using cached payments query');
        return cached;
      }
    }

    final snapshot = await _firestoreService.queryPayments(
      ownerId: ownerId,
      pgId: pgId,
      guestId: guestId,
      status: status,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );

    if (useCache) {
      await _cacheService.cacheQuery(cacheKey, snapshot);
    }

    return snapshot;
  }

  /// Query bookings with caching and DB-level filtering
  Future<QuerySnapshot> queryBookings({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    String? paymentStatus,
    int? limit,
    bool useCache = true,
  }) async {
    final cacheKey = FirestoreCacheService.generateCacheKey(
      collection: FirestoreConstants.bookings,
      filters: {
        if (ownerId != null) 'ownerId': ownerId,
        if (pgId != null) 'pgId': pgId,
        if (guestId != null) 'guestId': guestId,
        if (status != null) 'status': status,
        if (paymentStatus != null) 'paymentStatus': paymentStatus,
      },
      limit: limit,
    );

    if (useCache) {
      final cached = await _cacheService.getCachedQuery(cacheKey);
      if (cached != null) {
        if (kDebugMode) debugPrint('✅ Using cached bookings query');
        return cached;
      }
    }

    final snapshot = await _firestoreService.queryBookings(
      ownerId: ownerId,
      pgId: pgId,
      guestId: guestId,
      status: status,
      paymentStatus: paymentStatus,
      limit: limit,
    );

    if (useCache) {
      await _cacheService.cacheQuery(cacheKey, snapshot);
    }

    return snapshot;
  }

  /// Stream bookings with DB-level filtering
  Stream<QuerySnapshot> streamBookings({
    String? ownerId,
    String? pgId,
    String? status,
    String? paymentStatus,
  }) {
    return _firestoreService.streamBookings(
      ownerId: ownerId,
      pgId: pgId,
      status: status,
      paymentStatus: paymentStatus,
    );
  }

  /// Query complaints with caching and DB-level filtering
  Future<QuerySnapshot> queryComplaints({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    int? limit,
    bool useCache = true,
  }) async {
    final cacheKey = FirestoreCacheService.generateCacheKey(
      collection: FirestoreConstants.complaints,
      filters: {
        if (ownerId != null) 'ownerId': ownerId,
        if (pgId != null) 'pgId': pgId,
        if (guestId != null) 'guestId': guestId,
        if (status != null) 'status': status,
      },
      limit: limit,
    );

    if (useCache) {
      final cached = await _cacheService.getCachedQuery(cacheKey);
      if (cached != null) {
        return cached;
      }
    }

    final snapshot = await _firestoreService.queryComplaints(
      ownerId: ownerId,
      pgId: pgId,
      guestId: guestId,
      status: status,
      limit: limit,
    );

    if (useCache) {
      await _cacheService.cacheQuery(cacheKey, snapshot);
    }

    return snapshot;
  }

  /// Query published PGs (excludes drafts) with DB-level filtering
  Future<QuerySnapshot> queryPublishedPGs({
    String? ownerId,
    bool? isActive,
    String? city,
    int? limit,
    bool useCache = true,
  }) async {
    final cacheKey = FirestoreCacheService.generateCacheKey(
      collection: FirestoreConstants.pgs,
      filters: {
        'isDraft': false, // Always exclude drafts
        if (ownerId != null) 'ownerUid': ownerId,
        if (isActive != null) 'isActive': isActive,
        if (city != null) 'city': city,
      },
      limit: limit,
    );

    if (useCache) {
      final cached = await _cacheService.getCachedQuery(cacheKey);
      if (cached != null) {
        return cached;
      }
    }

    final snapshot = await _firestoreService.queryPublishedPGs(
      ownerId: ownerId,
      isActive: isActive,
      city: city,
      limit: limit,
    );

    if (useCache) {
      await _cacheService.cacheQuery(cacheKey, snapshot);
    }

    return snapshot;
  }

  /// Stream published PGs with DB-level filtering
  Stream<QuerySnapshot> streamPublishedPGs({
    String? ownerId,
    bool? isActive,
  }) {
    return _firestoreService.streamPublishedPGs(
      ownerId: ownerId,
      isActive: isActive,
    );
  }

  /// Batch write with proper Firestore batching
  Future<void> batchWrite({
    required List<Map<String, dynamic>> operations,
  }) async {
    await _firestoreService.batchWrite(operations: operations);
    
    // Invalidate relevant caches after batch write
    final collections = operations
        .map((op) => op['collection'] as String)
        .toSet();
    for (final collection in collections) {
      await _cacheService.invalidateCollection(collection);
    }
  }

  /// Batch read (parallel document reads)
  Future<List<DocumentSnapshot>> batchRead({
    required List<Map<String, dynamic>> documentRefs,
  }) async {
    return _firestoreService.batchRead(documentRefs: documentRefs);
  }

  /// Aggregate payments with DB-level filtering and caching
  Future<Map<String, dynamic>> aggregatePayments({
    String? ownerId,
    String? pgId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    bool useCache = true,
  }) async {
    final snapshot = await queryPayments(
      ownerId: ownerId,
      pgId: pgId,
      status: status,
      startDate: startDate,
      endDate: endDate,
      useCache: useCache,
    );

    double totalAmount = 0.0;
    int count = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] ?? 0).toDouble();
      totalAmount += amount;
      count++;
    }

    return {
      'totalAmount': totalAmount,
      'count': count,
      'averageAmount': count > 0 ? totalAmount / count : 0.0,
    };
  }

  /// Invalidate cache for a collection
  Future<void> invalidateCache(String collection) async {
    await _cacheService.invalidateCollection(collection);
  }
}

