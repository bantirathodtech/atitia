// lib/core/models/owner_payment_details_model.dart

/// Model for owner's payment details (bank account, UPI, QR code)
/// Used by guests to make payments
class OwnerPaymentDetailsModel {
  final String ownerId;
  final String? bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiId;
  final String? upiQrCodeUrl; // URL to uploaded QR code image
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
      paymentNote: map['paymentNote'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated'] as String)
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
      'paymentNote': paymentNote,
      'isActive': isActive,
      'lastUpdated': (lastUpdated ?? DateTime.now()).toIso8601String(),
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

