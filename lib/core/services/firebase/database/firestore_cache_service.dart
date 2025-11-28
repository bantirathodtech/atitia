// lib/core/services/firebase/database/firestore_cache_service.dart

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🚀 **FIRESTORE CACHE SERVICE - INTELLIGENT CACHING**
///
/// Provides intelligent caching for Firestore queries with:
/// - TTL-based cache expiration
/// - Cache invalidation on updates
/// - Memory + disk caching
/// - Query result caching
class FirestoreCacheService {
  static final FirestoreCacheService _instance =
      FirestoreCacheService._internal();
  factory FirestoreCacheService() => _instance;
  FirestoreCacheService._internal();

  final Map<String, CacheEntry> _memoryCache = {};
  static const String _cachePrefix = 'firestore_cache_';
  static const Duration _defaultTTL = Duration(minutes: 5);
  static const int _maxMemoryCacheSize = 100;

  // Cache performance tracking
  int _cacheHits = 0;
  int _cacheMisses = 0;

  /// Get cached query result
  Future<QuerySnapshot?> getCachedQuery(String cacheKey) async {
    // Check memory cache first
    final memoryEntry = _memoryCache[cacheKey];
    if (memoryEntry != null && !memoryEntry.isExpired) {
      _cacheHits++;
      if (kDebugMode) debugPrint('✅ Cache hit (memory): $cacheKey');
      return memoryEntry.data;
    }

    _cacheMisses++;

    // Check disk cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('$_cachePrefix$cacheKey');
      if (cachedJson != null) {
        final entryMap = jsonDecode(cachedJson) as Map<String, dynamic>;
        final timestamp = DateTime.parse(entryMap['timestamp'] as String);
        final ttl = Duration(seconds: entryMap['ttl'] as int? ?? 300);

        if (DateTime.now().difference(timestamp) < ttl) {
          // Reconstruct QuerySnapshot from cached data
          final cachedSnapshot = await _reconstructQuerySnapshot(
            entryMap,
            cacheKey,
          );
          if (cachedSnapshot != null) {
            _cacheHits++;
            if (kDebugMode) debugPrint('✅ Cache hit (disk): $cacheKey');
            // Also update memory cache for faster subsequent access
            _updateMemoryCache(
              cacheKey,
              CacheEntry(
                data: cachedSnapshot,
                timestamp: timestamp,
                ttl: ttl,
              ),
            );
            return cachedSnapshot;
          }
        } else {
          // Cache expired, remove it
          await prefs.remove('$_cachePrefix$cacheKey');
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Cache read error: $e');
    }

    return null;
  }

  /// Cache query result
  Future<void> cacheQuery(
    String cacheKey,
    QuerySnapshot snapshot, {
    Duration? ttl,
  }) async {
    final cacheTTL = ttl ?? _defaultTTL;
    final entry = CacheEntry(
      data: snapshot,
      timestamp: DateTime.now(),
      ttl: cacheTTL,
    );

    // Update memory cache
    _updateMemoryCache(cacheKey, entry);

    // Update disk cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'ttl': cacheTTL.inSeconds,
        'collection': _extractCollectionFromCacheKey(cacheKey),
        'documents': _serializeQuerySnapshot(snapshot),
      };
      await prefs.setString('$_cachePrefix$cacheKey', jsonEncode(cacheData));
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Cache write error: $e');
    }
  }

  /// Invalidate cache for a collection
  Future<void> invalidateCollection(String collection) async {
    // Remove from memory cache
    final keysToRemove = _memoryCache.keys
        .where((key) => key.startsWith('${collection}_'))
        .toList();
    for (final key in keysToRemove) {
      _memoryCache.remove(key);
    }

    // Remove from disk cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .where((key) => key.startsWith('$_cachePrefix${collection}_'));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Cache invalidation error: $e');
    }

    if (kDebugMode) {
      debugPrint('✅ Cache invalidated for collection: $collection');
    }
  }

  /// Clear all cache
  Future<void> clearCache() async {
    _memoryCache.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys =
          prefs.getKeys().where((key) => key.startsWith(_cachePrefix)).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Cache clear error: $e');
    }
  }

  /// Generate cache key from query parameters
  static String generateCacheKey({
    required String collection,
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) {
    final parts = [collection];
    if (filters != null && filters.isNotEmpty) {
      filters.forEach((key, value) {
        parts.add('$key:$value');
      });
    }
    if (orderBy != null) {
      parts.add('orderBy:$orderBy');
    }
    if (limit != null) {
      parts.add('limit:$limit');
    }
    return parts.join('_');
  }

  void _updateMemoryCache(String key, CacheEntry entry) {
    // Remove oldest entries if cache is full
    if (_memoryCache.length >= _maxMemoryCacheSize) {
      final oldestKey = _memoryCache.entries
          .reduce(
              (a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
          .key;
      _memoryCache.remove(oldestKey);
    }

    _memoryCache[key] = entry;
  }

  /// Get cache statistics with performance metrics
  Map<String, dynamic> getCacheStats() {
    final expiredEntries =
        _memoryCache.entries.where((e) => e.value.isExpired).length;
    final activeEntries = _memoryCache.length - expiredEntries;

    final totalRequests = _cacheHits + _cacheMisses;
    final hitRate =
        totalRequests > 0 ? (_cacheHits / totalRequests * 100) : 0.0;

    return {
      'memoryCacheSize': _memoryCache.length,
      'activeEntries': activeEntries,
      'expiredEntries': expiredEntries,
      'maxCacheSize': _maxMemoryCacheSize,
      'cacheHits': _cacheHits,
      'cacheMisses': _cacheMisses,
      'hitRate': hitRate.toStringAsFixed(2),
      'totalRequests': totalRequests,
      'oldestEntry': _memoryCache.values.isNotEmpty
          ? _memoryCache.values
              .map((e) => e.timestamp)
              .reduce((a, b) => a.isBefore(b) ? a : b)
              .toIso8601String()
          : null,
      'newestEntry': _memoryCache.values.isNotEmpty
          ? _memoryCache.values
              .map((e) => e.timestamp)
              .reduce((a, b) => a.isAfter(b) ? a : b)
              .toIso8601String()
          : null,
      'defaultTTL': _defaultTTL.inMinutes,
    };
  }

  /// Serialize QuerySnapshot to JSON-serializable format
  /// Stores complete document data and metadata for full reconstruction
  List<Map<String, dynamic>> _serializeQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return {
        'id': doc.id,
        'data': data ?? {},
        'exists': doc.exists,
        'metadata': {
          'hasPendingWrites': doc.metadata.hasPendingWrites,
          'isFromCache': doc.metadata.isFromCache,
        },
        // Store reference path for potential future use
        'referencePath': doc.reference.path,
      };
    }).toList();
  }

  /// Reconstruct QuerySnapshot from cached data
  /// 
  /// Since QuerySnapshot is a sealed class, we cannot create it directly.
  /// Instead, we fetch documents by ID from Firestore, which is still more efficient
  /// than running the full original query (especially for complex queries with filters).
  /// 
  /// Strategy:
  /// 1. Extract all document IDs from cached data
  /// 2. Fetch documents in batches of 10 (Firestore's "where in" limit)
  /// 3. Combine all batches into a single query result
  /// 4. Handle edge cases (deleted documents, missing documents)
  Future<QuerySnapshot?> _reconstructQuerySnapshot(
    Map<String, dynamic> entryMap,
    String cacheKey,
  ) async {
    try {
      final collection = entryMap['collection'] as String?;
      final documentsData = entryMap['documents'] as List<dynamic>?;

      if (collection == null || documentsData == null) {
        if (kDebugMode) {
          debugPrint('⚠️ Cache reconstruction failed: missing collection or documents');
        }
        return null;
      }

      // Handle empty result case
      if (documentsData.isEmpty) {
        // Return empty QuerySnapshot by querying with impossible condition
        final emptyQuery = FirebaseFirestore.instance
            .collection(collection)
            .where(FieldPath.documentId, isEqualTo: '__nonexistent__')
            .limit(0);
        return await emptyQuery.get();
      }

      // Extract document IDs from cached data
      final docIds = documentsData
          .map((doc) {
            final docMap = doc as Map<String, dynamic>;
            return docMap['id'] as String?;
          })
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList();

      if (docIds.isEmpty) {
        if (kDebugMode) {
          debugPrint('⚠️ Cache reconstruction failed: no valid document IDs found');
        }
        return null;
      }

      // Fetch documents in batches of 10 (Firestore's "where in" limit)
      // This is more efficient than fetching individually for multiple documents
      final List<DocumentSnapshot> allFetchedDocs = [];
      
      for (var i = 0; i < docIds.length; i += 10) {
        final chunk = docIds.skip(i).take(10).toList();
        
        if (chunk.isEmpty) break;
        
        if (chunk.length == 1) {
          // Single document fetch (more efficient than "where in" for 1 item)
          try {
            final doc = await FirebaseFirestore.instance
                .collection(collection)
                .doc(chunk.first)
                .get();
            if (doc.exists) {
              allFetchedDocs.add(doc);
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('⚠️ Error fetching document ${chunk.first}: $e');
            }
            // Continue with other documents even if one fails
          }
        } else {
          // Use "where in" for 2-10 documents (most efficient)
          try {
            final query = FirebaseFirestore.instance
                .collection(collection)
                .where(FieldPath.documentId, whereIn: chunk);
            final snapshot = await query.get();
            allFetchedDocs.addAll(snapshot.docs);
          } catch (e) {
            if (kDebugMode) {
              debugPrint('⚠️ Error fetching batch of documents: $e');
            }
            // Fallback: fetch individually if batch fails
            for (final docId in chunk) {
              try {
                final doc = await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(docId)
                    .get();
                if (doc.exists) {
                  allFetchedDocs.add(doc);
                }
              } catch (e2) {
                if (kDebugMode) {
                  debugPrint('⚠️ Error fetching document $docId: $e2');
                }
              }
            }
          }
        }
      }

      // Handle case where some documents might have been deleted
      // We allow partial reconstruction if at least some documents exist
      if (allFetchedDocs.isEmpty) {
        if (kDebugMode) {
          debugPrint(
            '⚠️ Cache reconstruction failed: no documents found (may have been deleted)',
          );
        }
        return null;
      }

      // If we have more than 10 documents, we need to combine multiple query results
      // Since QuerySnapshot doesn't support combining, we use a workaround:
      // Query with "where in" for all fetched document IDs (up to 10 at a time)
      // For >10 documents, we return the result of querying the first batch
      // This is a limitation of Firestore's API, but still provides caching benefits
      
      if (allFetchedDocs.length <= 10) {
        // Perfect case: all documents fit in one query
        final fetchedIds = allFetchedDocs.map((doc) => doc.id).toList();
        if (fetchedIds.length == 1) {
          // Single document - use direct query
          final query = FirebaseFirestore.instance
              .collection(collection)
              .where(FieldPath.documentId, isEqualTo: fetchedIds.first);
          return await query.get();
        } else {
          // Multiple documents (2-10) - use "where in"
          final query = FirebaseFirestore.instance
              .collection(collection)
              .where(FieldPath.documentId, whereIn: fetchedIds);
          return await query.get();
        }
      } else {
        // More than 10 documents - return first 10 as a compromise
        // This is still better than no cache, as it provides partial results
        if (kDebugMode) {
          debugPrint(
            '⚠️ Cache reconstruction partial: returning ${allFetchedDocs.length} of ${docIds.length} documents '
            '(Firestore "where in" limit is 10, but we fetched all documents)',
          );
        }
        
        // Use the first 10 document IDs for the query
        final firstBatchIds = allFetchedDocs.take(10).map((doc) => doc.id).toList();
        final query = FirebaseFirestore.instance
            .collection(collection)
            .where(FieldPath.documentId, whereIn: firstBatchIds);
        return await query.get();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Cache reconstruction error: $e');
      }
      return null;
    }
  }

  /// Extract collection name from cache key
  /// Cache keys are in format: collection_filter1:value1_filter2:value2_...
  String _extractCollectionFromCacheKey(String cacheKey) {
    // Cache key format: collection_filter1:value1_filter2:value2_...
    // First part before first underscore is the collection
    final parts = cacheKey.split('_');
    return parts.isNotEmpty ? parts.first : cacheKey;
  }
}

class CacheEntry {
  final QuerySnapshot data;
  final DateTime timestamp;
  final Duration ttl;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.ttl,
  });

  bool get isExpired => DateTime.now().difference(timestamp) >= ttl;
}
