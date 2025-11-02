// ============================================================================
// Guest PG Selector - Display Selected PG Information
// ============================================================================
// Shows the currently selected PG information for guests across all tabs
// Similar to owner dashboard's PG selection display
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../feature/owner_dashboard/shared/viewmodel/selected_pg_provider.dart';

/// Widget that displays the currently selected PG information for guests
/// Shows PG name, location, and status across all guest dashboard tabs
class GuestPgSelector extends StatelessWidget {
  const GuestPgSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedPgProvider>(
      builder: (context, selectedPgProvider, child) {
        final selectedPg = selectedPgProvider.selectedPg;

        if (selectedPg == null) {
          return _buildNoPgSelected(context);
        }

        return _buildPgSelected(context, selectedPg);
      },
    );
  }

  /// Builds the display when no PG is selected
  Widget _buildNoPgSelected(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      child: AdaptiveCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Icon(
                  Icons.home_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeadingSmall(
                      text: 'No PG Selected',
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    BodyText(
                      text:
                          'Please select a PG to view details and manage your stay',
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color:
                    isDark ? AppColors.textSecondary : AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the display when a PG is selected
  Widget _buildPgSelected(BuildContext context, dynamic selectedPg) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pgName = selectedPg.pgName ?? 'Unknown PG';
    final pgLocation = selectedPg.fullAddress ?? '${selectedPg.city ?? 'Unknown City'}, ${selectedPg.area ?? 'Unknown Area'}';
    final pgStatus = selectedPg.isActive ? 'active' : 'inactive';

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      child: AdaptiveCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: _getStatusColor(pgStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Icon(
                  Icons.home,
                  color: _getStatusColor(pgStatus),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingSmall(
                      text: pgName,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    CaptionText(
                      text: pgLocation,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 2),
                    _buildStatusChip(pgStatus),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color:
                    isDark ? AppColors.textSecondary : AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds status chip for PG status
  Widget _buildStatusChip(String status) {
    Color chipColor;
    String chipText;

    switch (status.toLowerCase()) {
      case 'active':
        chipColor = Colors.green;
        chipText = 'Active';
        break;
      case 'inactive':
        chipColor = Colors.orange;
        chipText = 'Inactive';
        break;
      case 'maintenance':
        chipColor = Colors.red;
        chipText = 'Maintenance';
        break;
      default:
        chipColor = Colors.grey;
        chipText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        chipText,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Gets color for PG status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'maintenance':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
