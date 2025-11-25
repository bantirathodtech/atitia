// lib/feature/guest_dashboard/pgs/viewmodel/guest_favorite_pg_viewmodel.dart

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../common/utils/logging/logging_mixin.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/services/localization/internationalization_service.dart';
import '../data/repository/guest_favorite_pg_repository.dart';

/// 🎨 **GUEST FAVORITE PG VIEWMODEL - PRODUCTION READY**
///
/// Manages favorite PGs state and operations for guests
class GuestFavoritePgViewModel extends BaseProviderState with LoggingMixin {
  final GuestFavoritePgRepository _repository;
  final _analyticsService = getIt.analytics;
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

  Set<String> _favoritePgIds = {};
  String? _currentGuestId;

  GuestFavoritePgViewModel({
    GuestFavoritePgRepository? repository,
  }) : _repository = repository ?? GuestFavoritePgRepository();

  /// Read-only set of favorite PG IDs
  Set<String> get favoritePgIds => _favoritePgIds;

  /// Check if a PG is in favorites
  bool isFavorite(String pgId) => _favoritePgIds.contains(pgId);

  /// Initialize favorites for a guest
  void initializeFavorites(String guestId) {
    if (_currentGuestId == guestId) return;

    _currentGuestId = guestId;
    clearError();

    // Stream favorite PG IDs
    _repository.streamFavoritePgIds(guestId).listen(
      (pgIds) {
        _favoritePgIds = pgIds.toSet();
        notifyListeners();
        logInfo(
          _text('favoritesLoaded', 'Favorites loaded'),
          feature: 'guest_favorites',
          metadata: {'count': pgIds.length},
        );
      },
      onError: (error) {
        setError(
          true,
          _i18n.translate('failedToLoadFavorites', parameters: {
            'error': error.toString(),
          }),
        );
        logError(
          _text('favoritesLoadError', 'Failed to load favorites'),
          feature: 'guest_favorites',
          error: error,
        );
      },
    );
  }

  /// Toggle favorite status for a PG
  Future<void> toggleFavorite(String guestId, String pgId) async {
    try {
      setLoading(true);
      clearError();

      final isCurrentlyFavorite = _favoritePgIds.contains(pgId);

      if (isCurrentlyFavorite) {
        await _repository.removeFromFavorites(guestId, pgId);
        _favoritePgIds.remove(pgId);
        logUserAction(
          _text('pgRemovedFromFavorites', 'PG removed from favorites'),
          feature: 'guest_favorites',
          metadata: {'pgId': pgId},
        );
      } else {
        await _repository.addToFavorites(guestId, pgId);
        _favoritePgIds.add(pgId);
        logUserAction(
          _text('pgAddedToFavorites', 'PG added to favorites'),
          feature: 'guest_favorites',
          metadata: {'pgId': pgId},
        );
      }

      notifyListeners();

      _analyticsService.logEvent(
        name: _i18n.translate('pgFavoriteToggledEvent'),
        parameters: {
          'pg_id': pgId,
          'is_favorite': !isCurrentlyFavorite,
        },
      );
    } catch (e) {
      setError(
        true,
        _i18n.translate('failedToToggleFavorite', parameters: {
          'error': e.toString(),
        }),
      );
      logError(
        _text('favoriteToggleError', 'Failed to toggle favorite'),
        feature: 'guest_favorites',
        error: e,
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Add PG to favorites
  Future<void> addToFavorites(String guestId, String pgId) async {
    if (_favoritePgIds.contains(pgId)) return;

    try {
      setLoading(true);
      clearError();
      await _repository.addToFavorites(guestId, pgId);
      _favoritePgIds.add(pgId);
      notifyListeners();

      _analyticsService.logEvent(
        name: _i18n.translate('pgAddedToFavoritesEvent'),
        parameters: {'pg_id': pgId},
      );
    } catch (e) {
      setError(
        true,
        _i18n.translate('failedToAddFavorite', parameters: {
          'error': e.toString(),
        }),
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Remove PG from favorites
  Future<void> removeFromFavorites(String guestId, String pgId) async {
    if (!_favoritePgIds.contains(pgId)) return;

    try {
      setLoading(true);
      clearError();
      await _repository.removeFromFavorites(guestId, pgId);
      _favoritePgIds.remove(pgId);
      notifyListeners();

      _analyticsService.logEvent(
        name: _i18n.translate('pgRemovedFromFavoritesEvent'),
        parameters: {'pg_id': pgId},
      );
    } catch (e) {
      setError(
        true,
        _i18n.translate('failedToRemoveFavorite', parameters: {
          'error': e.toString(),
        }),
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Clear all favorites (useful for logout)
  void clearFavorites() {
    _favoritePgIds.clear();
    _currentGuestId = null;
    notifyListeners();
  }
}
