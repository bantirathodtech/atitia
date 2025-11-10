// lib/features/owner_dashboard/foods/viewmodel/owner_food_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../common/utils/helpers/menu_initialization_helper.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/db/flutter_secure_storage.dart';
import '../../../../core/services/localization/internationalization_service.dart';
import '../data/models/owner_food_menu.dart';
import '../data/repository/owner_food_repository.dart';
import '../../../../core/repositories/food_feedback_repository.dart';

/// ViewModel for managing owner's food menus and dietary overrides.
/// Extends BaseProviderState for automatic service access and state management
/// Fetches and updates weekly menus and daily overrides from repository.
/// Supports uploading photos and maintains loading/error states with analytics tracking
class OwnerFoodViewModel extends BaseProviderState {
  final OwnerFoodRepository _repository;
  final _analyticsService = getIt.analytics;
  final LocalStorageService _localStorage = getIt<LocalStorageService>();
  final FoodFeedbackRepository _feedbackRepository;
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
  /// If repositories are not provided, creates them with default services
  OwnerFoodViewModel({
    OwnerFoodRepository? repository,
    FoodFeedbackRepository? feedbackRepository,
  })  : _repository = repository ?? OwnerFoodRepository(),
        _feedbackRepository = feedbackRepository ?? FoodFeedbackRepository();

  List<OwnerFoodMenu> _weeklyMenus = [];
  List<OwnerMenuOverride> _overrides = [];
  OwnerFoodMenu? _selectedMenu;
  OwnerMenuOverride? _selectedOverride;
  String _selectedDay = 'Monday';
  Map<String, dynamic> _menuStats = {};
  Map<String, Map<String, int>> _feedbackAgg = {
    'breakfast': {'likes': 0, 'dislikes': 0},
    'lunch': {'likes': 0, 'dislikes': 0},
    'dinner': {'likes': 0, 'dislikes': 0},
  };
  StreamSubscription<Map<String, Map<String, int>>>? _feedbackSub;

  // Track last loaded data for auto-reload optimization
  String? _lastLoadedOwnerId;
  String? _lastLoadedPgId;

  /// Read-only list of weekly menus
  List<OwnerFoodMenu> get weeklyMenus => _weeklyMenus;

  /// Read-only list of menu overrides
  List<OwnerMenuOverride> get overrides => _overrides;

  /// Currently selected menu for editing
  OwnerFoodMenu? get selectedMenu => _selectedMenu;

  /// Currently selected override for editing
  OwnerMenuOverride? get selectedOverride => _selectedOverride;

  /// Currently selected day
  String get selectedDay => _selectedDay;

  /// Menu statistics
  Map<String, dynamic> get menuStats => _menuStats;
  Map<String, Map<String, int>> get feedbackAggregates => _feedbackAgg;

