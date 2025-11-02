// lib/features/guest_dashboard/payments/view/widgets/guest_payment_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../data/models/guest_payment_model.dart';

/// Widget for displaying individual payment information in a card format
/// Shows payment details, status, and amount in a consistent layout
class GuestPaymentCardWidget extends StatelessWidget {
  final GuestPaymentModel payment;
  final VoidCallback? onTap;
  final VoidCallback? onPay;
  final bool showPayButton;

  const GuestPaymentCardWidget({
    super.key,
    required this.payment,
    this.onTap,
    this.onPay,
    this.showPayButton = false,
  });

  Color _getStatusColor() {
    switch (payment.status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return payment.isOverdue ? Colors.red : Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (payment.status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return payment.isOverdue ? Icons.warning : Icons.schedule;
      case 'failed':
        return Icons.error;
      case 'refunded':
        return Icons.refresh;
      default:
        return Icons.help;
    }
  }

  String _getStatusMessage() {
    switch (payment.status.toLowerCase()) {
      case 'paid':
        return 'Payment completed successfully';
      case 'pending':
        return payment.isOverdue
            ? 'Payment overdue - please pay immediately'
            : 'Payment pending';
      case 'failed':
        return 'Payment failed - please try again';
      case 'refunded':
        return 'Payment has been refunded';
      default:
        return 'Unknown status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.paddingS),
          _buildPaymentInfo(context),
          const SizedBox(height: AppSpacing.paddingS),
          _buildStatusRow(context),
          if (showPayButton && payment.status == 'Pending') ...[
            const SizedBox(height: AppSpacing.paddingM),
            _buildActionButtons(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingS),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
          ),
          child: Text(
            payment.paymentTypeIcon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(
                text: payment.paymentType,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
              CaptionText(
                text: 'Payment #${payment.paymentId.substring(0, 8)}',
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingS,
            vertical: AppSpacing.paddingXS,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
          ),
          child: Text(
            payment.status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyText(
              text: 'Amount',
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            BodyText(
              text: payment.formattedAmount,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingXS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyText(
              text: 'Due Date',
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            BodyText(
              text: _formatDate(payment.dueDate),
              color: payment.isOverdue ? Colors.red : null,
            ),
          ],
        ),
        if (payment.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.paddingXS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyText(
                text: 'Description',
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              Expanded(
                child: BodyText(
                  text: payment.description,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  align: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getStatusIcon(),
          color: _getStatusColor(),
          size: 16,
        ),
        const SizedBox(width: AppSpacing.paddingXS),
        Expanded(
          child: CaptionText(
            text: _getStatusMessage(),
            color: _getStatusColor(),
          ),
        ),
        if (payment.paymentMethod.isNotEmpty)
          CaptionText(
            text: payment.paymentMethod,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            onPressed: () {
              if (onTap != null) {
                onTap!();
              } else {
                // Default navigation to payment details
                final navigationService = getIt<NavigationService>();
                navigationService.goToGuestPaymentDetails(payment.paymentId);
              }
            },
            label: 'View Details',
            icon: Icons.visibility,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: PrimaryButton(
            onPressed: onPay,
            label: 'Pay Now',
            icon: Icons.payment,
            backgroundColor: _getStatusColor(),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
