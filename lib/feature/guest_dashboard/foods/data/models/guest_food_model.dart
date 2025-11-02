// lib/features/guest_dashboard/foods/models/guest_food_model.dart

/// Model representing a food item available for guest ordering
/// Contains food details, pricing, availability, and images
/// Follows Dart naming conventions with 'is' prefix for boolean properties
library;

import '../../../../../common/utils/date/converter/date_service_converter.dart';

class GuestFoodModel {
  final String foodId;
  final String name;
  final String description;
  final double price;
  final String category; // e.g., Veg, Non-Veg, Beverage, Snacks
  final List<String> photos; // URLs of food images
  final bool isAvailable; // Proper boolean naming with 'is' prefix
  final DateTime? availableFrom; // Optional availability time window
  final DateTime? availableUntil; // Optional availability time window

  GuestFoodModel({
    required this.foodId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.photos,
    required this.isAvailable, // Updated to proper naming
    this.availableFrom,
    this.availableUntil,
  });

  /// Creates a Food model instance from Firestore map data
  /// Handles field mapping with proper boolean naming convention
  factory GuestFoodModel.fromMap(Map<String, dynamic> map) {
    return GuestFoodModel(
      foodId: map['foodId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? 'General',
      photos: List<String>.from(map['photos'] ?? []),
      // Map from 'available' field in Firestore to 'isAvailable' in model
      isAvailable: map['available'] ?? true, // Default to available
      availableFrom: map['availableFrom'] != null
          ? DateServiceConverter.fromService(map['availableFrom'])
          : null,
      availableUntil: map['availableUntil'] != null
          ? DateServiceConverter.fromService(map['availableUntil'])
          : null,
    );
  }

  /// Converts the food instance into a Map for Firestore storage
  /// Maps 'isAvailable' back to 'available' field for Firestore compatibility
  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'photos': photos,
      'available': isAvailable, // Map to 'available' for Firestore
      'availableFrom': availableFrom != null
          ? DateServiceConverter.toService(availableFrom!)
          : null,
      'availableUntil': availableUntil != null
          ? DateServiceConverter.toService(availableUntil!)
          : null,
    };
  }

  /// Checks if food is currently available based on time constraints
  /// Considers both the boolean flag and time-based availability
  bool get isCurrentlyAvailable {
    if (!isAvailable) return false;

    final now = DateTime.now();
    if (availableFrom != null && now.isBefore(availableFrom!)) return false;
    if (availableUntil != null && now.isAfter(availableUntil!)) return false;

    return true;
  }

  /// Gets food category with proper formatting
  String get formattedCategory {
    switch (category.toLowerCase()) {
      case 'veg':
        return 'Vegetarian';
      case 'non-veg':
        return 'Non-Vegetarian';
      case 'beverage':
        return 'Beverage';
      case 'snacks':
        return 'Snacks';
      default:
        return category;
    }
  }

  /// Returns formatted price with currency symbol
  String get formattedPrice => '₹${price.toStringAsFixed(2)}';

  /// Checks if food has any images
  bool get hasImages => photos.isNotEmpty;

  /// Gets the first image URL or returns null if no images
  String? get firstImageUrl => hasImages ? photos.first : null;
}
