// lib/common/utils/helpers/menu_initialization_helper.dart

import '../../../feature/owner_dashboard/foods/data/models/owner_food_menu.dart';

/// Helper class to initialize default weekly menus for new owners
/// Provides sample menu data for all 7 days with breakfast, lunch, and dinner
class MenuInitializationHelper {
  /// Creates default weekly menus for a new owner
  /// Returns list of 7 menus (Monday to Sunday) with sample Indian meals
  ///
  /// Multi-PG Support:
  /// - If pgId is provided, creates menus for that specific PG
  /// - If pgId is null, creates menus for all PGs (backward compatible)
  static List<OwnerFoodMenu> createDefaultWeeklyMenus(String ownerId,
      {String? pgId}) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return weekdays.map((day) {
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
        description: 'Default menu for $day - customize as needed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  /// Returns default breakfast items based on day
  static List<String> _getDefaultBreakfast(String day) {
    final breakfastMenus = {
      'Monday': [
        'Idli with Sambar and Coconut Chutney',
        'Vada (2 pieces)',
        'Filter Coffee',
        'Banana',
      ],
      'Tuesday': [
        'Masala Dosa with Sambar and Chutney',
        'Medu Vada',
        'Tea',
        'Seasonal Fruit',
      ],
      'Wednesday': [
        'Upma with Coconut Chutney',
        'Vada (2 pieces)',
        'Coffee',
        'Boiled Eggs (2)',
      ],
      'Thursday': [
        'Poha with Peanuts and Curry Leaves',
        'Banana Chips',
        'Tea',
        'Papaya',
      ],
      'Friday': [
        'Puri with Potato Bhaji',
        'Halwa',
        'Coffee',
        'Orange',
      ],
      'Saturday': [
        'Pesarattu (Green Gram Dosa) with Ginger Chutney',
        'Upma',
        'Tea',
        'Seasonal Fruit',
      ],
      'Sunday': [
        'Special Breakfast - Pongal with Vada',
        'Sweet Pongal',
        'Filter Coffee',
        'Banana',
      ],
    };

    return breakfastMenus[day] ?? _getDefaultBreakfast('Monday');
  }

  /// Returns default lunch items based on day
  static List<String> _getDefaultLunch(String day) {
    final lunchMenus = {
      'Monday': [
        'Steamed Rice',
        'Sambar',
        'Rasam',
        'Vegetable Curry (Beans Palya)',
        'Curd',
        'Papad',
        'Buttermilk',
      ],
      'Tuesday': [
        'Steamed Rice',
        'Dal Tadka',
        'Rasam',
        'Cabbage Poriyal',
        'Brinjal Curry',
        'Curd',
        'Pickle',
      ],
      'Wednesday': [
        'Jeera Rice',
        'Sambar',
        'Rasam',
        'Potato Fry',
        'Spinach Dal',
        'Curd',
        'Papad',
      ],
      'Thursday': [
        'Steamed Rice',
        'Moong Dal',
        'Rasam',
        'Mixed Vegetable Curry',
        'Beetroot Poriyal',
        'Curd',
        'Buttermilk',
      ],
      'Friday': [
        'Lemon Rice',
        'Sambar',
        'Rasam',
        'Okra Fry (Bhendi)',
        'Carrot Poriyal',
        'Curd',
        'Pickle',
      ],
      'Saturday': [
        'Steamed Rice',
        'Toor Dal',
        'Rasam',
        'Pumpkin Curry',
        'Green Beans Poriyal',
        'Curd',
        'Papad',
      ],
      'Sunday': [
        'Special Lunch - Pulao',
        'Sambar',
        'Rasam',
        'Paneer Butter Masala',
        'Raita',
        'Sweet (Payasam)',
        'Papad',
      ],
    };

    return lunchMenus[day] ?? _getDefaultLunch('Monday');
  }

  /// Returns default dinner items based on day
  static List<String> _getDefaultDinner(String day) {
    final dinnerMenus = {
      'Monday': [
        'Chapati (4 pieces)',
        'Mixed Vegetable Curry',
        'Dal Fry',
        'Rice',
        'Curd',
      ],
      'Tuesday': [
        'Chapati (4 pieces)',
        'Palak Paneer',
        'Dal Tadka',
        'Rice',
        'Pickle',
      ],
      'Wednesday': [
        'Paratha (3 pieces)',
        'Aloo Gobi',
        'Moong Dal',
        'Rice',
        'Curd',
      ],
      'Thursday': [
        'Chapati (4 pieces)',
        'Chana Masala',
        'Tomato Rasam',
        'Rice',
        'Raita',
      ],
      'Friday': [
        'Puri (6 pieces)',
        'Aloo Curry',
        'Chana Dal',
        'Rice',
        'Curd',
      ],
      'Saturday': [
        'Chapati (4 pieces)',
        'Egg Curry (2 eggs)',
        'Dal Tadka',
        'Rice',
        'Pickle',
      ],
      'Sunday': [
        'Special Dinner - Naan (3 pieces)',
        'Paneer Tikka Masala',
        'Dal Makhani',
        'Jeera Rice',
        'Raita',
        'Gulab Jamun (2 pieces)',
      ],
    };

    return dinnerMenus[day] ?? _getDefaultDinner('Monday');
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
        return 'Morning meal (6:00 AM - 10:00 AM)';
      case 'lunch':
        return 'Afternoon meal (12:00 PM - 3:00 PM)';
      case 'dinner':
        return 'Evening meal (7:00 PM - 10:00 PM)';
      default:
        return 'Meal';
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
}
