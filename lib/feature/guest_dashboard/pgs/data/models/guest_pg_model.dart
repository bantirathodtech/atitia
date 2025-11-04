// lib/features/guest_dashboard/pgs/data/models/guest_pg_model.dart

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

import '../../../../../common/utils/date/converter/date_service_converter.dart';
import '../../../../owner_dashboard/mypg/data/models/pg_floor_model.dart';

/// Data model representing PG (Pay Guest) accommodation details
/// Contains comprehensive PG information including location, facilities, and media
/// Used for displaying PG listings and managing PG data in guest dashboard
class GuestPgModel {
  final String pgId;
  final String ownerUid;
  final String pgName;
  final String address;
  final String state;
  final String city;
  final String area;
  final List<PgFloorModel> floorStructure; // NEW: Flexible floor/room structure
  final int floors; // Kept for backward compatibility
  final int roomsPerFloor; // Kept for backward compatibility
  final int bedsPerRoom; // Kept for backward compatibility
  final List<String> amenities;
  final List<String> photos;
  final Map<String, dynamic> bankDetails;
  final double? latitude;
  final double? longitude;
  final String? description;
  final Map<String, dynamic>? pricing;
  final Map<String, dynamic>?
      rentConfig; // oneShare, twoShare, threeShare, fourShare, fiveShare
  final double? depositAmount; // Security deposit amount
  final String? maintenanceType; // 'one_time', 'monthly', 'none'
  final double? maintenanceAmount; // Maintenance charges
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? contactNumber;
  final String? email;
  final Map<String, dynamic>? rules;
  final List<String>? nearbyPlaces;
  final String? pgType; // 'Boys', 'Girls', 'Co-ed'
  final String? mealType; // 'Veg', 'Non-Veg', 'Both'
  final String? mealTimings; // Meal timing schedule
  final String? foodQuality; // Food quality description
  final bool? parkingAvailable;
  final String? parkingDetails; // Parking details description
  final bool? wifiAvailable;
  final bool? securityAvailable;
  final String? securityMeasures; // Security measures description
  final String? paymentInstructions; // Payment instructions
  final String? ownerName;
  final String? googleMapLink; // Google Maps link
  final Map<String, dynamic>? metadata;

