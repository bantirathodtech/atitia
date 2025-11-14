// lib/features/owner_dashboard/myguest/view/widgets/payment_list_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../../../../l10n/app_localizations.dart';
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

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const PaymentListWidget({
    required this.payments,
    required this.viewModel,
    required this.guests,
    required this.bookings,
    super.key,
  });

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (payments.isEmpty) {
      return EmptyState(
        title: loc?.ownerNoPaymentsTitle ??
            _text('ownerNoPaymentsTitle', 'No Payments'),
        message: loc?.ownerNoPaymentsMessage ??
            _text('ownerNoPaymentsMessage',
                'Payment records will appear here once payments are collected'),
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
          child: _buildPaymentCard(context, payment, loc),
        );
      },
    );
  }

  /// Builds individual payment card
  Widget _buildPaymentCard(
    BuildContext context,
    OwnerPaymentModel payment,
    AppLocalizations? loc,
  ) {
    final guest = guests.firstWhere(
      (g) => g.uid == payment.guestUid,
      orElse: () => OwnerGuestModel(
        uid: payment.guestUid,
        fullName: loc?.unknownGuest ?? _text('unknownGuest', 'Unknown Guest'),
        phoneNumber: '',
      ),
    );

    final booking = bookings.firstWhere(
      (b) => b.id == payment.bookingId,
      orElse: () => OwnerBookingModel(
        id: payment.bookingId,
        guestUid: payment.guestUid,
        pgId: payment.pgId,
        roomNumber: loc?.notAvailable ?? _text('notAvailable', 'Not available'),
        bedNumber: loc?.notAvailable ?? _text('notAvailable', 'Not available'),
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
                Icon(Icons.currency_rupee, size: 16, color: AppColors.success),
                const SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: _formatCurrency(payment.amountPaid, loc),
                  medium: true,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Payment date and method
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: _formatDate(payment.date, loc),
                  color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.7) ??
                      Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Icon(Icons.payment,
                    size: 14,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: payment.paymentMethodDisplay,
                  color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.7) ??
                      Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Room/Bed info
            Row(
              children: [
                Icon(Icons.bed,
                    size: 14,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: CaptionText(
                    text: booking.roomBedDisplay,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
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
                      label: loc?.reject ?? _text('reject', 'Reject'),
                      onPressed: () => _rejectPayment(context, payment, loc),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: PrimaryButton(
                      label: loc?.markPaymentCollected ??
                          _text('markPaymentCollected',
                              'Mark Payment as Collected'),
                      onPressed: () => _collectPayment(context, payment, loc),
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
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(
            text: loc?.paymentDetails ??
                _text('paymentDetails', 'Payment Details')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                  loc?.guestName ?? _text('guestName', 'Guest Name'),
                  guest.fullName,
                  loc),
              _buildDetailRow(loc?.phoneNumber ?? _text('phoneNumber', 'Phone'),
                  guest.phoneNumber, loc),
              _buildDetailRow(loc?.amount ?? _text('amount', 'Amount'),
                  _formatCurrency(payment.amountPaid, loc), loc),
              _buildDetailRow(
                  loc?.paymentMethod ??
                      _text('paymentMethod', 'Payment Method'),
                  payment.paymentMethodDisplay,
                  loc),
              _buildDetailRow(
                  loc?.paymentDate ?? _text('paymentDate', 'Payment Date'),
                  _formatDate(payment.date, loc),
                  loc),
              _buildDetailRow(loc?.status ?? _text('status', 'Status'),
                  payment.statusDisplay, loc),
              _buildDetailRow(loc?.roomBed ?? _text('roomBed', 'Room/Bed'),
                  booking.roomBedDisplay, loc),
              if (payment.transactionId != null &&
                  payment.transactionId!.isNotEmpty)
                _buildDetailRow(
                    loc?.transactionId ??
                        _text('transactionId', 'Transaction ID'),
                    payment.transactionId!,
                    loc),
              if (payment.notes != null && payment.notes!.isNotEmpty)
                _buildDetailRow(
                    loc?.notes ?? _text('notes', 'Notes'), payment.notes!, loc),
              if (payment.collectedBy != null)
                _buildDetailRow(
                    loc?.collectedBy ?? _text('collectedBy', 'Collected By'),
                    payment.collectedBy!,
                    loc),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc?.close ?? _text('close', 'Close')),
          ),
          if (payment.isPending) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectPayment(context, payment, loc);
              },
              child: Text(loc?.reject ?? _text('reject', 'Reject')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _collectPayment(context, payment, loc);
              },
              child: Text(loc?.markPaymentCollected ??
                  _text('markPaymentCollected', 'Mark Payment as Collected')),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a detail row for the dialog
  Widget _buildDetailRow(String label, String value, AppLocalizations? loc) {
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
  void _collectPayment(
      BuildContext context, OwnerPaymentModel payment, AppLocalizations? loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(
            text: loc?.markPaymentCollected ??
                _text('markPaymentCollected', 'Mark Payment as Collected')),
        content: BodyText(
          text: loc?.confirmMarkPaymentCollected(
                _formatCurrency(payment.amountPaid, loc),
              ) ??
              _text(
                'confirmMarkPaymentCollected',
                'Are you sure you want to mark this payment of {amount} as collected?',
                parameters: {
                  'amount': _formatCurrency(payment.amountPaid, loc),
                },
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc?.cancel ?? _text('cancel', 'Cancel')),
          ),
          PrimaryButton(
            label: loc?.confirm ?? _text('confirm', 'Confirm'),
            onPressed: () async {
              Navigator.of(context).pop();

              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              final ownerName = authProvider.user?.fullName ??
                  (loc?.owner ?? _text('owner', 'Owner'));

              final updatedPayment = payment.copyWith(
                status: 'collected',
                collectedBy: ownerName,
                updatedAt: DateTime.now(),
              );

              final success = await viewModel.updatePayment(updatedPayment);

              if (context.mounted) {
                final message = success
                    ? (loc?.paymentMarkedCollected ??
                        _text('paymentMarkedCollected',
                            'Payment marked as collected'))
                    : (loc?.ownerPaymentUpdateFailed ??
                        _text('ownerPaymentUpdateFailed',
                            'Failed to update payment'));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor:
                        success ? AppColors.success : AppColors.error,
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
  void _rejectPayment(
      BuildContext context, OwnerPaymentModel payment, AppLocalizations? loc) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(text: loc?.rejectPayment ?? 'Reject Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BodyText(
              text: loc?.provideRejectionReason ??
                  _text('provideRejectionReason',
                      'Please provide a reason for rejecting this payment:'),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: loc?.rejectionReason ??
                    _text('rejectionReason', 'Rejection Reason'),
                hintText: loc?.enterRejectionReason ??
                    _text('enterRejectionReason',
                        'Enter reason for rejection...'),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc?.cancel ?? _text('cancel', 'Cancel')),
          ),
          PrimaryButton(
            label: loc?.reject ?? _text('reject', 'Reject'),
            onPressed: () async {
              Navigator.of(context).pop();

              final updatedPayment = payment.copyWith(
                status: 'failed',
                notes: reasonController.text.trim().isNotEmpty
                    ? loc?.rejectedWithReason(reasonController.text.trim()) ??
                        _text('rejectedWithReason', 'Rejected: {reason}',
                            parameters: {
                              'reason': reasonController.text.trim()
                            })
                    : loc?.paymentRejectedByOwner ??
                        _text('paymentRejectedByOwner',
                            'Payment rejected by owner'),
                updatedAt: DateTime.now(),
              );

              final success = await viewModel.updatePayment(updatedPayment);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? (loc?.paymentRejected ??
                              _text('paymentRejected', 'Payment rejected'))
                          : (loc?.failedToRejectPayment ??
                              _text('failedToRejectPayment',
                                  'Failed to reject payment')),
                    ),
                    backgroundColor:
                        success ? AppColors.warning : AppColors.error,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount, AppLocalizations? loc) {
    final format = NumberFormat.simpleCurrency(
      locale: loc?.localeName,
      name: 'INR',
    );
    return format.format(amount);
  }

  String _formatDate(DateTime date, AppLocalizations? loc) {
    final locale = loc?.localeName;
    final datePart = DateFormat.yMMMd(locale).format(date);
    final timePart = DateFormat.jm(locale).format(date);
    return '$datePart • $timePart';
  }
}
