// lib/core/models/featured/featured_listing_model.dart

/// Model for tracking featured PG listings
/// Stores featured listing details, duration, payment information
library;

import '../../../common/utils/date/converter/date_service_converter.dart';

/// Featured listing status
enum FeaturedListingStatus {
  active,
  expired,
  cancelled,
  pending;

  String get displayName {
    switch (this) {
      case FeaturedListingStatus.active:
        return 'Active';
      case FeaturedListingStatus.expired:
        return 'Expired';
      case FeaturedListingStatus.cancelled:
        return 'Cancelled';
      case FeaturedListingStatus.pending:
        return 'Pending';
    }
  }

  String get firestoreValue => name;

  static FeaturedListingStatus? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return FeaturedListingStatus.values
          .firstWhere((status) => status.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Featured listing model
class FeaturedListingModel {
  final String featuredListingId;
  final String pgId;
  final String ownerId;
  final FeaturedListingStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int durationMonths; // 1, 3, or 6 months
  final double amountPaid; // Amount paid for featured listing
  final String? paymentId; // Razorpay payment ID
  final String? orderId; // Razorpay order ID
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  FeaturedListingModel({
    required this.featuredListingId,
    required this.pgId,
    required this.ownerId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.durationMonths,
    this.amountPaid = 0.0,
    this.paymentId,
    this.orderId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create featured listing from Firestore document
  factory FeaturedListingModel.fromMap(Map<String, dynamic> map) {
    return FeaturedListingModel(
      featuredListingId: map['featuredListingId'] as String? ?? '',
      pgId: map['pgId'] as String? ?? '',
      ownerId: map['ownerId'] as String? ?? '',
      status: FeaturedListingStatus.fromFirestoreValue(map['status']) ??
          FeaturedListingStatus.pending,
      startDate: map['startDate'] != null
          ? DateServiceConverter.fromService(map['startDate'] as String)
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateServiceConverter.fromService(map['endDate'] as String)
          : DateTime.now(),
      durationMonths: (map['durationMonths'] as num?)?.toInt() ?? 1,
      amountPaid: (map['amountPaid'] as num?)?.toDouble() ?? 0.0,
      paymentId: map['paymentId'] as String?,
      orderId: map['orderId'] as String?,
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
      'featuredListingId': featuredListingId,
      'pgId': pgId,
      'ownerId': ownerId,
      'status': status.firestoreValue,
      'startDate': DateServiceConverter.toService(startDate),
      'endDate': DateServiceConverter.toService(endDate),
      'durationMonths': durationMonths,
      'amountPaid': amountPaid,
      'paymentId': paymentId,
      'orderId': orderId,
      'createdAt': DateServiceConverter.toService(createdAt!),
      'updatedAt': DateServiceConverter.toService(updatedAt!),
      'metadata': metadata,
    };
  }

  /// Create a copy with updated fields
  FeaturedListingModel copyWith({
    String? featuredListingId,
    String? pgId,
    String? ownerId,
    FeaturedListingStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? durationMonths,
    double? amountPaid,
    String? paymentId,
    String? orderId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return FeaturedListingModel(
      featuredListingId: featuredListingId ?? this.featuredListingId,
      pgId: pgId ?? this.pgId,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      durationMonths: durationMonths ?? this.durationMonths,
      amountPaid: amountPaid ?? this.amountPaid,
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if featured listing is currently active
  bool get isActive =>
      status == FeaturedListingStatus.active && endDate.isAfter(DateTime.now());

  /// Check if featured listing has expired
  bool get isExpired =>
      status == FeaturedListingStatus.expired ||
      (status == FeaturedListingStatus.active &&
          endDate.isBefore(DateTime.now()));

  /// Get days remaining until expiration
  int get daysUntilExpiry {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  /// Get formatted duration
  String get formattedDuration {
    if (durationMonths == 1) return '1 Month';
    if (durationMonths == 3) return '3 Months';
    if (durationMonths == 6) return '6 Months';
    return '$durationMonths Months';
  }

  /// Get pricing for featured listing duration
  static double getPriceForDuration(int months) {
    switch (months) {
      case 1:
        return 299.0; // ₹299/month
      case 3:
        return 799.0; // ~₹266/month (save ₹98)
      case 6:
        return 1499.0; // ~₹250/month (save ₹294)
      default:
        return 299.0 * months; // Default pricing
    }
  }

  /// Get formatted price for duration
  static String getFormattedPriceForDuration(int months) {
    final price = getPriceForDuration(months);
    return '₹${price.toStringAsFixed(0)}';
  }

  @override
  String toString() {
    return 'FeaturedListingModel(pgId: $pgId, ownerId: $ownerId, status: $status, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeaturedListingModel &&
        other.featuredListingId == featuredListingId;
  }

  @override
  int get hashCode => featuredListingId.hashCode;
}
