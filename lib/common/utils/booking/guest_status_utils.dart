// lib/common/utils/booking/guest_status_utils.dart

/// 🔄 **GUEST STATUS UTILITIES - REUSABLE COMMON UTILITIES**
///
/// Provides helper functions for managing guest status transitions
/// in the booking lifecycle: Pending → Payment Pending → Active
///
/// Status Flow:
/// - 'pending': Booking request sent, awaiting owner approval
/// - 'payment_pending': Approved by owner, awaiting payment
/// - 'active': Payment received, guest is active
/// - 'inactive': Guest checked out or booking cancelled
library;

class GuestStatusUtils {
  /// Guest status constants
  static const String statusPending = 'pending';
  static const String statusPaymentPending = 'payment_pending';
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';

  /// Booking status constants
  static const String bookingStatusPending = 'pending';
  static const String bookingStatusApproved = 'approved';
  static const String bookingStatusActive = 'active';
  static const String bookingStatusCancelled = 'cancelled';

  /// Payment status constants
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusPartial = 'partial';
  static const String paymentStatusCollected = 'collected';

  /// Determines guest status based on booking and payment status
  static String getGuestStatus({
    required String bookingStatus,
    required String paymentStatus,
  }) {
    // If booking is cancelled or rejected, guest is inactive
    if (bookingStatus == bookingStatusCancelled) {
      return statusInactive;
    }

    // If booking is approved but no payment yet
    if (bookingStatus == bookingStatusApproved &&
        paymentStatus == paymentStatusPending) {
      return statusPaymentPending;
    }

    // If payment is collected and booking is active
    if (paymentStatus == paymentStatusCollected &&
        bookingStatus == bookingStatusActive) {
      return statusActive;
    }

    // If booking is pending approval
    if (bookingStatus == bookingStatusPending) {
      return statusPending;
    }

    // Default to payment pending for approved bookings
    return statusPaymentPending;
  }

  /// Checks if guest should appear in active guest list
  static bool shouldShowInGuestList({
    required String guestStatus,
    required String bookingStatus,
    required String paymentStatus,
  }) {
    // Show if active or payment pending (approved but not paid yet)
    return guestStatus == statusActive ||
        guestStatus == statusPaymentPending ||
        (bookingStatus == bookingStatusApproved &&
            paymentStatus == paymentStatusPending);
  }

  /// Gets display text for guest status
  static String getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case statusActive:
        return 'Active';
      case statusPaymentPending:
        return 'Payment Pending';
      case statusPending:
        return 'Pending Approval';
      case statusInactive:
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }

  /// Gets color for status badge
  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case statusActive:
        return 'success'; // Green
      case statusPaymentPending:
        return 'warning'; // Orange
      case statusPending:
        return 'info'; // Blue
      case statusInactive:
        return 'error'; // Red
      default:
        return 'secondary'; // Grey
    }
  }

  /// Checks if payment is required before guest becomes active
  static bool requiresPayment(String status) {
    return status == statusPaymentPending || status == statusPending;
  }

  /// Checks if guest is fully active (paid and assigned)
  static bool isFullyActive({
    required String guestStatus,
    required String? roomNumber,
    required String? bedNumber,
  }) {
    return guestStatus == statusActive &&
        roomNumber != null &&
        roomNumber.isNotEmpty &&
        bedNumber != null &&
        bedNumber.isNotEmpty;
  }
}
