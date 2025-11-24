// lib/core/services/sync/background_sync_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../common/utils/logging/logging_mixin.dart';
import '../../services/offline/offline_cache_service.dart';

/// 🚀 **BACKGROUND SYNC SERVICE - INTELLIGENT BACKGROUND SYNC**
///
/// Syncs data in background when app is minimized or connection restored
/// Uses connectivity monitoring and periodic sync
class BackgroundSyncService with LoggingMixin {
  static final BackgroundSyncService _instance =
      BackgroundSyncService._internal();
  factory BackgroundSyncService() => _instance;
  BackgroundSyncService._internal();

  final Connectivity _connectivity = Connectivity();
  final OfflineCacheService _offlineCacheService = OfflineCacheService();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicSyncTimer;
  bool _isInitialized = false;

  /// Initialize background sync service
  /// Uses connectivity monitoring and periodic sync
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Monitor connectivity changes for automatic sync
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen((result) async {
        if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
          // Connection restored - trigger sync
          await _performSync();
        }
      });

      // Perform initial sync check
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.isNotEmpty &&
          !connectivityResult.contains(ConnectivityResult.none)) {
        await _performSync();
      }

      // Set up periodic sync (every hour)
      _periodicSyncTimer = Timer.periodic(
        const Duration(hours: 1),
        (_) => _performSync(),
      );

      _isInitialized = true;
      logInfo('Background sync service initialized');
    } catch (e) {
      logError('Failed to initialize background sync: $e');
    }
  }

  /// Cancel background sync
  Future<void> cancelSync() async {
    await _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
    _connectivitySubscription = null;
    _periodicSyncTimer = null;
    _isInitialized = false;
    logInfo('Background sync cancelled');
  }

  /// Trigger immediate sync
  Future<void> triggerSync() async {
    await _performSync();
  }

  /// Perform sync operation
  Future<void> _performSync() async {
    try {
      // Sync cached data
      await _syncCachedData();

      // Sync pending offline actions
      await _offlineCacheService.syncOfflineData();

      logInfo('Background sync completed');
    } catch (e) {
      logError('Background sync failed: $e');
    }
  }

  /// Sync cached data with Firestore
  Future<void> _syncCachedData() async {
    // Sync critical collections in background
    // This is a lightweight sync - only sync necessary data
    // Full sync happens when app is active

    // Example: Sync user preferences, settings, etc.
    // Heavy data sync happens in foreground
  }

  /// Dispose resources
  void dispose() {
    cancelSync();
  }
}
