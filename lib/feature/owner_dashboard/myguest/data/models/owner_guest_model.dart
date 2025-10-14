// lib/features/owner_dashboard/myguest/data/models/owner_guest_model.dart

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Represents a guest user with comprehensive profile information
/// Enhanced with timestamps, status tracking, and helper methods
class OwnerGuestModel {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? profilePhotoUrl;
  final String? address;
  final String? aadhaarNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? occupation;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final DateTime? joiningDate;
  final DateTime? vacatingDate;
  final String status; // 'active', 'inactive', 'pending'
  final String? roomNumber;
  final String? bedNumber;
  final double? rent;
  final double? deposit;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  OwnerGuestModel({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.profilePhotoUrl,
    this.address,
    this.aadhaarNumber,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.joiningDate,
    this.vacatingDate,
    this.status = 'active',
    this.roomNumber,
    this.bedNumber,
    this.rent,
    this.deposit,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create OwnerGuestModel from Firestore document
  factory OwnerGuestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OwnerGuestModel(
      uid: doc.id,
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'],
      profilePhotoUrl: data['profilePhotoUrl'],
      address: data['address'],
      aadhaarNumber: data['aadhaarNumber'],
      dateOfBirth: data['dateOfBirth']?.toDate(),
      gender: data['gender'],
      occupation: data['occupation'],
      emergencyContactName: data['emergencyContactName'],
      emergencyContactPhone: data['emergencyContactPhone'],
      joiningDate: data['joiningDate']?.toDate(),
      vacatingDate: data['vacatingDate']?.toDate(),
      status: data['status'] ?? 'active',
      roomNumber: data['roomNumber'],
      bedNumber: data['bedNumber'],
      rent: data['rent']?.toDouble(),
      deposit: data['deposit']?.toDouble(),
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
    );
  }

  /// Factory constructor from Map
  factory OwnerGuestModel.fromMap(Map<String, dynamic> map) {
    return OwnerGuestModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'],
      profilePhotoUrl: map['profilePhotoUrl'],
      address: map['address'],
      aadhaarNumber: map['aadhaarNumber'],
      dateOfBirth: map['dateOfBirth']?.toDate(),
      gender: map['gender'],
      occupation: map['occupation'],
      emergencyContactName: map['emergencyContactName'],
      emergencyContactPhone: map['emergencyContactPhone'],
      joiningDate: map['joiningDate']?.toDate(),
      vacatingDate: map['vacatingDate']?.toDate(),
      status: map['status'] ?? 'active',
      roomNumber: map['roomNumber'],
      bedNumber: map['bedNumber'],
      rent: map['rent']?.toDouble(),
      deposit: map['deposit']?.toDouble(),
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Converts model to map for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'address': address,
      'aadhaarNumber': aadhaarNumber,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'occupation': occupation,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'joiningDate':
          joiningDate != null ? Timestamp.fromDate(joiningDate!) : null,
      'vacatingDate':
          vacatingDate != null ? Timestamp.fromDate(vacatingDate!) : null,
      'status': status,
      'roomNumber': roomNumber,
      'bedNumber': bedNumber,
      'rent': rent,
      'deposit': deposit,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'metadata': metadata,
    };
  }

