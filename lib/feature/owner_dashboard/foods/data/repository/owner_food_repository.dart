// lib/features/owner_dashboard/foods/data/repository/owner_food_repository.dart

import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../common/utils/constants/storage.dart';
import '../../../../../common/utils/exceptions/exceptions.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/interfaces/storage/storage_service_interface.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/services/cache/food_menu_cache_service.dart';
import '../models/owner_food_menu.dart';

/// Repository for managing Owner's food menu data using interface-based services.
/// Uses interface-based services for dependency injection (swappable backends)
/// Manages weekly menus, daily overrides, and photo uploads with analytics tracking
class OwnerFoodRepository {
  final IDatabaseService _databaseService;
  final IStorageService _storageService;
  final IAnalyticsService _analyticsService;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerFoodRepository({
    IDatabaseService? databaseService,
    IStorageService? storageService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _storageService =
            storageService ?? UnifiedServiceLocator.serviceFactory.storage,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  // Collection names for storing menus and overrides in Firestore.
  static const String weeklyMenusCollection = 'owner_weekly_menus';
  static const String dailyOverridesCollection = 'owner_daily_overrides';

  /// Fetches all weekly menus from Firestore for a specific owner
  /// Returns list of weekly menus with real-time updates
  /// Uses cache first to reduce Firestore reads (60-80% reduction)
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, returns menus for that PG only
  /// - If pgId is null, returns menus for all PGs (or legacy data without pgId)
  Future<List<OwnerFoodMenu>> fetchWeeklyMenus(String ownerId,
      {String? pgId}) async {
    try {
      // Check cache first
      final cacheService = FoodMenuCacheService.instance;
      final cachedMenus =
          await cacheService.getCachedWeeklyMenus(ownerId, pgId: pgId);

      if (cachedMenus != null) {
        // Cache hit - reconstruct from cached data
        try {
          final menus =
              cachedMenus.map((data) => OwnerFoodMenu.fromMap(data)).toList();
          await _analyticsService.logEvent(
            name: 'owner_weekly_menus_cache_hit',
            parameters: {
              'owner_id': ownerId,
              'pg_id': pgId ?? 'all',
            },
          );
          return menus;
        } catch (e) {
          // Cache data corrupted, fall through to Firestore fetch
        }
      }

      // Cache miss - fetch from Firestore
      // Query Firestore with server-side filtering to minimize permissions scope
      List<OwnerFoodMenu> menus;
      if (pgId != null && pgId.isNotEmpty) {
        final snapshot = await _databaseService
            .getCollectionStreamWithCompoundFilter(weeklyMenusCollection, [
          {'field': 'ownerId', 'value': ownerId},
          {'field': 'pgId', 'value': pgId},
          {'field': 'isActive', 'value': true},
        ]).first;

        menus = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return OwnerFoodMenu.fromMap(data);
        }).toList();
      } else {
        // Fallback: owner-wide query
        final snapshot = await _databaseService
            .getCollectionStreamWithFilter(
                weeklyMenusCollection, 'ownerId', ownerId)
            .first;

        menus = snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return OwnerFoodMenu.fromMap(data);
            })
            .where((menu) => menu.isActive)
            .toList();
      }

      // Cache the fetched menus
      final menusData = menus.map((menu) => menu.toMap()).toList();
      await cacheService.cacheWeeklyMenus(ownerId, menusData, pgId: pgId);

