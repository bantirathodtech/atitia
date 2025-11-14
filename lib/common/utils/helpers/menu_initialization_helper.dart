// lib/common/utils/helpers/menu_initialization_helper.dart

import '../../../core/services/localization/internationalization_service.dart';
import '../../../feature/owner_dashboard/foods/data/models/owner_food_menu.dart';

/// Helper class to initialize default weekly menus for new owners
/// Provides sample menu data for all 7 days with breakfast, lunch, and dinner
class MenuInitializationHelper {
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  static const List<String> _weekdayKeys = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const Map<String, List<String>> _defaultBreakfastMenus = {
    'monday': [
      'Idli with Sambar and Coconut Chutney',
      'Vada (2 pieces)',
      'Filter Coffee',
      'Banana',
    ],
    'tuesday': [
      'Masala Dosa with Sambar and Chutney',
      'Medu Vada',
      'Tea',
      'Seasonal Fruit',
    ],
    'wednesday': [
      'Upma with Coconut Chutney',
      'Vada (2 pieces)',
      'Coffee',
      'Boiled Eggs (2)',
    ],
    'thursday': [
      'Poha with Peanuts and Curry Leaves',
      'Banana Chips',
      'Tea',
      'Papaya',
    ],
    'friday': [
      'Puri with Potato Bhaji',
      'Halwa',
      'Coffee',
      'Orange',
    ],
    'saturday': [
      'Pesarattu (Green Gram Dosa) with Ginger Chutney',
      'Upma',
      'Tea',
      'Seasonal Fruit',
    ],
    'sunday': [
      'Special Breakfast - Pongal with Vada',
      'Sweet Pongal',
      'Filter Coffee',
      'Banana',
    ],
  };

  static const Map<String, List<String>> _defaultLunchMenus = {
    'monday': [
      'Steamed Rice',
      'Sambar',
      'Rasam',
      'Vegetable Curry (Beans Palya)',
      'Curd',
      'Papad',
      'Buttermilk',
    ],
    'tuesday': [
      'Steamed Rice',
      'Dal Tadka',
      'Rasam',
      'Cabbage Poriyal',
      'Brinjal Curry',
      'Curd',
      'Pickle',
    ],
    'wednesday': [
      'Jeera Rice',
      'Sambar',
      'Rasam',
      'Potato Fry',
      'Spinach Dal',
      'Curd',
      'Papad',
    ],
    'thursday': [
      'Steamed Rice',
      'Moong Dal',
      'Rasam',
      'Mixed Vegetable Curry',
      'Beetroot Poriyal',
      'Curd',
      'Buttermilk',
    ],
    'friday': [
      'Lemon Rice',
      'Sambar',
      'Rasam',
      'Okra Fry (Bhendi)',
      'Carrot Poriyal',
      'Curd',
      'Pickle',
    ],
    'saturday': [
      'Steamed Rice',
      'Toor Dal',
      'Rasam',
      'Pumpkin Curry',
      'Green Beans Poriyal',
      'Curd',
      'Papad',
    ],
    'sunday': [
      'Special Lunch - Pulao',
      'Sambar',
      'Rasam',
      'Paneer Butter Masala',
      'Raita',
      'Sweet (Payasam)',
      'Papad',
    ],
  };

  static const Map<String, List<String>> _defaultDinnerMenus = {
    'monday': [
      'Chapati (4 pieces)',
      'Mixed Vegetable Curry',
      'Dal Fry',
      'Rice',
      'Curd',
    ],
    'tuesday': [
      'Chapati (4 pieces)',
      'Palak Paneer',
      'Dal Tadka',
      'Rice',
      'Pickle',
    ],
    'wednesday': [
      'Paratha (3 pieces)',
      'Aloo Gobi',
      'Moong Dal',
      'Rice',
      'Curd',
    ],
    'thursday': [
      'Chapati (4 pieces)',
      'Chana Masala',
      'Tomato Rasam',
      'Rice',
      'Raita',
    ],
    'friday': [
      'Puri (6 pieces)',
      'Aloo Curry',
      'Chana Dal',
      'Rice',
      'Curd',
    ],
    'saturday': [
      'Chapati (4 pieces)',
      'Egg Curry (2 eggs)',
      'Dal Tadka',
      'Rice',
      'Pickle',
    ],
    'sunday': [
      'Special Dinner - Naan (3 pieces)',
      'Paneer Tikka Masala',
      'Dal Makhani',
      'Jeera Rice',
      'Raita',
      'Gulab Jamun (2 pieces)',
    ],
  };

