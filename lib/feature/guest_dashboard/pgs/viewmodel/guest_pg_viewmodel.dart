// lib/features/guest_dashboard/pgs/viewmodel/guest_pg_viewmodel.dart

import 'package:flutter/material.dart';

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../common/utils/logging/logging_mixin.dart';
import '../../../../common/utils/pg/pg_price_utils.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';

import '../../../../core/services/localization/internationalization_service.dart';
import '../../../../core/repositories/featured/featured_listing_repository.dart';
import '../data/models/guest_pg_model.dart';
import '../data/repository/guest_pg_repository.dart';

/// ViewModel for managing guest PGs UI state and business logic
/// Extends BaseProviderState for automatic service access and state management
/// Coordinates between UI layer and Repository layer
class GuestPgViewModel extends BaseProviderState with LoggingMixin {
  final GuestPgRepository _repository;
  final FeaturedListingRepository _featuredRepo;
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

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  GuestPgViewModel({
    GuestPgRepository? repository,
    FeaturedListingRepository? featuredRepo,
  })  : _repository = repository ?? GuestPgRepository(),
        _featuredRepo = featuredRepo ?? FeaturedListingRepository();

  List<GuestPgModel> _pgList = [];
  List<GuestPgModel> _filteredPGs = [];
  List<GuestPgModel> _cityPGs = [];
  List<GuestPgModel> _amenityPGs = [];
  GuestPgModel? _selectedPG;
  Set<String> _featuredPGIds = {}; // Set of featured PG IDs for quick lookup
  String _selectedFilter = 'All'; // All, By City, By Amenities
  String _searchQuery = '';
  Map<String, dynamic> _pgStats = {};
  List<String> _selectedAmenities = [];
  String? _selectedCity;
  String? _selectedPgType;
  String? _selectedMealType;
  bool? _wifiFilter;
  bool? _parkingFilter;
  double? _minPriceFilter;
  double? _maxPriceFilter;

  /// Read-only list of available PGs for UI consumption
  List<GuestPgModel> get pgList => _pgList;

  /// Read-only list of filtered PGs based on current filters
  List<GuestPgModel> get filteredPGs => _filteredPGs;

  /// Read-only list of PGs filtered by city
  List<GuestPgModel> get cityPGs => _cityPGs;

  /// Read-only list of PGs filtered by amenities
  List<GuestPgModel> get amenityPGs => _amenityPGs;

  /// Currently selected PG for detail view
  /// Returns null if no PG is selected
  GuestPgModel? get selectedPG => _selectedPG;

  /// Current filter selection
  String get selectedFilter => _selectedFilter;

  /// Current search query
  String get searchQuery => _searchQuery;

  /// PG statistics for dashboard
  Map<String, dynamic> get pgStats => _pgStats;

  /// Selected amenities for filtering
  List<String> get selectedAmenities => _selectedAmenities;

  /// Selected city for filtering
  String? get selectedCity => _selectedCity;

  /// Selected PG type for filtering
  String? get selectedPgType => _selectedPgType;

  /// Selected meal type for filtering
  String? get selectedMealType => _selectedMealType;

  /// WiFi filter status
  bool? get wifiFilter => _wifiFilter;

  /// Parking filter status
  bool? get parkingFilter => _parkingFilter;

  /// Minimum price filter
  double? get minPriceFilter => _minPriceFilter;

  /// Maximum price filter
  double? get maxPriceFilter => _maxPriceFilter;

  /// Check if a PG is featured
  bool isPGFeatured(String pgId) => _featuredPGIds.contains(pgId);

