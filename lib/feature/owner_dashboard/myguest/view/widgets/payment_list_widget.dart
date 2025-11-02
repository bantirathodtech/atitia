// lib/features/owner_dashboard/myguest/view/widgets/payment_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/owner_guest_model.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';

/// Widget displaying payment list with status and collection information
/// Shows comprehensive payment details with action buttons for owners
class PaymentListWidget extends StatelessWidget {
  final List<OwnerPaymentModel> payments;
  final OwnerGuestViewModel viewModel;
  final List<OwnerGuestModel> guests;
  final List<OwnerBookingModel> bookings;

  const PaymentListWidget({
    required this.payments,
    required this.viewModel,
    required this.guests,
    required this.bookings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const EmptyState(
        title: 'No Payments',
        message: 'Payment records will appear here once payments are collected',
        icon: Icons.payment_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
          child: _buildPaymentCard(context, payment),
        );
      },
    );
  }

  /// Builds individual payment card
  Widget _buildPaymentCard(BuildContext context, OwnerPaymentModel payment) {
    final guest = guests.firstWhere(
      (g) => g.uid == payment.guestUid,
      orElse: () => OwnerGuestModel(
        uid: payment.guestUid,
        fullName: 'Unknown Guest',
        phoneNumber: '',
      ),
    );

    final booking = bookings.firstWhere(
      (b) => b.id == payment.bookingId,
      orElse: () => OwnerBookingModel(
        id: payment.bookingId,
        guestUid: payment.guestUid,
        pgId: payment.pgId,
        roomNumber: 'N/A',
        bedNumber: 'N/A',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ),
    );

    return AdaptiveCard(
      onTap: () => _showPaymentDetails(context, payment, guest, booking),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with guest name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: HeadingSmall(text: guest.fullName),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: payment.statusColor.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: CaptionText(
                    text: payment.statusDisplay,
                    color: payment.statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // Payment amount
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                BodyText(
                  text: payment.formattedAmount,
                  medium: true,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Payment date and method
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                BodyText(
                  text: payment.formattedDate,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Icon(Icons.payment, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                BodyText(
                  text: payment.paymentMethodDisplay,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Room/Bed info
            Row(
              children: [
                Icon(Icons.bed, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: CaptionText(
                    text: booking.roomBedDisplay,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            // Action buttons for pending payments
            if (payment.isPending) ...[
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Reject',
                      onPressed: () => _rejectPayment(context, payment),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Mark Collected',
                      onPressed: () => _collectPayment(context, payment),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Shows payment details dialog
  void _showPaymentDetails(
    BuildContext context,
    OwnerPaymentModel payment,
    OwnerGuestModel guest,
    OwnerBookingModel booking,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(text: 'Payment Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Guest Name', guest.fullName),
              _buildDetailRow('Phone', guest.phoneNumber),
              _buildDetailRow('Amount', payment.formattedAmount),
              _buildDetailRow('Payment Method', payment.paymentMethodDisplay),
              _buildDetailRow('Payment Date', payment.formattedDate),
              _buildDetailRow('Status', payment.statusDisplay),
              _buildDetailRow('Room/Bed', booking.roomBedDisplay),
              if (payment.transactionId != null &&
                  payment.transactionId!.isNotEmpty)
                _buildDetailRow('Transaction ID', payment.transactionId!),
              if (payment.notes != null && payment.notes!.isNotEmpty)
                _buildDetailRow('Notes', payment.notes!),
              if (payment.collectedBy != null)
                _buildDetailRow('Collected By', payment.collectedBy!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (payment.isPending) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectPayment(context, payment);
              },
              child: const Text('Reject'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _collectPayment(context, payment);
              },
              child: const Text('Mark Collected'),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a detail row for the dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: BodyText(
              text: '$label:',
              medium: true,
            ),
          ),
          Expanded(
            child: BodyText(text: value),
          ),
        ],
      ),
    );
  }

  /// Collects a payment
  void _collectPayment(BuildContext context, OwnerPaymentModel payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingSmall(text: 'Mark Payment as Collected'),
        content: BodyText(
          text:
              'Are you sure you want to mark this payment of ${payment.formattedAmount} as collected?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Confirm',
            onPressed: () async {
              Navigator.of(context).pop();

              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              final ownerName = authProvider.user?.fullName ?? 'Owner';

              final updatedPayment = payment.copyWith(
                status: 'collected',
                collectedBy: ownerName,
                updatedAt: DateTime.now(),
              );

              final success = await viewModel.updatePayment(updatedPayment);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: BodyText(
                      text: success
                          ? 'Payment marked as collected'
                          : 'Failed to update payment',
                      color: Colors.white,
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Rejects a payment
  void _rejectPayment(BuildContext context, OwnerPaymentModel payment) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingSmall(text: 'Reject Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BodyText(
              text: 'Please provide a reason for rejecting this payment:',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason',
                hintText: 'Enter reason for rejection...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Reject',
            onPressed: () async {
              Navigator.of(context).pop();

              final updatedPayment = payment.copyWith(
                status: 'failed',
                notes: reasonController.text.trim().isNotEmpty
                    ? 'Rejected: ${reasonController.text.trim()}'
                    : 'Payment rejected by owner',
                updatedAt: DateTime.now(),
              );

              final success = await viewModel.updatePayment(updatedPayment);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: BodyText(
                      text: success
                          ? 'Payment rejected'
                          : 'Failed to reject payment',
                      color: Colors.white,
                    ),
                    backgroundColor: success ? Colors.orange : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
