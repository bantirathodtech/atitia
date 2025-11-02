// ============================================================================
// Guest PG AppBar Display - Small PG Selection Display for AppBar
// ============================================================================
// A compact widget that displays the currently selected PG information
// in the center of the AppBar for all guest dashboard tabs
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../viewmodel/guest_pg_selection_provider.dart';

/// Compact widget that displays selected PG information in AppBar
/// Shows PG name and location in a small, centered format
class GuestPgAppBarDisplay extends StatelessWidget {
  const GuestPgAppBarDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuestPgSelectionProvider>(
      builder: (context, guestPgProvider, child) {
        final selectedPg = guestPgProvider.selectedPg;

        if (selectedPg == null) {
          return _buildNoPgSelected(context);
        }

        return _buildPgSelected(context, selectedPg);
      },
    );
  }

  /// Builds the display when no PG is selected
  Widget _buildNoPgSelected(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.home_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 4),
          CaptionText(
            text: 'No PG Selected',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  /// Builds the display when a PG is selected
  Widget _buildPgSelected(BuildContext context, dynamic selectedPg) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pgName = selectedPg.pgName ?? 'Unknown PG';
    final pgLocation = selectedPg.fullAddress ??
        '${selectedPg.city ?? 'Unknown City'}, ${selectedPg.area ?? 'Unknown Area'}';
    final pgStatus = selectedPg.isActive ? 'active' : 'inactive';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(pgStatus).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: _getStatusColor(pgStatus).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.home,
            color: _getStatusColor(pgStatus),
            size: 16,
          ),
          const SizedBox(width: 4),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(
                text: pgName,
                color: isDark ? Colors.white : Colors.black,
              ),
              CaptionText(
                text: pgLocation,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ],
          ),
        ],
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
