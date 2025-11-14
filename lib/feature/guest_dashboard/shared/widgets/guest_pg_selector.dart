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
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../feature/owner_dashboard/shared/viewmodel/selected_pg_provider.dart';

/// Widget that displays the currently selected PG information for guests
/// Shows PG name, location, and status across all guest dashboard tabs
class GuestPgSelector extends StatelessWidget {
  const GuestPgSelector({super.key});

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

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
    final loc = AppLocalizations.of(context);

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
                    HeadingSmall(
                      text: loc?.noPgSelected ??
                          _text('noPgSelected', 'No PG Selected'),
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    BodyText(
                      text: loc?.selectPgPrompt ??
                          _text('selectPgPrompt',
                              'Please select a PG to view details and manage your stay'),
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
    final loc = AppLocalizations.of(context);

    final pgName = (selectedPg.pgName as String?)?.trim().isNotEmpty == true
        ? selectedPg.pgName
        : loc?.unknownPg ?? _text('unknownPg', 'Unknown PG');
    final pgLocation = _resolveLocation(
      context,
      selectedPg.fullAddress as String?,
      selectedPg.city as String?,
      selectedPg.area as String?,
    );
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
                  color: _getStatusColor(context, pgStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Icon(
                  Icons.home,
                  color: _getStatusColor(context, pgStatus),
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
                    const SizedBox(height: AppSpacing.paddingXS),
                    CaptionText(
                      text: pgLocation,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 2),
                    _buildStatusChip(context, pgStatus),
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
  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    String chipText;
    final loc = AppLocalizations.of(context);

    switch (status.toLowerCase()) {
      case 'active':
        chipColor = AppColors.success;
        chipText = loc?.statusActive ?? _text('statusActive', 'Active');
        break;
      case 'inactive':
        chipColor = AppColors.statusGrey;
        chipText = loc?.statusInactive ?? _text('statusInactive', 'Inactive');
        break;
      case 'maintenance':
        chipColor = context.decorativeRed;
        chipText =
            loc?.statusMaintenance ?? _text('statusMaintenance', 'Maintenance');
        break;
      default:
        chipColor = Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
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
  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'inactive':
        return AppColors.statusGrey;
      case 'maintenance':
        return context.decorativeRed;
      default:
        return Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  String _resolveLocation(
    BuildContext context,
    String? fullAddress,
    String? city,
    String? area,
  ) {
    final loc = AppLocalizations.of(context);
    if (fullAddress != null && fullAddress.trim().isNotEmpty) {
      return fullAddress.trim();
    }

    final hasCity = city?.trim().isNotEmpty ?? false;
    final hasArea = area?.trim().isNotEmpty ?? false;

    if (!hasCity && !hasArea) {
      return loc?.pgLocationFallback ??
          _text('pgLocationFallback', 'Location unavailable');
    }

    final cityValue = hasCity
        ? city!.trim()
        : loc?.unknownValue ?? _text('unknownValue', 'Unknown');
    final areaValue = hasArea
        ? area!.trim()
        : loc?.unknownValue ?? _text('unknownValue', 'Unknown');

    return '$cityValue, $areaValue';
  }
}
