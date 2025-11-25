// lib/core/models/subscription/owner_subscription_model.dart

/// Model for tracking owner subscription details
/// Stores subscription tier, status, payment history, and expiration dates
library;

import '../../../common/utils/date/converter/date_service_converter.dart';
import 'subscription_plan_model.dart';

/// Subscription status enumeration
enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  pendingPayment,
  gracePeriod;

  String get displayName {
    switch (this) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.pendingPayment:
        return 'Pending Payment';
      case SubscriptionStatus.gracePeriod:
        return 'Grace Period';
    }
  }

  String get firestoreValue => name;
  
  static SubscriptionStatus? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return SubscriptionStatus.values.firstWhere((status) => status.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Subscription billing period
enum BillingPeriod {
  monthly,
  yearly;

  String get displayName {
    switch (this) {
      case BillingPeriod.monthly:
        return 'Monthly';
      case BillingPeriod.yearly:
        return 'Yearly';
    }
  }

  String get firestoreValue => name;
  
  static BillingPeriod? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return BillingPeriod.values.firstWhere((period) => period.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Owner subscription model
class OwnerSubscriptionModel {
  final String subscriptionId;
  final String ownerId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final BillingPeriod billingPeriod;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? nextBillingDate; // Next payment due date
  final double amountPaid; // Total amount paid for this subscription
  final String? paymentId; // Razorpay payment ID
  final String? orderId; // Razorpay order ID
  final bool autoRenew; // Whether subscription auto-renews
  final DateTime? cancelledAt; // When subscription was cancelled
  final String? cancellationReason; // Reason for cancellation
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  OwnerSubscriptionModel({
    required this.subscriptionId,
    required this.ownerId,
    required this.tier,
    required this.status,
    required this.billingPeriod,
    required this.startDate,
    required this.endDate,
    this.nextBillingDate,
    this.amountPaid = 0.0,
    this.paymentId,
    this.orderId,
    this.autoRenew = true,
    this.cancelledAt,
    this.cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create subscription from Firestore document
  factory OwnerSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return OwnerSubscriptionModel(
      subscriptionId: map['subscriptionId'] as String? ?? '',
      ownerId: map['ownerId'] as String? ?? '',
      tier: SubscriptionTier.fromFirestoreValue(map['tier']) ?? SubscriptionTier.free,
      status: SubscriptionStatus.fromFirestoreValue(map['status']) ?? SubscriptionStatus.active,
      billingPeriod: BillingPeriod.fromFirestoreValue(map['billingPeriod']) ?? BillingPeriod.monthly,
      startDate: map['startDate'] != null
          ? DateServiceConverter.fromService(map['startDate'] as String)
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateServiceConverter.fromService(map['endDate'] as String)
          : DateTime.now(),
      nextBillingDate: map['nextBillingDate'] != null
          ? DateServiceConverter.fromService(map['nextBillingDate'] as String)
          : null,
      amountPaid: (map['amountPaid'] as num?)?.toDouble() ?? 0.0,
      paymentId: map['paymentId'] as String?,
      orderId: map['orderId'] as String?,
      autoRenew: map['autoRenew'] as bool? ?? true,
      cancelledAt: map['cancelledAt'] != null
          ? DateServiceConverter.fromService(map['cancelledAt'] as String)
          : null,
      cancellationReason: map['cancellationReason'] as String?,
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
      'subscriptionId': subscriptionId,
      'ownerId': ownerId,
      'tier': tier.firestoreValue,
      'status': status.firestoreValue,
      'billingPeriod': billingPeriod.firestoreValue,
      'startDate': DateServiceConverter.toService(startDate),
      'endDate': DateServiceConverter.toService(endDate),
      'nextBillingDate': nextBillingDate != null
          ? DateServiceConverter.toService(nextBillingDate!)
          : null,
      'amountPaid': amountPaid,
      'paymentId': paymentId,
      'orderId': orderId,
      'autoRenew': autoRenew,
      'cancelledAt': cancelledAt != null
          ? DateServiceConverter.toService(cancelledAt!)
          : null,
      'cancellationReason': cancellationReason,
      'createdAt': DateServiceConverter.toService(createdAt!),
      'updatedAt': DateServiceConverter.toService(updatedAt!),
      'metadata': metadata,
    };
  }

  /// Create a copy with updated fields
  OwnerSubscriptionModel copyWith({
    String? subscriptionId,
    String? ownerId,
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    BillingPeriod? billingPeriod,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextBillingDate,
    double? amountPaid,
    String? paymentId,
    String? orderId,
    bool? autoRenew,
    DateTime? cancelledAt,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return OwnerSubscriptionModel(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      ownerId: ownerId ?? this.ownerId,
      tier: tier ?? this.tier,
      status: status ?? this.status,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      amountPaid: amountPaid ?? this.amountPaid,
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      autoRenew: autoRenew ?? this.autoRenew,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if subscription is currently active
  bool get isActive => status == SubscriptionStatus.active && endDate.isAfter(DateTime.now());

  /// Check if subscription has expired
  bool get isExpired => status == SubscriptionStatus.expired || 
                       (status == SubscriptionStatus.active && endDate.isBefore(DateTime.now()));

  /// Check if subscription is in grace period (expired but within 7 days)
  bool get isInGracePeriod {
    if (status != SubscriptionStatus.gracePeriod && !isExpired) return false;
    final daysSinceExpiry = DateTime.now().difference(endDate).inDays;
    return daysSinceExpiry >= 0 && daysSinceExpiry <= 7;
  }

  /// Get days remaining until expiration
  int get daysUntilExpiry {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  /// Get days until next billing
  int? get daysUntilNextBilling {
    if (nextBillingDate == null) return null;
    if (nextBillingDate!.isBefore(DateTime.now())) return 0;
    return nextBillingDate!.difference(DateTime.now()).inDays;
  }

  /// Check if subscription can be renewed
  bool get canRenew => status == SubscriptionStatus.active || 
                       status == SubscriptionStatus.expired || 
                       status == SubscriptionStatus.gracePeriod;

  /// Check if subscription can be cancelled
  bool get canCancel => status == SubscriptionStatus.active || 
                        status == SubscriptionStatus.pendingPayment;

  @override
  String toString() {
    return 'OwnerSubscriptionModel(ownerId: $ownerId, tier: $tier, status: $status, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerSubscriptionModel && other.subscriptionId == subscriptionId;
  }

  @override
  int get hashCode => subscriptionId.hashCode;
}

