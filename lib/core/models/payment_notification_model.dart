// lib/core/models/payment_notification_model.dart

/// Model for payment notifications sent from guest to owner
/// Supports UPI QR code payments and manual payment confirmation
library;

import '../../common/utils/date/converter/date_service_converter.dart';

class PaymentNotificationModel {
  final String notificationId;
  final String guestId;
  final String ownerId;
  final String pgId;
  final String bookingId;
  final double amount;
  final String paymentMethod; // 'upi_qr', 'bank_transfer', 'cash', 'other'
  final String? transactionId;
  final String? paymentScreenshotUrl;
  final String? paymentNote;
  final String status; // 'pending', 'confirmed', 'rejected'
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final String? rejectionReason;

  PaymentNotificationModel({
    required this.notificationId,
    required this.guestId,
    required this.ownerId,
    required this.pgId,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    this.transactionId,
    this.paymentScreenshotUrl,
    this.paymentNote,
    this.status = 'pending',
    DateTime? createdAt,
    this.confirmedAt,
    this.rejectionReason,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PaymentNotificationModel.fromMap(Map<String, dynamic> map) {
    return PaymentNotificationModel(
      notificationId: map['notificationId'] as String,
      guestId: map['guestId'] as String,
      ownerId: map['ownerId'] as String,
      pgId: map['pgId'] as String,
      bookingId: map['bookingId'] as String,
      amount: (map['amount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] as String,
      transactionId: map['transactionId'] as String?,
      paymentScreenshotUrl: map['paymentScreenshotUrl'] as String?,
      paymentNote: map['paymentNote'] as String?,
      status: map['status'] as String? ?? 'pending',
      createdAt: DateServiceConverter.fromService(map['createdAt'] as String),
      confirmedAt: map['confirmedAt'] != null
          ? DateServiceConverter.fromService(map['confirmedAt'] as String)
          : null,
      rejectionReason: map['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'guestId': guestId,
      'ownerId': ownerId,
      'pgId': pgId,
      'bookingId': bookingId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'paymentScreenshotUrl': paymentScreenshotUrl,
      'paymentNote': paymentNote,
      'status': status,
      'createdAt': DateServiceConverter.toService(createdAt),
      'confirmedAt': confirmedAt != null
          ? DateServiceConverter.toService(confirmedAt!)
          : null,
      'rejectionReason': rejectionReason,
    };
  }

  PaymentNotificationModel copyWith({
    String? notificationId,
    String? guestId,
    String? ownerId,
    String? pgId,
    String? bookingId,
    double? amount,
    String? paymentMethod,
    String? transactionId,
    String? paymentScreenshotUrl,
    String? paymentNote,
    String? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    String? rejectionReason,
  }) {
    return PaymentNotificationModel(
      notificationId: notificationId ?? this.notificationId,
      guestId: guestId ?? this.guestId,
      ownerId: ownerId ?? this.ownerId,
      pgId: pgId ?? this.pgId,
      bookingId: bookingId ?? this.bookingId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      paymentScreenshotUrl: paymentScreenshotUrl ?? this.paymentScreenshotUrl,
      paymentNote: paymentNote ?? this.paymentNote,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  // Getters
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isRejected => status == 'rejected';

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Awaiting Confirmation';
      case 'confirmed':
        return 'Confirmed';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';

  String get paymentMethodDisplay {
    switch (paymentMethod) {
      case 'upi_qr':
        return 'UPI QR Code';
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'cash':
        return 'Cash';
      case 'other':
        return 'Other';
      default:
        return paymentMethod;
    }
  }
}