  /// Loads all available PGs with real-time streaming
  /// Sets up continuous listener for PG listing updates
  /// Automatically manages loading state through BaseProviderState
  void loadPGs(BuildContext context) {
    logMethodEntry('loadPGs');
    setLoading(true);
    clearError();

    logInfo(
      _text('guestPgStartingLoad', 'Starting to load PGs'),
      feature: 'guest_pgs',
    );

    // Load featured PG IDs first
    _loadFeaturedPGIds();

    // Listen to real-time PG updates
    _repository.getAllPGsStream().listen(
      (pgs) {
        _pgList = pgs;
        _updateFilteredPGs();
        _updatePGStats();
        setLoading(false);

        logInfo(
          _text('guestPgLoadSuccess', 'PGs loaded successfully'),
          feature: 'guest_pgs',
          metadata: {'count': pgs.length},
        );

        _analyticsService.logEvent(
          name: _i18n.translate('pgsLoadedEvent'),
          parameters: {
            'count': pgs.length,
          },
        );
      },
      onError: (error) {
        setError(
            true,
            _i18n.translate('failedToLoadPgs', parameters: {
              'error': error.toString(),
            }));
        setLoading(false);

        logError(
          _text('guestPgLoadFailure', 'Failed to load PGs'),
          feature: 'guest_pgs',
          error: error,
        );

        _analyticsService.logEvent(
          name: _i18n.translate('pgsLoadErrorEvent'),
          parameters: {
            'error': error.toString(),
          },
        );
      },
    );

    logMethodExit('loadPGs');
  }

  /// Refreshes PG data manually
  /// Useful for pull-to-refresh functionality
  void refreshPGs(BuildContext context) {
    logUserAction(
      _text('guestPgRefreshAction', 'Refresh PGs'),
      feature: 'guest_pgs',
    );
    loadPGs(context);
  }

  /// Sets the currently selected PG for detail view navigation
  /// Stores PG data in ViewModel state for parameter-less navigation
  void setSelectedPG(GuestPgModel pg) {
    _selectedPG = pg;
    notifyListeners();

    logUserAction(
      _text('guestPgSelectedAction', 'PG Selected'),
      feature: 'guest_pgs',
      metadata: {
        'pgId': pg.pgId,
        'pgName': pg.pgName,
        'city': pg.city,
        'area': pg.area,
      },
    );

    _analyticsService.logEvent(
      name: _i18n.translate('pgSelectedEvent'),
      parameters: {
        'pg_id': pg.pgId,
        'pg_name': pg.pgName,
        'city': pg.city,
        'area': pg.area,
      },
    );
  }

  /// Clears the currently selected PG
  /// Useful when navigating back from detail screen
  void clearSelectedPG() {
    _selectedPG = null;
    notifyListeners();

    logUserAction(
      _text('guestPgClearSelectionAction', 'Clear Selected PG'),
      feature: 'guest_pgs',
    );
  }

  /// Sets filter for PG listings
  void setFilter(String filter) {
    final oldFilter = _selectedFilter;
    _selectedFilter = filter;
    _updateFilteredPGs();
    notifyListeners();

    logStateChange(
      oldFilter,
      filter,
      feature: 'guest_pgs',
      metadata: {'filter': filter},
    );

    _analyticsService.logEvent(
      name: _i18n.translate('pgFilterChangedEvent'),
      parameters: {'filter': filter},
    );
  }

  /// Sets search query for PG listings
  void setSearchQuery(String query) {
    final oldQuery = _searchQuery;
    _searchQuery = query;
    _updateFilteredPGs();
    notifyListeners();

    logUserAction(
      _text('guestPgSearchQueryChangedAction', 'Search Query Changed'),
      feature: 'guest_pgs',
      metadata: {
        'oldQuery': oldQuery,
        'newQuery': query,
        'resultCount': _filteredPGs.length,
      },
    );

    _analyticsService.logEvent(
      name: _i18n.translate('pgSearchQueryChangedEvent'),
      parameters: {'query': query},
    );
  }

