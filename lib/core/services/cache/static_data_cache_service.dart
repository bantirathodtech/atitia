// lib/core/services/cache/static_data_cache_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache service for static data (cities, amenities lists) to reduce processing
/// Static data extracted from PG data, cached for 24 hours
/// Caches cities and amenities lists as JSON
/// Expected savings: Reduced computation and Firestore reads for stats
class StaticDataCacheService {
  static final StaticDataCacheService _instance =
      StaticDataCacheService._internal();
  factory StaticDataCacheService() => _instance;
  StaticDataCacheService._internal();

  static StaticDataCacheService get instance => _instance;

  static const String _citiesCacheKey = 'static_data_cities_cache';
  static const String _amenitiesCacheKey = 'static_data_amenities_cache';
  static const String _citiesTimestampKey = 'static_data_cities_timestamp';
  static const String _amenitiesTimestampKey = 'static_data_amenities_timestamp';
  static const Duration _cacheExpiry = Duration(hours: 24); // 24 hours expiry

  /// Get cached cities list
  /// Returns null if not cached or expired
  Future<List<String>?> getCachedCities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cachedData = prefs.getString(_citiesCacheKey);
      final timestampString = prefs.getString(_citiesTimestampKey);
      
      if (cachedData == null || timestampString == null) {
        return null;
      }

      // Check if cache is expired
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      
      if (now.difference(timestamp) > _cacheExpiry) {
        // Cache expired, remove it
        await invalidateCities();
        return null;
      }

      // Deserialize cached cities
      final cities = List<String>.from(jsonDecode(cachedData) as List);
      return cities;
    } catch (e) {
      // Cache error - return null to fallback to computation
      return null;
    }
  }

  /// Cache cities list
  Future<void> cacheCities(List<String> cities) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Serialize cities to JSON
      final citiesJson = jsonEncode(cities);
      
      // Save cache and timestamp
      await prefs.setString(_citiesCacheKey, citiesJson);
      await prefs.setString(_citiesTimestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache error - silently fail
    }
  }

  /// Get cached amenities list
  /// Returns null if not cached or expired
  Future<List<String>?> getCachedAmenities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cachedData = prefs.getString(_amenitiesCacheKey);
      final timestampString = prefs.getString(_amenitiesTimestampKey);
      
      if (cachedData == null || timestampString == null) {
        return null;
      }

      // Check if cache is expired
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      
      if (now.difference(timestamp) > _cacheExpiry) {
        // Cache expired, remove it
        await invalidateAmenities();
        return null;
      }

      // Deserialize cached amenities
      final amenities = List<String>.from(jsonDecode(cachedData) as List);
      return amenities;
    } catch (e) {
      // Cache error - return null to fallback to computation
      return null;
    }
  }

  /// Cache amenities list
  Future<void> cacheAmenities(List<String> amenities) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Serialize amenities to JSON
      final amenitiesJson = jsonEncode(amenities);
      
      // Save cache and timestamp
      await prefs.setString(_amenitiesCacheKey, amenitiesJson);
      await prefs.setString(_amenitiesTimestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache error - silently fail
    }
  }

  /// Cache both cities and amenities together
  Future<void> cacheStaticData(List<String> cities, List<String> amenities) async {
    await Future.wait([
      cacheCities(cities),
      cacheAmenities(amenities),
    ]);
  }

  /// Invalidate cities cache
  Future<void> invalidateCities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_citiesCacheKey);
      await prefs.remove(_citiesTimestampKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Invalidate amenities cache
  Future<void> invalidateAmenities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_amenitiesCacheKey);
      await prefs.remove(_amenitiesTimestampKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Invalidate all static data cache
  Future<void> invalidateAll() async {
    await Future.wait([
      invalidateCities(),
      invalidateAmenities(),
    ]);
  }
}

