// lib/features/guest_dashboard/pgs/viewmodel/guest_pg_viewmodel.dart

import 'package:flutter/material.dart';

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../common/utils/logging/logging_mixin.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../data/models/guest_pg_model.dart';
import '../data/repository/guest_pg_repository.dart';

/// ViewModel for managing guest PGs UI state and business logic
/// Extends BaseProviderState for automatic service access and state management
/// Coordinates between UI layer and Repository layer
class GuestPgViewModel extends BaseProviderState with LoggingMixin {
  final GuestPgRepository _repository;
  final _analyticsService = getIt.analytics;

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  GuestPgViewModel({
    GuestPgRepository? repository,
  }) : _repository = repository ?? GuestPgRepository();

  List<GuestPgModel> _pgList = [];
  List<GuestPgModel> _filteredPGs = [];
  List<GuestPgModel> _cityPGs = [];
  List<GuestPgModel> _amenityPGs = [];
  GuestPgModel? _selectedPG;
  String _selectedFilter = 'All'; // All, By City, By Amenities
  String _searchQuery = '';
  Map<String, dynamic> _pgStats = {};
  List<String> _selectedAmenities = [];
  String? _selectedCity;
  String? _selectedPgType;
  String? _selectedMealType;
  bool? _wifiFilter;
  bool? _parkingFilter;

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

  /// Loads all available PGs with real-time streaming
  /// Sets up continuous listener for PG listing updates
  /// Automatically manages loading state through BaseProviderState
  void loadPGs(BuildContext context) {
    logMethodEntry('loadPGs');
    setLoading(true);
    clearError();

    logInfo('Starting to load PGs', feature: 'guest_pgs');

    // Listen to real-time PG updates
    _repository.getAllPGsStream().listen(
      (pgs) {
        _pgList = pgs;
        _updateFilteredPGs();
        _updatePGStats();
        setLoading(false);

        logInfo(
          'PGs loaded successfully',
          feature: 'guest_pgs',
          metadata: {'count': pgs.length},
        );

        _analyticsService.logEvent(
          name: 'pgs_loaded',
          parameters: {
            'count': pgs.length,
          },
        );
      },
      onError: (error) {
        setError(true, 'Failed to load PGs: $error');
        setLoading(false);

        logError(
          'Failed to load PGs',
          feature: 'guest_pgs',
          error: error,
        );

        _analyticsService.logEvent(
          name: 'pgs_load_error',
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
    logUserAction('Refresh PGs', feature: 'guest_pgs');
    loadPGs(context);
  }

  /// Sets the currently selected PG for detail view navigation
  /// Stores PG data in ViewModel state for parameter-less navigation
  void setSelectedPG(GuestPgModel pg) {
    _selectedPG = pg;
    notifyListeners();

    logUserAction(
      'PG Selected',
      feature: 'guest_pgs',
      metadata: {
        'pgId': pg.pgId,
        'pgName': pg.pgName,
        'city': pg.city,
        'area': pg.area,
      },
    );

    _analyticsService.logEvent(
      name: 'pg_selected',
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

    logUserAction('Clear Selected PG', feature: 'guest_pgs');
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
      name: 'pg_filter_changed',
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
      'Search Query Changed',
      feature: 'guest_pgs',
      metadata: {
        'oldQuery': oldQuery,
        'newQuery': query,
        'resultCount': _filteredPGs.length,
      },
    );

    _analyticsService.logEvent(
      name: 'pg_search_query_changed',
      parameters: {'query': query},
    );
  }

  /// Sets selected amenities for filtering
  void setSelectedAmenities(List<String> amenities) {
    _selectedAmenities = amenities;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: 'pg_amenities_filter_changed',
      parameters: {'amenities': amenities},
    );
  }

  /// Sets selected city for filtering
  void setSelectedCity(String? city) {
    _selectedCity = city;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: 'pg_city_filter_changed',
      parameters: {'city': city ?? 'all'},
    );
  }

  /// Sets selected PG type for filtering
  void setSelectedPgType(String? pgType) {
    _selectedPgType = pgType;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: 'pg_type_filter_changed',
      parameters: {'pg_type': pgType ?? 'all'},
    );
  }

  /// Sets selected meal type for filtering
  void setSelectedMealType(String? mealType) {
    _selectedMealType = mealType;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: 'pg_meal_type_filter_changed',
      parameters: {'meal_type': mealType ?? 'all'},
    );
  }

  /// Sets WiFi filter
  void setWifiFilter(bool? wifiAvailable) {
    _wifiFilter = wifiAvailable;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: 'pg_wifi_filter_changed',
      parameters: {'wifi_available': wifiAvailable?.toString() ?? 'all'},
    );
  }

  /// Sets parking filter
  void setParkingFilter(bool? parkingAvailable) {
    _parkingFilter = parkingAvailable;
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: 'pg_parking_filter_changed',
      parameters: {'parking_available': parkingAvailable?.toString() ?? 'all'},
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
    _updateFilteredPGs();
    notifyListeners();
    _analyticsService.logEvent(
      name: 'pg_filters_cleared',
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
      setError(true, 'Failed to load PG details: $e');
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

    _filteredPGs = filtered;
  }

  /// Updates PG statistics for dashboard display
  void _updatePGStats() {
    final cities = _pgList.map((pg) => pg.city).toSet();
    final totalAmenities = _pgList.expand((pg) => pg.amenities).toSet();
    final pgTypes = _pgList
        .where((pg) => pg.pgType != null)
        .map((pg) => pg.pgType!)
        .toSet();

    _pgStats = {
      'totalPGs': _pgList.length,
      'totalCities': cities.length,
      'totalAmenities': totalAmenities.length,
      'totalPGTypes': pgTypes.length,
      'cities': cities.toList()..sort(),
      'amenities': totalAmenities.toList()..sort(),
      'pgTypes': pgTypes.toList()..sort(),
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
        name: 'pg_saved',
        parameters: {
          'pg_id': pg.pgId,
        },
      );
    } catch (e) {
      setError(true, 'Failed to save PG: $e');
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
        name: 'pg_deleted',
        parameters: {
          'pg_id': pgId,
        },
      );
    } catch (e) {
      setError(true, 'Failed to delete PG: $e');
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
      setError(true, 'Failed to load PG stats: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Uploads PG photo and returns download URL
  Future<String> uploadPGPhoto(
      String pgId, String fileName, dynamic file) async {
    try {
      setLoading(true);
      clearError();
      final downloadUrl = await _repository.uploadPGPhoto(pgId, fileName, file);
      return downloadUrl;
    } catch (e) {
      setError(true, 'Failed to upload photo: $e');
      rethrow;
    } finally {
      setLoading(false);
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
        pgType: pgType,
        mealType: mealType,
        wifiAvailable: wifiAvailable,
        parkingAvailable: parkingAvailable,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      return results;
    } catch (e) {
      setError(true, 'Failed to perform search: $e');
      return [];
    } finally {
      setLoading(false);
    }
  }
}
