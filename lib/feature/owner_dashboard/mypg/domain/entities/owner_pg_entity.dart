// lib/feature/owner_dashboard/mypg/domain/entities/owner_pg_entity.dart

/// Domain entity for Owner PG
/// Represents the core business logic and rules for PG management
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
  final List<dynamic> floorStructure;
  final Map<String, dynamic> rentConfig;
  final double depositAmount;
  final String maintenanceType;
  final double maintenanceAmount;
  final String? googleMapLink;
  final String? ownerNumber;
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
    required this.floorStructure,
    required this.rentConfig,
    required this.depositAmount,
    required this.maintenanceType,
    required this.maintenanceAmount,
    this.googleMapLink,
    this.ownerNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create entity from map
  factory OwnerPgEntity.fromMap(Map<String, dynamic> map) {
    return OwnerPgEntity(
      id: map['id'] ?? '',
      name: map['pgName'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      ownerUid: map['ownerUid'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      photos: List<String>.from(map['photos'] ?? []),
      contactNumber: map['contactNumber'] ?? '',
      pgType: map['pgType'] ?? '',
      floorStructure: List<dynamic>.from(map['floorStructure'] ?? []),
      rentConfig: Map<String, dynamic>.from(map['rentConfig'] ?? {}),
      depositAmount: (map['depositAmount'] ?? 0.0).toDouble(),
      maintenanceType: map['maintenanceType'] ?? 'one_time',
      maintenanceAmount: (map['maintenanceAmount'] ?? 0.0).toDouble(),
      googleMapLink: map['googleMapLink'],
      ownerNumber: map['ownerNumber'],
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
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
      'floorStructure': floorStructure,
      'rentConfig': rentConfig,
      'depositAmount': depositAmount,
      'maintenanceType': maintenanceType,
      'maintenanceAmount': maintenanceAmount,
      'googleMapLink': googleMapLink,
      'ownerNumber': ownerNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
    List<dynamic>? floorStructure,
    Map<String, dynamic>? rentConfig,
    double? depositAmount,
    String? maintenanceType,
    double? maintenanceAmount,
    String? googleMapLink,
    String? ownerNumber,
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
      floorStructure: floorStructure ?? this.floorStructure,
      rentConfig: rentConfig ?? this.rentConfig,
      depositAmount: depositAmount ?? this.depositAmount,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      maintenanceAmount: maintenanceAmount ?? this.maintenanceAmount,
      googleMapLink: googleMapLink ?? this.googleMapLink,
      ownerNumber: ownerNumber ?? this.ownerNumber,
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
