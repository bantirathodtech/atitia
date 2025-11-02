// lib/core/models/bed_change_request_model.dart

class BedChangeRequestModel {
  final String requestId;
  final String guestId;
  final String ownerId;
  final String pgId;
  final String? currentRoomNumber;
  final String? currentBedNumber;
  final String? preferredRoomNumber;
  final String? preferredBedNumber;
  final String reason;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? decisionNotes;

  BedChangeRequestModel({
    required this.requestId,
    required this.guestId,
    required this.ownerId,
    required this.pgId,
    required this.reason,
    this.currentRoomNumber,
    this.currentBedNumber,
    this.preferredRoomNumber,
    this.preferredBedNumber,
    this.status = 'pending',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.decisionNotes,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory BedChangeRequestModel.fromMap(Map<String, dynamic> map) {
    return BedChangeRequestModel(
      requestId: map['requestId'] ?? '',
      guestId: map['guestId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      pgId: map['pgId'] ?? '',
      currentRoomNumber: map['currentRoomNumber'],
      currentBedNumber: map['currentBedNumber'],
      preferredRoomNumber: map['preferredRoomNumber'],
      preferredBedNumber: map['preferredBedNumber'],
      reason: map['reason'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
      decisionNotes: map['decisionNotes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'guestId': guestId,
      'ownerId': ownerId,
      'pgId': pgId,
      'currentRoomNumber': currentRoomNumber,
      'currentBedNumber': currentBedNumber,
      'preferredRoomNumber': preferredRoomNumber,
      'preferredBedNumber': preferredBedNumber,
      'reason': reason,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'decisionNotes': decisionNotes,
    };
  }
}
