// lib/features/guest_dashboard/profile/data/models/guest_profile_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../auth/data/model/user_model.dart';

/// GuestModel extends base UserModel with guest-specific profile data.
/// Contains comprehensive guest information including personal, professional, and accommodation details
class GuestProfileModel extends UserModel {
  final String? address;
  final String? guardianName;
  final String? guardianPhone;
  final String? foodPreference;
  final String? maritalStatus;
  final String? education;
  final String? occupation;
  final String? organizationName;
  final String? organizationAddress;
  final String? vehicleNo;
  final String? vehicleName;
  final DateTime? joiningDate;
  final double? deposit;
  final double? rent;
  final String? bloodGroup;
  final String? nationality;
  @override
  final String? state;
  @override
  final String? city;
  @override
  final String? pincode;
  final String? idProofType;
  final String? idProofNumber;
  final String? idProofUrl;
  final List<String>? allergies;
  final String? medicalConditions;
  final DateTime? lastUpdated;
  final Map<String, dynamic>? preferences;
  // Note: isActive, metadata, isVerified, createdAt, updatedAt are inherited from UserModel

  const GuestProfileModel({
    required super.userId,
    required super.phoneNumber,
    required super.role,
    super.fullName,
    super.dateOfBirth,
    super.age,
    super.gender,
    super.email,
    super.aadhaarNumber,
    super.aadhaarPhotoUrl,
    super.profilePhotoUrl,
    super.emergencyContact,
    this.address,
    this.guardianName,
    this.guardianPhone,
    this.foodPreference,
    this.maritalStatus,
    this.education,
    this.occupation,
    this.organizationName,
    this.organizationAddress,
    this.vehicleNo,
    this.vehicleName,
    this.joiningDate,
    this.deposit,
    this.rent,
    this.bloodGroup,
    this.nationality,
    this.state,
    this.city,
    this.pincode,
    this.idProofType,
    this.idProofNumber,
    this.idProofUrl,
    this.allergies,
    this.medicalConditions,
    this.lastUpdated,
    this.preferences,
    // isActive, metadata inherited from UserModel
    super.isActive,
    super.isVerified,
    super.createdAt,
    super.updatedAt,
    super.lastLoginAt,
    super.metadata,
  });

