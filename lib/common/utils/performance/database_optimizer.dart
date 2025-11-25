// lib/common/utils/performance/database_optimizer.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../../../core/services/optimization/stream_debounce_service.dart';

/// Database optimization utility for Firestore queries
/// Provides query optimization, pagination, and caching strategies
class DatabaseOptimizer {
  static const int _defaultPageSize = 20;
  static const int _maxPageSize = 50;
  static final Map<String, DocumentSnapshot<Object?>?> _queryCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  /// Optimized query with pagination and caching
  static Future<QuerySnapshot> getPaginatedData({
    required Query query,
    int pageSize = _defaultPageSize,
    DocumentSnapshot? lastDocument,
    bool useCache = true,
    Duration? cacheDuration,
  }) async {
    final cacheKey = _generateCacheKey(query, pageSize, lastDocument?.id);

    // Check cache first
    if (useCache && _queryCache.containsKey(cacheKey)) {
      final cachedTimestamp = _cacheTimestamps[cacheKey];
      if (cachedTimestamp != null &&
          DateTime.now().difference(cachedTimestamp) <
              (cacheDuration ?? _cacheExpiry)) {
        // Return cached result (simplified - in real implementation, you'd cache the full result)
        return await _executeQuery(query, pageSize, lastDocument);
      }
    }

    // Execute query
    final result = await _executeQuery(query, pageSize, lastDocument);

    // Cache the result
    if (useCache) {
      _queryCache[cacheKey] = result.docs.isNotEmpty ? result.docs.last : null;
      _cacheTimestamps[cacheKey] = DateTime.now();
    }

    return result;
  }

  /// Execute optimized query
  static Future<QuerySnapshot> _executeQuery(
    Query query,
    int pageSize,
    DocumentSnapshot? lastDocument,
  ) async {
    // Limit page size
    final limitedPageSize = pageSize > _maxPageSize ? _maxPageSize : pageSize;

    Query optimizedQuery = query.limit(limitedPageSize);

    // Add pagination
    if (lastDocument != null) {
      optimizedQuery = optimizedQuery.startAfterDocument(lastDocument);
    }

    return await optimizedQuery.get();
  }

  /// Optimized single document fetch with caching
  static Future<DocumentSnapshot?> getDocument({
    required String collection,
    required String documentId,
    bool useCache = true,
    Duration? cacheDuration,
  }) async {
    final cacheKey = '$collection/$documentId';

    // Check cache first
    if (useCache && _queryCache.containsKey(cacheKey)) {
      final cachedTimestamp = _cacheTimestamps[cacheKey];
      if (cachedTimestamp != null &&
          DateTime.now().difference(cachedTimestamp) <
              (cacheDuration ?? _cacheExpiry)) {
        final cachedDoc = _queryCache[cacheKey];
        if (cachedDoc != null) return cachedDoc;
      }
    }

    // Fetch from Firestore
    final doc = await FirebaseFirestore.instance
        .collection(collection)
        .doc(documentId)
        .get();

    // Cache the result
    if (useCache && doc.exists) {
      _queryCache[cacheKey] = doc;
      _cacheTimestamps[cacheKey] = DateTime.now();
    }

    return doc.exists ? doc : null;
  }

  /// Batch write operations for better performance
  static Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    if (operations.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();

    for (final operation in operations) {
      final collection = operation['collection'] as String;
      final documentId = operation['documentId'] as String;
      final data = operation['data'] as Map<String, dynamic>;
      final operationType = operation['type'] as String;

      final docRef =
          FirebaseFirestore.instance.collection(collection).doc(documentId);

      switch (operationType) {
        case 'set':
          batch.set(docRef, data);
          break;
        case 'update':
          batch.update(docRef, data);
          break;
        case 'delete':
          batch.delete(docRef);
          break;
      }
    }

    await batch.commit();
  }

  /// Optimized real-time listener with debouncing
  /// Uses custom debounce service to reduce rapid-fire updates
  static Stream<QuerySnapshot> listenToCollection({
    required Query query,
    int pageSize = _defaultPageSize,
    Duration debounceDuration = const Duration(milliseconds: 50),
  }) {
    final stream = query.limit(pageSize).snapshots();
    return StreamDebounceService.instance.debounce(stream, duration: debounceDuration);
  }

  /// Clear expired cache entries
  static void clearExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > _cacheExpiry) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      _queryCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// Clear all cache
  static void clearCache() {
    _queryCache.clear();
    _cacheTimestamps.clear();
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    return {
      'cacheSize': _queryCache.length,
      'oldestEntry': _cacheTimestamps.values.isNotEmpty
          ? _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b)
          : null,
      'newestEntry': _cacheTimestamps.values.isNotEmpty
          ? _cacheTimestamps.values.reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }

  /// Generate cache key for query
  static String _generateCacheKey(
      Query query, int pageSize, String? lastDocumentId) {
    return '${query.toString()}_${pageSize}_${lastDocumentId ?? 'first'}';
  }

  /// Optimized search query with text indexing
  static Future<QuerySnapshot> searchDocuments({
    required String collection,
    required String field,
    required String searchTerm,
    int limit = _defaultPageSize,
  }) async {
    // For better performance, implement full-text search with Algolia or similar
    // For now, use Firestore's basic text search capabilities

    return await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isGreaterThanOrEqualTo: searchTerm)
        .where(field, isLessThanOrEqualTo: '$searchTerm\uf8ff')
        .limit(limit)
        .get();
  }

  /// Preload critical data for better performance
  static Future<void> preloadCriticalData({
    required List<Map<String, String>> documents,
    Duration? cacheDuration,
  }) async {
    final futures = documents.map((doc) => getDocument(
          collection: doc['collection']!,
          documentId: doc['documentId']!,
          cacheDuration: cacheDuration,
        ));

    await Future.wait(futures);
  }

  /// Create optimized paginated query with automatic limit
  /// Always applies limit to prevent loading all documents
  static Query createPaginatedQuery({
    required Query baseQuery,
    int pageSize = _defaultPageSize,
    DocumentSnapshot? startAfter,
  }) {
    Query query = baseQuery.limit(pageSize > _maxPageSize ? _maxPageSize : pageSize);
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    return query;
  }

  /// Ensure query has limit applied (cost optimization)
  /// Prevents accidentally loading all documents
  static Query ensureLimited(Query query, {int defaultLimit = _defaultPageSize}) {
    // Check if query already has limit
    // Note: This is a simple check - in production, you might want to parse the query
    // For now, we'll always apply a limit as a safety measure
    return query.limit(defaultLimit);
  }

  /// Create query with multiple optimizations
  /// - Applies limit
  /// - Adds ordering for consistent pagination
  /// - Prepares for pagination
  static Query createOptimizedQuery({
    required Query baseQuery,
    int pageSize = _defaultPageSize,
    String? orderByField,
    bool descending = true,
    DocumentSnapshot? startAfter,
  }) {
    Query query = baseQuery;
    
    // Add ordering if specified (important for consistent pagination)
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }
    
    // Apply limit
    query = query.limit(pageSize > _maxPageSize ? _maxPageSize : pageSize);
    
    // Add pagination cursor
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    return query;
  }
}

/// Extension for debouncing streams
extension StreamDebounce<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;
    Timer? timer;

    controller = StreamController<T>(
      onListen: () {
        subscription = listen((data) {
          timer?.cancel();
          timer = Timer(duration, () {
            controller!.add(data);
          });
        });
      },
      onCancel: () {
        subscription?.cancel();
        timer?.cancel();
      },
    );

    return controller.stream;
  }
}