  /// Creates a copy with updated fields
  OwnerGuestModel copyWith({
    String? uid,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? profilePhotoUrl,
    String? address,
    String? aadhaarNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? occupation,
    String? emergencyContactName,
    String? emergencyContactPhone,
    DateTime? joiningDate,
    DateTime? vacatingDate,
    String? status,
    String? roomNumber,
    String? bedNumber,
    double? rent,
    double? deposit,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerGuestModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      address: address ?? this.address,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      joiningDate: joiningDate ?? this.joiningDate,
      vacatingDate: vacatingDate ?? this.vacatingDate,
      status: status ?? this.status,
      roomNumber: roomNumber ?? this.roomNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns formatted joining date
  String get formattedJoiningDate => joiningDate != null
      ? DateFormat('MMM dd, yyyy').format(joiningDate!)
      : 'N/A';

  /// Returns formatted vacating date
  String get formattedVacatingDate => vacatingDate != null
      ? DateFormat('MMM dd, yyyy').format(vacatingDate!)
      : 'N/A';

  /// Returns formatted rent amount
  String get formattedRent =>
      rent != null ? '₹${NumberFormat('#,##0').format(rent)}' : 'N/A';

  /// Returns formatted deposit amount
  String get formattedDeposit =>
      deposit != null ? '₹${NumberFormat('#,##0').format(deposit)}' : 'N/A';

  /// Returns guest initials for avatar
  String get initials {
    if (fullName.isEmpty) return 'G';
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }

  /// Returns room and bed display
  String get roomBedDisplay {
    if (roomNumber != null && bedNumber != null) {
      return 'Room $roomNumber, Bed $bedNumber';
    } else if (roomNumber != null) {
      return 'Room $roomNumber';
    }
    return 'Not Assigned';
  }

  /// Returns true if guest is currently active
  bool get isActive => status.toLowerCase() == 'active';

  /// Returns true if guest is pending approval
  bool get isPending => status.toLowerCase() == 'pending';

  /// Returns true if guest has emergency contact
  bool get hasEmergencyContact =>
      emergencyContactName != null && emergencyContactPhone != null;

  /// Returns status color for UI
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF4CAF50); // Green
      case 'pending':
        return const Color(0xFFFFA726); // Orange
      case 'inactive':
        return const Color(0xFFEF5350); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Returns status display text
  String get statusDisplay {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  @override
  String toString() {
    return 'OwnerGuestModel(uid: $uid, fullName: $fullName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerGuestModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

/// Represents a booking made by a guest with room allocation details
/// Enhanced with comprehensive tracking and helper methods
class OwnerBookingModel {
  final String id;
  final String guestUid;
  final String pgId;
  final String roomNumber;
  final String bedNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String paymentStatus; // 'collected', 'pending', 'partial'
  final String status; // 'approved', 'pending', 'rejected', 'cancelled'
  final double? rentAmount;
  final double? depositAmount;
  final double? paidAmount;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final Map<String, dynamic>? metadata;

  OwnerBookingModel({
    required this.id,
    required this.guestUid,
    required this.pgId,
    required this.roomNumber,
    required this.bedNumber,
    required this.startDate,
    required this.endDate,
    this.paymentStatus = 'pending',
    this.status = 'pending',
    this.rentAmount,
    this.depositAmount,
    this.paidAmount,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.createdBy,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create OwnerBookingModel from Firestore document
  factory OwnerBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OwnerBookingModel(
      id: doc.id,
      guestUid: data['guestUid'] ?? '',
      pgId: data['pgId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      bedNumber: data['bedNumber'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      paymentStatus: data['paymentStatus'] ?? 'pending',
      status: data['status'] ?? 'pending',
      rentAmount: data['rentAmount']?.toDouble(),
      depositAmount: data['depositAmount']?.toDouble(),
      paidAmount: data['paidAmount']?.toDouble(),
      notes: data['notes'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      createdBy: data['createdBy'],
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
    );
  }

  /// Factory constructor from Map
  factory OwnerBookingModel.fromMap(Map<String, dynamic> map) {
    return OwnerBookingModel(
      id: map['id'] ?? '',
      guestUid: map['guestUid'] ?? '',
      pgId: map['pgId'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      bedNumber: map['bedNumber'] ?? '',
      startDate: map['startDate']?.toDate() ?? DateTime.now(),
      endDate: map['endDate']?.toDate() ?? DateTime.now(),
      paymentStatus: map['paymentStatus'] ?? 'pending',
      status: map['status'] ?? 'pending',
      rentAmount: map['rentAmount']?.toDouble(),
      depositAmount: map['depositAmount']?.toDouble(),
      paidAmount: map['paidAmount']?.toDouble(),
      notes: map['notes'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      createdBy: map['createdBy'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Converts model to map for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'guestUid': guestUid,
      'pgId': pgId,
      'roomNumber': roomNumber,
      'bedNumber': bedNumber,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'paymentStatus': paymentStatus,
      'status': status,
      'rentAmount': rentAmount,
      'depositAmount': depositAmount,
      'paidAmount': paidAmount,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'metadata': metadata,
    };
  }

  /// Creates a copy with updated fields
  OwnerBookingModel copyWith({
    String? id,
    String? guestUid,
    String? pgId,
    String? roomNumber,
    String? bedNumber,
    DateTime? startDate,
    DateTime? endDate,
    String? paymentStatus,
    String? status,
    double? rentAmount,
    double? depositAmount,
    double? paidAmount,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerBookingModel(
      id: id ?? this.id,
      guestUid: guestUid ?? this.guestUid,
      pgId: pgId ?? this.pgId,
      roomNumber: roomNumber ?? this.roomNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      rentAmount: rentAmount ?? this.rentAmount,
      depositAmount: depositAmount ?? this.depositAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      createdBy: createdBy ?? this.createdBy,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Checks if booking is currently active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) &&
        now.isBefore(endDate) &&
        status.toLowerCase() == 'approved';
  }

  /// Checks if booking is pending approval
  bool get isPending => status.toLowerCase() == 'pending';

  /// Checks if booking is approved
  bool get isApproved => status.toLowerCase() == 'approved';

  /// Checks if booking is rejected
  bool get isRejected => status.toLowerCase() == 'rejected';

  /// Checks if payment is fully collected
  bool get isPaymentCollected => paymentStatus.toLowerCase() == 'collected';

  /// Checks if payment is pending
  bool get isPaymentPending => paymentStatus.toLowerCase() == 'pending';

  /// Returns formatted start date
  String get formattedStartDate => DateFormat('MMM dd, yyyy').format(startDate);

  /// Returns formatted end date
  String get formattedEndDate => DateFormat('MMM dd, yyyy').format(endDate);

  /// Returns formatted rent amount
  String get formattedRent => rentAmount != null
      ? '₹${NumberFormat('#,##0').format(rentAmount)}'
      : 'N/A';

  /// Returns formatted deposit amount
  String get formattedDeposit => depositAmount != null
      ? '₹${NumberFormat('#,##0').format(depositAmount)}'
      : 'N/A';

  /// Returns formatted paid amount
  String get formattedPaid => paidAmount != null
      ? '₹${NumberFormat('#,##0').format(paidAmount)}'
      : '₹0';

  /// Returns remaining amount to be paid
  double get remainingAmount {
    final total = (rentAmount ?? 0) + (depositAmount ?? 0);
    final paid = paidAmount ?? 0;
    return total - paid;
  }

  /// Returns formatted remaining amount
  String get formattedRemaining =>
      '₹${NumberFormat('#,##0').format(remainingAmount)}';

  /// Returns room and bed display
  String get roomBedDisplay => 'Room $roomNumber, Bed $bedNumber';

  /// Returns booking duration in days
  int get durationInDays => endDate.difference(startDate).inDays;

  /// Returns status display text
  String get statusDisplay {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  /// Returns payment status display text
  String get paymentStatusDisplay {
    return paymentStatus[0].toUpperCase() +
        paymentStatus.substring(1).toLowerCase();
  }

  @override
  String toString() {
    return 'OwnerBookingModel(id: $id, guestUid: $guestUid, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerBookingModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents payment information for a booking
/// Enhanced with comprehensive tracking and helper methods
class OwnerPaymentModel {
  final String id;
  final String bookingId;
  final String guestUid;
  final String pgId;
  final double amountPaid;
  final String status; // 'collected', 'pending', 'failed', 'refunded'
  final String paymentMethod; // 'cash', 'upi', 'card', 'bank_transfer'
  final DateTime date;
  final String? transactionId;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? collectedBy;
  final Map<String, dynamic>? metadata;

  OwnerPaymentModel({
    required this.id,
    required this.bookingId,
    required this.guestUid,
    required this.pgId,
    required this.amountPaid,
    this.status = 'pending',
    this.paymentMethod = 'cash',
    required this.date,
    this.transactionId,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.collectedBy,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create OwnerPaymentModel from Firestore document
  factory OwnerPaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OwnerPaymentModel(
      id: doc.id,
      bookingId: data['bookingId'] ?? '',
      guestUid: data['guestUid'] ?? '',
      pgId: data['pgId'] ?? '',
      amountPaid: data['amountPaid']?.toDouble() ?? 0.0,
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? 'cash',
      date: (data['date'] as Timestamp).toDate(),
      transactionId: data['transactionId'],
      notes: data['notes'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      collectedBy: data['collectedBy'],
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
    );
  }

  /// Factory constructor from Map
  factory OwnerPaymentModel.fromMap(Map<String, dynamic> map) {
    return OwnerPaymentModel(
      id: map['id'] ?? '',
      bookingId: map['bookingId'] ?? '',
      guestUid: map['guestUid'] ?? '',
      pgId: map['pgId'] ?? '',
      amountPaid: map['amountPaid']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      paymentMethod: map['paymentMethod'] ?? 'cash',
      date: map['date']?.toDate() ?? DateTime.now(),
      transactionId: map['transactionId'],
      notes: map['notes'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      collectedBy: map['collectedBy'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Converts model to map for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'guestUid': guestUid,
      'pgId': pgId,
      'amountPaid': amountPaid,
      'status': status,
      'paymentMethod': paymentMethod,
      'date': Timestamp.fromDate(date),
      'transactionId': transactionId,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'collectedBy': collectedBy,
      'metadata': metadata,
    };
  }

  /// Creates a copy with updated fields
  OwnerPaymentModel copyWith({
    String? id,
    String? bookingId,
    String? guestUid,
    String? pgId,
    double? amountPaid,
    String? status,
    String? paymentMethod,
    DateTime? date,
    String? transactionId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? collectedBy,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerPaymentModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      guestUid: guestUid ?? this.guestUid,
      pgId: pgId ?? this.pgId,
      amountPaid: amountPaid ?? this.amountPaid,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      collectedBy: collectedBy ?? this.collectedBy,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Checks if payment has been collected
  bool get isCollected => status.toLowerCase() == 'collected';

  /// Checks if payment is pending
  bool get isPending => status.toLowerCase() == 'pending';

  /// Checks if payment failed
  bool get isFailed => status.toLowerCase() == 'failed';

  /// Returns formatted payment date
  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);

  /// Returns formatted amount
  String get formattedAmount => '₹${NumberFormat('#,##0').format(amountPaid)}';

  /// Returns payment method display
  String get paymentMethodDisplay {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'upi':
        return 'UPI';
      case 'card':
        return 'Card';
      case 'bank_transfer':
        return 'Bank Transfer';
      default:
        return paymentMethod;
    }
  }

  /// Returns status display text
  String get statusDisplay {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  /// Returns status color for UI
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'collected':
        return const Color(0xFF4CAF50); // Green
      case 'pending':
        return const Color(0xFFFFA726); // Orange
      case 'failed':
        return const Color(0xFFEF5350); // Red
      case 'refunded':
        return const Color(0xFF42A5F5); // Blue
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  @override
  String toString() {
    return 'OwnerPaymentModel(id: $id, bookingId: $bookingId, amount: $formattedAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerPaymentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
