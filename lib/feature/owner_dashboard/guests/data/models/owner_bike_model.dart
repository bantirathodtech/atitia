// lib/feature/owner_dashboard/guests/data/models/owner_bike_model.dart

import 'package:equatable/equatable.dart';

/// Model representing a bike in the owner's PG management system
/// Contains bike information, guest details, and parking assignments
class OwnerBikeModel extends Equatable {
  final String bikeId;
  final String guestId;
  final String guestName;
  final String pgId;
  final String ownerId;
  final String roomNumber;
  final String bikeNumber;
  final String bikeName;
  final String bikeType; // two_wheeler, scooter, motorcycle
  final String color;
  final String parkingSpot;
  final String status; // registered, active, removed, violation
  final DateTime registrationDate;
  final DateTime? lastParkedDate;
  final DateTime? removalDate;
  final String? violationReason;
  final String? notes;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const OwnerBikeModel({
    required this.bikeId,
    required this.guestId,
    required this.guestName,
    required this.pgId,
    required this.ownerId,
    required this.roomNumber,
    required this.bikeNumber,
    required this.bikeName,
    required this.bikeType,
    required this.color,
    required this.parkingSpot,
    required this.status,
    required this.registrationDate,
    this.lastParkedDate,
    this.removalDate,
    this.violationReason,
    this.notes,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  /// Create OwnerBikeModel from Firestore document
  factory OwnerBikeModel.fromMap(Map<String, dynamic> data) {
    return OwnerBikeModel(
      bikeId: data['bikeId'] ?? '',
      guestId: data['guestId'] ?? '',
      guestName: data['guestName'] ?? '',
      pgId: data['pgId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      bikeNumber: data['bikeNumber'] ?? '',
      bikeName: data['bikeName'] ?? '',
      bikeType: data['bikeType'] ?? 'two_wheeler',
      color: data['color'] ?? '',
      parkingSpot: data['parkingSpot'] ?? '',
      status: data['status'] ?? 'registered',
      registrationDate: data['registrationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['registrationDate'])
          : DateTime.now(),
      lastParkedDate: data['lastParkedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastParkedDate'])
          : null,
      removalDate: data['removalDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['removalDate'])
          : null,
      violationReason: data['violationReason'],
      notes: data['notes'],
      photoUrl: data['photoUrl'],
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert OwnerBikeModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'bikeId': bikeId,
      'guestId': guestId,
      'guestName': guestName,
      'pgId': pgId,
      'ownerId': ownerId,
      'roomNumber': roomNumber,
      'bikeNumber': bikeNumber,
      'bikeName': bikeName,
      'bikeType': bikeType,
      'color': color,
      'parkingSpot': parkingSpot,
      'status': status,
      'registrationDate': registrationDate.millisecondsSinceEpoch,
      'lastParkedDate': lastParkedDate?.millisecondsSinceEpoch,
      'removalDate': removalDate?.millisecondsSinceEpoch,
      'violationReason': violationReason,
      'notes': notes,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  OwnerBikeModel copyWith({
    String? bikeId,
    String? guestId,
    String? guestName,
    String? pgId,
    String? ownerId,
    String? roomNumber,
    String? bikeNumber,
    String? bikeName,
    String? bikeType,
    String? color,
    String? parkingSpot,
    String? status,
    DateTime? registrationDate,
    DateTime? lastParkedDate,
    DateTime? removalDate,
    String? violationReason,
    String? notes,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return OwnerBikeModel(
      bikeId: bikeId ?? this.bikeId,
      guestId: guestId ?? this.guestId,
      guestName: guestName ?? this.guestName,
      pgId: pgId ?? this.pgId,
      ownerId: ownerId ?? this.ownerId,
      roomNumber: roomNumber ?? this.roomNumber,
      bikeNumber: bikeNumber ?? this.bikeNumber,
      bikeName: bikeName ?? this.bikeName,
      bikeType: bikeType ?? this.bikeType,
      color: color ?? this.color,
      parkingSpot: parkingSpot ?? this.parkingSpot,
      status: status ?? this.status,
      registrationDate: registrationDate ?? this.registrationDate,
      lastParkedDate: lastParkedDate ?? this.lastParkedDate,
      removalDate: removalDate ?? this.removalDate,
      violationReason: violationReason ?? this.violationReason,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        bikeId,
        guestId,
        guestName,
        pgId,
        ownerId,
        roomNumber,
        bikeNumber,
        bikeName,
        bikeType,
        color,
        parkingSpot,
        status,
        registrationDate,
        lastParkedDate,
        removalDate,
        violationReason,
        notes,
        photoUrl,
        createdAt,
        updatedAt,
        isActive,
      ];

  /// Get status display
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'registered':
        return 'Registered';
      case 'active':
        return 'Active';
      case 'removed':
        return 'Removed';
      case 'violation':
        return 'Violation';
      default:
        return 'Unknown';
    }
  }

  /// Get bike type display
  String get bikeTypeDisplay {
    switch (bikeType.toLowerCase()) {
      case 'two_wheeler':
        return 'Two Wheeler';
      case 'scooter':
        return 'Scooter';
      case 'motorcycle':
        return 'Motorcycle';
      default:
        return 'Two Wheeler';
    }
  }

  /// Get full bike display name
  String get fullBikeName => '$bikeNumber - $bikeName';

  /// Get guest and room info
  String get guestInfo => '$guestName (Room $roomNumber)';

  /// Check if bike is currently active
  bool get isCurrentlyActive => status.toLowerCase() == 'active';

  /// Check if bike has violations
  bool get hasViolation => status.toLowerCase() == 'violation';

  /// Get registration duration
  Duration get registrationDuration =>
      DateTime.now().difference(registrationDate);

  /// Get formatted registration duration
  String get formattedRegistrationDuration {
    final duration = registrationDuration;
    if (duration.inDays > 0) {
      return '${duration.inDays} days';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours';
    } else {
      return '${duration.inMinutes} minutes';
    }
  }

  /// Get last parked time display
  String get lastParkedDisplay {
    if (lastParkedDate == null) return 'Never parked';

    final now = DateTime.now();
    final difference = now.difference(lastParkedDate!);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

/// Model representing a bike movement request
class BikeMovementRequest extends Equatable {
  final String requestId;
  final String bikeId;
  final String guestId;
  final String guestName;
  final String pgId;
  final String ownerId;
  final String requestType; // move, remove, reassign
  final String currentSpot;
  final String? newSpot;
  final String reason;
  final String status; // pending, approved, rejected, completed
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? processedBy;
  final String? notes;
  final bool isActive;

  const BikeMovementRequest({
    required this.requestId,
    required this.bikeId,
    required this.guestId,
    required this.guestName,
    required this.pgId,
    required this.ownerId,
    required this.requestType,
    required this.currentSpot,
    this.newSpot,
    required this.reason,
    required this.status,
    required this.requestedAt,
    this.processedAt,
    this.processedBy,
    this.notes,
    required this.isActive,
  });

  /// Create BikeMovementRequest from Firestore document
  factory BikeMovementRequest.fromMap(Map<String, dynamic> data) {
    return BikeMovementRequest(
      requestId: data['requestId'] ?? '',
      bikeId: data['bikeId'] ?? '',
      guestId: data['guestId'] ?? '',
      guestName: data['guestName'] ?? '',
      pgId: data['pgId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      requestType: data['requestType'] ?? 'move',
      currentSpot: data['currentSpot'] ?? '',
      newSpot: data['newSpot'],
      reason: data['reason'] ?? '',
      status: data['status'] ?? 'pending',
      requestedAt: data['requestedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['requestedAt'])
          : DateTime.now(),
      processedAt: data['processedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['processedAt'])
          : null,
      processedBy: data['processedBy'],
      notes: data['notes'],
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert BikeMovementRequest to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'bikeId': bikeId,
      'guestId': guestId,
      'guestName': guestName,
      'pgId': pgId,
      'ownerId': ownerId,
      'requestType': requestType,
      'currentSpot': currentSpot,
      'newSpot': newSpot,
      'reason': reason,
      'status': status,
      'requestedAt': requestedAt.millisecondsSinceEpoch,
      'processedAt': processedAt?.millisecondsSinceEpoch,
      'processedBy': processedBy,
      'notes': notes,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        requestId,
        bikeId,
        guestId,
        guestName,
        pgId,
        ownerId,
        requestType,
        currentSpot,
        newSpot,
        reason,
        status,
        requestedAt,
        processedAt,
        processedBy,
        notes,
        isActive,
      ];

  /// Get request type display
  String get requestTypeDisplay {
    switch (requestType.toLowerCase()) {
      case 'move':
        return 'Move Bike';
      case 'remove':
        return 'Remove Bike';
      case 'reassign':
        return 'Reassign Spot';
      default:
        return 'Unknown';
    }
  }

  /// Get status display
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  /// Check if request is pending
  bool get isPending => status.toLowerCase() == 'pending';

  /// Check if request is approved
  bool get isApproved => status.toLowerCase() == 'approved';

  /// Get movement description
  String get movementDescription {
    switch (requestType.toLowerCase()) {
      case 'move':
        return 'Move from $currentSpot to ${newSpot ?? 'new spot'}';
      case 'remove':
        return 'Remove from $currentSpot';
      case 'reassign':
        return 'Reassign spot from $currentSpot';
      default:
        return 'Bike movement request';
    }
  }
}
