// lib/feature/owner_dashboard/guests/data/models/owner_guest_model.dart

import 'package:equatable/equatable.dart';

/// Model representing a guest in the owner's PG management system
/// Contains guest information, room assignment, and contact details
class OwnerGuestModel extends Equatable {
  final String guestId;
  final String guestName;
  final String phoneNumber;
  final String email;
  final String pgId;
  final String ownerId;
  final String roomNumber;
  final String bedNumber;
  final String bookingId;
  final String status; // active, inactive, pending
  final DateTime checkInDate;
  final DateTime? checkOutDate;
  final String profilePhotoUrl;
  final String emergencyContact;
  final String emergencyPhone;
  final String address;
  final String occupation;
  final String company;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const OwnerGuestModel({
    required this.guestId,
    required this.guestName,
    required this.phoneNumber,
    required this.email,
    required this.pgId,
    required this.ownerId,
    required this.roomNumber,
    required this.bedNumber,
    required this.bookingId,
    required this.status,
    required this.checkInDate,
    this.checkOutDate,
    required this.profilePhotoUrl,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.address,
    required this.occupation,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  /// Create OwnerGuestModel from Firestore document
  factory OwnerGuestModel.fromMap(Map<String, dynamic> data) {
    return OwnerGuestModel(
      guestId: data['guestId'] ?? '',
      guestName: data['guestName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      pgId: data['pgId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      bedNumber: data['bedNumber'] ?? '',
      bookingId: data['bookingId'] ?? '',
      status: data['status'] ?? 'active',
      checkInDate: data['checkInDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['checkInDate'])
          : DateTime.now(),
      checkOutDate: data['checkOutDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['checkOutDate'])
          : null,
      profilePhotoUrl: data['profilePhotoUrl'] ?? '',
      emergencyContact: data['emergencyContact'] ?? '',
      emergencyPhone: data['emergencyPhone'] ?? '',
      address: data['address'] ?? '',
      occupation: data['occupation'] ?? '',
      company: data['company'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert OwnerGuestModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'guestId': guestId,
      'guestName': guestName,
      'phoneNumber': phoneNumber,
      'email': email,
      'pgId': pgId,
      'ownerId': ownerId,
      'roomNumber': roomNumber,
      'bedNumber': bedNumber,
      'bookingId': bookingId,
      'status': status,
      'checkInDate': checkInDate.millisecondsSinceEpoch,
      'checkOutDate': checkOutDate?.millisecondsSinceEpoch,
      'profilePhotoUrl': profilePhotoUrl,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'address': address,
      'occupation': occupation,
      'company': company,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  OwnerGuestModel copyWith({
    String? guestId,
    String? guestName,
    String? phoneNumber,
    String? email,
    String? pgId,
    String? ownerId,
    String? roomNumber,
    String? bedNumber,
    String? bookingId,
    String? status,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? profilePhotoUrl,
    String? emergencyContact,
    String? emergencyPhone,
    String? address,
    String? occupation,
    String? company,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return OwnerGuestModel(
      guestId: guestId ?? this.guestId,
      guestName: guestName ?? this.guestName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      pgId: pgId ?? this.pgId,
      ownerId: ownerId ?? this.ownerId,
      roomNumber: roomNumber ?? this.roomNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      bookingId: bookingId ?? this.bookingId,
      status: status ?? this.status,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        guestId,
        guestName,
        phoneNumber,
        email,
        pgId,
        ownerId,
        roomNumber,
        bedNumber,
        bookingId,
        status,
        checkInDate,
        checkOutDate,
        profilePhotoUrl,
        emergencyContact,
        emergencyPhone,
        address,
        occupation,
        company,
        createdAt,
        updatedAt,
        isActive,
      ];

  /// Get display name for UI
  String get displayName => guestName.isNotEmpty ? guestName : 'Unknown Guest';

  /// Get room assignment display
  String get roomAssignment => 'Room $roomNumber, Bed $bedNumber';

  /// Get status display
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  /// Check if guest is currently active
  bool get isCurrentlyActive => status.toLowerCase() == 'active' && isActive;

  /// Get duration of stay
  Duration get stayDuration => DateTime.now().difference(checkInDate);

  /// Get formatted stay duration
  String get formattedStayDuration {
    final duration = stayDuration;
    if (duration.inDays > 0) {
      return '${duration.inDays} days';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours';
    } else {
      return '${duration.inMinutes} minutes';
    }
  }
}
