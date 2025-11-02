// lib/core/services/offline/offline_cache_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/firebase/di/firebase_service_locator.dart';
import '../../../common/utils/date/converter/date_service_converter.dart';

/// Offline cache service for storing and syncing data locally
/// Provides offline access to critical app data
class OfflineCacheService {
  static final OfflineCacheService _instance = OfflineCacheService._internal();
  factory OfflineCacheService() => _instance;
  OfflineCacheService._internal();

  static OfflineCacheService get instance => _instance;

  // Logger not available - removed for now
  final _analyticsService = getIt.analytics;

  static const String _cacheVersion = '1.0.0';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _offlineDataKey = 'offline_data';

  bool _isInitialized = false;
  String? _cacheDirectoryPath;
  Map<String, dynamic> _offlineData = {};

  /// Initialize offline cache service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
    // Logger not available: _logger.info call removed

      // Get cache directory
      final directory = await getApplicationDocumentsDirectory();
      _cacheDirectoryPath = '${directory.path}/atitia_cache';

      // Create cache directory if it doesn't exist
      final cacheDir = Directory(_cacheDirectoryPath!);
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      // Load existing offline data
      await _loadOfflineData();

      _isInitialized = true;

      await _analyticsService.logEvent(
        name: 'offline_cache_initialized',
        parameters: {
          'cache_directory': _cacheDirectoryPath ?? 'unknown',
          'data_size': _offlineData.length,
        },
      );

    // Logger not available: _logger.info call removed
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Cache data for offline access
  Future<void> cacheData(String key, dynamic data, {Duration? expiry}) async {
    if (!_isInitialized) await initialize();

    try {
      final cacheEntry = <String, dynamic>{
        'data': data,
        'timestamp': DateServiceConverter.toService(DateTime.now()),
        'expiry': expiry != null
            ? DateServiceConverter.toService(DateTime.now().add(expiry))
            : null,
      };

      _offlineData[key] = cacheEntry;
      await _saveOfflineData();

    // Logger not available: _logger call removed
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Retrieve cached data
  Future<T?> getCachedData<T>(String key) async {
    if (!_isInitialized) await initialize();

    try {
      final cacheEntry = _offlineData[key];
      if (cacheEntry == null) return null;

      // Check if data has expired
      if (cacheEntry['expiry'] != null) {
        final expiryDate =
            DateServiceConverter.fromService(cacheEntry['expiry']);
        if (DateTime.now().isAfter(expiryDate)) {
          _offlineData.remove(key);
          await _saveOfflineData();
          return null;
        }
      }

      final data = cacheEntry['data'];
      if (data is T) {
    // Logger not available: _logger call removed
        return data;
      }

      return null;
    } catch (e) {
    // Logger not available: _logger call removed
      return null;
    }
  }

  /// Cache PG data for offline access
  Future<void> cachePGData(List<dynamic> pgData) async {
    await cacheData(
      'pgs_data',
      pgData,
      expiry: const Duration(hours: 24), // Cache for 24 hours
    );
  }

  /// Get cached PG data
  Future<List<dynamic>?> getCachedPGData() async {
    return await getCachedData<List<dynamic>>('pgs_data');
  }

  /// Cache user profile data
  Future<void> cacheUserProfile(Map<String, dynamic> profileData) async {
    await cacheData(
      'user_profile',
      profileData,
      expiry: const Duration(days: 7), // Cache for 7 days
    );
  }

  /// Get cached user profile
  Future<Map<String, dynamic>?> getCachedUserProfile() async {
    return await getCachedData<Map<String, dynamic>>('user_profile');
  }

  /// Cache booking data
  Future<void> cacheBookingData(List<dynamic> bookingData) async {
    await cacheData(
      'bookings_data',
      bookingData,
      expiry: const Duration(hours: 12), // Cache for 12 hours
    );
  }

  /// Get cached booking data
  Future<List<dynamic>?> getCachedBookingData() async {
    return await getCachedData<List<dynamic>>('bookings_data');
  }

  /// Cache payment data
  Future<void> cachePaymentData(List<dynamic> paymentData) async {
    await cacheData(
      'payments_data',
      paymentData,
      expiry: const Duration(hours: 6), // Cache for 6 hours
    );
  }

  /// Get cached payment data
  Future<List<dynamic>?> getCachedPaymentData() async {
    return await getCachedData<List<dynamic>>('payments_data');
  }

  /// Check if data is available offline
  bool isDataAvailableOffline(String key) {
    return _offlineData.containsKey(key);
  }

  /// Get last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastSyncKey);
    return timestamp != null
        ? DateServiceConverter.fromService(timestamp)
        : null;
  }

  /// Set last sync timestamp
  Future<void> setLastSyncTime(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _lastSyncKey, DateServiceConverter.toService(timestamp));
  }

