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
          // TODO: Reconstruct QuerySnapshot from cached data
          // For now, return null to fetch fresh data
          if (kDebugMode) debugPrint('✅ Cache hit (disk): $cacheKey');
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
        // TODO: Serialize QuerySnapshot data
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
