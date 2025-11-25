// lib/core/services/cache/user_profile_cache_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache service for user profiles to reduce Firestore reads
/// Profiles are cached for 1 hour and invalidated on updates
/// Caches raw Firestore document data as JSON
/// Expected savings: 50-70% reduction in profile reads
class UserProfileCacheService {
  static final UserProfileCacheService _instance =
      UserProfileCacheService._internal();
  factory UserProfileCacheService() => _instance;
  UserProfileCacheService._internal();

  static UserProfileCacheService get instance => _instance;

  static const String _cachePrefix = 'user_profile_cache_';
  static const String _timestampPrefix = 'user_profile_timestamp_';
  static const Duration _cacheExpiry = Duration(hours: 1);

  /// Get cached profile data by userId
  /// Returns null if not cached or expired
  /// Returns raw Map<String, dynamic> as stored in Firestore
  Future<Map<String, dynamic>?> getCachedProfileData(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if cache exists
      final cacheKey = '$_cachePrefix$userId';
      final timestampKey = '$_timestampPrefix$userId';

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

      // Deserialize cached profile data
      final profileData = jsonDecode(cachedData) as Map<String, dynamic>;
      return profileData;
    } catch (e) {
      // Cache error - return null to fallback to Firestore
      return null;
    }
  }

  /// Cache profile data (raw Firestore document data)
  /// Pass the raw Map<String, dynamic> from Firestore document
  Future<void> cacheProfileData(
      String userId, Map<String, dynamic> profileData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cacheKey = '$_cachePrefix$userId';
      final timestampKey = '$_timestampPrefix$userId';

      // Serialize profile data to JSON
      final profileJson = jsonEncode(profileData);

      // Save cache and timestamp
      await prefs.setString(cacheKey, profileJson);
      await prefs.setString(timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache error - silently fail (fallback to Firestore will work)
    }
  }

  /// Invalidate (remove) cached profile for a specific userId
  /// Call this when profile is updated to ensure fresh data
  Future<void> invalidateProfile(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cacheKey = '$_cachePrefix$userId';
      final timestampKey = '$_timestampPrefix$userId';

      await prefs.remove(cacheKey);
      await prefs.remove(timestampKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Clear all cached profiles
  /// Useful for logout or cache reset
  Future<void> clearAllProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Remove all profile cache keys
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
  Future<void> clearExpiredProfiles() async {
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
            // Extract userId from timestamp key
            final userId = timestampKey.replaceFirst(_timestampPrefix, '');
            final cacheKey = '$_cachePrefix$userId';

            // Remove expired cache
            await prefs.remove(cacheKey);
            await prefs.remove(timestampKey);
          }
        } catch (e) {
          // Invalid timestamp - remove it
          final userId = timestampKey.replaceFirst(_timestampPrefix, '');
          final cacheKey = '$_cachePrefix$userId';
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

  /// Check if profile is cached and valid
  Future<bool> isProfileCached(String userId) async {
    final cached = await getCachedProfileData(userId);
    return cached != null;
  }
}
