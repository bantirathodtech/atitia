// lib/features/owner_dashboard/overview/view/widgets/owner_summary_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/owner_overview_model.dart';

/// Widget displaying summary statistics for owner dashboard
class OwnerSummaryWidget extends StatelessWidget {
  final OwnerOverviewModel overview;

  const OwnerSummaryWidget({
    required this.overview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cardGap =
        context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                loc.totalRevenue,
                overview.formattedTotalRevenue,
                Icons.account_balance_wallet,
                AppColors.success,
              ),
            ),
            SizedBox(width: cardGap),
            Expanded(
              child: _buildSummaryCard(
                context,
                loc.properties,
                '${overview.totalProperties}',
                Icons.apartment,
                AppColors.info,
              ),
            ),
          ],
        ),
        SizedBox(height: cardGap),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                loc.activeTenants,
                '${overview.activeTenants}',
                Icons.people,
                AppColors.info,
              ),
            ),
            SizedBox(width: cardGap),
            Expanded(
              child: _buildSummaryCard(
                context,
                loc.occupancy,
                overview.formattedOccupancyRate,
                Icons.bed,
                AppColors.purple,
              ),
            ),
          ],
        ),
        if (overview.hasPendingBookings || overview.hasPendingComplaints) ...[
          SizedBox(height: cardGap),
          Row(
            children: [
              if (overview.hasPendingBookings)
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    loc.pendingBookings,
                    '${overview.pendingBookings}',
                    Icons.pending_actions,
                    AppColors.statusOrange,
                  ),
                ),
              if (overview.hasPendingBookings && overview.hasPendingComplaints)
                SizedBox(width: cardGap),
              if (overview.hasPendingComplaints)
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    loc.pendingComplaints,
                    '${overview.pendingComplaints}',
                    Icons.report_problem,
                    AppColors.error,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    final padding = context.responsivePadding;
    return AdaptiveCard(
      padding:
          EdgeInsets.all(context.isMobile ? padding.top * 0.5 : padding.top),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Icon and number side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: context.isMobile ? 18 : 24,
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              HeadingMedium(
                text: value,
                color: color,
              ),
            ],
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),
          // Row 2: Text below
          BodyText(
            text: title,
            small: true,
            color:
                (context.textTheme.bodySmall?.color ?? context.colors.onSurface)
                    .withValues(alpha: 0.7),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
