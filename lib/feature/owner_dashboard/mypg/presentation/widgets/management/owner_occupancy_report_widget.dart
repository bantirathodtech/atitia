// lib/features/owner_dashboard/mypg/presentation/widgets/owner_occupancy_report_widget.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../data/models/owner_pg_management_model.dart';

/// Widget displaying occupancy report with statistics
class OwnerOccupancyReportWidget extends StatelessWidget {
  final OwnerOccupancyReport report;

  const OwnerOccupancyReportWidget({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_rounded, color: AppColors.info, size: 20),
                const SizedBox(width: 8),
                HeadingMedium(
                  text: 'Occupancy Report',
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Beds',
                    '${report.totalBeds}',
                    Icons.bed,
                    AppColors.info,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Occupied',
                    '${report.occupiedBeds}',
                    Icons.person,
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Vacant',
                    '${report.vacantBeds}',
                    Icons.bed_outlined,
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
                    'Occupancy Rate',
                    '${report.occupancyPercentage.toStringAsFixed(1)}%',
                    Icons.pie_chart,
                    theme.primaryColor,
                  ),
                ),
                if (report.pendingBeds > 0)
                  Expanded(
                    child: _buildStatItem(
                      'Pending',
                      '${report.pendingBeds}',
                      Icons.schedule,
                      AppColors.warning,
                    ),
                  ),
                if (report.maintenanceBeds > 0)
                  Expanded(
                    child: _buildStatItem(
                      'Maintenance',
                      '${report.maintenanceBeds}',
                      Icons.build,
                      AppColors.error,
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