  /// Sets selected amenities for filtering
  void setSelectedAmenities(List<String> amenities) {
    _selectedAmenities = amenities;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgAmenitiesFilterChangedEvent'),
      parameters: {'amenities': amenities},
    );
  }

  /// Sets selected city for filtering
  void setSelectedCity(String? city) {
    _selectedCity = city;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgCityFilterChangedEvent'),
      parameters: {'city': city ?? 'all'},
    );
  }

  /// Sets selected PG type for filtering
  void setSelectedPgType(String? pgType) {
    _selectedPgType = pgType;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgTypeFilterChangedEvent'),
      parameters: {'pg_type': pgType ?? 'all'},
    );
  }

  /// Sets selected meal type for filtering
  void setSelectedMealType(String? mealType) {
    _selectedMealType = mealType;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgMealTypeFilterChangedEvent'),
      parameters: {'meal_type': mealType ?? 'all'},
    );
  }

  /// Sets WiFi filter
  void setWifiFilter(bool? wifiAvailable) {
    _wifiFilter = wifiAvailable;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgWifiFilterChangedEvent'),
      parameters: {'wifi_available': wifiAvailable?.toString() ?? 'all'},
    );
  }

  /// Sets parking filter
  void setParkingFilter(bool? parkingAvailable) {
    _parkingFilter = parkingAvailable;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgParkingFilterChangedEvent'),
      parameters: {'parking_available': parkingAvailable?.toString() ?? 'all'},
    );
  }

  /// Sets price range filter
  void setPriceRangeFilter(double? minPrice, double? maxPrice) {
    _minPriceFilter = minPrice;
    _maxPriceFilter = maxPrice;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgPriceRangeFilterChangedEvent'),
      parameters: {
        'min_price': minPrice?.toString() ?? 'none',
        'max_price': maxPrice?.toString() ?? 'none',
      },
    );
  }

  /// Clears all filters
  void clearAllFilters() {
    _selectedFilter = 'All';
    _searchQuery = '';
    _selectedAmenities = [];
    _selectedCity = null;
    _selectedPgType = null;
    _selectedMealType = null;
    _wifiFilter = null;
    _parkingFilter = null;
    _minPriceFilter = null;
    _maxPriceFilter = null;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: _i18n.translate('pgFiltersClearedEvent'),
      parameters: {},
    );
  }

  /// Retrieves specific PG details by ID from repository
  /// Useful for direct PG lookup without selection
  Future<GuestPgModel?> getPGById(String pgId) async {
    try {
      setLoading(true);
      clearError();
      final pg = await _repository.getPGById(pgId);
      setLoading(false);

      if (pg != null) {
        _selectedPG = pg;
        notifyListeners();
      }

      return pg;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToLoadPgDetails', parameters: {
            'error': e.toString(),
          }));
      setLoading(false);
      return null;
    }
  }

  /// Updates filtered PGs based on current filter and search query
  void _updateFilteredPGs() {
    List<GuestPgModel> filtered = _pgList;

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((pg) {
        final query = _searchQuery.toLowerCase();
        return pg.pgName.toLowerCase().contains(query) ||
            pg.city.toLowerCase().contains(query) ||
            pg.area.toLowerCase().contains(query) ||
            pg.address.toLowerCase().contains(query) ||
            pg.amenities
                .any((amenity) => amenity.toLowerCase().contains(query));
      }).toList();
    }

    // Apply city filter
    if (_selectedCity != null) {
      filtered = filtered
          .where((pg) => pg.city.toLowerCase() == _selectedCity!.toLowerCase())
          .toList();
    }

    // Apply PG type filter
    if (_selectedPgType != null) {
      filtered = filtered
          .where((pg) =>
              pg.pgType?.toLowerCase() == _selectedPgType!.toLowerCase())
          .toList();
    }

    // Apply meal type filter
    if (_selectedMealType != null) {
      filtered = filtered
          .where((pg) =>
              pg.mealType?.toLowerCase() == _selectedMealType!.toLowerCase())
          .toList();
    }

    // Apply WiFi filter
    if (_wifiFilter != null) {
      filtered =
          filtered.where((pg) => pg.wifiAvailable == _wifiFilter).toList();
    }

    // Apply parking filter
    if (_parkingFilter != null) {
      filtered = filtered
          .where((pg) => pg.parkingAvailable == _parkingFilter)
          .toList();
    }

    // Apply amenities filter
    if (_selectedAmenities.isNotEmpty) {
      filtered = filtered.where((pg) {
        final pgAmenities = pg.amenities.map((a) => a.toLowerCase()).toSet();
        final searchAmenities =
            _selectedAmenities.map((a) => a.toLowerCase()).toSet();
        return pgAmenities.containsAll(searchAmenities);
      }).toList();
    }

    // Apply price range filter
    if (_minPriceFilter != null || _maxPriceFilter != null) {
      filtered = filtered.where((pg) {
        // Get price from rentConfig using utility
        final minRent = PgPriceUtils.getMinRent(pg.rentConfig);
        final maxRent = PgPriceUtils.getMaxRent(pg.rentConfig);
        
        if (minRent == null || maxRent == null) return false;

        // Check if PG price range overlaps with filter range
        final filterMin = _minPriceFilter ?? 0.0;
        final filterMax = _maxPriceFilter ?? double.infinity;

        return (minRent >= filterMin && minRent <= filterMax) ||
            (maxRent >= filterMin && maxRent <= filterMax) ||
            (minRent <= filterMin && maxRent >= filterMax);
      }).toList();
    }

    // Apply filter based on selected filter type
    switch (_selectedFilter.toLowerCase()) {
      case 'by city':
        _cityPGs = filtered;
        break;
      case 'by amenities':
        _amenityPGs = filtered;
        break;
      default:
        // Show all
        break;
    }

    // Sort featured PGs first
    filtered.sort((a, b) {
      final aIsFeatured = _featuredPGIds.contains(a.pgId);
      final bIsFeatured = _featuredPGIds.contains(b.pgId);
      
      if (aIsFeatured && !bIsFeatured) return -1;
      if (!aIsFeatured && bIsFeatured) return 1;
      return 0; // Maintain original order for non-featured PGs
    });

    _filteredPGs = filtered;
  }

  /// Load featured PG IDs from repository
  Future<void> _loadFeaturedPGIds() async {
    try {
      final featuredIds = await _featuredRepo.getActiveFeaturedPGIds();
      _featuredPGIds = featuredIds.toSet();
      notifyListeners();
    } catch (e) {
      logError(
        'Failed to load featured PG IDs',
        feature: 'guest_pgs',
        error: e,
      );
      // Continue without featured sorting if loading fails
      _featuredPGIds = {};
    }
  }

  /// Updates PG statistics for dashboard display
  void _updatePGStats() {
    final cities = _pgList.map((pg) => pg.city).toSet();
    final totalAmenities = _pgList.expand((pg) => pg.amenities).toSet();
    final pgTypes = _pgList
        .where((pg) => pg.pgType != null)
        .map((pg) => pg.pgType!)
        .toSet();

    // Calculate price range
    final allRentConfigs = _pgList
        .map((pg) => pg.rentConfig)
        .where((config) => config != null && config.isNotEmpty)
        .toList();
    final priceRange = PgPriceUtils.getOverallPriceRange(allRentConfigs);

    _pgStats = {
      'totalPGs': _pgList.length,
      'totalCities': cities.length,
      'totalAmenities': totalAmenities.length,
      'totalPGTypes': pgTypes.length,
      'cities': cities.toList()..sort(),
      'amenities': totalAmenities.toList()..sort(),
      'pgTypes': pgTypes.toList()..sort(),
      'minPrice': priceRange['min'],
      'maxPrice': priceRange['max'],
      'avgRoomsPerPG': _pgList.isNotEmpty
          ? _pgList.map((pg) => pg.totalRooms).reduce((a, b) => a + b) /
              _pgList.length
          : 0.0,
      'avgBedsPerPG': _pgList.isNotEmpty
          ? _pgList.map((pg) => pg.totalBeds).reduce((a, b) => a + b) /
              _pgList.length
          : 0.0,
    };
  }

  /// Adds or updates PG in Firestore
  /// Handles both new PG creation and existing PG updates
  Future<void> addOrUpdatePG(GuestPgModel pg, BuildContext context) async {
    try {
      setLoading(true);
      clearError();
      await _repository.addOrUpdatePG(pg);
      _analyticsService.logEvent(
        name: _i18n.translate('pgSavedEvent'),
        parameters: {
          'pg_id': pg.pgId,
        },
      );
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToSavePg', parameters: {
            'error': e.toString(),
          }));
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Deletes PG from Firestore
  /// Removes PG listing completely from database
  Future<void> deletePG(String pgId, BuildContext context) async {
    try {
      setLoading(true);
      clearError();
      await _repository.deletePG(pgId);
      _analyticsService.logEvent(
        name: _i18n.translate('pgDeletedEvent'),
        parameters: {
          'pg_id': pgId,
        },
      );
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToDeletePg', parameters: {
            'error': e.toString(),
          }));
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Filters PGs by city for location-based browsing
  /// Returns filtered list of PGs matching the specified city
  List<GuestPgModel> getPGsByCity(String city) {
    return _pgList
        .where((pg) => pg.city.toLowerCase() == city.toLowerCase())
        .toList();
  }

  /// Gets unique cities from available PGs for location filtering
  /// Returns sorted list of cities with PG listings
  List<String> getAvailableCities() {
    final cities = _pgList.map((pg) => pg.city).toSet();
    return cities.toList()..sort();
  }

  /// Searches PGs by name, area, or city
  /// Returns filtered list based on search query
  List<GuestPgModel> searchPGs(String query) {
    if (query.isEmpty) return _pgList;

    final lowercaseQuery = query.toLowerCase();
    return _pgList
        .where((pg) =>
            pg.pgName.toLowerCase().contains(lowercaseQuery) ||
            pg.area.toLowerCase().contains(lowercaseQuery) ||
            pg.city.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  /// Gets total count of available PGs for summary display
  int get totalPGCount => _pgList.length;

  /// Gets filtered PG count for current view
  int get filteredPGCount => _filteredPGs.length;

  /// Checks if any PGs are currently available
  bool get hasPGs => _pgList.isNotEmpty;

  /// Checks if filtered PGs are available
  bool get hasFilteredPGs => _filteredPGs.isNotEmpty;

  /// Gets unique amenities from all PGs
  List<String> getAvailableAmenities() {
    final amenities = _pgList.expand((pg) => pg.amenities).toSet();
    return amenities.toList()..sort();
  }

  /// Gets PGs with specific amenities
  List<GuestPgModel> getPGsByAmenities(List<String> amenities) {
    return _pgList.where((pg) {
      final pgAmenities = pg.amenities.map((a) => a.toLowerCase()).toSet();
      final searchAmenities = amenities.map((a) => a.toLowerCase()).toSet();
      return pgAmenities.containsAll(searchAmenities);
    }).toList();
  }

  /// Gets unique PG types from all PGs
  List<String> getAvailablePgTypes() {
    final pgTypes = _pgList
        .where((pg) => pg.pgType != null)
        .map((pg) => pg.pgType!)
        .toSet();
    return pgTypes.toList()..sort();
  }

  /// Gets unique meal types from all PGs
  List<String> getAvailableMealTypes() {
    final mealTypes = _pgList
        .where((pg) => pg.mealType != null)
        .map((pg) => pg.mealType!)
        .toSet();
    return mealTypes.toList()..sort();
  }

  /// Loads PG statistics from repository
  Future<void> loadPGStats() async {
    try {
      setLoading(true);
      clearError();
      final stats = await _repository.getPGStats();
      _pgStats = stats;
      notifyListeners();
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToLoadPgStats', parameters: {
            'error': e.toString(),
          }));
    } finally {
      setLoading(false);
    }
  }

  /// Uploads PG photo and returns download URL
  Future<String?> uploadPGPhoto(
      String pgId, String fileName, dynamic file) async {
    try {
      setLoading(true);
      clearError();
      final downloadUrl = await _repository.uploadPGPhoto(
        pgId,
        fileName,
        file,
      );
      setLoading(false);
      return downloadUrl;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUploadPgPhoto', parameters: {
            'error': e.toString(),
          }));
      setLoading(false);
      return null;
    }
  }

  /// Performs advanced search with multiple criteria
  Future<List<GuestPgModel>> performAdvancedSearch({
    String? city,
    String? area,
    List<String>? amenities,
    String? pgType,
    String? mealType,
    bool? wifiAvailable,
    bool? parkingAvailable,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      setLoading(true);
      clearError();
      final results = await _repository.searchPGs(
        city: city,
        area: area,
        amenities: amenities,
        minPrice: minPrice,
        maxPrice: maxPrice,
        pgType: pgType,
        mealType: mealType,
        wifiAvailable: wifiAvailable,
        parkingAvailable: parkingAvailable,
      );
      setLoading(false);
      return results;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToPerformPgSearch', parameters: {
            'error': e.toString(),
          }));
      setLoading(false);
      return [];
    }
  }
}
