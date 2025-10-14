// ============================================================================
// PG Bed Model - Represents a single bed in a room
// ============================================================================
// Tracks individual bed status and guest assignment
// ============================================================================

/// Model representing a single bed in the PG
class PgBedModel {
  final String bedId;
  final String bedNumber; // "101-A", "101-B", "T1-A", etc.
  final String roomId; // Parent room reference
  final String status; // "vacant", "occupied", "reserved", "maintenance"
  final String? guestId; // ID of guest occupying this bed (if occupied)
  final DateTime? occupiedFrom; // When guest started occupying
  final DateTime? occupiedUntil; // Expected vacating date

  PgBedModel({
    required this.bedId,
    required this.bedNumber,
    required this.roomId,
    required this.status,
    this.guestId,
    this.occupiedFrom,
    this.occupiedUntil,
  });

  /// Create from Firestore map
  factory PgBedModel.fromMap(Map<String, dynamic> map) {
    return PgBedModel(
      bedId: map['bedId'] ?? '',
      bedNumber: map['bedNumber'] ?? '',
      roomId: map['roomId'] ?? '',
      status: map['status'] ?? 'vacant',
      guestId: map['guestId'],
      occupiedFrom: map['occupiedFrom']?.toDate(),
      occupiedUntil: map['occupiedUntil']?.toDate(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'bedId': bedId,
      'bedNumber': bedNumber,
      'roomId': roomId,
      'status': status,
      'guestId': guestId,
      'occupiedFrom': occupiedFrom,
      'occupiedUntil': occupiedUntil,
    };
  }

  /// Check if bed is vacant
  bool get isVacant => status == 'vacant';

  /// Check if bed is occupied
  bool get isOccupied => status == 'occupied';

  /// Check if bed is reserved
  bool get isReserved => status == 'reserved';

  /// Copy with updated fields
  PgBedModel copyWith({
    String? bedId,
    String? bedNumber,
    String? roomId,
    String? status,
    String? guestId,
    DateTime? occupiedFrom,
    DateTime? occupiedUntil,
  }) {
    return PgBedModel(
      bedId: bedId ?? this.bedId,
      bedNumber: bedNumber ?? this.bedNumber,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      guestId: guestId ?? this.guestId,
      occupiedFrom: occupiedFrom ?? this.occupiedFrom,
      occupiedUntil: occupiedUntil ?? this.occupiedUntil,
    );
  }
}

