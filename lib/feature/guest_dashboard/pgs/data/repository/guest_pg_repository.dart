// lib/features/guest_dashboard/pgs/data/repository/guest_pg_repository.dart

import '../../../../../common/utils/constants/storage.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/interfaces/storage/storage_service_interface.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../models/guest_pg_model.dart';

/// Repository handling PG data operations and file uploads
/// Uses interface-based services for dependency injection (swappable backends)
/// Manages PG listings, details, and photo operations with proper error handling
class GuestPgRepository {
  final IDatabaseService _databaseService;
  final IStorageService _storageService;
  final IAnalyticsService _analyticsService;
  final InternationalizationService _i18n =
      InternationalizationService.instance;
  final InternationalizationService _uiI18n =
      InternationalizationService.instance;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _uiI18n.translate(key, parameters: parameters);
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
  GuestPgRepository({
    IDatabaseService? databaseService,
    IStorageService? storageService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _storageService =
            storageService ?? UnifiedServiceLocator.serviceFactory.storage,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Retrieves specific PG details by pgId from Firestore
  /// Returns null if PG document doesn't exist
  /// Throws exception for network or permission errors
  Future<GuestPgModel?> getPGById(String pgId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.pgs,
        pgId,
      );

      if (!doc.exists) {
        await _analyticsService.logEvent(
          name: _i18n.translate('pgNotFoundEvent'),
          parameters: {'pg_id': pgId},
        );
        return null;
      }

      final pg = GuestPgModel.fromMap(
        doc.data() as Map<String, dynamic>,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('pgViewedEvent'),
        parameters: {
          'pg_id': pgId,
          'pg_name': pg.pgName,
          'city': pg.city,
          'area': pg.area,
        },
      );

      return pg;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('pgFetchErrorEvent'),
        parameters: {
          'pg_id': pgId,
          'error': e.toString(),
        },
      );
      throw Exception(
        _text(
          'failedToFetchPgDetails',
          'Failed to load PG details: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Streams all available PGs with real-time updates
  /// Returns continuous stream for reactive UI updates
  /// Filters out inactive PGs and drafts for guest consumption
  /// OPTIMIZED: Filter at DB level using compound filters
  Stream<List<GuestPgModel>> getAllPGsStream() {
    // OPTIMIZED: Use compound filter to exclude drafts and inactive PGs at DB level
    return _databaseService
        .getCollectionStreamWithCompoundFilter(
          FirestoreConstants.pgs,
          [
            {'field': 'isDraft', 'value': false},
            {'field': 'isActive', 'value': true},
          ],
        )
        .map((snapshot) {
      final pgs = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return GuestPgModel.fromMap(data);
          })
          .toList();

      // Log analytics for PG list loaded
      _analyticsService.logEvent(
        name: _i18n.translate('pgsLoadedEvent'),
        parameters: {
          'total_pgs': pgs.length,
          'cities_count': pgs.map((pg) => pg.city).toSet().length,
        },
      );

      return pgs;
    });
  }

  /// Adds or updates PG document in Firestore
  /// Uses pgId as document ID for direct access
  /// Updates timestamp automatically on save
  Future<void> addOrUpdatePG(GuestPgModel pg) async {
    try {
      final pgData = pg.copyWith(updatedAt: DateTime.now());
      await _databaseService.setDocument(
        FirestoreConstants.pgs,
        pg.pgId,
        pgData.toMap(),
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('pgSavedEvent'),
        parameters: {
          'pg_id': pg.pgId,
          'pg_name': pg.pgName,
          'city': pg.city,
          'area': pg.area,
          'floors': pg.floors,
          'total_rooms': pg.totalRooms,
          'amenities_count': pg.amenities.length,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('pgSaveErrorEvent'),
        parameters: {
          'pg_id': pg.pgId,
          'error': e.toString(),
        },
      );
      throw Exception(
        _text(
          'failedToSavePg',
          'Failed to save PG: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Deletes PG document from Firestore
  /// Removes PG listing completely from database
  /// Throws exception for deletion failures
  Future<void> deletePG(String pgId) async {
    try {
      await _databaseService.deleteDocument(
        FirestoreConstants.pgs,
        pgId,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('pgDeletedEvent'),
        parameters: {'pg_id': pgId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('pgDeleteErrorEvent'),
        parameters: {
          'pg_id': pgId,
          'error': e.toString(),
        },
      );
      throw Exception(
        _text(
          'failedToDeletePg',
          'Failed to delete PG: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Uploads PG photo to Cloud Storage and returns download URL
  /// Organizes files by pgId for proper asset management
  /// Throws exception for upload failures
  Future<String> uploadPGPhoto(
    String pgId,
    String fileName,
    dynamic file,
  ) async {
    try {
      final path = '${StorageConstants.pgPhotos}$pgId/photos';
      final downloadUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('pgPhotoUploadedEvent'),
        parameters: {
          'pg_id': pgId,
          'file_name': fileName,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('pgPhotoUploadErrorEvent'),
        parameters: {
          'pg_id': pgId,
          'file_name': fileName,
          'error': e.toString(),
        },
      );
      throw Exception(
        _text(
          'failedToUploadPgPhoto',
          'Failed to upload PG photo: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Searches PGs by location, amenities, or other criteria
  /// Returns filtered list of matching PGs
  Future<List<GuestPgModel>> searchPGs({
    String? city,
    String? area,
    List<String>? amenities,
    double? minPrice,
    double? maxPrice,
    String? pgType,
    String? mealType,
    bool? wifiAvailable,
    bool? parkingAvailable,
  }) async {
    try {
      // This would typically use Firestore queries for better performance
      // For now, we'll filter from the stream
      final allPGs = await getAllPGsStream().first;

      final filteredPGs = allPGs.where((pg) {
        if (city != null &&
            !pg.city.toLowerCase().contains(city.toLowerCase())) {
          return false;
        }
        if (area != null &&
            !pg.area.toLowerCase().contains(area.toLowerCase())) {
          return false;
        }
        if (amenities != null && amenities.isNotEmpty) {
          final pgAmenities = pg.amenities.map((a) => a.toLowerCase()).toSet();
          final searchAmenities = amenities.map((a) => a.toLowerCase()).toSet();
          if (!pgAmenities.containsAll(searchAmenities)) {
            return false;
          }
        }
        if (pgType != null &&
            pg.pgType?.toLowerCase() != pgType.toLowerCase()) {
          return false;
        }
        if (mealType != null &&
            pg.mealType?.toLowerCase() != mealType.toLowerCase()) {
          return false;
        }
        if (wifiAvailable != null && pg.wifiAvailable != wifiAvailable) {
          return false;
        }
        if (parkingAvailable != null &&
            pg.parkingAvailable != parkingAvailable) {
          return false;
        }
        // Add price filtering logic here when pricing is implemented
        return true;
      }).toList();

      await _analyticsService.logEvent(
        name: _i18n.translate('pgSearchPerformedEvent'),
        parameters: {
          'search_criteria': {
            'city': city,
            'area': area,
            'amenities_count': amenities?.length ?? 0,
            'pg_type': pgType,
            'meal_type': mealType,
            'wifi_available': wifiAvailable?.toString(),
            'parking_available': parkingAvailable?.toString(),
          },
          'results_count': filteredPGs.length,
        },
      );

      return filteredPGs;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('pgSearchErrorEvent'),
        parameters: {'error': e.toString()},
      );
      throw Exception(
        _text(
          'failedToSearchPgs',
          'Failed to search PGs: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Gets PGs by owner UID for owner-specific listings
  /// Returns list of PGs owned by the specified user
  Future<List<GuestPgModel>> getPGsByOwner(String ownerUid) async {
    try {
      final allPGs = await getAllPGsStream().first;
      final ownerPGs = allPGs.where((pg) => pg.ownerUid == ownerUid).toList();

      await _analyticsService.logEvent(
        name: _i18n.translate('ownerPgsFetchedEvent'),
        parameters: {
          'owner_uid': ownerUid,
          'pgs_count': ownerPGs.length,
        },
      );

      return ownerPGs;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('ownerPgsFetchErrorEvent'),
        parameters: {
          'owner_uid': ownerUid,
          'error': e.toString(),
        },
      );
      throw Exception(
        _text(
          'failedToFetchOwnerPgs',
          'Failed to fetch owner PGs: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Gets PGs by city for location-based filtering
  /// Returns list of PGs in the specified city
  Future<List<GuestPgModel>> getPGsByCity(String city) async {
    try {
      final allPGs = await getAllPGsStream().first;
      final cityPGs = allPGs
          .where((pg) => pg.city.toLowerCase() == city.toLowerCase())
          .toList();

      await _analyticsService.logEvent(
        name: _i18n.translate('cityPgsFetchedEvent'),
        parameters: {
          'city': city,
          'pgs_count': cityPGs.length,
        },
      );

      return cityPGs;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('cityPgsFetchErrorEvent'),
        parameters: {
          'city': city,
          'error': e.toString(),
        },
      );
      throw Exception(
        _text(
          'failedToFetchCityPgs',
          'Failed to fetch city PGs: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Gets PGs by amenities for feature-based filtering
  /// Returns list of PGs that have all specified amenities
  Future<List<GuestPgModel>> getPGsByAmenities(List<String> amenities) async {
    try {
      final allPGs = await getAllPGsStream().first;
      final amenityPGs = allPGs.where((pg) {
        final pgAmenities = pg.amenities.map((a) => a.toLowerCase()).toSet();
        final searchAmenities = amenities.map((a) => a.toLowerCase()).toSet();
        return pgAmenities.containsAll(searchAmenities);
      }).toList();

      await _analyticsService.logEvent(
        name: _i18n.translate('amenityPgsFetchedEvent'),
        parameters: {
          'amenities': amenities,
          'pgs_count': amenityPGs.length,
        },
      );

      return amenityPGs;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('amenityPgsFetchErrorEvent'),
        parameters: {
          'amenities': amenities,
          'error': e.toString(),
        },
      );
      throw Exception(
        _text(
          'failedToFetchAmenityPgs',
          'Failed to fetch amenity PGs: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Gets PG statistics for analytics and dashboard
  /// Returns aggregated data about PGs
  Future<Map<String, dynamic>> getPGStats() async {
    try {
      final allPGs = await getAllPGsStream().first;

      final cities = allPGs.map((pg) => pg.city).toSet();
      final amenities = allPGs.expand((pg) => pg.amenities).toSet();
      final pgTypes = allPGs
          .where((pg) => pg.pgType != null)
          .map((pg) => pg.pgType!)
          .toSet();

      final stats = {
        'totalPGs': allPGs.length,
        'totalCities': cities.length,
        'totalAmenities': amenities.length,
        'totalPGTypes': pgTypes.length,
        'cities': cities.toList()..sort(),
        'amenities': amenities.toList()..sort(),
        'pgTypes': pgTypes.toList()..sort(),
        'avgRoomsPerPG': allPGs.isNotEmpty
            ? allPGs.map((pg) => pg.totalRooms).reduce((a, b) => a + b) /
                allPGs.length
            : 0.0,
        'avgBedsPerPG': allPGs.isNotEmpty
            ? allPGs.map((pg) => pg.totalBeds).reduce((a, b) => a + b) /
                allPGs.length
            : 0.0,
      };

      await _analyticsService.logEvent(
        name: _i18n.translate('pgStatsGeneratedEvent'),
        parameters: stats,
      );

      return stats;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('pgStatsErrorEvent'),
        parameters: {'error': e.toString()},
      );
      throw Exception(
        _text(
          'failedToGetPgStats',
          'Failed to get PG stats: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }
}
