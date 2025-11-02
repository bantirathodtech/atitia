// ============================================================================
// PG Floor Model - Represents a single floor in the PG building
// ============================================================================
// Supports flexible room configurations per floor
// Each floor can have different number of rooms
// ============================================================================

import 'pg_room_model.dart';

/// Model representing a floor in the PG building
class PgFloorModel {
  final String floorId;
  final String floorName; // "Ground Floor", "Floor 1", "Terrace", etc.
  final int floorNumber; // 0 (Ground), 1, 2, 3, etc.
  final List<PgRoomModel> rooms;
  final String? description;

  PgFloorModel({
    required this.floorId,
    required this.floorName,
    required this.floorNumber,
    required this.rooms,
    this.description,
  });

  /// Create from Firestore map
  factory PgFloorModel.fromMap(Map<String, dynamic> map) {
    return PgFloorModel(
      floorId: map['floorId'] ?? '',
      floorName: map['floorName'] ?? '',
      floorNumber: (map['floorNumber'] ?? 0).toInt(),
      rooms: (map['rooms'] as List<dynamic>?)
              ?.map((r) => PgRoomModel.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
      description: map['description'],
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'floorId': floorId,
      'floorName': floorName,
      'floorNumber': floorNumber,
      'rooms': rooms.map((r) => r.toMap()).toList(),
      'description': description,
    };
  }

  /// Get total rooms on this floor
  int get totalRooms => rooms.length;

  /// Get total beds on this floor
  int get totalBeds => rooms.fold(0, (sum, room) => sum + room.bedsCount);

  /// Get total revenue potential for this floor
  int get totalRevenue => rooms.fold(0, (sum, room) => sum + room.totalRevenue);

  /// Get vacant beds count
  int get vacantBeds =>
      rooms.fold(0, (sum, room) => sum + room.vacantBedsCount);

  /// Get occupied beds count
  int get occupiedBeds =>
      rooms.fold(0, (sum, room) => sum + room.occupiedBedsCount);

  /// Copy with updated fields
  PgFloorModel copyWith({
    String? floorId,
    String? floorName,
    int? floorNumber,
    List<PgRoomModel>? rooms,
    String? description,
  }) {
    return PgFloorModel(
      floorId: floorId ?? this.floorId,
      floorName: floorName ?? this.floorName,
      floorNumber: floorNumber ?? this.floorNumber,
      rooms: rooms ?? this.rooms,
      description: description ?? this.description,
    );
  }
}
