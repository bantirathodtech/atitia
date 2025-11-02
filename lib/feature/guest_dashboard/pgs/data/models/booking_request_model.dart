// ============================================================================
// Booking Request Model - Data Model for Guest Booking Requests
// ============================================================================
// Represents a booking request sent by a guest to join a PG
// Used for creating and managing booking requests in Firestore
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Data model representing a booking request from a guest to join a PG
class BookingRequestModel extends Equatable {
  final String requestId;
  final String guestId;
  final String guestName;
  final String guestPhone;
  final String guestEmail;
  final String pgId;
  final String pgName;
  final String ownerId;
  final String ownerUid;
  final String status; // 'pending', 'approved', 'rejected', 'cancelled'
  final String? message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? respondedAt;
  final String? responseMessage;
  final Map<String, dynamic>? metadata;

  const BookingRequestModel({
    required this.requestId,
    required this.guestId,
    required this.guestName,
    required this.guestPhone,
    required this.guestEmail,
    required this.pgId,
    required this.pgName,
    required this.ownerId,
    required this.ownerUid,
    required this.status,
    this.message,
    required this.createdAt,
    required this.updatedAt,
    this.respondedAt,
    this.responseMessage,
    this.metadata,
  });

  /// Creates a BookingRequestModel from Firestore document data
  factory BookingRequestModel.fromMap(Map<String, dynamic> data) {
    return BookingRequestModel(
      requestId: data['requestId'] ?? '',
      guestId: data['guestId'] ?? '',
      guestName: data['guestName'] ?? '',
      guestPhone: data['guestPhone'] ?? '',
      guestEmail: data['guestEmail'] ?? '',
      pgId: data['pgId'] ?? '',
      pgName: data['pgName'] ?? '',
      ownerId: data['ownerId'] ?? '',
      ownerUid: data['ownerUid'] ?? '',
      status: data['status'] ?? 'pending',
      message: data['message'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      respondedAt: (data['respondedAt'] as Timestamp?)?.toDate(),
      responseMessage: data['responseMessage'],
      metadata: data['metadata'],
    );
  }

  /// Converts BookingRequestModel to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'guestId': guestId,
      'guestName': guestName,
      'guestPhone': guestPhone,
      'guestEmail': guestEmail,
      'pgId': pgId,
      'pgName': pgName,
      'ownerId': ownerId,
      'ownerUid': ownerUid,
      'status': status,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'respondedAt':
          respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'responseMessage': responseMessage,
      'metadata': metadata,
    };
  }

  /// Creates a copy of the model with updated fields
  BookingRequestModel copyWith({
    String? requestId,
    String? guestId,
    String? guestName,
    String? guestPhone,
    String? guestEmail,
    String? pgId,
    String? pgName,
    String? ownerId,
    String? ownerUid,
    String? status,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? respondedAt,
    String? responseMessage,
    Map<String, dynamic>? metadata,
  }) {
    return BookingRequestModel(
      requestId: requestId ?? this.requestId,
      guestId: guestId ?? this.guestId,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestEmail: guestEmail ?? this.guestEmail,
      pgId: pgId ?? this.pgId,
      pgName: pgName ?? this.pgName,
      ownerId: ownerId ?? this.ownerId,
      ownerUid: ownerUid ?? this.ownerUid,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      respondedAt: respondedAt ?? this.respondedAt,
      responseMessage: responseMessage ?? this.responseMessage,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Gets the status display text
  String get statusDisplayText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  /// Gets the status color
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'orange';
      case 'approved':
        return 'green';
      case 'rejected':
        return 'red';
      case 'cancelled':
        return 'grey';
      default:
        return 'grey';
    }
  }

  /// Checks if the request is pending
  bool get isPending => status.toLowerCase() == 'pending';

  /// Checks if the request is approved
  bool get isApproved => status.toLowerCase() == 'approved';

  /// Checks if the request is rejected
  bool get isRejected => status.toLowerCase() == 'rejected';

  /// Checks if the request is cancelled
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  @override
  List<Object?> get props => [
        requestId,
        guestId,
        guestName,
        guestPhone,
        guestEmail,
        pgId,
        pgName,
        ownerId,
        ownerUid,
        status,
        message,
        createdAt,
        updatedAt,
        respondedAt,
        responseMessage,
        metadata,
      ];
}
