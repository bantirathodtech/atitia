import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// User model representing both Guest and Owner users
/// Enhanced with timestamps, validation, and helper methods
class UserModel extends Equatable {
  final String userId;
  final String phoneNumber;
  final String role; // 'guest' or 'owner'
  final String? fullName;
  final DateTime? dateOfBirth;
  final int? age;
  final String? gender;
  final String? email;
  final String? aadhaarNumber;
  final String? aadhaarPhotoUrl;
  final String? profilePhotoUrl;
  final Map<String, dynamic>? emergencyContact;
  // Address fields (for Owner PG location)
  final String? pgAddress;
  final String? state;
  final String? city;
  final String? pincode;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? metadata;

  const UserModel({
    required this.userId,
    required this.phoneNumber,
    required this.role,
    this.fullName,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.email,
    this.aadhaarNumber,
    this.aadhaarPhotoUrl,
    this.profilePhotoUrl,
    this.emergencyContact,
    this.pgAddress,
    this.state,
    this.city,
    this.pincode,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.metadata,
  });

  /// Creates a copy with optional updated fields
  UserModel copyWith({
    String? userId,
    String? phoneNumber,
    String? role,
    String? fullName,
    DateTime? dateOfBirth,
    int? age,
    String? gender,
    String? email,
    String? aadhaarNumber,
    String? aadhaarPhotoUrl,
    String? profilePhotoUrl,
    Map<String, dynamic>? emergencyContact,
    String? pgAddress,
    String? state,
    String? city,
    String? pincode,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      aadhaarPhotoUrl: aadhaarPhotoUrl ?? this.aadhaarPhotoUrl,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      pgAddress: pgAddress ?? this.pgAddress,
      state: state ?? this.state,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        phoneNumber,
        role,
        fullName,
        dateOfBirth,
        age,
        gender,
        email,
        aadhaarNumber,
        aadhaarPhotoUrl,
        profilePhotoUrl,
        emergencyContact,
        pgAddress,
        state,
        city,
        pincode,
        isActive,
        isVerified,
        createdAt,
        updatedAt,
        lastLoginAt,
        metadata,
      ];

  /// Json deserialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      fullName: json['fullName'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? (json['dateOfBirth'] is Timestamp
              ? (json['dateOfBirth'] as Timestamp).toDate()
              : DateTime.parse(json['dateOfBirth']))
          : null,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      aadhaarPhotoUrl: json['aadhaarPhotoUrl'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      emergencyContact: json['emergencyContact'] != null
          ? Map<String, dynamic>.from(json['emergencyContact'])
          : null,
      pgAddress: json['pgAddress'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      pincode: json['pincode'] as String?,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? (json['lastLoginAt'] is Timestamp
              ? (json['lastLoginAt'] as Timestamp).toDate()
              : DateTime.parse(json['lastLoginAt']))
          : null,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  /// Json serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'role': role,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'age': age,
      'gender': gender,
      'email': email,
      'aadhaarNumber': aadhaarNumber,
      'aadhaarPhotoUrl': aadhaarPhotoUrl,
      'profilePhotoUrl': profilePhotoUrl,
      'emergencyContact': emergencyContact,
      'pgAddress': pgAddress,
      'state': state,
      'city': city,
      'pincode': pincode,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Firestore-specific serialization with Timestamp
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'role': role,
      'fullName': fullName,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'age': age,
      'gender': gender,
      'email': email,
      'aadhaarNumber': aadhaarNumber,
      'aadhaarPhotoUrl': aadhaarPhotoUrl,
      'profilePhotoUrl': profilePhotoUrl,
      'emergencyContact': emergencyContact,
      'pgAddress': pgAddress,
      'state': state,
      'city': city,
      'pincode': pincode,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'metadata': metadata,
    };
  }

  // ==================== HELPER METHODS ====================

  /// Check if user is a guest
  bool get isGuest => role == 'guest';

  /// Check if user is an owner
  bool get isOwner => role == 'owner';

  /// Check if profile is complete
  bool get isProfileComplete =>
      fullName != null &&
      fullName!.isNotEmpty &&
      dateOfBirth != null &&
      gender != null &&
      aadhaarNumber != null &&
      emergencyContact != null &&
      emergencyContact!['name'] != null &&
      emergencyContact!['phone'] != null;

  /// Get display name for UI
  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) {
      return fullName!;
    } else if (phoneNumber.isNotEmpty) {
      return phoneNumber;
    } else {
      return 'User';
    }
  }

  /// Get initials for avatar
  String get initials {
    if (fullName == null || fullName!.isEmpty) return 'U';
    final names = fullName!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName!.substring(0, 1).toUpperCase();
  }

  /// Get formatted date of birth
  String get formattedDateOfBirth => dateOfBirth != null
      ? DateFormat('MMM dd, yyyy').format(dateOfBirth!)
      : 'N/A';

  /// Get formatted created date
  String get formattedCreatedAt => createdAt != null
      ? DateFormat('MMM dd, yyyy').format(createdAt!)
      : 'N/A';

  /// Get formatted last login
  String get formattedLastLogin => lastLoginAt != null
      ? DateFormat('MMM dd, yyyy hh:mm a').format(lastLoginAt!)
      : 'Never';

  /// Get role display text
  String get roleDisplay => role == 'guest' ? 'Guest' : 'Owner';

  /// Get status display
  String get statusDisplay => isActive ? 'Active' : 'Inactive';

  /// Get verification status display
  String get verificationDisplay => isVerified ? 'Verified' : 'Not Verified';

  /// Get emergency contact name
  String? get emergencyContactName => emergencyContact?['name'];

  /// Get emergency contact phone
  String? get emergencyContactPhone => emergencyContact?['phone'];

  /// Get emergency contact relationship
  String? get emergencyContactRelationship => emergencyContact?['relationship'];

  /// Check if has emergency contact
  bool get hasEmergencyContact =>
      emergencyContact != null &&
      emergencyContact!['name'] != null &&
      emergencyContact!['phone'] != null;

  /// Check if has profile photo
  bool get hasProfilePhoto =>
      profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty;

  /// Check if has Aadhaar document
  bool get hasAadhaarDocument =>
      aadhaarPhotoUrl != null && aadhaarPhotoUrl!.isNotEmpty;

  /// Check if has complete address
  bool get hasCompleteAddress =>
      pgAddress != null &&
      pgAddress!.isNotEmpty &&
      state != null &&
      state!.isNotEmpty &&
      city != null &&
      city!.isNotEmpty &&
      pincode != null &&
      pincode!.isNotEmpty;

  /// Get formatted full address
  String get fullAddress {
    if (!hasCompleteAddress) return 'Address not provided';
    return '$pgAddress, $city, $state - $pincode';
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, role: $role, fullName: $fullName)';
  }
}
