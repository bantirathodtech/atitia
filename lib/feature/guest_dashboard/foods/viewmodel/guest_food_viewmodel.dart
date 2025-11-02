// lib/features/guest_dashboard/foods/viewmodel/guest_food_viewmodel.dart

import 'package:flutter/material.dart';

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../common/utils/logging/logging_mixin.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/repositories/booking_repository.dart';
import '../../../../core/models/booking_model.dart';
import '../../../auth/logic/auth_provider.dart';
import '../../../owner_dashboard/foods/data/models/owner_food_menu.dart';
import '../../../owner_dashboard/foods/data/repository/owner_food_repository.dart';
import '../../../../core/repositories/food_feedback_repository.dart';
import 'package:intl/intl.dart';

/// 🍽️ **GUEST FOOD VIEWMODEL - PRODUCTION READY**
///
/// **Responsibilities:**
/// - Load weekly menu from guest's booked PG
/// - Display today's menu prominently
/// - Show special menu overrides
/// - Handle loading/error states
/// - Analytics tracking
class GuestFoodViewmodel extends BaseProviderState with LoggingMixin {
  final OwnerFoodRepository _repository;
  final BookingRepository _bookingRepository;
  final _analyticsService = getIt.analytics;
  final FoodFeedbackRepository _feedbackRepository;

  /// Constructor with dependency injection
  /// If repositories are not provided, creates them with default services
  GuestFoodViewmodel({
    OwnerFoodRepository? repository,
    BookingRepository? bookingRepository,
    FoodFeedbackRepository? feedbackRepository,
  })  : _repository = repository ?? OwnerFoodRepository(),
        _bookingRepository = bookingRepository ?? BookingRepository(),
        _feedbackRepository = feedbackRepository ?? FoodFeedbackRepository();

  List<OwnerFoodMenu> _weeklyMenus = [];
  List<OwnerMenuOverride> _specialMenus = [];
  String? _bookedPgId;
  String? _ownerIdOfPg;

  /// Read-only list of weekly menus
  List<OwnerFoodMenu> get weeklyMenus => _weeklyMenus;

  /// Read-only list of special menus
  List<OwnerMenuOverride> get specialMenus => _specialMenus;

