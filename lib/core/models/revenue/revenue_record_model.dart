// lib/core/models/revenue/revenue_record_model.dart

/// Model for tracking all app revenue (subscriptions, featured listings, etc.)
/// Used for revenue analytics and reporting
library;

import '../../../common/utils/date/converter/date_service_converter.dart';

/// Revenue type enumeration
enum RevenueType {
  subscription,
  featuredListing,
  successFee; // Future: commission on bookings

  String get displayName {
    switch (this) {
      case RevenueType.subscription:
        return 'Subscription';
      case RevenueType.featuredListing:
        return 'Featured Listing';
      case RevenueType.successFee:
        return 'Success Fee';
    }
  }

  String get firestoreValue => name;

  static RevenueType? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return RevenueType.values.firstWhere((type) => type.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Payment status for revenue record
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  String get firestoreValue => name;

  static PaymentStatus? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return PaymentStatus.values.firstWhere((status) => status.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Revenue record model
class RevenueRecordModel {
  final String revenueId;
  final RevenueType type;
  final String ownerId;
  final double amount; // Amount in INR
  final PaymentStatus status;
  final String? paymentId; // Razorpay payment ID
  final String? orderId; // Razorpay order ID
  final String? subscriptionId; // If type is subscription
  final String? featuredListingId; // If type is featured listing
  final DateTime paymentDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>?
      metadata; // Additional metadata (tier, duration, etc.)

  RevenueRecordModel({
    required this.revenueId,
    required this.type,
    required this.ownerId,
    required this.amount,
    required this.status,
    required this.paymentDate,
    this.paymentId,
    this.orderId,
    this.subscriptionId,
    this.featuredListingId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create revenue record from Firestore document
  factory RevenueRecordModel.fromMap(Map<String, dynamic> map) {
    return RevenueRecordModel(
      revenueId: map['revenueId'] as String? ?? '',
      type: RevenueType.fromFirestoreValue(map['type']) ??
          RevenueType.subscription,
      ownerId: map['ownerId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      status: PaymentStatus.fromFirestoreValue(map['status']) ??
          PaymentStatus.pending,
      paymentDate: map['paymentDate'] != null
          ? DateServiceConverter.fromService(map['paymentDate'] as String)
          : DateTime.now(),
      paymentId: map['paymentId'] as String?,
      orderId: map['orderId'] as String?,
      subscriptionId: map['subscriptionId'] as String?,
      featuredListingId: map['featuredListingId'] as String?,
      createdAt: map['createdAt'] != null
          ? DateServiceConverter.fromService(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateServiceConverter.fromService(map['updatedAt'] as String)
          : DateTime.now(),
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Convert to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'revenueId': revenueId,
      'type': type.firestoreValue,
      'ownerId': ownerId,
      'amount': amount,
      'status': status.firestoreValue,
      'paymentDate': DateServiceConverter.toService(paymentDate),
      'paymentId': paymentId,
      'orderId': orderId,
      'subscriptionId': subscriptionId,
      'featuredListingId': featuredListingId,
      'createdAt': DateServiceConverter.toService(createdAt!),
      'updatedAt': DateServiceConverter.toService(updatedAt!),
      'metadata': metadata,
    };
  }

  /// Create a copy with updated fields
  RevenueRecordModel copyWith({
    String? revenueId,
    RevenueType? type,
    String? ownerId,
    double? amount,
    PaymentStatus? status,
    DateTime? paymentDate,
    String? paymentId,
    String? orderId,
    String? subscriptionId,
    String? featuredListingId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return RevenueRecordModel(
      revenueId: revenueId ?? this.revenueId,
      type: type ?? this.type,
      ownerId: ownerId ?? this.ownerId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      featuredListingId: featuredListingId ?? this.featuredListingId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if payment is completed
  bool get isCompleted => status == PaymentStatus.completed;

  /// Check if payment is pending
  bool get isPending => status == PaymentStatus.pending;

  /// Check if payment failed
  bool get isFailed => status == PaymentStatus.failed;

  /// Get formatted amount
  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';

  /// Get month-year string for grouping (e.g., "2025-01")
  String get monthYear {
    final year = paymentDate.year;
    final month = paymentDate.month.toString().padLeft(2, '0');
    return '$year-$month';
  }

  /// Get year string for grouping
  String get year => paymentDate.year.toString();

  @override
  String toString() {
    return 'RevenueRecordModel(type: $type, ownerId: $ownerId, amount: $amount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RevenueRecordModel && other.revenueId == revenueId;
  }

  @override
  int get hashCode => revenueId.hashCode;
}
