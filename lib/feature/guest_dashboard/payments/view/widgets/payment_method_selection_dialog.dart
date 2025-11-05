// lib/features/guest_dashboard/payments/view/widgets/payment_method_selection_dialog.dart

import 'package:flutter/material.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';

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

  const PaymentMethodSelectionDialog({
    super.key,
    required this.razorpayEnabled,
    required this.onMethodSelected,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
              text: 'Select Payment Method',
              color: theme.textTheme.titleLarge?.color,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: 'Choose how you want to make the payment',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            // Razorpay Option (if enabled)
            if (razorpayEnabled) ...[
              _buildPaymentMethodOption(
                context: context,
                icon: Icons.payment,
                title: 'Razorpay',
                description: 'Secure online payment via Razorpay',
                color: Colors.blue,
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
              title: 'UPI Payment',
              description: 'Pay via PhonePe, Paytm, Google Pay, etc. and share screenshot',
              color: Colors.green,
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
              title: 'Cash Payment',
              description: 'Pay in cash and request owner confirmation',
              color: Colors.orange,
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
                  child: const Text('Cancel'),
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
                  const SizedBox(height: 4),
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