  /// Gets menu for a specific day
  OwnerFoodMenu? getMenuForDay(String day) {
    try {
      return _weeklyMenus.firstWhere(
        (menu) => menu.day.toLowerCase() == day.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadBookedPgIfNeeded() async {
    if (_bookedPgId != null) return;
    final guestId = getIt<AuthProvider>().user?.userId;
    if (guestId == null || guestId.isEmpty) return;
    final booking = await _bookingRepository.getGuestActiveBooking(guestId);
    if (booking != null) {
      _bookedPgId = booking.pgId;
      _ownerIdOfPg = booking.ownerId;
    }
  }

  /// Submits simple like/dislike feedback for a meal on today's date
  Future<void> submitMealFeedback({
    required String meal, // breakfast|lunch|dinner
    required bool like,
  }) async {
    // Ensure we know the booked PG
    if (_bookedPgId == null) {
      await _loadBookedPgIfNeeded();
      if (_bookedPgId == null) return;
    }

    final guestId = getIt<AuthProvider>().user?.userId ?? '';
    if (guestId.isEmpty) return;

    final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _feedbackRepository.submitFeedback(
      pgId: _bookedPgId!,
      guestId: guestId,
      dateKey: dateKey,
      meal: meal,
      value: like ? 1 : -1,
    );
  }

  /// Checks if there's a special menu for today
  OwnerMenuOverride? getTodaySpecialMenu() {
    final today = DateTime.now();
    try {
      return _specialMenus.firstWhere(
        (menu) =>
            menu.date.year == today.year &&
            menu.date.month == today.month &&
            menu.date.day == today.day &&
            menu.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  /// Loads guest's menu from their booked PG
  Future<void> loadGuestMenu() async {
    try {
      setLoading(true);
      clearError();

      _analyticsService.logEvent(
        name: 'guest_menu_load_started',
        parameters: {},
      );

      // First, try to get guest's active booking
      await _loadGuestBooking();

      if (_bookedPgId != null && _ownerIdOfPg != null) {
        // Guest has a booking - load menu for their booked PG
        await _loadMenuForPg(_bookedPgId!, _ownerIdOfPg!);
      } else {
        // No booking found - show empty state
        _weeklyMenus = [];
        setLoading(false);
        notifyListeners();

        _analyticsService.logEvent(
          name: 'guest_menu_no_booking',
          parameters: {},
        );
      }
    } catch (e) {
      setError(true, 'Failed to load menu: $e');
      setLoading(false);

      _analyticsService.logEvent(
        name: 'guest_menu_load_exception',
        parameters: {
          'error': e.toString(),
        },
      );
    }
  }

  /// Load menu for a specific PG and owner
  Future<void> _loadMenuForPg(String pgId, String ownerId) async {
    try {
      // Stream weekly menus for this PG
      _repository.getWeeklyMenusStream(ownerId, pgId: pgId).listen(
        (menus) {
          _weeklyMenus = menus;
          setLoading(false);
          notifyListeners();

          _analyticsService.logEvent(
            name: 'guest_menu_loaded',
            parameters: {
              'menus_count': menus.length,
              'pg_id': pgId,
              'owner_id': ownerId,
            },
          );
        },
        onError: (error) {
          setError(true, 'Failed to load menu: $error');
          setLoading(false);

          _analyticsService.logEvent(
            name: 'guest_menu_load_error',
            parameters: {
              'error': error.toString(),
              'pg_id': pgId,
            },
          );
        },
      );

      // Stream special menus/overrides for this PG
      _repository.getMenuOverridesStream(ownerId, pgId: pgId).listen(
        (overrides) {
          _specialMenus = overrides;
          notifyListeners();

          _analyticsService.logEvent(
            name: 'guest_special_menus_loaded',
            parameters: {
              'overrides_count': overrides.length,
            },
          );
        },
        onError: (error) {
          // Don't fail the whole screen if special menus fail
          debugPrint('Failed to load special menus: $error');
        },
      );
    } catch (e) {
      setError(true, 'Failed to load menu for PG: $e');
      setLoading(false);
    }
  }

  /// Loads guest's active booking to get PG and owner info
  Future<void> _loadGuestBooking() async {
    try {
      // Get current user ID from AuthProvider
      final authProvider = getIt<AuthProvider>();
      final userId = authProvider.user?.userId;

      if (userId == null) {
        _bookedPgId = null;
        _ownerIdOfPg = null;
        return;
      }

      // Get guest's bookings
      final bookings =
          await _bookingRepository.streamGuestBookings(userId).first;

      // Find the first confirmed booking
      BookingModel? activeBooking;
      try {
        activeBooking = bookings.firstWhere(
          (booking) => booking.status == 'confirmed',
        );
      } catch (e) {
        // No confirmed booking found, try to get any booking
        if (bookings.isNotEmpty) {
          activeBooking = bookings.first;
        }
      }

      if (activeBooking != null) {
        _bookedPgId = activeBooking.pgId;
        _ownerIdOfPg = activeBooking.ownerId;

        _analyticsService.logEvent(
          name: 'guest_booking_found',
          parameters: {
            'booking_id': activeBooking.bookingId,
            'pg_id': _bookedPgId!,
            'owner_id': _ownerIdOfPg!,
          },
        );
      } else {
        _bookedPgId = null;
        _ownerIdOfPg = null;

        _analyticsService.logEvent(
          name: 'guest_no_booking_found',
          parameters: {
            'user_id': userId,
          },
        );
      }
    } catch (e) {
      _bookedPgId = null;
      _ownerIdOfPg = null;

      _analyticsService.logEvent(
        name: 'guest_booking_load_error',
        parameters: {
          'error': e.toString(),
        },
      );
    }
  }

  /// Loads menu for a specific PG and owner
  Future<void> loadMenuForPg(String pgId, String ownerId) async {
    try {
      setLoading(true);
      clearError();

      _bookedPgId = pgId;
      _ownerIdOfPg = ownerId;

      _analyticsService.logEvent(
        name: 'guest_menu_load_for_pg',
        parameters: {
          'pg_id': pgId,
          'owner_id': ownerId,
        },
      );

      // Use the internal method to load menu
      await _loadMenuForPg(pgId, ownerId);
    } catch (e) {
      setError(true, 'Failed to load menu: $e');
      setLoading(false);
    }
  }

  /// Gets today's menu (considering special overrides)
  OwnerFoodMenu? getTodaysMenu() {
    final today = DateTime.now();
    final dayName = _getDayName(today.weekday);

    // Check for special menu first
    final specialMenu = getTodaySpecialMenu();
    if (specialMenu != null && specialMenu.isActive) {
      // Special menus take precedence
      // Return null to indicate special menu should be shown
      return null;
    }

    // Return regular weekly menu
    return getMenuForDay(dayName);
  }

  /// Gets day name from weekday number
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  /// Gets total items count for today
  int getTodayItemsCount() {
    final todayMenu = getTodaysMenu();
    if (todayMenu == null) return 0;

    return todayMenu.breakfast.length +
        todayMenu.lunch.length +
        todayMenu.dinner.length;
  }

  /// Checks if menu is available for a day
  bool hasMenuForDay(String day) {
    return getMenuForDay(day) != null;
  }

  /// Gets all days with menus
  List<String> getDaysWithMenus() {
    return _weeklyMenus.map((menu) => menu.day).toList();
  }

  /// Refreshes menu data
  Future<void> refreshMenu() async {
    if (_bookedPgId != null && _ownerIdOfPg != null) {
      await loadMenuForPg(_bookedPgId!, _ownerIdOfPg!);
    } else {
      await loadGuestMenu();
    }
  }

  /// Legacy method - kept for backward compatibility
  /// Not used in weekly menu flow
  Future<dynamic> getFoodById(String foodId) async {
    // This method is no longer used since we display weekly menus
    // Kept for backward compatibility with detail screen
    return null;
  }
}