  /// Sync offline data with server
  Future<void> syncOfflineData() async {
    if (!_isInitialized) await initialize();

    try {
      // Logger not available: _logger.info call removed

      await _analyticsService.logEvent(
        name: 'offline_data_synced',
        parameters: {
          'sync_time': DateServiceConverter.toService(DateTime.now()),
          'data_keys': _offlineData.keys.toList(),
        },
      );

      // Logger not available: _logger.info call removed
    } catch (e) {
      // Logger not available: _logger.error call removed
    }
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    try {
      _offlineData.clear();
      await _saveOfflineData();

      // Clear cache directory
      if (_cacheDirectoryPath != null) {
        final cacheDir = Directory(_cacheDirectoryPath!);
        if (await cacheDir.exists()) {
          await cacheDir.delete(recursive: true);
          await cacheDir.create(recursive: true);
        }
      }

      // Logger not available: _logger.info call removed
    } catch (e) {
      // Logger not available: _logger.error call removed
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    final totalEntries = _offlineData.length;
    final expiredEntries = _offlineData.values.where((entry) {
      if (entry['expiry'] == null) return false;
      final expiryDate = DateServiceConverter.fromService(entry['expiry']);
      return DateTime.now().isAfter(expiryDate);
    }).length;

    return {
      'totalEntries': totalEntries,
      'expiredEntries': expiredEntries,
      'validEntries': totalEntries - expiredEntries,
      'cacheVersion': _cacheVersion,
      'isInitialized': _isInitialized,
    };
  }

  /// Load offline data from storage
  Future<void> _loadOfflineData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(_offlineDataKey);

      if (dataString != null) {
        _offlineData = Map<String, dynamic>.from(jsonDecode(dataString));

        // Clean up expired entries
        await _cleanupExpiredEntries();
      }
    } catch (e) {
    // Logger not available: _logger call removed
      _offlineData = {};
    }
  }

  /// Save offline data to storage
  Future<void> _saveOfflineData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = jsonEncode(_offlineData);
      await prefs.setString(_offlineDataKey, dataString);
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Clean up expired cache entries
  Future<void> _cleanupExpiredEntries() async {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _offlineData.entries) {
      final cacheEntry = entry.value;
      if (cacheEntry['expiry'] != null) {
        final expiryDate = DateTime.parse(cacheEntry['expiry']);
        if (now.isAfter(expiryDate)) {
          keysToRemove.add(entry.key);
        }
      }
    }

    for (final key in keysToRemove) {
      _offlineData.remove(key);
    }

    if (keysToRemove.isNotEmpty) {
      await _saveOfflineData();
    // Logger not available: _logger call removed
    }
  }

  /// Cache image for offline access
  Future<void> cacheImage(String imageUrl, List<int> imageBytes) async {
    if (!_isInitialized) await initialize();
    if (_cacheDirectoryPath == null) return;

    try {
      final fileName = _getImageFileName(imageUrl);
      final file = File('$_cacheDirectoryPath/$fileName');
      await file.writeAsBytes(imageBytes);

    // Logger not available: _logger call removed
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Get cached image file
  Future<File?> getCachedImage(String imageUrl) async {
    if (!_isInitialized) await initialize();
    if (_cacheDirectoryPath == null) return null;

    try {
      final fileName = _getImageFileName(imageUrl);
      final file = File('$_cacheDirectoryPath/$fileName');

      if (await file.exists()) {
        return file;
      }
    } catch (e) {
    // Logger not available: _logger call removed
    }

    return null;
  }

  /// Generate file name for cached image
  String _getImageFileName(String imageUrl) {
    final uri = Uri.parse(imageUrl);
    final pathSegments = uri.pathSegments;
    final fileName = pathSegments.isNotEmpty
        ? pathSegments.last
        : 'image_${DateTime.now().millisecondsSinceEpoch}';

    return 'img_${fileName.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
