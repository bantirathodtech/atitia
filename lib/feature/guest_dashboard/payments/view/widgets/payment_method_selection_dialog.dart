// lib/features/guest_dashboard/payments/view/widgets/payment_method_selection_dialog.dart

import 'package:flutter/material.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';

/// Payment method types
enum PaymentMethodType {
  razorpay,
  upi,
  cash,
}

/// Dialog for selecting payment method
/// Shows 3 options: Razorpay (optional), UPI, Cash
class PaymentMethodSelectionDialog extends StatelessWidget {
  final bool razorpayEnabled;
  final Function(PaymentMethodType) onMethodSelected;
  final VoidCallback? onCancel;
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const PaymentMethodSelectionDialog({
    super.key,
    required this.razorpayEnabled,
    required this.onMethodSelected,
    this.onCancel,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(
              text: loc?.selectPaymentMethodTitle ??
                  _text('selectPaymentMethodTitle', 'Select Payment Method'),
              color: theme.textTheme.titleLarge?.color,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: loc?.selectPaymentMethodSubtitle ??
                  _text('selectPaymentMethodSubtitle',
                      'Choose how you want to make the payment'),
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            // Razorpay Option (if enabled)
            if (razorpayEnabled) ...[
              _buildPaymentMethodOption(
                context: context,
                icon: Icons.payment,
                title: loc?.paymentMethodRazorpay ??
                    _text('paymentMethodRazorpay', 'Razorpay'),
                description: loc?.razorpayPaymentDescription ??
                    _text('razorpayPaymentDescription',
                        'Secure online payment via Razorpay'),
                color: AppColors.statusBlue,
                isDark: isDark,
                onTap: () {
                  Navigator.of(context).pop();
                  onMethodSelected(PaymentMethodType.razorpay);
                },
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],
            // UPI Option
            _buildPaymentMethodOption(
              context: context,
              icon: Icons.qr_code_scanner,
              title: loc?.paymentMethodUpi ?? _text('paymentMethodUpi', 'UPI'),
              description: loc?.upiPaymentDescription ??
                  _text('upiPaymentDescription',
                      'Pay via PhonePe, Paytm, Google Pay, etc. and share screenshot'),
              color: AppColors.statusGreen,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).pop();
                onMethodSelected(PaymentMethodType.upi);
              },
            ),
            const SizedBox(height: AppSpacing.paddingM),
            // Cash Option
            _buildPaymentMethodOption(
              context: context,
              icon: Icons.money,
              title:
                  loc?.paymentMethodCash ?? _text('paymentMethodCash', 'Cash'),
              description: loc?.cashPaymentDescription ??
                  _text('cashPaymentDescription',
                      'Pay in cash and request owner confirmation'),
              color: AppColors.statusOrange,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).pop();
                onMethodSelected(PaymentMethodType.cash);
              },
            ),
            const SizedBox(height: AppSpacing.paddingL),
            // Cancel Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel?.call();
                  },
                  child: Text(loc?.cancel ?? _text('cancel', 'Cancel')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingS),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.paddingXS),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  /// Show payment method selection dialog
  static Future<PaymentMethodType?> show(
    BuildContext context, {
    required bool razorpayEnabled,
  }) {
    return showDialog<PaymentMethodType>(
      context: context,
      builder: (context) => PaymentMethodSelectionDialog(
        razorpayEnabled: razorpayEnabled,
        onMethodSelected: (method) {
          Navigator.of(context).pop(method);
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
