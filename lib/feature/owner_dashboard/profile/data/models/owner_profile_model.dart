// lib/features/owner_dashboard/profile/data/models/owner_profile_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Represents the detailed profile of an Owner with business and banking information
/// Contains personal details, identification documents, banking information,
/// UPI details, and owned PG property references
/// Enhanced with timestamps, validation, and helper methods
class OwnerProfile {
  final String ownerId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String? profilePhoto;
  final String? aadhaarNumber;
  final String? aadhaarPhoto;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? bankIFSC;
  final String? upiId;
  final String? upiQrCodeUrl;
  final List<String> pgIds; // List of PG property IDs managed by owner
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? panNumber;
  final String? gstNumber;
  final String? businessName;
  final String? businessType;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  OwnerProfile({
    required this.ownerId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.profilePhoto,
    this.aadhaarNumber,
    this.aadhaarPhoto,
    this.bankAccountName,
    this.bankAccountNumber,
    this.bankIFSC,
    this.upiId,
    this.upiQrCodeUrl,
    this.pgIds = const [],
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.panNumber,
    this.gstNumber,
    this.businessName,
    this.businessType,
    this.dateOfBirth,
    this.gender,
    this.isActive = true,
    this.isVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Provides bank details as a structured map for consistent access
  Map<String, String?> get bankDetails => {
        'accountName': bankAccountName,
        'accountNumber': bankAccountNumber,
        'ifsc': bankIFSC,
      };

  /// Provides UPI details as a structured map for payment processing
  Map<String, String?> get upiDetails => {
        'upiId': upiId,
        'qrCodeUrl': upiQrCodeUrl,
      };

  /// Factory constructor to create OwnerProfile from Firestore document
  factory OwnerProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Extract nested fields safely with fallback values
    final bankData = data['bankDetails'] as Map<String, dynamic>? ?? {};
    final upiData = data['upiDetails'] as Map<String, dynamic>? ?? {};

    return OwnerProfile(
      ownerId: doc.id,
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      profilePhoto: data['profilePhoto'],
      aadhaarNumber: data['aadhaarNumber'],
      aadhaarPhoto: data['aadhaarPhoto'],
      bankAccountName: bankData['accountName'],
      bankAccountNumber: bankData['accountNumber'],
      bankIFSC: bankData['ifsc'],
      upiId: upiData['upiId'],
      upiQrCodeUrl: upiData['qrCodeUrl'],
      pgIds: List<String>.from(data['pgIds'] ?? []),
      address: data['address'],
      city: data['city'],
      state: data['state'],
      pincode: data['pincode'],
      panNumber: data['panNumber'],
      gstNumber: data['gstNumber'],
      businessName: data['businessName'],
      businessType: data['businessType'],
      dateOfBirth: data['dateOfBirth']?.toDate(),
      gender: data['gender'],
      isActive: data['isActive'] ?? true,
      isVerified: data['isVerified'] ?? false,
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
    );
  }

  /// Converts OwnerProfile to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'profilePhoto': profilePhoto,
      'aadhaarNumber': aadhaarNumber,
      'aadhaarPhoto': aadhaarPhoto,
      'bankDetails': {
        'accountName': bankAccountName,
        'accountNumber': bankAccountNumber,
        'ifsc': bankIFSC,
      },
      'upiDetails': {
        'upiId': upiId,
        'qrCodeUrl': upiQrCodeUrl,
      },
      'pgIds': pgIds,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'panNumber': panNumber,
      'gstNumber': gstNumber,
      'businessName': businessName,
      'businessType': businessType,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'metadata': metadata,
    };
  }

  /// Creates a copy with updated fields
  OwnerProfile copyWith({
    String? ownerId,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? profilePhoto,
    String? aadhaarNumber,
    String? aadhaarPhoto,
    String? bankAccountName,
    String? bankAccountNumber,
    String? bankIFSC,
    String? upiId,
    String? upiQrCodeUrl,
    List<String>? pgIds,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? panNumber,
    String? gstNumber,
    String? businessName,
    String? businessType,
    DateTime? dateOfBirth,
    String? gender,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerProfile(
      ownerId: ownerId ?? this.ownerId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      aadhaarPhoto: aadhaarPhoto ?? this.aadhaarPhoto,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankIFSC: bankIFSC ?? this.bankIFSC,
      upiId: upiId ?? this.upiId,
      upiQrCodeUrl: upiQrCodeUrl ?? this.upiQrCodeUrl,
      pgIds: pgIds ?? this.pgIds,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      panNumber: panNumber ?? this.panNumber,
      gstNumber: gstNumber ?? this.gstNumber,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  /// Checks if owner has any PG properties registered
  bool get hasPGs => pgIds.isNotEmpty;

  /// Gets the number of PG properties managed by owner
  int get pgCount => pgIds.length;

  /// Checks if owner has complete bank details
  bool get hasBankDetails =>
      bankAccountName != null &&
      bankAccountName!.isNotEmpty &&
      bankAccountNumber != null &&
      bankAccountNumber!.isNotEmpty &&
      bankIFSC != null &&
      bankIFSC!.isNotEmpty;

  /// Checks if owner has UPI setup
  bool get hasUpiSetup => upiId != null && upiId!.isNotEmpty;

  /// Checks if owner has complete profile
  bool get hasCompleteProfile =>
      fullName.isNotEmpty &&
      email.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      hasBankDetails;

  /// Checks if owner has business information
  bool get hasBusinessInfo =>
      businessName != null && businessName!.isNotEmpty;

  /// Returns owner initials for avatar
  String get initials {
    if (fullName.isEmpty) return 'O';
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }

  /// Returns full address string
  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (pincode != null && pincode!.isNotEmpty) parts.add(pincode!);
    return parts.isEmpty ? 'N/A' : parts.join(', ');
  }

  /// Returns formatted date of birth
  String get formattedDateOfBirth => dateOfBirth != null
      ? DateFormat('MMM dd, yyyy').format(dateOfBirth!)
      : 'N/A';

  /// Returns formatted created date
  String get formattedCreatedAt => createdAt != null
      ? DateFormat('MMM dd, yyyy').format(createdAt!)
      : 'N/A';

  /// Returns formatted updated date
  String get formattedUpdatedAt => updatedAt != null
      ? DateFormat('MMM dd, yyyy hh:mm a').format(updatedAt!)
      : 'N/A';

  /// Returns display name for UI
  String get displayName => businessName ?? fullName;

  /// Returns status display
  String get statusDisplay => isActive ? 'Active' : 'Inactive';

  /// Returns verification status display
  String get verificationDisplay => isVerified ? 'Verified' : 'Not Verified';

  /// Returns profile completion percentage
  int get profileCompletionPercentage {
    int completed = 0;
    const int total = 10;

    if (fullName.isNotEmpty) completed++;
    if (email.isNotEmpty) completed++;
    if (phoneNumber.isNotEmpty) completed++;
    if (hasBankDetails) completed++;
    if (hasUpiSetup) completed++;
    if (profilePhoto != null) completed++;
    if (aadhaarNumber != null) completed++;
    if (hasBusinessInfo) completed++;
    if (address != null && address!.isNotEmpty) completed++;
    if (panNumber != null && panNumber!.isNotEmpty) completed++;

    return ((completed / total) * 100).round();
  }

  @override
  String toString() {
    return 'OwnerProfile(ownerId: $ownerId, fullName: $fullName, pgCount: $pgCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerProfile && other.ownerId == ownerId;
  }

  @override
  int get hashCode => ownerId.hashCode;
}

