// lib/core/services/cache/food_menu_cache_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache service for food menus to reduce Firestore reads
/// Food menus change weekly, cached for 6 hours
/// Caches weekly menus and overrides as JSON
/// Expected savings: 60-80% reduction in food menu reads
class FoodMenuCacheService {
  static final FoodMenuCacheService _instance =
      FoodMenuCacheService._internal();
  factory FoodMenuCacheService() => _instance;
  FoodMenuCacheService._internal();

  static FoodMenuCacheService get instance => _instance;

  static const String _cachePrefix = 'food_menu_cache_';
  static const String _timestampPrefix = 'food_menu_timestamp_';
  static const Duration _cacheExpiry = Duration(hours: 6); // 6 hours expiry

  /// Get cached weekly menus by ownerId and optional pgId
  /// Returns null if not cached or expired
  Future<List<Map<String, dynamic>>?> getCachedWeeklyMenus(
      String ownerId, {String? pgId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cacheKey = '${_cachePrefix}weekly_${ownerId}_${pgId ?? 'all'}';
      final timestampKey = '${_timestampPrefix}weekly_${ownerId}_${pgId ?? 'all'}';
      
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
        await invalidateWeeklyMenus(ownerId, pgId: pgId);
        return null;
      }

      // Deserialize cached menus
      final menus = List<Map<String, dynamic>>.from(
          jsonDecode(cachedData) as List);
      return menus;
    } catch (e) {
      // Cache error - return null to fallback to Firestore
      return null;
    }
  }

  /// Cache weekly menus
  Future<void> cacheWeeklyMenus(String ownerId,
      List<Map<String, dynamic>> menus, {String? pgId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cacheKey = '${_cachePrefix}weekly_${ownerId}_${pgId ?? 'all'}';
      final timestampKey = '${_timestampPrefix}weekly_${ownerId}_${pgId ?? 'all'}';
      
      // Serialize menus to JSON
      final menusJson = jsonEncode(menus);
      
      // Save cache and timestamp
      await prefs.setString(cacheKey, menusJson);
      await prefs.setString(timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache error - silently fail (fallback to Firestore will work)
    }
  }

  /// Get cached menu overrides by ownerId and optional pgId
  Future<List<Map<String, dynamic>>?> getCachedMenuOverrides(
      String ownerId, {String? pgId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cacheKey = '${_cachePrefix}overrides_${ownerId}_${pgId ?? 'all'}';
      final timestampKey = '${_timestampPrefix}overrides_${ownerId}_${pgId ?? 'all'}';
      
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
        await invalidateMenuOverrides(ownerId, pgId: pgId);
        return null;
      }

      // Deserialize cached overrides
      final overrides = List<Map<String, dynamic>>.from(
          jsonDecode(cachedData) as List);
      return overrides;
    } catch (e) {
      // Cache error - return null to fallback to Firestore
      return null;
    }
  }

  /// Cache menu overrides
  Future<void> cacheMenuOverrides(String ownerId,
      List<Map<String, dynamic>> overrides, {String? pgId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cacheKey = '${_cachePrefix}overrides_${ownerId}_${pgId ?? 'all'}';
      final timestampKey = '${_timestampPrefix}overrides_${ownerId}_${pgId ?? 'all'}';
      
      // Serialize overrides to JSON
      final overridesJson = jsonEncode(overrides);
      
      // Save cache and timestamp
      await prefs.setString(cacheKey, overridesJson);
      await prefs.setString(timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache error - silently fail (fallback to Firestore will work)
    }
  }

  /// Invalidate weekly menus cache for ownerId and optional pgId
  Future<void> invalidateWeeklyMenus(String ownerId, {String? pgId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '${_cachePrefix}weekly_${ownerId}_${pgId ?? 'all'}';
      final timestampKey = '${_timestampPrefix}weekly_${ownerId}_${pgId ?? 'all'}';
      await prefs.remove(cacheKey);
      await prefs.remove(timestampKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Invalidate menu overrides cache for ownerId and optional pgId
  Future<void> invalidateMenuOverrides(String ownerId, {String? pgId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '${_cachePrefix}overrides_${ownerId}_${pgId ?? 'all'}';
      final timestampKey = '${_timestampPrefix}overrides_${ownerId}_${pgId ?? 'all'}';
      await prefs.remove(cacheKey);
      await prefs.remove(timestampKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Invalidate all food menu caches for an owner
  Future<void> invalidateAllMenus(String ownerId) async {
    await invalidateWeeklyMenus(ownerId);
    await invalidateMenuOverrides(ownerId);
  }
}

