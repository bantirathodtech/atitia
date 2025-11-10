// lib/features/owner_dashboard/mypg/presentation/widgets/owner_occupancy_report_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/grids/responsive_grid.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/owner_pg_management_model.dart';

/// Widget displaying occupancy report with statistics
class OwnerOccupancyReportWidget extends StatelessWidget {
  final OwnerOccupancyReport report;

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const OwnerOccupancyReportWidget({
    required this.report,
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
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final numberFormatter = NumberFormat.decimalPattern(loc?.localeName);
    final percentageFormatter =
        NumberFormat.decimalPattern(loc?.localeName);
    final totalBedsText = numberFormatter.format(report.totalBeds);
    final occupiedBedsText = numberFormatter.format(report.occupiedBeds);
    final vacantBedsText = numberFormatter.format(report.vacantBeds);
    final pendingBedsText = numberFormatter.format(report.pendingBeds);
    final maintenanceBedsText =
        numberFormatter.format(report.maintenanceBeds);
    final occupancyRateText =
        '${percentageFormatter.format(report.occupancyPercentage)}%';

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
                  text: loc?.ownerOccupancyReportTitle ??
                      _text('ownerOccupancyReportTitle', 'Occupancy Report'),
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            ResponsiveGrid(
              targetTileWidth: 200,
              horizontalGap: AppSpacing.paddingS,
              verticalGap: AppSpacing.paddingS,
              childAspectRatio: 1.8,
              children: [
                _buildStatItem(
                  loc?.ownerOccupancyReportTotalBedsLabel ??
                      _text('ownerOccupancyReportTotalBedsLabel', 'Total Beds'),
                  totalBedsText,
                  Icons.bed,
                  AppColors.info,
                ),
                _buildStatItem(
                  loc?.ownerOccupancyReportOccupiedLabel ??
                      _text('ownerOccupancyReportOccupiedLabel', 'Occupied'),
                  occupiedBedsText,
                  Icons.person,
                  AppColors.success,
                ),
                _buildStatItem(
                  loc?.ownerOccupancyReportVacantLabel ??
                      _text('ownerOccupancyReportVacantLabel', 'Vacant'),
                  vacantBedsText,
                  Icons.bed_outlined,
                  AppColors.warning,
                ),
                _buildStatItem(
                  loc?.ownerOccupancyReportRateLabel ??
                      _text('ownerOccupancyReportRateLabel', 'Occupancy Rate'),
                  occupancyRateText,
                  Icons.pie_chart,
                  theme.primaryColor,
                ),
                if (report.pendingBeds > 0)
                  _buildStatItem(
                    loc?.ownerOccupancyReportPendingLabel ??
                        _text('ownerOccupancyReportPendingLabel', 'Pending'),
                    pendingBedsText,
                    Icons.schedule,
                    AppColors.warning,
                  ),
                if (report.maintenanceBeds > 0)
                  _buildStatItem(
                    loc?.ownerOccupancyReportMaintenanceLabel ??
                        _text('ownerOccupancyReportMaintenanceLabel',
                            'Maintenance'),
                    maintenanceBedsText,
                    Icons.build,
                    AppColors.error,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            const SizedBox(height: AppSpacing.paddingS),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