  /// Creates default weekly menus for a new owner
  /// Returns list of 7 menus (Monday to Sunday) with sample Indian meals
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, creates menus for that specific PG
  /// - If pgId is null, creates menus for all PGs (backward compatible)
  static List<OwnerFoodMenu> createDefaultWeeklyMenus(String ownerId,
      {String? pgId}) {
    return _weekdayKeys.map((day) {
      final dayKey = day.toLowerCase();
      final translatedDay = _i18n.translate('weekday_$dayKey');
      final dayDisplay =
          translatedDay != 'weekday_$dayKey' ? translatedDay : day;
      final translatedDescription = _i18n.translate(
        'menuDefaultDescription',
        parameters: {'day': dayDisplay},
      );
      final description = translatedDescription != 'menuDefaultDescription'
          ? translatedDescription
          : 'Default menu for $day - customize as needed';

      return OwnerFoodMenu(
        menuId:
            '${ownerId}_${day.toLowerCase()}_default${pgId != null ? '_$pgId' : ''}',
        ownerId: ownerId,
        pgId: pgId, // Link menu to specific PG
        day: day,
        breakfast: _getDefaultBreakfast(day),
        lunch: _getDefaultLunch(day),
        dinner: _getDefaultDinner(day),
        photoUrls: [],
        isActive: true,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  /// Returns default breakfast items based on day
  static List<String> _getDefaultBreakfast(String day) {
    final key = 'menuBreakfast_${day.toLowerCase()}';
    final fallback = _defaultBreakfastMenus[day.toLowerCase()] ??
        _defaultBreakfastMenus['monday']!;
    return _getMenuItems(
      key,
      fallback,
    );
  }

  /// Returns default lunch items based on day
  static List<String> _getDefaultLunch(String day) {
    final key = 'menuLunch_${day.toLowerCase()}';
    final fallback =
        _defaultLunchMenus[day.toLowerCase()] ?? _defaultLunchMenus['monday']!;
    return _getMenuItems(
      key,
      fallback,
    );
  }

  /// Returns default dinner items based on day
  static List<String> _getDefaultDinner(String day) {
    final key = 'menuDinner_${day.toLowerCase()}';
    final fallback = _defaultDinnerMenus[day.toLowerCase()] ??
        _defaultDinnerMenus['monday']!;
    return _getMenuItems(
      key,
      fallback,
    );
  }

  /// Creates an empty menu template for a specific day
  static OwnerFoodMenu createEmptyMenu(String ownerId, String day,
      {String? pgId}) {
    return OwnerFoodMenu(
      menuId:
          '${ownerId}_${day.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
      ownerId: ownerId,
      pgId: pgId, // Include pgId for PG-specific menus
      day: day,
      breakfast: [],
      lunch: [],
      dinner: [],
      photoUrls: [],
      isActive: true,
      description: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Validates menu data before saving
  static bool validateMenu(OwnerFoodMenu menu, {bool requireMeals = false}) {
    // Basic validation
    if (menu.ownerId.isEmpty || menu.day.isEmpty) {
      return false;
    }

    // If requireMeals is true, at least one meal should have items
    if (requireMeals) {
      if (menu.breakfast.isEmpty && menu.lunch.isEmpty && menu.dinner.isEmpty) {
        return false;
      }
    }

    return true;
  }

  /// Gets sample photo URLs (placeholder for testing)
  static List<String> getSamplePhotoUrls() {
    // In production, these would be actual uploaded images
    return [];
  }

  /// Creates a menu with custom items
  static OwnerFoodMenu createCustomMenu({
    required String ownerId,
    required String day,
    List<String>? breakfast,
    List<String>? lunch,
    List<String>? dinner,
    List<String>? photoUrls,
    String? description,
  }) {
    return OwnerFoodMenu(
      menuId:
          '${ownerId}_${day.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
      ownerId: ownerId,
      day: day,
      breakfast: breakfast ?? [],
      lunch: lunch ?? [],
      dinner: dinner ?? [],
      photoUrls: photoUrls ?? [],
      isActive: true,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Gets meal type icon
  static String getMealTypeIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return '🌅';
      case 'lunch':
        return '🌞';
      case 'dinner':
        return '🌙';
      default:
        return '🍽️';
    }
  }

  /// Gets meal type description
  static String getMealTypeDescription(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        {
          final translation =
              _i18n.translate('menuMealTypeBreakfastDescription');
          return translation != 'menuMealTypeBreakfastDescription'
              ? translation
              : 'Morning meal (6:00 AM - 10:00 AM)';
        }
      case 'lunch':
        {
          final translation = _i18n.translate('menuMealTypeLunchDescription');
          return translation != 'menuMealTypeLunchDescription'
              ? translation
              : 'Afternoon meal (12:00 PM - 3:00 PM)';
        }
      case 'dinner':
        {
          final translation = _i18n.translate('menuMealTypeDinnerDescription');
          return translation != 'menuMealTypeDinnerDescription'
              ? translation
              : 'Evening meal (7:00 PM - 10:00 PM)';
        }
      default:
        final translation = _i18n.translate('menuMealTypeGeneric');
        return translation != 'menuMealTypeGeneric' ? translation : 'Meal';
    }
  }

  /// Checks if a menu needs update (older than 30 days)
  static bool needsUpdate(OwnerFoodMenu menu) {
    if (menu.updatedAt == null) return true;

    final daysSinceUpdate = DateTime.now().difference(menu.updatedAt!).inDays;
    return daysSinceUpdate > 30;
  }

  /// Gets the current day's menu from a list of weekly menus
  static OwnerFoodMenu? getCurrentDayMenu(List<OwnerFoodMenu> weeklyMenus) {
    final now = DateTime.now();
    final currentDay = weekdayString(now);

    try {
      return weeklyMenus.firstWhere((menu) => menu.day == currentDay);
    } catch (_) {
      return null;
    }
  }

  /// Helper converts DateTime to weekday string
  static String weekdayString(DateTime date) {
    return _weekdayKeys[date.weekday - 1];
  }

  static List<String> _getMenuItems(String key, List<String> fallback) {
    final translation = _i18n.translate(key);
    if (translation.isEmpty || translation == key) {
      return fallback;
    }

    final decoded = _splitMenuItems(translation);
    if (decoded.isEmpty) {
      return fallback;
    }
    return decoded;
  }

  static List<String> _splitMenuItems(String value) {
    return value
        .split('|')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
