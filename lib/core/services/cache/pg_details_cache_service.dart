// lib/core/services/cache/pg_details_cache_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache service for PG details to reduce Firestore reads
/// PG details are cached for 4 hours (they change less frequently than profiles)
/// Caches raw Firestore document data as JSON
/// Expected savings: 60-80% reduction in PG detail reads
class PgDetailsCacheService {
  static final PgDetailsCacheService _instance =
      PgDetailsCacheService._internal();
  factory PgDetailsCacheService() => _instance;
  PgDetailsCacheService._internal();

  static PgDetailsCacheService get instance => _instance;

  static const String _cachePrefix = 'pg_details_cache_';
  static const String _timestampPrefix = 'pg_details_timestamp_';
  static const Duration _cacheExpiry = Duration(hours: 4); // 4 hours expiry

  /// Get cached PG details data by pgId
  /// Returns null if not cached or expired
  /// Returns raw Map<String, dynamic> as stored in Firestore
  Future<Map<String, dynamic>?> getCachedPGDetails(String pgId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if cache exists
      final cacheKey = '$_cachePrefix$pgId';
      final timestampKey = '$_timestampPrefix$pgId';

      final cachedData = prefs.getString(cacheKey);
      final timestampString = prefs.getString(timestampKey);

      if (cachedData == null || timestampString == null) {
        return null;
      }

      // Check if cache is expired
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      if (now.difference(timestamp) > _cacheExpiry) {
        // Cache expired, remove it
        await prefs.remove(cacheKey);
        await prefs.remove(timestampKey);
        return null;
      }

      // Deserialize cached PG details data
      final pgData = jsonDecode(cachedData) as Map<String, dynamic>;
      return pgData;
    } catch (e) {
      // Cache error - return null to fallback to Firestore
      return null;
    }
  }

  /// Cache PG details data (raw Firestore document data)
  /// Pass the raw Map<String, dynamic> from Firestore document
  Future<void> cachePGDetails(String pgId, Map<String, dynamic> pgData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cacheKey = '$_cachePrefix$pgId';
      final timestampKey = '$_timestampPrefix$pgId';

      // Serialize PG data to JSON
      final pgJson = jsonEncode(pgData);

      // Save cache and timestamp
      await prefs.setString(cacheKey, pgJson);
      await prefs.setString(timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache error - silently fail (fallback to Firestore will work)
    }
  }

  /// Invalidate (remove) cached PG details for a specific pgId
  /// Call this when PG is updated to ensure fresh data
  Future<void> invalidatePGDetails(String pgId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cacheKey = '$_cachePrefix$pgId';
      final timestampKey = '$_timestampPrefix$pgId';

      await prefs.remove(cacheKey);
      await prefs.remove(timestampKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Clear all cached PG details
  /// Useful for logout or cache reset
  Future<void> clearAllPGDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Remove all PG cache keys
      final keysToRemove = keys.where((key) =>
          key.startsWith(_cachePrefix) || key.startsWith(_timestampPrefix));

      for (final key in keysToRemove) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Clear expired cache entries
  /// Call this periodically to clean up expired entries
  Future<void> clearExpiredPGDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final now = DateTime.now();

      // Find all timestamp keys
      final timestampKeys =
          keys.where((key) => key.startsWith(_timestampPrefix));

      for (final timestampKey in timestampKeys) {
        final timestampString = prefs.getString(timestampKey);
        if (timestampString == null) continue;

        try {
          final timestamp = DateTime.parse(timestampString);
          if (now.difference(timestamp) > _cacheExpiry) {
            // Extract pgId from timestamp key
            final pgId = timestampKey.replaceFirst(_timestampPrefix, '');
            final cacheKey = '$_cachePrefix$pgId';

            // Remove expired cache
            await prefs.remove(cacheKey);
            await prefs.remove(timestampKey);
          }
        } catch (e) {
          // Invalid timestamp - remove it
          final pgId = timestampKey.replaceFirst(_timestampPrefix, '');
          final cacheKey = '$_cachePrefix$pgId';
          await prefs.remove(cacheKey);
          await prefs.remove(timestampKey);
        }
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cacheExpiry': _cacheExpiry.inHours,
      'cachePrefix': _cachePrefix,
    };
  }

  /// Check if PG details are cached and valid
  Future<bool> isPGCached(String pgId) async {
    final cached = await getCachedPGDetails(pgId);
    return cached != null;
  }
}
