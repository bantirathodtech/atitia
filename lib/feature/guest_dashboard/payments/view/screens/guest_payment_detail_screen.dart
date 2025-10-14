// lib/features/guest_dashboard/payments/view/screens/guest_payment_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../data/models/guest_payment_model.dart';
import '../../viewmodel/guest_payment_viewmodel.dart';

/// Screen displaying detailed information for a specific payment
/// Shows comprehensive payment details, status, and actions
class GuestPaymentDetailScreen extends StatefulWidget {
  final String paymentId;

  const GuestPaymentDetailScreen({
    super.key,
    required this.paymentId,
  });

  @override
  State<GuestPaymentDetailScreen> createState() =>
      _GuestPaymentDetailScreenState();
}

class _GuestPaymentDetailScreenState extends State<GuestPaymentDetailScreen> {
  GuestPaymentModel? _payment;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPaymentDetails();
  }

  Future<void> _loadPaymentDetails() async {
    try {
      final paymentVM =
          Provider.of<GuestPaymentViewModel>(context, listen: false);
      final payment = await paymentVM.getPaymentById(widget.paymentId);

      if (mounted) {
        setState(() {
          _payment = payment;
          _isLoading = false;
          _error = payment == null ? 'Payment not found' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load payment details: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Payment Details',
        showBackButton: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return Center(child: AdaptiveLoader());
    }

    if (_error != null || _payment == null) {
      return Center(
        child: EmptyState(
          title: 'Payment Not Found',
          message: _error ?? 'The requested payment could not be found.',
          icon: Icons.error_outline,
          actionLabel: 'Go Back',
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentHeader(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPaymentInfo(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPaymentTimeline(context),
          if (_payment!.metadata != null && _payment!.metadata!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingL),
            _buildMetadataSection(context),
          ],
          const SizedBox(height: AppSpacing.paddingL),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildPaymentHeader(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingM),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: Text(
                  _payment!.paymentTypeIcon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingMedium(
                      text: _payment!.paymentType,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                    CaptionText(
                      text: 'Payment #${_payment!.paymentId.substring(0, 8)}',
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingS,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: Text(
                  _payment!.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                _payment!.formattedAmount,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Payment Information',
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildInfoRow(context, 'Description', _payment!.description),
          _buildInfoRow(context, 'Payment Method', _payment!.paymentMethod),
          _buildInfoRow(context, 'Due Date', _formatDate(_payment!.dueDate)),
          _buildInfoRow(
              context, 'Payment Date', _formatDate(_payment!.paymentDate)),
          if (_payment!.transactionId != null)
            _buildInfoRow(context, 'Transaction ID', _payment!.transactionId!),
          if (_payment!.upiReferenceId != null)
            _buildInfoRow(context, 'UPI Reference', _payment!.upiReferenceId!),
          _buildInfoRow(context, 'PG ID', _payment!.pgId),
          _buildInfoRow(context, 'Owner ID', _payment!.ownerId),
        ],
      ),
    );
  }

  Widget _buildPaymentTimeline(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Timeline',
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildTimelineItem(
            context,
            'Created',
            _formatDateTime(_payment!.createdAt ?? _payment!.paymentDate),
            Icons.add_circle_outline,
            Colors.blue,
          ),
          if (_payment!.status == 'Paid') ...[
            const SizedBox(height: AppSpacing.paddingS),
            _buildTimelineItem(
              context,
              'Paid',
              _formatDateTime(_payment!.updatedAt ?? _payment!.paymentDate),
              Icons.check_circle_outline,
              Colors.green,
            ),
          ],
          if (_payment!.status == 'Failed') ...[
            const SizedBox(height: AppSpacing.paddingS),
            _buildTimelineItem(
              context,
              'Failed',
              _formatDateTime(_payment!.updatedAt ?? _payment!.paymentDate),
              Icons.error_outline,
              Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Additional Information',
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          ..._payment!.metadata!.entries.map((entry) =>
              _buildInfoRow(context, entry.key, entry.value.toString())),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodyText(
              text: label,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: BodyText(
              text: value,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, String date,
      IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                text: title,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              CaptionText(
                text: date,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (_payment!.status == 'Pending') ...[
          PrimaryButton(
            onPressed: () => _processPayment(context),
            label: 'Pay Now',
            icon: Icons.payment,
            width: double.infinity,
          ),
          const SizedBox(height: AppSpacing.paddingM),
        ],
        SecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          label: 'Back to Payments',
          icon: Icons.arrow_back,
          width: double.infinity,
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (_payment!.status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return _payment!.isOverdue ? Colors.red : Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  void _processPayment(BuildContext context) async {
    final paymentVM =
        Provider.of<GuestPaymentViewModel>(context, listen: false);

    // Show payment method selection dialog
    final paymentMethod = await _showPaymentMethodDialog(context);
    if (paymentMethod != null) {
      final success =
          await paymentVM.processPayment(_payment!.paymentId, paymentMethod);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Payment processed successfully!'
                : 'Payment failed. Please try again.'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          // Refresh payment details
          await _loadPaymentDetails();
        }
      }
    }
  }

  Future<String?> _showPaymentMethodDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingMedium(text: 'Select Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('UPI'),
              onTap: () => Navigator.of(context).pop('UPI'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () => Navigator.of(context).pop('Credit Card'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Net Banking'),
              onTap: () => Navigator.of(context).pop('Net Banking'),
            ),
          ],
        ),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            label: 'Cancel',
          ),
        ],
      ),
    );
  }
}
