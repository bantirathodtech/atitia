// lib/common/widgets/payment/payment_reminder_banner.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';

/// 🎨 **PAYMENT REMINDER BANNER - REUSABLE COMPONENT**
///
/// Displays payment reminders for pending/overdue payments
/// Theme-aware and responsive
class PaymentReminderBanner extends StatelessWidget {
  final double amount;
  final DateTime? dueDate;
  final bool isOverdue;
  final VoidCallback? onPayNow;
  final VoidCallback? onDismiss;

  const PaymentReminderBanner({
    super.key,
    required this.amount,
    this.dueDate,
    this.isOverdue = false,
    this.onPayNow,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Determine banner color based on status
    final backgroundColor = isOverdue
        ? AppColors.error.withOpacity(0.1)
        : AppColors.statusOrange.withOpacity(0.1);
    final borderColor = isOverdue
        ? AppColors.error.withOpacity(0.3)
        : AppColors.statusOrange.withOpacity(0.3);
    final iconColor = isOverdue ? AppColors.error : AppColors.statusOrange;

    String message;
    IconData icon;

    if (isOverdue && dueDate != null) {
      final daysOverdue = DateTime.now().difference(dueDate!).inDays;
      message =
          'Your payment of ₹${_formatAmount(amount)} is overdue by $daysOverdue day(s).';
      icon = Icons.warning_amber_rounded;
    } else if (dueDate != null) {
      final daysUntilDue = dueDate!.difference(DateTime.now()).inDays;
      message =
          'Your payment of ₹${_formatAmount(amount)} is due in $daysUntilDue day(s).';
      icon = Icons.access_time;
    } else {
      message = 'You have a pending payment of ₹${_formatAmount(amount)}.';
      icon = Icons.payment;
    }

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(
                  text: message,
                  color: iconColor,
                  medium: true,
                ),
                if (dueDate != null) ...[
                  const SizedBox(height: AppSpacing.paddingXS),
                  CaptionText(
                    text:
                        'Due Date: ${DateFormat('MMM dd, yyyy').format(dueDate!)}',
                    color: iconColor.withOpacity(0.8),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onDismiss,
              color: iconColor,
              tooltip: 'Dismiss',
            ),
          if (onPayNow != null) ...[
            const SizedBox(width: AppSpacing.paddingXS),
            ElevatedButton.icon(
              onPressed: onPayNow,
              icon: const Icon(Icons.payment, size: 18),
              label: const Text('Pay Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingS,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,##0').format(amount);
  }
}
