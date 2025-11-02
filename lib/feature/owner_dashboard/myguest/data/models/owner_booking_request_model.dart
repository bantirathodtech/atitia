// lib/features/owner_dashboard/myguest/data/models/owner_booking_request_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a booking request from a guest to join a PG
/// This is the initial request before it becomes an actual booking
class OwnerBookingRequestModel {
  final String requestId;
  final String guestId;
  final String guestName;
  final String guestPhone;
  final String guestEmail;
  final String pgId;
  final String pgName;
  final String ownerId;
  final String ownerUid;
  final String status; // pending, approved, rejected
  final String? message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? respondedAt;
  final String? responseMessage;
  final Map<String, dynamic> metadata;

  const OwnerBookingRequestModel({
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
    required this.metadata,
  });

  /// Creates model from Firestore document
  factory OwnerBookingRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OwnerBookingRequestModel(
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
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  /// Converts model to Firestore document map
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

  /// Creates a copy with updated fields
  OwnerBookingRequestModel copyWith({
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
    return OwnerBookingRequestModel(
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

  /// Formatted creation date
  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Formatted creation time
  String get formattedCreatedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  /// Status display text
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  /// Whether the request is pending
  bool get isPending => status.toLowerCase() == 'pending';

  /// Whether the request is approved
  bool get isApproved => status.toLowerCase() == 'approved';

  /// Whether the request is rejected
  bool get isRejected => status.toLowerCase() == 'rejected';

  /// Whether the request has been responded to
  bool get isResponded => respondedAt != null;

  /// Full display name for the guest
  String get guestDisplayName => guestName;

  /// Contact information display
  String get contactInfo => '$guestPhone • $guestEmail';

  /// Request summary for display
  String get requestSummary {
    if (message != null && message!.isNotEmpty) {
      return message!.length > 50
          ? '${message!.substring(0, 50)}...'
          : message!;
    }
    return 'No additional message';
  }

  @override
  String toString() {
    return 'OwnerBookingRequestModel(requestId: $requestId, guestName: $guestName, pgName: $pgName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerBookingRequestModel &&
        other.requestId == requestId &&
        other.guestId == guestId &&
        other.pgId == pgId &&
        other.status == status;
  }

  @override
  int get hashCode {
    return requestId.hashCode ^
        guestId.hashCode ^
        pgId.hashCode ^
        status.hashCode;
  }
}