  GuestPgModel({
    required this.pgId,
    required this.ownerUid,
    required this.pgName,
    required this.address,
    required this.state,
    required this.city,
    required this.area,
    this.floorStructure = const [], // Default to empty list
    this.floors = 0,
    this.roomsPerFloor = 0,
    this.bedsPerRoom = 0,
    required this.amenities,
    required this.photos,
    required this.bankDetails,
    this.latitude,
    this.longitude,
    this.description,
    this.pricing,
    this.rentConfig,
    this.depositAmount,
    this.maintenanceType,
    this.maintenanceAmount,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.contactNumber,
    this.email,
    this.rules,
    this.nearbyPlaces,
    this.pgType,
    this.mealType,
    this.mealTimings,
    this.foodQuality,
    this.parkingAvailable,
    this.parkingDetails,
    this.wifiAvailable,
    this.securityAvailable,
    this.securityMeasures,
    this.paymentInstructions,
    this.ownerName,
    this.googleMapLink,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Parse date from various formats (Timestamp, String, DateTime)
  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;

    // If it's already a DateTime, return it
    if (date is DateTime) return date;

    // If it's a Firestore Timestamp, convert to DateTime
    if (date is Timestamp) return date.toDate();

    // If it's a String (ISO format), parse it
    if (date is String) {
      try {
        return DateServiceConverter.fromService(date);
      } catch (e) {
        // If parsing fails, try direct DateTime.parse
        try {
          return DateTime.parse(date);
        } catch (e2) {
          return null;
        }
      }
    }

    return null;
  }

  /// Creates GuestPgModel instance from Firestore document data
  /// Handles null values gracefully with appropriate defaults
  factory GuestPgModel.fromMap(Map<String, dynamic> map) {
    return GuestPgModel(
      pgId: map['pgId'] ?? '',
      ownerUid: map['ownerUid'] ?? '',
      pgName: map['pgName'] ?? '',
      address: map['address'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      area: map['area'] ?? '',
      floorStructure: (map['floorStructure'] as List<dynamic>?)
              ?.map((f) => PgFloorModel.fromMap(f as Map<String, dynamic>))
              .toList() ??
          [],
      floors: (map['floors'] ?? 0).toInt(),
      roomsPerFloor: (map['roomsPerFloor'] ?? 0).toInt(),
      bedsPerRoom: (map['bedsPerRoom'] ?? 0).toInt(),
      amenities: List<String>.from(map['amenities'] ?? []),
      photos: List<String>.from(map['photos'] ?? []),
      bankDetails: Map<String, dynamic>.from(map['bankDetails'] ?? {}),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      description: map['description'],
      pricing: map['pricing'] != null
          ? Map<String, dynamic>.from(map['pricing'])
          : null,
      rentConfig: map['rentConfig'] != null
          ? Map<String, dynamic>.from(map['rentConfig'])
          : null,
      depositAmount: map['depositAmount']?.toDouble(),
      maintenanceType: map['maintenanceType'],
      maintenanceAmount: map['maintenanceAmount']?.toDouble(),
      isActive: map['isActive'] ?? true,
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']) ?? DateTime.now(),
      contactNumber: map['contactNumber'],
      email: map['email'],
      rules:
          map['rules'] != null ? Map<String, dynamic>.from(map['rules']) : null,
      nearbyPlaces: map['nearbyPlaces'] != null
          ? List<String>.from(map['nearbyPlaces'])
          : null,
      pgType: map['pgType'],
      mealType: map['mealType'],
      mealTimings: map['mealTimings'],
      foodQuality: map['foodQuality'],
      parkingAvailable: map['parkingAvailable'],
      parkingDetails: map['parkingDetails'],
      wifiAvailable: map['wifiAvailable'],
      securityAvailable: map['securityAvailable'],
      securityMeasures: map['securityMeasures'],
      paymentInstructions: map['paymentInstructions'],
      ownerName: map['ownerName'],
      googleMapLink:
          map['googleMapLink'] ?? map['mapLink'], // Support both field names
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Converts GuestPgModel instance to Map for Firestore storage
  /// Includes all fields for complete data persistence
  Map<String, dynamic> toMap() {
    return {
      'pgId': pgId,
      'ownerUid': ownerUid,
      'pgName': pgName,
      'address': address,
      'state': state,
      'city': city,
      'area': area,
      'floorStructure': floorStructure.map((f) => f.toMap()).toList(),
      'floors': floors,
      'roomsPerFloor': roomsPerFloor,
      'bedsPerRoom': bedsPerRoom,
      'amenities': amenities,
      'photos': photos,
      'bankDetails': bankDetails,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'pricing': pricing,
      'rentConfig': rentConfig,
      'depositAmount': depositAmount,
      'maintenanceType': maintenanceType,
      'maintenanceAmount': maintenanceAmount,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'contactNumber': contactNumber,
      'email': email,
      'rules': rules,
      'nearbyPlaces': nearbyPlaces,
      'pgType': pgType,
      'mealType': mealType,
      'mealTimings': mealTimings,
      'foodQuality': foodQuality,
      'parkingAvailable': parkingAvailable,
      'parkingDetails': parkingDetails,
      'wifiAvailable': wifiAvailable,
      'securityAvailable': securityAvailable,
      'securityMeasures': securityMeasures,
      'paymentInstructions': paymentInstructions,
      'ownerName': ownerName,
      'googleMapLink': googleMapLink,
      'metadata': metadata,
    };
  }

  /// Creates a copy of this GuestPgModel with updated fields
  /// Useful for partial updates without losing existing data
  GuestPgModel copyWith({
    String? pgId,
    String? ownerUid,
    String? pgName,
    String? address,
    String? state,
    String? city,
    String? area,
    List<PgFloorModel>? floorStructure,
    int? floors,
    int? roomsPerFloor,
    int? bedsPerRoom,
    List<String>? amenities,
    List<String>? photos,
    Map<String, dynamic>? bankDetails,
    double? latitude,
    double? longitude,
    String? description,
    Map<String, dynamic>? pricing,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contactNumber,
    String? email,
    Map<String, dynamic>? rules,
    List<String>? nearbyPlaces,
    String? pgType,
    String? mealType,
    bool? parkingAvailable,
    bool? wifiAvailable,
    bool? securityAvailable,
    String? ownerName,
    String? googleMapLink,
    Map<String, dynamic>? metadata,
  }) {
    return GuestPgModel(
      pgId: pgId ?? this.pgId,
      ownerUid: ownerUid ?? this.ownerUid,
      pgName: pgName ?? this.pgName,
      address: address ?? this.address,
      state: state ?? this.state,
      city: city ?? this.city,
      area: area ?? this.area,
      floorStructure: floorStructure ?? this.floorStructure,
      floors: floors ?? this.floors,
      roomsPerFloor: roomsPerFloor ?? this.roomsPerFloor,
      bedsPerRoom: bedsPerRoom ?? this.bedsPerRoom,
      amenities: amenities ?? this.amenities,
      photos: photos ?? this.photos,
      bankDetails: bankDetails ?? this.bankDetails,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      pricing: pricing ?? this.pricing,
      rentConfig: rentConfig ?? rentConfig,
      depositAmount: depositAmount ?? depositAmount,
      maintenanceType: maintenanceType ?? maintenanceType,
      maintenanceAmount: maintenanceAmount ?? maintenanceAmount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      rules: rules ?? this.rules,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      pgType: pgType ?? this.pgType,
      mealType: mealType ?? this.mealType,
      mealTimings: mealTimings ?? mealTimings,
      foodQuality: foodQuality ?? foodQuality,
      parkingAvailable: parkingAvailable ?? this.parkingAvailable,
      parkingDetails: parkingDetails ?? parkingDetails,
      wifiAvailable: wifiAvailable ?? this.wifiAvailable,
      securityAvailable: securityAvailable ?? this.securityAvailable,
      securityMeasures: securityMeasures ?? securityMeasures,
      paymentInstructions: paymentInstructions ?? paymentInstructions,
      ownerName: ownerName ?? this.ownerName,
      googleMapLink: googleMapLink ?? this.googleMapLink,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns the full address string combining area, city, and state
  String get fullAddress => '$area, $city, $state';

  /// Returns total number of rooms in the PG
  /// Uses flexible floor structure if available, otherwise uses simple calculation
  int get totalRooms {
    if (floorStructure.isNotEmpty) {
      return floorStructure.fold(0, (sum, floor) => sum + floor.totalRooms);
    }
    return floors * roomsPerFloor;
  }

  /// Returns total number of beds in the PG
  /// Uses flexible floor structure if available, otherwise uses simple calculation
  int get totalBeds {
    if (floorStructure.isNotEmpty) {
      return floorStructure.fold(0, (sum, floor) => sum + floor.totalBeds);
    }
    return totalRooms * bedsPerRoom;
  }

  /// Returns total revenue potential (all beds occupied)
  /// Only works with flexible floor structure
  int get totalRevenuePotential {
    if (floorStructure.isNotEmpty) {
      return floorStructure.fold(0, (sum, floor) => sum + floor.totalRevenue);
    }
    return 0;
  }

  /// Returns number of floors in the building
  int get totalFloors =>
      floorStructure.isNotEmpty ? floorStructure.length : floors;

  /// Check if PG uses flexible structure
  bool get hasFlexibleStructure => floorStructure.isNotEmpty;

  /// Returns true if PG has photos available
  bool get hasPhotos => photos.isNotEmpty;

  /// Returns true if PG has amenities listed
  bool get hasAmenities => amenities.isNotEmpty;

  /// Returns formatted creation date
  String get formattedCreatedAt => DateFormat('MMM dd, yyyy').format(createdAt);

  /// Returns formatted updated date
  String get formattedUpdatedAt => DateFormat('MMM dd, yyyy').format(updatedAt);

  /// Returns contact display name
  String get contactDisplayName => ownerName ?? 'Owner';

  /// Returns true if PG has contact information
  bool get hasContactInfo => contactNumber != null || email != null;

  /// Returns true if PG has location coordinates
  bool get hasLocation => latitude != null && longitude != null;

  /// Returns true if PG has nearby places
  bool get hasNearbyPlaces => nearbyPlaces != null && nearbyPlaces!.isNotEmpty;

  /// Returns true if PG has rules
  bool get hasRules => rules != null && rules!.isNotEmpty;

  /// Returns true if PG has pricing information
  bool get hasPricing => pricing != null && pricing!.isNotEmpty;

  /// Returns PG type display name
  String get pgTypeDisplay => pgType ?? 'Not Specified';

  /// Returns meal type display name
  String get mealTypeDisplay => mealType ?? 'Not Specified';

  /// Returns formatted pricing information
  String get formattedPricing {
    if (!hasPricing) return 'Contact for pricing';

    final rent = pricing!['monthlyRent'];
    final deposit = pricing!['securityDeposit'];

    if (rent != null && deposit != null) {
      return '₹${NumberFormat('#,##0').format(rent)}/month + ₹${NumberFormat('#,##0').format(deposit)} deposit';
    } else if (rent != null) {
      return '₹${NumberFormat('#,##0').format(rent)}/month';
    } else {
      return 'Contact for pricing';
    }
  }

  /// Returns primary photo URL or null
  String? get primaryPhoto => hasPhotos ? photos.first : null;

  /// Returns PG status color based on availability
  String get statusDisplay => isActive ? 'Available' : 'Unavailable';

  /// Returns PG status color for UI
  int get statusColor {
    if (!isActive) return 0xFFE57373; // Red
    return 0xFF81C784; // Green
  }

  /// Returns distance from a given point (if location is available)
  double? getDistanceFrom(double? lat, double? lng) {
    if (!hasLocation || lat == null || lng == null) return null;

    // Simple distance calculation (not accurate for large distances)
    final latDiff = (latitude! - lat).abs();
    final lngDiff = (longitude! - lng).abs();
    return (latDiff + lngDiff) * 111; // Rough conversion to km
  }

  @override
  String toString() {
    return 'GuestPgModel(pgId: $pgId, pgName: $pgName, city: $city, area: $area)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuestPgModel && other.pgId == pgId;
  }

  @override
  int get hashCode => pgId.hashCode;
}
