// lib/features/owner_dashboard/mypg/data/models/owner_pg_management_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Model representing a bed in the PG with enhanced tracking
class OwnerBed {
  final String id;
  final String roomId;
  final String floorId;
  final String bedNumber;
  final String status; // 'occupied', 'vacant', 'pending', 'maintenance'
  final String? guestName;
  final String? guestUid;
  final String? bookingId;
  final DateTime? occupiedSince;
  final DateTime? vacatingOn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  OwnerBed({
    required this.id,
    required this.roomId,
    required this.floorId,
    required this.bedNumber,
    this.status = 'vacant',
    this.guestName,
    this.guestUid,
    this.bookingId,
    this.occupiedSince,
    this.vacatingOn,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory OwnerBed.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OwnerBed(
      id: doc.id,
      roomId: data['roomId'] ?? '',
      floorId: data['floorId'] ?? '',
      bedNumber: data['bedNumber'] ?? '',
      status: data['status'] ?? 'vacant',
      guestName: data['guestName'],
      guestUid: data['guestUid'],
      bookingId: data['bookingId'],
      occupiedSince: data['occupiedSince']?.toDate(),
      vacatingOn: data['vacatingOn']?.toDate(),
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      metadata:
          data['metadata'] != null ? Map<String, dynamic>.from(data['metadata']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'floorId': floorId,
      'bedNumber': bedNumber,
      'status': status,
      'guestName': guestName,
      'guestUid': guestUid,
      'bookingId': bookingId,
      'occupiedSince': occupiedSince != null ? Timestamp.fromDate(occupiedSince!) : null,
      'vacatingOn': vacatingOn != null ? Timestamp.fromDate(vacatingOn!) : null,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'metadata': metadata,
    };
  }

  OwnerBed copyWith({
    String? id,
    String? roomId,
    String? floorId,
    String? bedNumber,
    String? status,
    String? guestName,
    String? guestUid,
    String? bookingId,
    DateTime? occupiedSince,
    DateTime? vacatingOn,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerBed(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      floorId: floorId ?? this.floorId,
      bedNumber: bedNumber ?? this.bedNumber,
      status: status ?? this.status,
      guestName: guestName ?? this.guestName,
      guestUid: guestUid ?? this.guestUid,
      bookingId: bookingId ?? this.bookingId,
      occupiedSince: occupiedSince ?? this.occupiedSince,
      vacatingOn: vacatingOn ?? this.vacatingOn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isOccupied => status.toLowerCase() == 'occupied';
  bool get isVacant => status.toLowerCase() == 'vacant';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isUnderMaintenance => status.toLowerCase() == 'maintenance';

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'occupied':
        return const Color(0xFF4CAF50);
      case 'vacant':
        return const Color(0xFF9E9E9E);
      case 'pending':
        return const Color(0xFFFFA726);
      case 'maintenance':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String get statusDisplay => status[0].toUpperCase() + status.substring(1).toLowerCase();
}

/// Model representing a room which contains beds
class OwnerRoom {
  final String id;
  final String floorId;
  final String roomNumber;
  final int capacity;
  final String? roomType;
  final double? rentPerBed;
  final List<String>? amenities;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  OwnerRoom({
    required this.id,
    required this.floorId,
    required this.roomNumber,
    this.capacity = 1,
    this.roomType,
    this.rentPerBed,
    this.amenities,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory OwnerRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OwnerRoom(
      id: doc.id,
      floorId: data['floorId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      capacity: data['capacity'] ?? 1,
      roomType: data['roomType'],
      rentPerBed: data['rentPerBed']?.toDouble(),
      amenities: data['amenities'] != null ? List<String>.from(data['amenities']) : null,
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      metadata:
          data['metadata'] != null ? Map<String, dynamic>.from(data['metadata']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'floorId': floorId,
      'roomNumber': roomNumber,
      'capacity': capacity,
      'roomType': roomType,
      'rentPerBed': rentPerBed,
      'amenities': amenities,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'metadata': metadata,
    };
  }

  String get formattedRent =>
      rentPerBed != null ? '₹${NumberFormat('#,##0').format(rentPerBed)}/bed' : 'N/A';
}

/// Model representing a floor that contains rooms
class OwnerFloor {
  final String id;
  final String floorName;
  final int floorNumber;
  final int totalRooms;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  OwnerFloor({
    required this.id,
    required this.floorName,
    this.floorNumber = 0,
    this.totalRooms = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory OwnerFloor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OwnerFloor(
      id: doc.id,
      floorName: data['floorName'] ?? '',
      floorNumber: data['floorNumber'] ?? 0,
      totalRooms: data['totalRooms'] ?? 0,
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      metadata:
          data['metadata'] != null ? Map<String, dynamic>.from(data['metadata']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'floorName': floorName,
      'floorNumber': floorNumber,
      'totalRooms': totalRooms,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'metadata': metadata,
    };
  }
}

/// Model representing a booking in PG with enhanced tracking
class OwnerBooking {
  final String id;
  final String guestUid;
  final String pgId;
  final String roomNumber;
  final String bedNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String paymentStatus;
  final String status;
  final double? rentAmount;
  final double? depositAmount;
  final String? guestName;
  final String? guestPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  OwnerBooking({
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
    this.guestName,
    this.guestPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory OwnerBooking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OwnerBooking(
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
      guestName: data['guestName'],
      guestPhone: data['guestPhone'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      metadata:
          data['metadata'] != null ? Map<String, dynamic>.from(data['metadata']) : null,
    );
  }

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
      'guestName': guestName,
      'guestPhone': guestPhone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'metadata': metadata,
    };
  }

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && status.toLowerCase() == 'approved';
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';

  String get formattedStartDate => DateFormat('MMM dd, yyyy').format(startDate);
  String get formattedEndDate => DateFormat('MMM dd, yyyy').format(endDate);
  int get durationInDays => endDate.difference(startDate).inDays;
  String get roomBedDisplay => 'Room $roomNumber, Bed $bedNumber';
}

/// Model representing revenue summary with enhanced analytics
class OwnerRevenueReport {
  final double collectedAmount;
  final double pendingAmount;
  final double totalAmount;
  final int totalPayments;
  final int collectedPayments;
  final int pendingPayments;
  final DateTime? generatedAt;
  final Map<String, dynamic>? breakdown;

  OwnerRevenueReport({
    this.collectedAmount = 0.0,
    this.pendingAmount = 0.0,
    double? totalAmount,
    this.totalPayments = 0,
    this.collectedPayments = 0,
    this.pendingPayments = 0,
    DateTime? generatedAt,
    this.breakdown,
  })  : totalAmount = totalAmount ?? (collectedAmount + pendingAmount),
        generatedAt = generatedAt ?? DateTime.now();

  String get formattedCollected => '₹${NumberFormat('#,##0').format(collectedAmount)}';
  String get formattedPending => '₹${NumberFormat('#,##0').format(pendingAmount)}';
  String get formattedTotal => '₹${NumberFormat('#,##0').format(totalAmount)}';

  double get collectionPercentage {
    if (totalAmount == 0) return 0;
    return (collectedAmount / totalAmount) * 100;
  }

  String get formattedCollectionPercentage => '${collectionPercentage.toStringAsFixed(1)}%';
}

/// Model representing occupancy statistics
class OwnerOccupancyReport {
  final int totalBeds;
  final int occupiedBeds;
  final int vacantBeds;
  final int pendingBeds;
  final int maintenanceBeds;
  final DateTime? generatedAt;

  OwnerOccupancyReport({
    this.totalBeds = 0,
    this.occupiedBeds = 0,
    this.vacantBeds = 0,
    this.pendingBeds = 0,
    this.maintenanceBeds = 0,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  double get occupancyPercentage {
    if (totalBeds == 0) return 0;
    return (occupiedBeds / totalBeds) * 100;
  }

  String get formattedOccupancy => '${occupancyPercentage.toStringAsFixed(1)}%';
  String get occupancyDisplay => '$occupiedBeds/$totalBeds occupied';
}

