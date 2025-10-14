// lib/features/owner_dashboard/foods/data/repository/owner_food_repository.dart


import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../common/utils/constants/storage.dart';
import '../models/owner_food_menu.dart';

/// Repository for managing Owner's food menu data using Firebase services.
/// Uses Firebase service locator for dependency injection
/// Manages weekly menus, daily overrides, and photo uploads with analytics tracking
class OwnerFoodRepository {
  final _firestoreService = getIt.firestore;
  final _storageService = getIt.storage;
  final _analyticsService = getIt.analytics;

  // Collection names for storing menus and overrides in Firestore.
  static const String weeklyMenusCollection = 'owner_weekly_menus';
  static const String dailyOverridesCollection = 'owner_daily_overrides';

  /// Fetches all weekly menus from Firestore for a specific owner
  /// Returns list of weekly menus with real-time updates
  /// 
  /// Multi-PG Support:
  /// - If pgId is provided, returns menus for that PG only
  /// - If pgId is null, returns menus for all PGs (or legacy data without pgId)
  Future<List<OwnerFoodMenu>> fetchWeeklyMenus(String ownerId, {String? pgId}) async {
    try {
      final snapshot = await _firestoreService
          .getCollectionStream(weeklyMenusCollection)
          .first;

      final menus = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return OwnerFoodMenu.fromMap(data);
          })
          .where((menu) {
            // Filter by owner
            if (menu.ownerId != ownerId || !menu.isActive) return false;
            
            // Multi-PG filtering:
            // - If pgId is provided, include only menus for that PG
            // - Also include legacy menus (menu.pgId == null) for backward compatibility
            if (pgId != null) {
              return menu.pgId == null || menu.pgId == pgId;
            }
            
            // If no pgId filter, return all menus
            return true;
          })
          .toList();

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
      throw Exception('Failed to fetch weekly menus: $e');
    }
  }

  /// Streams all weekly menus for real-time updates
  /// 
  /// Multi-PG Support:
  /// - If pgId is provided, streams menus for that PG only
  /// - If pgId is null, streams menus for all PGs (or legacy data without pgId)
  Stream<List<OwnerFoodMenu>> getWeeklyMenusStream(String ownerId, {String? pgId}) {
    return _firestoreService
        .getCollectionStream(weeklyMenusCollection)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return OwnerFoodMenu.fromMap(data);
          })
          .where((menu) {
            // Filter by owner
            if (menu.ownerId != ownerId || !menu.isActive) return false;
            
            // Multi-PG filtering:
            // - If pgId is provided, include only menus for that PG
            // - Also include legacy menus (menu.pgId == null) for backward compatibility
            if (pgId != null) {
              return menu.pgId == null || menu.pgId == pgId;
            }
            
            // If no pgId filter, return all menus
            return true;
          })
          .toList();
    });
  }

  /// Fetches specific weekly menu by menuId
  Future<OwnerFoodMenu?> getWeeklyMenuById(String menuId) async {
    try {
      final doc = await _firestoreService.getDocument(
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
      throw Exception('Failed to fetch weekly menu: $e');
    }
  }

  /// Fetches all daily menu overrides from Firestore for a specific owner
  /// 
  /// Multi-PG Support:
  /// - If pgId is provided, returns overrides for that PG only
  /// - If pgId is null, returns overrides for all PGs (or legacy data without pgId)
  Future<List<OwnerMenuOverride>> fetchMenuOverrides(String ownerId, {String? pgId}) async {
    try {
      final snapshot = await _firestoreService
          .getCollectionStream(dailyOverridesCollection)
          .first;

      final overrides = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return OwnerMenuOverride.fromMap(data);
          })
          .where((override) {
            // Filter by owner
            if (override.ownerId != ownerId || !override.isActive) return false;
            
            // Multi-PG filtering:
            // - If pgId is provided, include only overrides for that PG
            // - Also include legacy overrides (override.pgId == null) for backward compatibility
            if (pgId != null) {
              return override.pgId == null || override.pgId == pgId;
            }
            
            // If no pgId filter, return all overrides
            return true;
          })
          .toList();

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
      throw Exception('Failed to fetch menu overrides: $e');
    }
  }

  /// Streams all menu overrides for real-time updates
  /// 
  /// Multi-PG Support:
  /// - If pgId is provided, streams overrides for that PG only
  /// - If pgId is null, streams overrides for all PGs (or legacy data without pgId)
  Stream<List<OwnerMenuOverride>> getMenuOverridesStream(String ownerId, {String? pgId}) {
    return _firestoreService
        .getCollectionStream(dailyOverridesCollection)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return OwnerMenuOverride.fromMap(data);
          })
          .where((override) {
            // Filter by owner
            if (override.ownerId != ownerId || !override.isActive) return false;
            
            // Multi-PG filtering:
            // - If pgId is provided, include only overrides for that PG
            // - Also include legacy overrides (override.pgId == null) for backward compatibility
            if (pgId != null) {
              return override.pgId == null || override.pgId == pgId;
            }
            
            // If no pgId filter, return all overrides
            return true;
          })
          .toList();
    });
  }

  /// Saves or updates a single weekly menu to Firestore
  Future<void> saveWeeklyMenu(OwnerFoodMenu menu) async {
    try {
      final updatedMenu = menu.copyWith(updatedAt: DateTime.now());
      await _firestoreService.setDocument(
        weeklyMenusCollection,
        menu.menuId,
        updatedMenu.toMap(),
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
      throw Exception('Failed to save weekly menu: $e');
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
      throw Exception('Failed to save weekly menus: $e');
    }
  }

  /// Deletes a weekly menu from Firestore
  Future<void> deleteWeeklyMenu(String menuId) async {
    try {
      await _firestoreService.deleteDocument(
        weeklyMenusCollection,
        menuId,
      );

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
      throw Exception('Failed to delete weekly menu: $e');
    }
  }

  /// Saves or updates a daily menu override for a specific date.
  Future<void> saveMenuOverride(OwnerMenuOverride override) async {
    try {
      final updatedOverride = override.copyWith(updatedAt: DateTime.now());
      await _firestoreService.setDocument(
        dailyOverridesCollection,
        override.overrideId,
        updatedOverride.toMap(),
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
      throw Exception('Failed to save menu override: $e');
    }
  }

  /// Deletes a menu override from Firestore
  Future<void> deleteMenuOverride(String overrideId) async {
    try {
      await _firestoreService.deleteDocument(
        dailyOverridesCollection,
        overrideId,
      );

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
      throw Exception('Failed to delete menu override: $e');
    }
  }

  /// Uploads a photo file to Firebase Storage and returns the download URL.
  /// Uploads food photo (cross-platform: mobile & web)
  /// Accepts File on mobile, XFile on web
  /// Storage service handles both types automatically
  Future<String> uploadPhoto(
    String ownerId,
    String fileName,
    dynamic file,  // File on mobile, XFile on web
  ) async {
    try {
      final path = '${StorageConstants.foodPhotos}owner_$ownerId/';
      // Storage service auto-detects File vs XFile and handles appropriately
      final downloadUrl = await _storageService.uploadFile(file, path, fileName);

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
      throw Exception('Failed to upload photo: $e');
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
      throw Exception('Failed to delete photo: $e');
    }
  }

  /// Gets menu statistics for owner dashboard
  /// Generates menu statistics
  /// 
  /// Multi-PG Support:
  /// - If pgId is provided, generates stats for that specific PG
  /// - If pgId is null, generates stats for all PGs
  Future<Map<String, dynamic>> getMenuStats(String ownerId, {String? pgId}) async {
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
        'totalPhotos':
            weeklyMenus.fold<int>(0, (sum, menu) => sum + menu.photoUrls.length),
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
      throw Exception('Failed to fetch menu stats: $e');
    }
  }
}