  /// Loads weekly menus and daily overrides from backend.
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, loads menus for that specific PG
  /// - If pgId is null, loads all menus (backward compatible)
  Future<void> loadMenus(String ownerId, {String? pgId}) async {
    try {
      setLoading(true);
      clearError();

      _weeklyMenus = await _repository.fetchWeeklyMenus(ownerId, pgId: pgId);
      _overrides = await _repository.fetchMenuOverrides(ownerId, pgId: pgId);
      await _loadMenuStats(ownerId, pgId: pgId);
      _startFeedbackStream(pgId: pgId);

      // Update tracking variables
      _lastLoadedOwnerId = ownerId;
      _lastLoadedPgId = pgId;

      // Save state to local storage for persistence
      await _saveMenuState(ownerId, pgId);

      _analyticsService.logEvent(
        name: 'owner_menus_loaded',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'weekly_menus_count': _weeklyMenus.length,
          'overrides_count': _overrides.length,
        },
      );

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodLoadMenusFailed',
          'Failed to load menus: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      _weeklyMenus = [];
      _overrides = [];
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  /// Auto-reloads menus when PG selection changes
  /// Only reloads if the owner or PG has actually changed
  Future<void> autoReloadIfNeeded(String ownerId, {String? pgId}) async {
    if (_lastLoadedOwnerId != ownerId || _lastLoadedPgId != pgId) {
      await loadMenus(ownerId, pgId: pgId);
    } else {}
  }

  /// Refresh menus for current PG (force reload)
  Future<void> refreshMenus(String ownerId, {String? pgId}) async {
    await loadMenus(ownerId, pgId: pgId);
  }

  void _startFeedbackStream({String? pgId}) {
    _feedbackSub?.cancel();
    if (pgId == null) return;
    final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _feedbackSub = _feedbackRepository
        .streamAggregates(pgId: pgId, dateKey: dateKey)
        .listen((agg) {
      _feedbackAgg = agg;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _feedbackSub?.cancel();
    super.dispose();
  }

  /// Save current menu state to local storage
  Future<void> _saveMenuState(String ownerId, String? pgId) async {
    try {
      if (pgId != null) {
        await _localStorage.write('food_menu_loaded_$ownerId', pgId);
        await _localStorage.write(
            'food_menu_timestamp_$ownerId', DateTime.now().toIso8601String());
      }
    } catch (e) {
      debugPrint(
        _text(
          'ownerFoodSaveStateFailedLog',
          '⚠️ Owner Food ViewModel: Failed to save menu state: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Clear menu state and force reload
  Future<void> clearMenuState(String ownerId) async {
    try {
      await _localStorage.delete('food_menu_loaded_$ownerId');
      await _localStorage.delete('food_menu_timestamp_$ownerId');
      _lastLoadedOwnerId = null;
      _lastLoadedPgId = null;
      _weeklyMenus = [];
      _overrides = [];
      notifyListeners();
    } catch (e) {
      debugPrint(
        _text(
          'ownerFoodClearStateFailedLog',
          '⚠️ Owner Food ViewModel: Failed to clear menu state: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  /// Streams weekly menus for real-time updates
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, streams menus for that specific PG
  /// - If pgId is null, streams all menus (backward compatible)
  void streamWeeklyMenus(String ownerId, {String? pgId}) {
    setLoading(true);
    clearError();

    _repository.getWeeklyMenusStream(ownerId, pgId: pgId).listen(
      (menus) {
        _weeklyMenus = menus;
        setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        setError(
          true,
          _text(
            'ownerFoodStreamMenusFailed',
            'Failed to stream menus: {error}',
            parameters: {'error': error.toString()},
          ),
        );
        setLoading(false);
      },
    );
  }

  /// Streams menu overrides for real-time updates
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, streams overrides for that specific PG
  /// - If pgId is null, streams all overrides (backward compatible)
  void streamMenuOverrides(String ownerId, {String? pgId}) {
    _repository.getMenuOverridesStream(ownerId, pgId: pgId).listen(
      (overrides) {
        _overrides = overrides;
        notifyListeners();
      },
      onError: (error) {
        setError(
          true,
          _text(
            'ownerFoodStreamOverridesFailed',
            'Failed to stream overrides: {error}',
            parameters: {'error': error.toString()},
          ),
        );
      },
    );
  }

  /// Saves a single weekly menu
  Future<bool> saveWeeklyMenu(OwnerFoodMenu menu) async {
    try {
      setLoading(true);
      clearError();
      await _repository.saveWeeklyMenu(menu);

      _analyticsService.logEvent(
        name: 'owner_weekly_menu_save_success',
        parameters: {
          'menu_id': menu.menuId,
          'day': menu.day,
        },
      );

      // Notify listeners to update UI
      notifyListeners();
      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodSaveMenuFailed',
          'Failed to save menu: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Saves updated weekly menus and refreshes data.
  Future<bool> saveWeeklyMenus(List<OwnerFoodMenu> menus) async {
    try {
      setLoading(true);
      clearError();
      await _repository.saveWeeklyMenus(menus);

      _analyticsService.logEvent(
        name: 'owner_weekly_menus_save_success',
        parameters: {'menus_count': menus.length},
      );

      // Notify listeners to update UI
      notifyListeners();
      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodSaveMenusFailed',
          'Failed to save menus: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Deletes a weekly menu
  Future<bool> deleteWeeklyMenu(String menuId) async {
    try {
      setLoading(true);
      clearError();
      await _repository.deleteWeeklyMenu(menuId);

      _analyticsService.logEvent(
        name: 'owner_weekly_menu_delete_success',
        parameters: {'menu_id': menuId},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodDeleteMenuFailed',
          'Failed to delete menu: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Saves or updates a daily override and refreshes data.
  Future<bool> saveOverride(OwnerMenuOverride override) async {
    try {
      setLoading(true);
      clearError();
      await _repository.saveMenuOverride(override);

      _analyticsService.logEvent(
        name: 'owner_menu_override_save_success',
        parameters: {
          'override_id': override.overrideId,
          'date': override.formattedDate,
        },
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodSaveOverrideFailed',
          'Failed to save override: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Deletes a menu override
  Future<bool> deleteMenuOverride(String overrideId) async {
    try {
      setLoading(true);
      clearError();
      await _repository.deleteMenuOverride(overrideId);

      _analyticsService.logEvent(
        name: 'owner_menu_override_delete_success',
        parameters: {'override_id': overrideId},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodDeleteOverrideFailed',
          'Failed to delete override: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Uploads a photo to storage and returns download URL
  /// Uploads food photo (cross-platform: mobile & web)
  /// Accepts File on mobile, XFile on web
  Future<String?> uploadPhoto(
    String ownerId,
    String filename,
    dynamic file, // File on mobile, XFile on web
  ) async {
    try {
      setLoading(true);
      clearError();
      final downloadUrl =
          await _repository.uploadPhoto(ownerId, filename, file);

      _analyticsService.logEvent(
        name: 'owner_food_photo_upload_success',
        parameters: {
          'owner_id': ownerId,
          'file_name': filename,
        },
      );

      return downloadUrl;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodUploadPhotoFailed',
          'Failed to upload photo: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Deletes a photo from storage
  Future<bool> deletePhoto(String photoUrl) async {
    try {
      setLoading(true);
      clearError();
      await _repository.deletePhoto(photoUrl);

      _analyticsService.logEvent(
        name: 'owner_food_photo_delete_success',
        parameters: {'photo_url': photoUrl},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodDeletePhotoFailed',
          'Failed to delete photo: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Returns combined menu for a specific date,
  /// applying daily overrides if present.
  OwnerFoodMenu getMenuForDate(DateTime date) {
    final override = getOverrideForDate(date);
    final weekly = _getWeeklyMenuForDate(date);

    if (override != null) {
      // Override meals and photos if specified, else fallback to weekly
      return OwnerFoodMenu(
        menuId: weekly.menuId,
        ownerId: weekly.ownerId,
        day: weekly.day,
        breakfast: override.breakfast ?? weekly.breakfast,
        lunch: override.lunch ?? weekly.lunch,
        dinner: override.dinner ?? weekly.dinner,
        photoUrls: override.photoUrls ?? weekly.photoUrls,
        createdAt: weekly.createdAt,
        updatedAt: DateTime.now(),
        isActive: weekly.isActive,
        description: override.specialNote ?? weekly.description,
      );
    }

    return weekly;
  }

  /// Finds the daily override entry for a given date.
  /// Returns null if none found.
  OwnerMenuOverride? getOverrideForDate(DateTime date) {
    try {
      return _overrides.firstWhere((o) =>
          o.date.year == date.year &&
          o.date.month == date.month &&
          o.date.day == date.day);
    } catch (_) {
      return null;
    }
  }

  /// Finds the weekly menu entry for the weekday of given date.
  /// Returns a blank menu if none found.
  OwnerFoodMenu _getWeeklyMenuForDate(DateTime date) {
    final dayStr = _weekdayString(date);
    try {
      return _weeklyMenus.firstWhere((menu) => menu.day == dayStr);
    } catch (_) {
      // Return blank menu if no weekly data found for the day
      return OwnerFoodMenu(
        menuId: 'temp_${dayStr.toLowerCase()}',
        ownerId: '',
        day: dayStr,
        breakfast: [],
        lunch: [],
        dinner: [],
        photoUrls: [],
      );
    }
  }

  /// Gets menu by day name
  OwnerFoodMenu? getMenuByDay(String day) {
    try {
      return _weeklyMenus.firstWhere((menu) => menu.day == day);
    } catch (_) {
      return null;
    }
  }

  /// Sets the selected day for menu viewing/editing
  void setSelectedDay(String day) {
    _selectedDay = day;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_menu_day_selected',
      parameters: {'day': day},
    );
  }

  /// Sets the selected menu for editing
  void setSelectedMenu(OwnerFoodMenu menu) {
    _selectedMenu = menu;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_menu_selected',
      parameters: {
        'menu_id': menu.menuId,
        'day': menu.day,
      },
    );
  }

  /// Sets the selected override for editing
  void setSelectedOverride(OwnerMenuOverride override) {
    _selectedOverride = override;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_override_selected',
      parameters: {
        'override_id': override.overrideId,
        'date': override.formattedDate,
      },
    );
  }

  /// Clears selected menu
  void clearSelectedMenu() {
    _selectedMenu = null;
    notifyListeners();
  }

  /// Clears selected override
  void clearSelectedOverride() {
    _selectedOverride = null;
    notifyListeners();
  }

  /// Loads menu statistics
  Future<void> _loadMenuStats(String ownerId, {String? pgId}) async {
    try {
      _menuStats = await _repository.getMenuStats(ownerId, pgId: pgId);
      notifyListeners();
    } catch (e) {
      // Stats loading failure shouldn't block main functionality
      _menuStats = {};
    }
  }

  /// Helper converts DateTime to weekday string
  String _weekdayString(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[date.weekday - 1];
  }

  /// Gets list of all weekday names
  List<String> get weekdays => [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];

  /// Gets upcoming overrides (future dates)
  List<OwnerMenuOverride> get upcomingOverrides {
    final now = DateTime.now();
    return _overrides.where((override) => override.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Gets past overrides (past dates)
  List<OwnerMenuOverride> get pastOverrides {
    final now = DateTime.now();
    return _overrides.where((override) => override.date.isBefore(now)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Gets festival overrides
  List<OwnerMenuOverride> get festivalOverrides {
    return _overrides.where((override) => override.isFestival).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Checks if menu exists for a specific day
  bool hasMenuForDay(String day) {
    return _weeklyMenus.any((menu) => menu.day == day);
  }

  /// Checks if override exists for a specific date
  bool hasOverrideForDate(DateTime date) {
    return getOverrideForDate(date) != null;
  }

  /// Gets total menu items count
  int get totalMenuItems {
    return _weeklyMenus.fold<int>(0, (sum, menu) => sum + menu.totalItems);
  }

  /// Gets total overrides count
  int get totalOverrides => _overrides.length;

  /// Checks if any menus are available
  bool get hasMenus => _weeklyMenus.isNotEmpty;

  /// Checks if any overrides are available
  bool get hasOverrides => _overrides.isNotEmpty;

  /// Initializes default weekly menus for a new owner
  /// Creates sample menus for all 7 days with default items
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, creates menus for that specific PG
  /// - If pgId is null, creates menus for all PGs (backward compatible)
  Future<bool> initializeDefaultMenus(String ownerId, {String? pgId}) async {
    try {
      setLoading(true);
      clearError();

      // Check if menus already exist for this PG
      final existingMenus =
          await _repository.fetchWeeklyMenus(ownerId, pgId: pgId);
      if (existingMenus.isNotEmpty) {
        setError(true, 'Menus already exist for this PG');
        return false;
      }

      // Create default menus with PG association
      final defaultMenus = MenuInitializationHelper.createDefaultWeeklyMenus(
          ownerId,
          pgId: pgId);

      // Save all default menus
      await _repository.saveWeeklyMenus(defaultMenus);

      // Reload menus
      await loadMenus(ownerId, pgId: pgId);

      _analyticsService.logEvent(
        name: 'owner_default_menus_initialized',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'menus_count': defaultMenus.length,
        },
      );

      // Notify listeners to update UI
      notifyListeners();
      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodInitializeDefaultsFailed',
          'Failed to initialize default menus: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Updates menu for the current day
  Future<bool> updateCurrentDayMenu({
    required String ownerId,
    required List<String> breakfast,
    required List<String> lunch,
    required List<String> dinner,
    List<String>? photoUrls,
    String? description,
  }) async {
    try {
      setLoading(true);
      clearError();

      final currentDay = MenuInitializationHelper.weekdayString(DateTime.now());
      final existingMenu = getMenuByDay(currentDay);

      final menuId = existingMenu?.menuId ??
          '${ownerId}_${currentDay.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';

      final updatedMenu = OwnerFoodMenu(
        menuId: menuId,
        ownerId: ownerId,
        day: currentDay,
        breakfast: breakfast,
        lunch: lunch,
        dinner: dinner,
        photoUrls: photoUrls ?? existingMenu?.photoUrls ?? [],
        description: description,
        isActive: true,
        createdAt: existingMenu?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.saveWeeklyMenu(updatedMenu);

      _analyticsService.logEvent(
        name: 'owner_current_day_menu_updated',
        parameters: {
          'owner_id': ownerId,
          'day': currentDay,
        },
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerFoodUpdateCurrentMenuFailed',
          'Failed to update current day menu: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Gets the current day's menu
  OwnerFoodMenu? get currentDayMenu {
    return MenuInitializationHelper.getCurrentDayMenu(_weeklyMenus);
  }

  /// Checks if menus need initialization
  bool needsInitialization() {
    return _weeklyMenus.isEmpty;
  }

  /// Creates an empty menu for a specific day
  OwnerFoodMenu createEmptyMenuForDay(String ownerId, String day,
      {String? pgId}) {
    return MenuInitializationHelper.createEmptyMenu(ownerId, day, pgId: pgId);
  }

  /// Gets menu override for a specific date
  /// Returns the special menu override if it exists for the given date
  OwnerMenuOverride? getMenuOverrideForDate(DateTime date) {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    for (final override in _overrides) {
      final overrideDateString =
          '${override.date.year}-${override.date.month.toString().padLeft(2, '0')}-${override.date.day.toString().padLeft(2, '0')}';
      if (overrideDateString == dateString && override.isActive) {
        return override;
      }
    }
    return null;
  }
}