      await _analyticsService.logEvent(
        name: 'owner_weekly_menus_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'menus_count': menus.length,
        },
      );

      return menus;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_weekly_menus_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodFetchMenusFailed',
          'Failed to fetch weekly menus',
        ),
        details: e.toString(),
      );
    }
  }

  /// Streams all weekly menus for real-time updates
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, streams menus for that PG only
  /// - If pgId is null, streams menus for all PGs (or legacy data without pgId)
  Stream<List<OwnerFoodMenu>> getWeeklyMenusStream(String ownerId,
      {String? pgId}) {
    // Prefer server-side filters
    // COST OPTIMIZATION: Limit to 30 menus per stream
    final stream = (pgId != null && pgId.isNotEmpty)
        ? _databaseService.getCollectionStreamWithCompoundFilter(
            weeklyMenusCollection,
            [
              {'field': 'ownerId', 'value': ownerId},
              {'field': 'pgId', 'value': pgId},
              {'field': 'isActive', 'value': true},
            ],
            limit: 30,
          )
        : _databaseService.getCollectionStreamWithFilter(
            weeklyMenusCollection,
            'ownerId',
            ownerId,
            limit: 30,
          );

    return stream.map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              OwnerFoodMenu.fromMap(doc.data() as Map<String, dynamic>))
          .where((m) => m.isActive)
          .toList();
    });
  }

  /// Fetches specific weekly menu by menuId
  Future<OwnerFoodMenu?> getWeeklyMenuById(String menuId) async {
    try {
      final doc = await _databaseService.getDocument(
        weeklyMenusCollection,
        menuId,
      );

      if (!doc.exists) return null;

      return OwnerFoodMenu.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_weekly_menu_fetch_error',
        parameters: {
          'menu_id': menuId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodFetchMenuFailed',
          'Failed to fetch weekly menu',
        ),
        details: e.toString(),
      );
    }
  }

  /// Fetches all daily menu overrides from Firestore for a specific owner
  /// Uses cache first to reduce Firestore reads (60-80% reduction)
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, returns overrides for that PG only
  /// - If pgId is null, returns overrides for all PGs (or legacy data without pgId)
  Future<List<OwnerMenuOverride>> fetchMenuOverrides(String ownerId,
      {String? pgId}) async {
    try {
      // Check cache first
      final cacheService = FoodMenuCacheService.instance;
      final cachedOverrides =
          await cacheService.getCachedMenuOverrides(ownerId, pgId: pgId);

      if (cachedOverrides != null) {
        // Cache hit - reconstruct from cached data
        try {
          final overrides = cachedOverrides
              .map((data) => OwnerMenuOverride.fromMap(data))
              .toList();
          await _analyticsService.logEvent(
            name: 'owner_menu_overrides_cache_hit',
            parameters: {
              'owner_id': ownerId,
              'pg_id': pgId ?? 'all',
            },
          );
          return overrides;
        } catch (e) {
          // Cache data corrupted, fall through to Firestore fetch
        }
      }

      // Cache miss - fetch from Firestore
      List<OwnerMenuOverride> overrides;
      if (pgId != null && pgId.isNotEmpty) {
        final snapshot = await _databaseService
            .getCollectionStreamWithCompoundFilter(dailyOverridesCollection, [
          {'field': 'ownerId', 'value': ownerId},
          {'field': 'pgId', 'value': pgId},
          {'field': 'isActive', 'value': true},
        ]).first;

        overrides = snapshot.docs
            .map((doc) =>
                OwnerMenuOverride.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        final snapshot = await _databaseService
            .getCollectionStreamWithFilter(
                dailyOverridesCollection, 'ownerId', ownerId)
            .first;

        overrides = snapshot.docs
            .map((doc) =>
                OwnerMenuOverride.fromMap(doc.data() as Map<String, dynamic>))
            .where((o) => o.isActive)
            .toList();
      }

      // Cache the fetched overrides
      final overridesData =
          overrides.map((override) => override.toMap()).toList();
      await cacheService.cacheMenuOverrides(ownerId, overridesData, pgId: pgId);

      await _analyticsService.logEvent(
        name: 'owner_menu_overrides_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'overrides_count': overrides.length,
        },
      );

      return overrides;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_menu_overrides_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodFetchOverridesFailed',
          'Failed to fetch menu overrides',
        ),
        details: e.toString(),
      );
    }
  }

  /// Streams all menu overrides for real-time updates
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, streams overrides for that PG only
  /// - If pgId is null, streams overrides for all PGs (or legacy data without pgId)
  Stream<List<OwnerMenuOverride>> getMenuOverridesStream(String ownerId,
      {String? pgId}) {
    // COST OPTIMIZATION: Limit to 30 overrides per stream
    final stream = (pgId != null && pgId.isNotEmpty)
        ? _databaseService.getCollectionStreamWithCompoundFilter(
            dailyOverridesCollection,
            [
              {'field': 'ownerId', 'value': ownerId},
              {'field': 'pgId', 'value': pgId},
              {'field': 'isActive', 'value': true},
            ],
            limit: 30,
          )
        : _databaseService.getCollectionStreamWithFilter(
            dailyOverridesCollection,
            'ownerId',
            ownerId,
            limit: 30,
          );

    return stream.map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              OwnerMenuOverride.fromMap(doc.data() as Map<String, dynamic>))
          .where((o) => o.isActive)
          .toList();
    });
  }

  /// Saves or updates a single weekly menu to Firestore
  /// Invalidates cache on save
  Future<void> saveWeeklyMenu(OwnerFoodMenu menu) async {
    try {
      final updatedMenu = menu.copyWith(updatedAt: DateTime.now());
      await _databaseService.setDocument(
        weeklyMenusCollection,
        menu.menuId,
        updatedMenu.toMap(),
      );

      // Invalidate cache when menu is saved
      await FoodMenuCacheService.instance.invalidateWeeklyMenus(
        menu.ownerId,
        pgId: menu.pgId,
      );

      await _analyticsService.logEvent(
        name: 'owner_weekly_menu_saved',
        parameters: {
          'menu_id': menu.menuId,
          'owner_id': menu.ownerId,
          'day': menu.day,
          'total_items': menu.totalItems,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_weekly_menu_save_error',
        parameters: {
          'menu_id': menu.menuId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodRepositorySaveMenuFailed',
          'Failed to save weekly menu',
        ),
        details: e.toString(),
      );
    }
  }

  /// Saves or updates the list of weekly menus to Firestore.
  Future<void> saveWeeklyMenus(List<OwnerFoodMenu> menus) async {
    try {
      for (var menu in menus) {
        await saveWeeklyMenu(menu);
      }

      await _analyticsService.logEvent(
        name: 'owner_weekly_menus_batch_saved',
        parameters: {
          'menus_count': menus.length,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_weekly_menus_batch_save_error',
        parameters: {
          'menus_count': menus.length,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodRepositorySaveMenusFailed',
          'Failed to save weekly menus',
        ),
        details: e.toString(),
      );
    }
  }

  /// Deletes a weekly menu from Firestore
  /// Invalidates cache on delete
  Future<void> deleteWeeklyMenu(String menuId) async {
    try {
      // Get menu first to get ownerId and pgId for cache invalidation
      final menu = await getWeeklyMenuById(menuId);

      await _databaseService.deleteDocument(
        weeklyMenusCollection,
        menuId,
      );

      // Invalidate cache when menu is deleted
      if (menu != null) {
        await FoodMenuCacheService.instance.invalidateWeeklyMenus(
          menu.ownerId,
          pgId: menu.pgId,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_weekly_menu_deleted',
        parameters: {'menu_id': menuId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_weekly_menu_delete_error',
        parameters: {
          'menu_id': menuId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodRepositoryDeleteMenuFailed',
          'Failed to delete weekly menu',
        ),
        details: e.toString(),
      );
    }
  }

  /// Saves or updates a daily menu override for a specific date.
  /// Invalidates cache on save
  Future<void> saveMenuOverride(OwnerMenuOverride override) async {
    try {
      final updatedOverride = override.copyWith(updatedAt: DateTime.now());
      await _databaseService.setDocument(
        dailyOverridesCollection,
        override.overrideId,
        updatedOverride.toMap(),
      );

      // Invalidate cache when override is saved
      await FoodMenuCacheService.instance.invalidateMenuOverrides(
        override.ownerId,
        pgId: override.pgId,
      );

      await _analyticsService.logEvent(
        name: 'owner_menu_override_saved',
        parameters: {
          'override_id': override.overrideId,
          'owner_id': override.ownerId,
          'date': override.formattedDate,
          'is_festival': override.isFestival,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_menu_override_save_error',
        parameters: {
          'override_id': override.overrideId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodRepositorySaveOverrideFailed',
          'Failed to save menu override',
        ),
        details: e.toString(),
      );
    }
  }

  /// Deletes a menu override from Firestore
  /// Invalidates cache on delete
  Future<void> deleteMenuOverride(String overrideId) async {
    try {
      // Get override first to get ownerId and pgId for cache invalidation
      final overrideDoc = await _databaseService.getDocument(
        dailyOverridesCollection,
        overrideId,
      );

      OwnerMenuOverride? override;
      if (overrideDoc.exists) {
        override = OwnerMenuOverride.fromMap(
            overrideDoc.data() as Map<String, dynamic>);
      }

      await _databaseService.deleteDocument(
        dailyOverridesCollection,
        overrideId,
      );

      // Invalidate cache when override is deleted
      if (override != null) {
        await FoodMenuCacheService.instance.invalidateMenuOverrides(
          override.ownerId,
          pgId: override.pgId,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_menu_override_deleted',
        parameters: {'override_id': overrideId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_menu_override_delete_error',
        parameters: {
          'override_id': overrideId,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodRepositoryDeleteOverrideFailed',
          'Failed to delete menu override',
        ),
        details: e.toString(),
      );
    }
  }

  /// Uploads a photo file to Firebase Storage and returns the download URL.
  /// Uploads food photo (cross-platform: mobile & web)
  /// Accepts File on mobile, XFile on web
  /// Storage service handles both types automatically
  Future<String> uploadPhoto(
    String ownerId,
    String fileName,
    dynamic file, // File on mobile, XFile on web
  ) async {
    try {
      final path = '${StorageConstants.foodPhotos}owner_$ownerId/';
      // Storage service auto-detects File vs XFile and handles appropriately
      final downloadUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: 'owner_food_photo_uploaded',
        parameters: {
          'owner_id': ownerId,
          'file_name': fileName,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_food_photo_upload_error',
        parameters: {
          'owner_id': ownerId,
          'file_name': fileName,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodRepositoryUploadPhotoFailed',
          'Failed to upload photo',
        ),
        details: e.toString(),
      );
    }
  }

  /// Deletes a photo from Firebase Storage
  Future<void> deletePhoto(String photoUrl) async {
    try {
      await _storageService.deleteFile(photoUrl);

      await _analyticsService.logEvent(
        name: 'owner_food_photo_deleted',
        parameters: {'photo_url': photoUrl},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_food_photo_delete_error',
        parameters: {
          'photo_url': photoUrl,
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodRepositoryDeletePhotoFailed',
          'Failed to delete photo',
        ),
        details: e.toString(),
      );
    }
  }

  /// Gets menu statistics for owner dashboard
  /// Generates menu statistics
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, generates stats for that specific PG
  /// - If pgId is null, generates stats for all PGs
  Future<Map<String, dynamic>> getMenuStats(String ownerId,
      {String? pgId}) async {
    try {
      final weeklyMenus = await fetchWeeklyMenus(ownerId, pgId: pgId);
      final overrides = await fetchMenuOverrides(ownerId, pgId: pgId);

      final stats = {
        'totalWeeklyMenus': weeklyMenus.length,
        'totalOverrides': overrides.length,
        'totalBreakfastItems': weeklyMenus.fold<int>(
            0, (sum, menu) => sum + menu.breakfast.length),
        'totalLunchItems':
            weeklyMenus.fold<int>(0, (sum, menu) => sum + menu.lunch.length),
        'totalDinnerItems':
            weeklyMenus.fold<int>(0, (sum, menu) => sum + menu.dinner.length),
        'totalPhotos': weeklyMenus.fold<int>(
            0, (sum, menu) => sum + menu.photoUrls.length),
        'upcomingFestivals': overrides
            .where((o) => o.isFestival && o.date.isAfter(DateTime.now()))
            .length,
        'pgId': pgId ?? 'all',
      };

      await _analyticsService.logEvent(
        name: 'owner_menu_stats_generated',
        parameters: stats,
      );

      return stats;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_menu_stats_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw AppException(
        message: _text(
          'ownerFoodFetchStatsFailed',
          'Failed to fetch menu stats',
        ),
        details: e.toString(),
      );
    }
  }
}
