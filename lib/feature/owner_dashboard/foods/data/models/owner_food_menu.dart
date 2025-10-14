// lib/features/owner_dashboard/foods/data/models/owner_food_menu.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Represents a weekly or daily menu item for owner-managed food.
/// Each day has breakfast, lunch, dinner meals and photos.
/// Enhanced with timestamps, metadata, and helper methods
/// 
/// Multi-PG Support:
/// - pgId field links menu to specific PG
/// - Backward compatible: null pgId means menu applies to all owner's PGs (legacy data)
class OwnerFoodMenu {
  final String menuId;
  final String ownerId;
  final String? pgId; // NEW: Links menu to specific PG (null for backward compatibility)
  final String day;
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> dinner;
  final List<String> photoUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? description;
  final Map<String, dynamic>? nutritionInfo;
  final Map<String, dynamic>? metadata;

  OwnerFoodMenu({
    required this.menuId,
    required this.ownerId,
    this.pgId, // Optional for backward compatibility
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.description,
    this.nutritionInfo,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Creates OwnerFoodMenu from Firestore document data
  /// Backward compatible: pgId can be null for legacy data
  factory OwnerFoodMenu.fromMap(Map<String, dynamic> map) {
    return OwnerFoodMenu(
      menuId: map['menuId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      pgId: map['pgId'], // Nullable for backward compatibility
      day: map['day'] ?? '',
      breakfast: List<String>.from(map['breakfast'] ?? []),
      lunch: List<String>.from(map['lunch'] ?? []),
      dinner: List<String>.from(map['dinner'] ?? []),
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      isActive: map['isActive'] ?? true,
      description: map['description'],
      nutritionInfo: map['nutritionInfo'] != null
          ? Map<String, dynamic>.from(map['nutritionInfo'])
          : null,
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Converts OwnerFoodMenu to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'ownerId': ownerId,
      'pgId': pgId, // Include pgId (can be null for legacy compatibility)
      'day': day,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'photoUrls': photoUrls,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'description': description,
      'nutritionInfo': nutritionInfo,
      'metadata': metadata,
    };
  }

  /// Creates a copy with updated fields
  OwnerFoodMenu copyWith({
    String? menuId,
    String? ownerId,
    String? pgId,
    String? day,
    List<String>? breakfast,
    List<String>? lunch,
    List<String>? dinner,
    List<String>? photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? description,
    Map<String, dynamic>? nutritionInfo,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerFoodMenu(
      menuId: menuId ?? this.menuId,
      ownerId: ownerId ?? this.ownerId,
      pgId: pgId ?? this.pgId,
      day: day ?? this.day,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns total number of items across all meals
  int get totalItems => breakfast.length + lunch.length + dinner.length;

  /// Returns true if menu has any meals
  bool get hasMeals => totalItems > 0;

  /// Returns true if menu has photos
  bool get hasPhotos => photoUrls.isNotEmpty;

  /// Returns formatted creation date
  String get formattedCreatedAt =>
      createdAt != null ? DateFormat('MMM dd, yyyy').format(createdAt!) : 'N/A';

  /// Returns formatted updated date
  String get formattedUpdatedAt =>
      updatedAt != null ? DateFormat('MMM dd, yyyy').format(updatedAt!) : 'N/A';

  /// Returns meal summary
  String get mealSummary =>
      '${breakfast.length} breakfast, ${lunch.length} lunch, ${dinner.length} dinner items';

  /// Returns status display
  String get statusDisplay => isActive ? 'Active' : 'Inactive';

  @override
  String toString() {
    return 'OwnerFoodMenu(menuId: $menuId, day: $day, totalItems: $totalItems)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerFoodMenu && other.menuId == menuId;
  }

  @override
  int get hashCode => menuId.hashCode;
}

/// Represents an optional override menu for a specific date
/// such as festival or special occasions.
/// Null fields fallback to weekly defaults.
/// 
/// Multi-PG Support:
/// - pgId field links override to specific PG
/// - Backward compatible: null pgId means override applies to all owner's PGs (legacy data)
class OwnerMenuOverride {
  final String overrideId;
  final String ownerId;
  final String? pgId; // NEW: Links override to specific PG (null for backward compatibility)
  final DateTime date;
  final String? festivalName;
  final List<String>? breakfast;
  final List<String>? lunch;
  final List<String>? dinner;
  final List<String>? photoUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? specialNote;
  final Map<String, dynamic>? metadata;

  OwnerMenuOverride({
    required this.overrideId,
    required this.ownerId,
    this.pgId, // Optional for backward compatibility
    required this.date,
    this.festivalName,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.specialNote,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Creates OwnerMenuOverride from Firestore document data
  /// Backward compatible: pgId can be null for legacy data
  factory OwnerMenuOverride.fromMap(Map<String, dynamic> map) {
    return OwnerMenuOverride(
      overrideId: map['overrideId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      pgId: map['pgId'], // Nullable for backward compatibility
      date: map['date']?.toDate() ?? DateTime.now(),
      festivalName: map['festivalName'],
      breakfast: map['breakfast'] != null
          ? List<String>.from(map['breakfast'])
          : null,
      lunch: map['lunch'] != null ? List<String>.from(map['lunch']) : null,
      dinner: map['dinner'] != null ? List<String>.from(map['dinner']) : null,
      photoUrls: map['photoUrls'] != null
          ? List<String>.from(map['photoUrls'])
          : null,
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      isActive: map['isActive'] ?? true,
      specialNote: map['specialNote'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Converts OwnerMenuOverride to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'overrideId': overrideId,
      'ownerId': ownerId,
      'pgId': pgId, // Include pgId (can be null for legacy compatibility)
      'date': Timestamp.fromDate(date),
      'festivalName': festivalName,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'photoUrls': photoUrls,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'specialNote': specialNote,
      'metadata': metadata,
    };
  }

  /// Creates a copy with updated fields
  OwnerMenuOverride copyWith({
    String? overrideId,
    String? ownerId,
    String? pgId,
    DateTime? date,
    String? festivalName,
    List<String>? breakfast,
    List<String>? lunch,
    List<String>? dinner,
    List<String>? photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? specialNote,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerMenuOverride(
      overrideId: overrideId ?? this.overrideId,
      ownerId: ownerId ?? this.ownerId,
      pgId: pgId ?? this.pgId,
      date: date ?? this.date,
      festivalName: festivalName ?? this.festivalName,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isActive: isActive ?? this.isActive,
      specialNote: specialNote ?? this.specialNote,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns true if override has any meals
  bool get hasMeals =>
      (breakfast != null && breakfast!.isNotEmpty) ||
      (lunch != null && lunch!.isNotEmpty) ||
      (dinner != null && dinner!.isNotEmpty);

  /// Returns true if override has photos
  bool get hasPhotos => photoUrls != null && photoUrls!.isNotEmpty;

  /// Returns true if this is a festival/special occasion
  bool get isFestival => festivalName != null && festivalName!.isNotEmpty;

  /// Returns formatted date
  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);

  /// Returns formatted creation date
  String get formattedCreatedAt =>
      createdAt != null ? DateFormat('MMM dd, yyyy').format(createdAt!) : 'N/A';

  /// Returns formatted updated date
  String get formattedUpdatedAt =>
      updatedAt != null ? DateFormat('MMM dd, yyyy').format(updatedAt!) : 'N/A';

  /// Returns display title
  String get displayTitle => festivalName ?? 'Special Menu - $formattedDate';

  /// Returns status display
  String get statusDisplay => isActive ? 'Active' : 'Inactive';

  @override
  String toString() {
    return 'OwnerMenuOverride(overrideId: $overrideId, date: $formattedDate, festival: $festivalName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerMenuOverride && other.overrideId == overrideId;
  }

  @override
  int get hashCode => overrideId.hashCode;
}

