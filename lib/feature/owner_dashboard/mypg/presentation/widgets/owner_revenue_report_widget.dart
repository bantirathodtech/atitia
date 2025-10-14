// lib/features/owner_dashboard/mypg/presentation/widgets/owner_revenue_report_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../data/models/owner_pg_management_model.dart';

/// Widget displaying revenue report with financial statistics
class OwnerRevenueReportWidget extends StatelessWidget {
  final OwnerRevenueReport report;

  const OwnerRevenueReportWidget({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet_rounded,
                    color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                HeadingMedium(
                  text: 'Revenue Report',
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Collected',
                    '₹${report.collectedAmount.toStringAsFixed(0)}',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Pending',
                    '₹${report.pendingAmount.toStringAsFixed(0)}',
                    Icons.schedule,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Payments',
                    '${report.totalPayments}',
                    Icons.receipt,
                    AppColors.info,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Collected Count',
                    '${report.collectedPayments}',
                    Icons.paid,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(text: value, medium: true, color: color),
          CaptionText(text: label, color: color),
        ],
      ),
    );
  }
}
