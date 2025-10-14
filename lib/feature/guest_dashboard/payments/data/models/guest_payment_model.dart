// guest_payment_model.dart

/// Model representing a payment made by a guest.
/// Includes rent payments, security deposits, and other charges
class GuestPaymentModel {
  final String paymentId;
  final String bookingId;
  final String guestId;
  final String pgId;
  final String ownerId;
  final double amount;
  final DateTime paymentDate;
  final DateTime dueDate;
  final String status; // Pending, Paid, Failed, Refunded
  final String paymentMethod; // UPI, Card, Cash, Net Banking
  final String? transactionId;
  final String? upiReferenceId;
  final String paymentType; // Rent, Security Deposit, Maintenance, Late Fee
  final String description;
  final Map<String, dynamic>? metadata; // Additional payment details
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GuestPaymentModel({
    required this.paymentId,
    required this.bookingId,
    required this.guestId,
    required this.pgId,
    required this.ownerId,
    required this.amount,
    required this.paymentDate,
    required this.dueDate,
    required this.status,
    required this.paymentMethod,
    this.transactionId,
    this.upiReferenceId,
    required this.paymentType,
    required this.description,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates an instance from a Firestore Map.
  factory GuestPaymentModel.fromMap(Map<String, dynamic> map) {
    return GuestPaymentModel(
      paymentId: map['paymentId'] ?? '',
      bookingId: map['bookingId'] ?? '',
      guestId: map['guestId'] ?? '',
      pgId: map['pgId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentDate: map['paymentDate'] != null 
          ? DateTime.parse(map['paymentDate']) 
          : DateTime.now(),
      dueDate: map['dueDate'] != null 
          ? DateTime.parse(map['dueDate']) 
          : DateTime.now().add(const Duration(days: 30)),
      status: map['status'] ?? 'Pending',
      paymentMethod: map['paymentMethod'] ?? 'UPI',
      transactionId: map['transactionId'],
      upiReferenceId: map['upiReferenceId'],
      paymentType: map['paymentType'] ?? 'Rent',
      description: map['description'] ?? '',
      metadata: map['metadata'] != null 
          ? Map<String, dynamic>.from(map['metadata']) 
          : null,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt']) 
          : null,
    );
  }

  /// Converts model instance back to Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'bookingId': bookingId,
      'guestId': guestId,
      'pgId': pgId,
      'ownerId': ownerId,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'upiReferenceId': upiReferenceId,
      'paymentType': paymentType,
      'description': description,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a copy with updated fields
  GuestPaymentModel copyWith({
    String? paymentId,
    String? bookingId,
    String? guestId,
    String? pgId,
    String? ownerId,
    double? amount,
    DateTime? paymentDate,
    DateTime? dueDate,
    String? status,
    String? paymentMethod,
    String? transactionId,
    String? upiReferenceId,
    String? paymentType,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GuestPaymentModel(
      paymentId: paymentId ?? this.paymentId,
      bookingId: bookingId ?? this.bookingId,
      guestId: guestId ?? this.guestId,
      pgId: pgId ?? this.pgId,
      ownerId: ownerId ?? this.ownerId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      upiReferenceId: upiReferenceId ?? this.upiReferenceId,
      paymentType: paymentType ?? this.paymentType,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if payment is overdue
  bool get isOverdue {
    return status == 'Pending' && DateTime.now().isAfter(dueDate);
  }

  /// Check if payment is successful
  bool get isPaid {
    return status == 'Paid';
  }

  /// Get payment status color for UI
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'green';
      case 'pending':
        return isOverdue ? 'red' : 'orange';
      case 'failed':
        return 'red';
      case 'refunded':
        return 'blue';
      default:
        return 'grey';
    }
  }

  /// Get formatted amount string
  String get formattedAmount {
    return '₹${amount.toStringAsFixed(2)}';
  }

  /// Get payment type icon
  String get paymentTypeIcon {
    switch (paymentType.toLowerCase()) {
      case 'rent':
        return '🏠';
      case 'security deposit':
        return '🔒';
      case 'maintenance':
        return '🔧';
      case 'late fee':
        return '⏰';
      default:
        return '💳';
    }
  }
}
