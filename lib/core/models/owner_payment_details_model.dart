// lib/core/models/owner_payment_details_model.dart

/// Model for owner's payment details (bank account, UPI, QR code)
/// Used by guests to make payments
library;

import '../../common/utils/date/converter/date_service_converter.dart';

class OwnerPaymentDetailsModel {
  final String ownerId;
  final String? bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiId;
  final String? upiQrCodeUrl; // URL to uploaded QR code image
  final String? razorpayKey; // Razorpay API key for payment processing
  final bool razorpayEnabled; // Whether Razorpay is enabled for this owner
  final String? paymentNote; // Additional instructions for guests
  final bool isActive;
  final DateTime? lastUpdated;

  OwnerPaymentDetailsModel({
    required this.ownerId,
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.upiId,
    this.upiQrCodeUrl,
    this.razorpayKey,
    this.razorpayEnabled = false,
    this.paymentNote,
    this.isActive = true,
    this.lastUpdated,
  });

  factory OwnerPaymentDetailsModel.fromMap(Map<String, dynamic> map) {
    return OwnerPaymentDetailsModel(
      ownerId: map['ownerId'] as String,
      bankName: map['bankName'] as String?,
      accountHolderName: map['accountHolderName'] as String?,
      accountNumber: map['accountNumber'] as String?,
      ifscCode: map['ifscCode'] as String?,
      upiId: map['upiId'] as String?,
      upiQrCodeUrl: map['upiQrCodeUrl'] as String?,
      razorpayKey: map['razorpayKey'] as String?,
      razorpayEnabled: map['razorpayEnabled'] as bool? ?? false,
      paymentNote: map['paymentNote'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      lastUpdated: map['lastUpdated'] != null
          ? DateServiceConverter.fromService(map['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'upiId': upiId,
      'upiQrCodeUrl': upiQrCodeUrl,
      'razorpayKey': razorpayKey,
      'razorpayEnabled': razorpayEnabled,
      'paymentNote': paymentNote,
      'isActive': isActive,
      'lastUpdated':
          DateServiceConverter.toService(lastUpdated ?? DateTime.now()),
    };
  }

  OwnerPaymentDetailsModel copyWith({
    String? ownerId,
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? upiId,
    String? upiQrCodeUrl,
    String? razorpayKey,
    bool? razorpayEnabled,
    String? paymentNote,
    bool? isActive,
    DateTime? lastUpdated,
  }) {
    return OwnerPaymentDetailsModel(
      ownerId: ownerId ?? this.ownerId,
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      upiId: upiId ?? this.upiId,
      upiQrCodeUrl: upiQrCodeUrl ?? this.upiQrCodeUrl,
      razorpayKey: razorpayKey ?? this.razorpayKey,
      razorpayEnabled: razorpayEnabled ?? this.razorpayEnabled,
      paymentNote: paymentNote ?? this.paymentNote,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Getters
  bool get hasBankDetails =>
      bankName != null &&
      accountHolderName != null &&
      accountNumber != null &&
      ifscCode != null;

  bool get hasUpiDetails => upiId != null || upiQrCodeUrl != null;

  bool get hasAnyPaymentMethod => hasBankDetails || hasUpiDetails;

  String get maskedAccountNumber {
    if (accountNumber == null || accountNumber!.length < 4) return '****';
    return '****${accountNumber!.substring(accountNumber!.length - 4)}';
  }
}
