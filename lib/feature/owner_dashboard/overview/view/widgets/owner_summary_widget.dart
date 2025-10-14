// lib/features/owner_dashboard/overview/view/widgets/owner_summary_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/styles/spacing.dart';
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Total Revenue',
                overview.formattedTotalRevenue,
                Icons.account_balance_wallet,
                Colors.green,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingS),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Properties',
                '${overview.totalProperties}',
                Icons.apartment,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingS),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Active Tenants',
                '${overview.activeTenants}',
                Icons.people,
                Colors.orange,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingS),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Occupancy',
                overview.formattedOccupancyRate,
                Icons.bed,
                Colors.purple,
              ),
            ),
          ],
        ),
        if (overview.hasPendingBookings || overview.hasPendingComplaints) ...[
          const SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              if (overview.hasPendingBookings)
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Pending Bookings',
                    '${overview.pendingBookings}',
                    Icons.pending_actions,
                    Colors.amber,
                  ),
                ),
              if (overview.hasPendingBookings && overview.hasPendingComplaints)
                const SizedBox(width: AppSpacing.paddingS),
              if (overview.hasPendingComplaints)
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Pending Complaints',
                    '${overview.pendingComplaints}',
                    Icons.report_problem,
                    Colors.red,
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
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          HeadingMedium(text: value, color: color),
          const SizedBox(height: AppSpacing.paddingXS),
          CaptionText(text: title, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}
