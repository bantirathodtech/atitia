// lib/features/guest_dashboard/payments/view/widgets/guest_payment_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
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
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const GuestPaymentCardWidget({
    super.key,
    required this.payment,
    this.onTap,
    this.onPay,
    this.showPayButton = false,
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

  Color _getStatusColor(BuildContext context) {
    switch (payment.status.toLowerCase()) {
      case 'paid':
        return AppColors.success;
      case 'pending':
        return payment.isOverdue ? AppColors.error : AppColors.statusOrange;
      case 'failed':
        return AppColors.error;
      case 'refunded':
        return AppColors.info;
      default:
        return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
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

  String _getStatusMessage(AppLocalizations? loc) {
    switch (payment.status.toLowerCase()) {
      case 'paid':
        return loc?.paymentCompletedSuccessfully ??
            _text('paymentCompletedSuccessfully',
                'Payment completed successfully');
      case 'pending':
        return payment.isOverdue
            ? (loc?.paymentOverdue ??
                _text('paymentOverdue',
                    'Payment overdue — please pay immediately'))
            : (loc?.paymentPending ??
                _text('paymentPending', 'Payment pending'));
      case 'failed':
        return loc?.paymentFailedMessage ??
            _text('paymentFailedMessage', 'Payment failed — please try again');
      case 'refunded':
        return loc?.paymentRefunded ??
            _text('paymentRefunded', 'Payment has been refunded');
      default:
        return loc?.unknownStatus ?? _text('unknownStatus', 'Unknown status');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return AdaptiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, loc),
          const SizedBox(height: AppSpacing.paddingS),
          _buildPaymentInfo(context, loc),
          const SizedBox(height: AppSpacing.paddingS),
          _buildStatusRow(context, loc),
          if (showPayButton && payment.status.toLowerCase() == 'pending') ...[
            const SizedBox(height: AppSpacing.paddingM),
            _buildActionButtons(context, loc),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations? loc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingS),
          decoration: BoxDecoration(
            color: _getStatusColor(context).withValues(alpha: 0.1),
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
                text: _paymentTypeLabel(payment.paymentType, loc),
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
              CaptionText(
                text: loc?.paymentNumber(
                      payment.paymentId.substring(0, 8).toUpperCase(),
                    ) ??
                    _text(
                      'paymentNumber',
                      'Payment #{id}',
                      parameters: {
                        'id': payment.paymentId.substring(0, 8).toUpperCase(),
                      },
                    ),
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
            color: _getStatusColor(context),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
          ),
          child: Text(
            _statusLabel(payment.status, loc),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(BuildContext context, AppLocalizations? loc) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyText(
              text: loc?.amount ?? _text('amount', 'Amount'),
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            BodyText(
              text: _formatAmount(payment.amount, loc),
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingXS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyText(
              text: loc?.dueDate ?? _text('dueDate', 'Due Date'),
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            BodyText(
              text: _formatDate(payment.dueDate, loc),
              color: payment.isOverdue ? AppColors.error : null,
            ),
          ],
        ),
        if (payment.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.paddingXS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyText(
                text: loc?.description ?? _text('description', 'Description'),
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

  Widget _buildStatusRow(BuildContext context, AppLocalizations? loc) {
    return Row(
      children: [
        Icon(
          _getStatusIcon(),
          color: _getStatusColor(context),
          size: 16,
        ),
        const SizedBox(width: AppSpacing.paddingXS),
        Expanded(
          child: CaptionText(
            text: _getStatusMessage(loc),
            color: _getStatusColor(context),
          ),
        ),
        if (payment.paymentMethod.isNotEmpty)
          CaptionText(
            text: _paymentMethodLabel(payment.paymentMethod, loc),
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations? loc) {
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
            label: loc?.viewDetails ?? _text('viewDetails', 'View Details'),
            icon: Icons.visibility,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: PrimaryButton(
            onPressed: onPay,
            label: loc?.payNow ?? _text('payNow', 'Pay Now'),
            icon: Icons.payment,
            backgroundColor: _getStatusColor(context),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date, AppLocalizations? loc) {
    final locale = loc?.localeName;
    return DateFormat.yMMMd(locale).format(date);
  }

  String _formatAmount(double amount, AppLocalizations? loc) {
    final locale = loc?.localeName ?? 'en_IN';
    final symbol = NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    return NumberFormat.currency(locale: locale, symbol: symbol).format(amount);
  }

  String _statusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'paid':
        return loc?.paid ?? _text('paid', 'Paid');
      case 'pending':
        return loc?.pending ?? _text('pending', 'Pending');
      case 'failed':
        return loc?.failed ?? _text('failed', 'Failed');
      case 'refunded':
        return loc?.refunded ?? _text('refunded', 'Refunded');
      case 'confirmed':
        return loc?.confirmed ?? _text('confirmed', 'Confirmed');
      default:
        return status;
    }
  }

  String _paymentMethodLabel(String method, AppLocalizations? loc) {
    switch (method.toLowerCase()) {
      case 'razorpay':
        return loc?.paymentMethodRazorpay ??
            _text('paymentMethodRazorpay', 'Razorpay');
      case 'upi':
        return loc?.paymentMethodUpi ?? _text('paymentMethodUpi', 'UPI');
      case 'cash':
        return loc?.paymentMethodCash ?? _text('paymentMethodCash', 'Cash');
      case 'bank_transfer':
        return loc?.paymentMethodBankTransfer ??
            _text('paymentMethodBankTransfer', 'Bank Transfer');
      default:
        return loc?.paymentMethodOther ?? _text('paymentMethodOther', 'Other');
    }
  }

  String _paymentTypeLabel(String type, AppLocalizations? loc) {
    switch (type.toLowerCase()) {
      case 'rent':
        return loc?.paymentTypeRent ?? _text('paymentTypeRent', 'Rent Payment');
      case 'security deposit':
        return loc?.paymentTypeSecurityDeposit ??
            _text('paymentTypeSecurityDeposit', 'Security Deposit');
      case 'maintenance':
        return loc?.paymentTypeMaintenance ??
            _text('paymentTypeMaintenance', 'Maintenance Fee');
      case 'late fee':
        return loc?.paymentTypeLateFee ??
            _text('paymentTypeLateFee', 'Late Fee');
      default:
        return loc?.paymentTypeOther(type) ??
            _text('paymentTypeOther', '{type} Payment',
                parameters: {'type': type});
    }
  }
}