  /// Factory to create GuestProfileModel from Firestore map.
  factory GuestProfileModel.fromMap(Map<String, dynamic> map) {
    Timestamp? joiningTimestamp = map['joiningDate'] as Timestamp?;
    Timestamp? dobTimestamp = map['dateOfBirth'] as Timestamp?;
    Timestamp? lastUpdatedTimestamp = map['lastUpdated'] as Timestamp?;

    return GuestProfileModel(
      userId: map['userId'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? 'guest',
      fullName: map['fullName'],
      dateOfBirth: dobTimestamp?.toDate(),
      age: map['age'] is int ? map['age'] : null,
      gender: map['gender'],
      email: map['email'],
      aadhaarNumber: map['aadhaarNumber'],
      aadhaarPhotoUrl: map['aadhaarPhotoUrl'],
      profilePhotoUrl: map['profilePhotoUrl'],
      emergencyContact: map['emergencyContact']?.cast<String, dynamic>(),
      address: map['address'],
      guardianName: map['guardianName'],
      guardianPhone: map['guardianPhone'],
      foodPreference: map['foodPreference'],
      maritalStatus: map['maritalStatus'],
      education: map['education'],
      occupation: map['occupation'],
      organizationName: map['organizationName'],
      organizationAddress: map['organizationAddress'],
      vehicleNo: map['vehicleNo'],
      vehicleName: map['vehicleName'],
      joiningDate: joiningTimestamp?.toDate(),
      deposit: map['deposit'] != null ? (map['deposit'] as num).toDouble() : null,
      rent: map['rent'] != null ? (map['rent'] as num).toDouble() : null,
      bloodGroup: map['bloodGroup'],
      nationality: map['nationality'],
      state: map['state'],
      city: map['city'],
      pincode: map['pincode'],
      idProofType: map['idProofType'],
      idProofNumber: map['idProofNumber'],
      idProofUrl: map['idProofUrl'],
      allergies: map['allergies'] != null ? List<String>.from(map['allergies']) : null,
      medicalConditions: map['medicalConditions'],
      isActive: map['isActive'] ?? true,
      lastUpdated: lastUpdatedTimestamp?.toDate() ?? DateTime.now(),
      preferences: map['preferences'] != null ? Map<String, dynamic>.from(map['preferences']) : null,
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(map['metadata']) : null,
    );
  }

  /// Converts guest information to map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'role': role,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'age': age,
      'gender': gender,
      'email': email,
      'aadhaarNumber': aadhaarNumber,
      'aadhaarPhotoUrl': aadhaarPhotoUrl,
      'profilePhotoUrl': profilePhotoUrl,
      'emergencyContact': emergencyContact,
      'address': address,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'foodPreference': foodPreference,
      'maritalStatus': maritalStatus,
      'education': education,
      'occupation': occupation,
      'organizationName': organizationName,
      'organizationAddress': organizationAddress,
      'vehicleNo': vehicleNo,
      'vehicleName': vehicleName,
      'joiningDate': joiningDate != null ? Timestamp.fromDate(joiningDate!) : null,
      'deposit': deposit,
      'rent': rent,
      'bloodGroup': bloodGroup,
      'nationality': nationality,
      'state': state,
      'city': city,
      'pincode': pincode,
      'idProofType': idProofType,
      'idProofNumber': idProofNumber,
      'idProofUrl': idProofUrl,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'isActive': isActive,
      'lastUpdated': lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : Timestamp.fromDate(DateTime.now()),
      'preferences': preferences,
      'metadata': metadata,
    };
  }

  /// Creates a copy of this GuestProfileModel with updated fields
  @override
  GuestProfileModel copyWith({
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
    String? pgAddress, // From UserModel
    String? address,
    String? guardianName,
    String? guardianPhone,
    String? foodPreference,
    String? maritalStatus,
    String? education,
    String? occupation,
    String? organizationName,
    String? organizationAddress,
    String? vehicleNo,
    String? vehicleName,
    DateTime? joiningDate,
    double? deposit,
    double? rent,
    String? bloodGroup,
    String? nationality,
    String? state,
    String? city,
    String? pincode,
    String? idProofType,
    String? idProofNumber,
    String? idProofUrl,
    List<String>? allergies,
    String? medicalConditions,
    DateTime? lastUpdated,
    Map<String, dynamic>? preferences,
    // Inherited from UserModel
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    return GuestProfileModel(
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
      address: address ?? this.address,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      foodPreference: foodPreference ?? this.foodPreference,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      organizationName: organizationName ?? this.organizationName,
      organizationAddress: organizationAddress ?? this.organizationAddress,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      vehicleName: vehicleName ?? this.vehicleName,
      joiningDate: joiningDate ?? this.joiningDate,
      deposit: deposit ?? this.deposit,
      rent: rent ?? this.rent,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      nationality: nationality ?? this.nationality,
      state: state ?? this.state,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      idProofType: idProofType ?? this.idProofType,
      idProofNumber: idProofNumber ?? this.idProofNumber,
      idProofUrl: idProofUrl ?? this.idProofUrl,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      lastUpdated: lastUpdated ?? DateTime.now(),
      preferences: preferences ?? this.preferences,
      // Pass inherited fields to super
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns formatted joining date
  String get formattedJoiningDate =>
      joiningDate != null ? DateFormat('MMM dd, yyyy').format(joiningDate!) : 'N/A';

  /// Returns formatted date of birth
  @override
  String get formattedDateOfBirth =>
      dateOfBirth != null ? DateFormat('MMM dd, yyyy').format(dateOfBirth!) : 'N/A';

  /// Returns formatted last updated date
  String get formattedLastUpdated =>
      lastUpdated != null ? DateFormat('MMM dd, yyyy hh:mm a').format(lastUpdated!) : 'N/A';

  /// Returns formatted deposit amount
  String get formattedDeposit =>
      deposit != null ? '₹${NumberFormat('#,##0').format(deposit)}' : 'N/A';

  /// Returns formatted rent amount
  String get formattedRent =>
      rent != null ? '₹${NumberFormat('#,##0').format(rent)}' : 'N/A';

  /// Returns formatted monthly payment (rent + deposit)
  String get formattedMonthlyPayment {
    if (rent != null) {
      return '₹${NumberFormat('#,##0').format(rent)}/month';
    }
    return 'N/A';
  }

  /// Returns display name for UI
  @override
  String get displayName => fullName ?? 'Guest User';

  /// Returns initials for avatar
  @override
  String get initials {
    if (fullName == null || fullName!.isEmpty) return 'GU';
    final names = fullName!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName!.substring(0, 2).toUpperCase();
  }

  /// Returns true if profile has basic required information
  bool get hasCompleteProfile =>
      fullName != null &&
      fullName!.isNotEmpty &&
      email != null &&
      email!.isNotEmpty &&
      phoneNumber.isNotEmpty;

  /// Returns true if profile has emergency contact
  @override
  bool get hasEmergencyContact =>
      emergencyContact != null && emergencyContact!.isNotEmpty;

  /// Returns true if profile has guardian information
  bool get hasGuardianInfo =>
      guardianName != null && guardianName!.isNotEmpty;

  /// Returns true if profile has vehicle information
  bool get hasVehicleInfo =>
      vehicleNo != null && vehicleNo!.isNotEmpty;

  /// Returns true if profile has medical information
  bool get hasMedicalInfo =>
      bloodGroup != null || medicalConditions != null || (allergies != null && allergies!.isNotEmpty);

  /// Returns true if profile has professional information
  bool get hasProfessionalInfo =>
      occupation != null && occupation!.isNotEmpty;

  /// Returns true if profile has ID proof
  bool get hasIdProof =>
      idProofType != null && idProofNumber != null;

  /// Returns profile completion percentage
  int get profileCompletionPercentage {
    int completed = 0;
    const int total = 10;

    if (fullName != null && fullName!.isNotEmpty) completed++;
    if (email != null && email!.isNotEmpty) completed++;
    if (dateOfBirth != null) completed++;
    if (gender != null) completed++;
    if (address != null && address!.isNotEmpty) completed++;
    if (hasEmergencyContact) completed++;
    if (hasGuardianInfo) completed++;
    if (hasProfessionalInfo) completed++;
    if (hasIdProof) completed++;
    if (profilePhotoUrl != null) completed++;

    return ((completed / total) * 100).round();
  }

  /// Returns status display text
  @override
  String get statusDisplay => isActive == true ? 'Active' : 'Inactive';

  /// Returns full address string
  @override
  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (pincode != null && pincode!.isNotEmpty) parts.add(pincode!);
    return parts.isEmpty ? 'N/A' : parts.join(', ');
  }

  @override
  String toString() {
    return 'GuestProfileModel(userId: $userId, fullName: $fullName, email: $email)';
  }
}
