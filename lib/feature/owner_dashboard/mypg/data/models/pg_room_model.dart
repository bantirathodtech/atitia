// ============================================================================
// PG Room Model - Represents a single room in the PG
// ============================================================================
// Supports flexible bed configurations and sharing-based pricing
// Each room can have different number of beds and pricing
// ============================================================================

import 'pg_bed_model.dart';

/// Model representing a room in the PG
class PgRoomModel {
  final String roomId;
  final String roomNumber; // "101", "T1", "A-5", etc.
  final String
      sharingType; // "1-sharing", "2-sharing", "3-sharing", "4-sharing", "5-sharing"
  final int bedsCount; // Number of beds in this room
  final int pricePerBed; // Monthly rent per bed in rupees
  final List<PgBedModel> beds; // Individual bed tracking
  final String? description;
  final double? roomSize; // In sq ft (optional)

  PgRoomModel({
    required this.roomId,
    required this.roomNumber,
    required this.sharingType,
    required this.bedsCount,
    required this.pricePerBed,
    required this.beds,
    this.description,
    this.roomSize,
  });

  /// Create from Firestore map
  factory PgRoomModel.fromMap(Map<String, dynamic> map) {
    return PgRoomModel(
      roomId: map['roomId'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      sharingType: map['sharingType'] ?? '',
      bedsCount: (map['bedsCount'] ?? 0).toInt(),
      pricePerBed: (map['pricePerBed'] ?? 0).toInt(),
      beds: (map['beds'] as List<dynamic>?)
              ?.map((b) => PgBedModel.fromMap(b as Map<String, dynamic>))
              .toList() ??
          [],
      description: map['description'],
      roomSize: map['roomSize']?.toDouble(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomNumber': roomNumber,
      'sharingType': sharingType,
      'bedsCount': bedsCount,
      'pricePerBed': pricePerBed,
      'beds': beds.map((b) => b.toMap()).toList(),
      'description': description,
      'roomSize': roomSize,
    };
  }

  /// Get total revenue for this room (all beds occupied)
  int get totalRevenue => bedsCount * pricePerBed;

  /// Get current revenue (only occupied beds)
  int get currentRevenue => occupiedBedsCount * pricePerBed;

  /// Get vacant beds count
  int get vacantBedsCount => beds.where((bed) => bed.status == 'vacant').length;

  /// Get occupied beds count
  int get occupiedBedsCount =>
      beds.where((bed) => bed.status == 'occupied').length;

  /// Get occupancy percentage
  double get occupancyPercentage =>
      bedsCount > 0 ? (occupiedBedsCount / bedsCount) * 100 : 0;

  /// Get sharing number (extract from "5-sharing" → 5)
  int get sharingNumber {
    final match = RegExp(r'(\d+)').firstMatch(sharingType);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  /// Display name for UI
  String get displayName => 'Room $roomNumber ($sharingType)';

  /// Formatted price
  String get formattedPrice => '₹${pricePerBed.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}/month';

  /// Copy with updated fields
  PgRoomModel copyWith({
    String? roomId,
    String? roomNumber,
    String? sharingType,
    int? bedsCount,
    int? pricePerBed,
    List<PgBedModel>? beds,
    String? description,
    double? roomSize,
  }) {
    return PgRoomModel(
      roomId: roomId ?? this.roomId,
      roomNumber: roomNumber ?? this.roomNumber,
      sharingType: sharingType ?? this.sharingType,
      bedsCount: bedsCount ?? this.bedsCount,
      pricePerBed: pricePerBed ?? this.pricePerBed,
      beds: beds ?? this.beds,
      description: description ?? this.description,
      roomSize: roomSize ?? this.roomSize,
    );
  }

  /// Generate beds for this room based on bed count
  static List<PgBedModel> generateBeds(
      String roomId, String roomNumber, int count) {
    return List.generate(
      count,
      (index) => PgBedModel(
        bedId: '${roomId}_bed_${index + 1}',
        bedNumber:
            '$roomNumber-${String.fromCharCode(65 + index)}', // A, B, C...
        roomId: roomId,
        status: 'vacant',
        guestId: null,
      ),
    );
  }
}
