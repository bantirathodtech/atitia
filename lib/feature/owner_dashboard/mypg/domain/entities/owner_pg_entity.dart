// lib/feature/owner_dashboard/mypg/domain/entities/owner_pg_entity.dart

/// Domain entity for Owner PG
/// Represents the core business logic and rules for PG management
library;

import '../../../../../common/utils/date/converter/date_service_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class OwnerPgEntity {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String ownerUid;
  final List<String> amenities;
  final List<String> photos;
  final String contactNumber;
  final String pgType;
  final String? mealType;
  final String? area;
  final List<dynamic> floorStructure;
  final Map<String, dynamic> rentConfig;
  final double depositAmount;
  final String maintenanceType;
  final double maintenanceAmount;
  final String? googleMapLink;
  final String? ownerNumber;
  final Map<String, dynamic>? rules; // Entry/exit timings, policies
  final String? mealTimings; // Meal timing schedule
  final String? foodQuality; // Food quality description
  final List<String>? nearbyPlaces; // Nearby landmarks/locations
  final String? parkingDetails; // Parking details description
  final String? securityMeasures; // Security measures description
  final String? paymentInstructions; // Payment instructions
  final DateTime createdAt;
  final DateTime updatedAt;

  const OwnerPgEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.ownerUid,
    required this.amenities,
    required this.photos,
    required this.contactNumber,
    required this.pgType,
    this.mealType,
    this.area,
    required this.floorStructure,
    required this.rentConfig,
    required this.depositAmount,
    required this.maintenanceType,
    required this.maintenanceAmount,
    this.googleMapLink,
    this.ownerNumber,
    this.rules,
    this.mealTimings,
    this.foodQuality,
    this.nearbyPlaces,
    this.parkingDetails,
    this.securityMeasures,
    this.paymentInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse photos list from various formats (handles null, empty, List types)
  static List<String> _parsePhotosList(dynamic photos) {
    if (photos == null) return <String>[];
    if (photos is List) {
      return photos
          .where((p) => p != null)
          .map((p) => p.toString().trim())
          .where((p) => p.isNotEmpty)
          .toList();
    }
    return <String>[];
  }

  /// Create entity from map
  factory OwnerPgEntity.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateServiceConverter.fromService(v);
      return DateTime.now();
    }

    return OwnerPgEntity(
      id: map['id'] ??
          map['pgId'] ??
          '', // Support both 'id' and 'pgId' field names
      name: map['pgName'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      ownerUid: map['ownerUid'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      photos: _parsePhotosList(map['photos']),
      contactNumber: map['contactNumber'] ?? '',
      pgType: map['pgType'] ?? '',
      mealType: map['mealType'],
      area: map['area'],
      floorStructure: List<dynamic>.from(map['floorStructure'] ?? []),
      rentConfig: Map<String, dynamic>.from(map['rentConfig'] ?? {}),
      depositAmount: (map['depositAmount'] ?? 0.0).toDouble(),
      maintenanceType: map['maintenanceType'] ?? 'one_time',
      maintenanceAmount: (map['maintenanceAmount'] ?? 0.0).toDouble(),
      googleMapLink: map['googleMapLink'],
      ownerNumber: map['ownerNumber'],
      rules:
          map['rules'] != null ? Map<String, dynamic>.from(map['rules']) : null,
      mealTimings: map['mealTimings'],
      foodQuality: map['foodQuality'],
      nearbyPlaces: map['nearbyPlaces'] != null
          ? List<String>.from(map['nearbyPlaces'])
          : null,
      parkingDetails: map['parkingDetails'],
      securityMeasures: map['securityMeasures'],
      paymentInstructions: map['paymentInstructions'],
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  /// Convert entity to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pgName': name,
      'address': address,
      'city': city,
      'state': state,
      'ownerUid': ownerUid,
      'amenities': amenities,
      'photos': photos,
      'contactNumber': contactNumber,
      'pgType': pgType,
      'mealType': mealType,
      'area': area,
      'floorStructure': floorStructure,
      'rentConfig': rentConfig,
      'depositAmount': depositAmount,
      'maintenanceType': maintenanceType,
      'maintenanceAmount': maintenanceAmount,
      'googleMapLink': googleMapLink,
      'ownerNumber': ownerNumber,
      'rules': rules,
      'mealTimings': mealTimings,
      'foodQuality': foodQuality,
      'nearbyPlaces': nearbyPlaces,
      'parkingDetails': parkingDetails,
      'securityMeasures': securityMeasures,
      'paymentInstructions': paymentInstructions,
      'createdAt': DateServiceConverter.toService(createdAt),
      'updatedAt': DateServiceConverter.toService(updatedAt),
    };
  }

  /// Copy with changes
  OwnerPgEntity copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? state,
    String? ownerUid,
    List<String>? amenities,
    List<String>? photos,
    String? contactNumber,
    String? pgType,
    String? mealType,
    String? area,
    List<dynamic>? floorStructure,
    Map<String, dynamic>? rentConfig,
    double? depositAmount,
    String? maintenanceType,
    double? maintenanceAmount,
    String? googleMapLink,
    String? ownerNumber,
    Map<String, dynamic>? rules,
    String? mealTimings,
    String? foodQuality,
    List<String>? nearbyPlaces,
    String? parkingDetails,
    String? securityMeasures,
    String? paymentInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OwnerPgEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      ownerUid: ownerUid ?? this.ownerUid,
      amenities: amenities ?? this.amenities,
      photos: photos ?? this.photos,
      contactNumber: contactNumber ?? this.contactNumber,
      pgType: pgType ?? this.pgType,
      mealType: mealType ?? this.mealType,
      area: area ?? this.area,
      floorStructure: floorStructure ?? this.floorStructure,
      rentConfig: rentConfig ?? this.rentConfig,
      depositAmount: depositAmount ?? this.depositAmount,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      maintenanceAmount: maintenanceAmount ?? this.maintenanceAmount,
      googleMapLink: googleMapLink ?? this.googleMapLink,
      ownerNumber: ownerNumber ?? this.ownerNumber,
      rules: rules ?? this.rules,
      mealTimings: mealTimings ?? this.mealTimings,
      foodQuality: foodQuality ?? this.foodQuality,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      parkingDetails: parkingDetails ?? this.parkingDetails,
      securityMeasures: securityMeasures ?? this.securityMeasures,
      paymentInstructions: paymentInstructions ?? this.paymentInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerPgEntity &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.ownerUid == ownerUid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        ownerUid.hashCode;
  }

  @override
  String toString() {
    return 'OwnerPgEntity(id: $id, name: $name, address: $address, city: $city, state: $state, ownerUid: $ownerUid)';
  }
}
