// lib/core/models/booking_model.dart

/// 🏠 **BOOKING MODEL - PRODUCTION READY**
///
/// **Represents a PG bed booking by a guest**
///
/// **Fields:**
/// - Booking details (ID, dates, status)
/// - Guest and Owner info
/// - PG, Floor, Room, Bed details
/// - Financial info (rent, deposit, dues)
/// - Timestamps
class BookingModel {
  final String bookingId;
  final String guestId;
  final String ownerId;
  final String pgId;
  final String floorId;
  final String roomId;
  final String bedId;
  
  final String pgName;
  final String roomNumber;
  final String bedNumber;
  final int sharingType; // 1-5 sharing
  
  final double rentPerMonth;
  final double securityDeposit;
  final double? pendingDues;
  
  final DateTime bookingDate;
  final DateTime startDate;
  final DateTime? endDate;
  
  final String status; // pending, confirmed, active, expired, cancelled
  final String? cancellationReason;
  final DateTime? cancellationDate;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.bookingId,
    required this.guestId,
    required this.ownerId,
    required this.pgId,
    required this.floorId,
    required this.roomId,
    required this.bedId,
    required this.pgName,
    required this.roomNumber,
    required this.bedNumber,
    required this.sharingType,
    required this.rentPerMonth,
    required this.securityDeposit,
    this.pendingDues,
    required this.bookingDate,
    required this.startDate,
    this.endDate,
    this.status = 'pending',
    this.cancellationReason,
    this.cancellationDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'] ?? '',
      guestId: map['guestId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      pgId: map['pgId'] ?? '',
      floorId: map['floorId'] ?? '',
      roomId: map['roomId'] ?? '',
      bedId: map['bedId'] ?? '',
      pgName: map['pgName'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      bedNumber: map['bedNumber'] ?? '',
      sharingType: map['sharingType'] ?? 1,
      rentPerMonth: (map['rentPerMonth'] ?? 0).toDouble(),
      securityDeposit: (map['securityDeposit'] ?? 0).toDouble(),
      pendingDues: map['pendingDues']?.toDouble(),
      bookingDate: DateTime.parse(map['bookingDate']),
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      status: map['status'] ?? 'pending',
      cancellationReason: map['cancellationReason'],
      cancellationDate: map['cancellationDate'] != null
          ? DateTime.parse(map['cancellationDate'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'guestId': guestId,
      'ownerId': ownerId,
      'pgId': pgId,
      'floorId': floorId,
      'roomId': roomId,
      'bedId': bedId,
      'pgName': pgName,
      'roomNumber': roomNumber,
      'bedNumber': bedNumber,
      'sharingType': sharingType,
      'rentPerMonth': rentPerMonth,
      'securityDeposit': securityDeposit,
      'pendingDues': pendingDues,
      'bookingDate': bookingDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'cancellationReason': cancellationReason,
      'cancellationDate': cancellationDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BookingModel copyWith({
    String? bookingId,
    String? guestId,
    String? ownerId,
    String? pgId,
    String? floorId,
    String? roomId,
    String? bedId,
    String? pgName,
    String? roomNumber,
    String? bedNumber,
    int? sharingType,
    double? rentPerMonth,
    double? securityDeposit,
    double? pendingDues,
    DateTime? bookingDate,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? cancellationReason,
    DateTime? cancellationDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      guestId: guestId ?? this.guestId,
      ownerId: ownerId ?? this.ownerId,
      pgId: pgId ?? this.pgId,
      floorId: floorId ?? this.floorId,
      roomId: roomId ?? this.roomId,
      bedId: bedId ?? this.bedId,
      pgName: pgName ?? this.pgName,
      roomNumber: roomNumber ?? this.roomNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      sharingType: sharingType ?? this.sharingType,
      rentPerMonth: rentPerMonth ?? this.rentPerMonth,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      pendingDues: pendingDues ?? this.pendingDues,
      bookingDate: bookingDate ?? this.bookingDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancellationDate: cancellationDate ?? this.cancellationDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

