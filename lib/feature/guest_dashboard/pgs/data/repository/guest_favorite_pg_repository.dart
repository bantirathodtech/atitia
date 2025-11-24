// lib/feature/guest_dashboard/pgs/data/repository/guest_favorite_pg_repository.dart

import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/di/common/unified_service_locator.dart';

/// 🎨 **GUEST FAVORITE PG REPOSITORY - PRODUCTION READY**
///
/// Manages favorite PGs for guests
/// Uses Firestore to store favorite PG IDs
class GuestFavoritePgRepository {
  final IDatabaseService _databaseService;
  final InternationalizationService _i18n =
      InternationalizationService.instance;
  static const String _favoritesCollection = 'favorite_pgs';

  GuestFavoritePgRepository({
    IDatabaseService? databaseService,
  }) : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database;

  /// Add PG to favorites
  Future<void> addToFavorites(String guestId, String pgId) async {
    try {
      final favoriteId = '${guestId}_$pgId';
      await _databaseService.setDocument(
        _favoritesCollection,
        favoriteId,
        {
          'guestId': guestId,
          'pgId': pgId,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw Exception(_i18n.translate('failedToAddFavorite', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Remove PG from favorites
  Future<void> removeFromFavorites(String guestId, String pgId) async {
    try {
      final favoriteId = '${guestId}_$pgId';
      await _databaseService.deleteDocument(_favoritesCollection, favoriteId);
    } catch (e) {
      throw Exception(_i18n.translate('failedToRemoveFavorite', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Check if PG is in favorites
  Future<bool> isFavorite(String guestId, String pgId) async {
    try {
      final favoriteId = '${guestId}_$pgId';
      final doc = await _databaseService.getDocument(
        _favoritesCollection,
        favoriteId,
      );
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Stream favorite PG IDs for a guest
  Stream<List<String>> streamFavoritePgIds(String guestId) {
    return _databaseService
        .getCollectionStreamWithFilter(
          _favoritesCollection,
          'guestId',
          guestId,
        )
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['pgId'] as String)
          .toList();
    });
  }

  /// Get all favorite PG IDs for a guest (one-time read)
  Future<List<String>> getFavoritePgIds(String guestId) async {
    try {
      final snapshot = await _databaseService.queryDocuments(
        _favoritesCollection,
        field: 'guestId',
        isEqualTo: guestId,
      );

      return snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['pgId'] as String)
          .toList();
    } catch (e) {
      throw Exception(_i18n.translate('failedToGetFavorites', parameters: {
        'error': e.toString(),
      }));
    }
  }
}

