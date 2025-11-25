// lib/core/services/cache/featured_listings_cache_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache service for featured listings to reduce Firestore reads
/// Featured listings rarely change, cached for 12 hours
/// Caches active featured PG IDs as JSON list
/// Expected savings: 70-90% reduction in featured listing reads
class FeaturedListingsCacheService {
  static final FeaturedListingsCacheService _instance =
      FeaturedListingsCacheService._internal();
  factory FeaturedListingsCacheService() => _instance;
  FeaturedListingsCacheService._internal();

  static FeaturedListingsCacheService get instance => _instance;

  static const String _cacheKey = 'featured_listings_cache';
  static const String _timestampKey = 'featured_listings_timestamp';
  static const Duration _cacheExpiry = Duration(hours: 12); // 12 hours expiry

  /// Get cached active featured PG IDs
  /// Returns null if not cached or expired
  Future<List<String>?> getCachedFeaturedPGIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cachedData = prefs.getString(_cacheKey);
      final timestampString = prefs.getString(_timestampKey);

      if (cachedData == null || timestampString == null) {
        return null;
      }

      // Check if cache is expired
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      if (now.difference(timestamp) > _cacheExpiry) {
        // Cache expired, remove it
        await invalidateCache();
        return null;
      }

      // Deserialize cached PG IDs
      final pgIds = List<String>.from(jsonDecode(cachedData) as List);
      return pgIds;
    } catch (e) {
      // Cache error - return null to fallback to Firestore
      return null;
    }
  }

  /// Cache active featured PG IDs
  Future<void> cacheFeaturedPGIds(List<String> pgIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Serialize PG IDs to JSON
      final pgIdsJson = jsonEncode(pgIds);

      // Save cache and timestamp
      await prefs.setString(_cacheKey, pgIdsJson);
      await prefs.setString(_timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache error - silently fail (fallback to Firestore will work)
    }
  }

  /// Invalidate (remove) cached featured listings
  /// Call this when featured listings are updated
  Future<void> invalidateCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_timestampKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Check if featured listings are cached and valid
  Future<bool> isCacheValid() async {
    final cached = await getCachedFeaturedPGIds();
    return cached != null;
  }
}
