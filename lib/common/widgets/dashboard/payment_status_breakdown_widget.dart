// lib/common/widgets/dashboard/payment_status_breakdown_widget.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../cards/adaptive_card.dart';
import '../text/heading_medium.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';
import '../../utils/extensions/context_extensions.dart';

/// 📊 **PAYMENT STATUS BREAKDOWN WIDGET - REUSABLE COMMON WIDGET**
///
/// Displays payment status breakdown (Paid, Pending, Partial, Overdue)
/// Used in owner dashboard to show payment analytics
class PaymentStatusBreakdownWidget extends StatelessWidget {
  final int paidCount;
  final int pendingCount;
  final int partialCount;
  final double? paidAmount;
  final double? pendingAmount;
  final double? partialAmount;
  final VoidCallback? onViewDetails;

  const PaymentStatusBreakdownWidget({
    required this.paidCount,
    required this.pendingCount,
    this.partialCount = 0,
    this.paidAmount,
    this.pendingAmount,
    this.partialAmount,
    this.onViewDetails,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = paidCount + pendingCount + partialCount;
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    final paidPercentage = (paidCount / totalCount * 100);
    final pendingPercentage = (pendingCount / totalCount * 100);
    final partialPercentage = (partialCount / totalCount * 100);

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 20,
                      color: context.primaryColor,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    HeadingMedium(
                      text: 'Payment Status',
                      color: context.primaryColor,
                    ),
                  ],
                ),
                if (onViewDetails != null)
                  TextButton(
                    onPressed: onViewDetails,
                    child: BodyText(
                      text: 'View Details',
                      color: context.primaryColor,
                      small: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            // Status Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatusCard(
                    context,
                    'Paid',
                    paidCount,
                    paidPercentage,
                    AppColors.success,
                    paidAmount,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: _buildStatusCard(
                    context,
                    'Pending',
                    pendingCount,
                    pendingPercentage,
                    AppColors.warning,
                    pendingAmount,
                  ),
                ),
                if (partialCount > 0) ...[
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: _buildStatusCard(
                      context,
                      'Partial',
                      partialCount,
                      partialPercentage,
                      AppColors.info,
                      partialAmount,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            // Progress Bar
            _buildProgressBar(
              context,
              paidPercentage,
              pendingPercentage,
              partialPercentage,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // Summary
            _buildSummary(context, totalCount),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    String label,
    int count,
    double percentage,
    Color color,
    double? amount,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              BodyText(
                text: label,
                small: true,
                color: color,
                medium: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          BodyText(
            text: '$count',
            color: color,
            medium: true,
          ),
          if (amount != null) ...[
            const SizedBox(height: 2),
            CaptionText(
              text: '₹${amount.toStringAsFixed(0)}',
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
          const SizedBox(height: 2),
          CaptionText(
            text: '${percentage.toStringAsFixed(1)}%',
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    double paidPercentage,
    double pendingPercentage,
    double partialPercentage,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        ),
        child: Row(
          children: [
            if (paidPercentage > 0)
              Expanded(
                flex: paidPercentage.round(),
                child: Container(
                  color: AppColors.success,
                ),
              ),
            if (pendingPercentage > 0)
              Expanded(
                flex: pendingPercentage.round(),
                child: Container(
                  color: AppColors.warning,
                ),
              ),
            if (partialPercentage > 0)
              Expanded(
                flex: partialPercentage.round(),
                child: Container(
                  color: AppColors.info,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, int totalCount) {
    final theme = Theme.of(context);
    final collectionRate = paidCount > 0
        ? (paidCount / totalCount * 100).toStringAsFixed(1)
        : '0.0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CaptionText(
          text: 'Total: $totalCount guests',
          color: theme.textTheme.bodySmall?.color,
        ),
        Row(
          children: [
            Icon(
              Icons.trending_up,
              size: 14,
              color: AppColors.success,
            ),
            const SizedBox(width: 4),
            CaptionText(
              text: 'Collection Rate: ${collectionRate}%',
              color: AppColors.success,
            ),
          ],
        ),
      ],
    );
  }
}

