// lib/core/models/refund/refund_request_model.dart

/// Model for refund requests
/// Used for tracking refund requests for subscriptions and featured listings
library;

import '../../../common/utils/date/converter/date_service_converter.dart';

/// Refund request status
enum RefundStatus {
  pending,
  approved,
  rejected,
  processing,
  completed,
  failed;

  String get displayName {
    switch (this) {
      case RefundStatus.pending:
        return 'Pending';
      case RefundStatus.approved:
        return 'Approved';
      case RefundStatus.rejected:
        return 'Rejected';
      case RefundStatus.processing:
        return 'Processing';
      case RefundStatus.completed:
        return 'Completed';
      case RefundStatus.failed:
        return 'Failed';
    }
  }

  String get firestoreValue => name;

  static RefundStatus? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return RefundStatus.values.firstWhere((status) => status.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Refund request type
enum RefundType {
  subscription,
  featuredListing;

  String get displayName {
    switch (this) {
      case RefundType.subscription:
        return 'Subscription';
      case RefundType.featuredListing:
        return 'Featured Listing';
    }
  }

  String get firestoreValue => name;

  static RefundType? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return RefundType.values.firstWhere((type) => type.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Refund request model
class RefundRequestModel {
  final String refundRequestId;
  final RefundType type;
  final String ownerId;
  final String? subscriptionId; // If type is subscription
  final String? featuredListingId; // If type is featured listing
  final String revenueRecordId; // Reference to original revenue record
  final double amount; // Refund amount in INR
  final RefundStatus status;
  final String reason; // Owner's reason for refund request
  final String? adminNotes; // Admin notes for approval/rejection
  final String? razorpayRefundId; // Razorpay refund ID after processing
  final String? rejectionReason; // If rejected, reason for rejection
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? processedBy; // Admin user ID who processed the refund
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RefundRequestModel({
    required this.refundRequestId,
    required this.type,
    required this.ownerId,
    required this.revenueRecordId,
    required this.amount,
    required this.status,
    required this.reason,
    required this.requestedAt,
    this.subscriptionId,
    this.featuredListingId,
    this.adminNotes,
    this.razorpayRefundId,
    this.rejectionReason,
    this.processedAt,
    this.processedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create refund request from Firestore document
  factory RefundRequestModel.fromMap(Map<String, dynamic> map) {
    return RefundRequestModel(
      refundRequestId: map['refundRequestId'] as String? ?? '',
      type: RefundType.fromFirestoreValue(map['type']) ?? RefundType.subscription,
      ownerId: map['ownerId'] as String? ?? '',
      subscriptionId: map['subscriptionId'] as String?,
      featuredListingId: map['featuredListingId'] as String?,
      revenueRecordId: map['revenueRecordId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      status: RefundStatus.fromFirestoreValue(map['status']) ?? RefundStatus.pending,
      reason: map['reason'] as String? ?? '',
      adminNotes: map['adminNotes'] as String?,
      razorpayRefundId: map['razorpayRefundId'] as String?,
      rejectionReason: map['rejectionReason'] as String?,
      requestedAt: map['requestedAt'] != null
          ? DateServiceConverter.fromService(map['requestedAt'] as String)
          : DateTime.now(),
      processedAt: map['processedAt'] != null
          ? DateServiceConverter.fromService(map['processedAt'] as String)
          : null,
      processedBy: map['processedBy'] as String?,
      createdAt: map['createdAt'] != null
          ? DateServiceConverter.fromService(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateServiceConverter.fromService(map['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'refundRequestId': refundRequestId,
      'type': type.firestoreValue,
      'ownerId': ownerId,
      'subscriptionId': subscriptionId,
      'featuredListingId': featuredListingId,
      'revenueRecordId': revenueRecordId,
      'amount': amount,
      'status': status.firestoreValue,
      'reason': reason,
      'adminNotes': adminNotes,
      'razorpayRefundId': razorpayRefundId,
      'rejectionReason': rejectionReason,
      'requestedAt': DateServiceConverter.toService(requestedAt),
      'processedAt': processedAt != null
          ? DateServiceConverter.toService(processedAt!)
          : null,
      'processedBy': processedBy,
      'createdAt': DateServiceConverter.toService(createdAt!),
      'updatedAt': DateServiceConverter.toService(updatedAt!),
    };
  }

  /// Create a copy with updated fields
  RefundRequestModel copyWith({
    String? refundRequestId,
    RefundType? type,
    String? ownerId,
    String? subscriptionId,
    String? featuredListingId,
    String? revenueRecordId,
    double? amount,
    RefundStatus? status,
    String? reason,
    String? adminNotes,
    String? razorpayRefundId,
    String? rejectionReason,
    DateTime? requestedAt,
    DateTime? processedAt,
    String? processedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RefundRequestModel(
      refundRequestId: refundRequestId ?? this.refundRequestId,
      type: type ?? this.type,
      ownerId: ownerId ?? this.ownerId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      featuredListingId: featuredListingId ?? this.featuredListingId,
      revenueRecordId: revenueRecordId ?? this.revenueRecordId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      adminNotes: adminNotes ?? this.adminNotes,
      razorpayRefundId: razorpayRefundId ?? this.razorpayRefundId,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requestedAt: requestedAt ?? this.requestedAt,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Check if refund is pending approval
  bool get isPending => status == RefundStatus.pending;

  /// Check if refund is approved
  bool get isApproved => status == RefundStatus.approved;

  /// Check if refund is rejected
  bool get isRejected => status == RefundStatus.rejected;

  /// Check if refund is completed
  bool get isCompleted => status == RefundStatus.completed;

  /// Get formatted amount
  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';

  @override
  String toString() {
    return 'RefundRequestModel(type: $type, ownerId: $ownerId, amount: $amount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RefundRequestModel && other.refundRequestId == refundRequestId;
  }

  @override
  int get hashCode => refundRequestId.hashCode;
}

