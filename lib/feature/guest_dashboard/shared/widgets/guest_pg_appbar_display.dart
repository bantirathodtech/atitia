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
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../viewmodel/guest_pg_selection_provider.dart';

/// Compact widget that displays selected PG information in AppBar
/// Shows PG name and location in a small, centered format
class GuestPgAppBarDisplay extends StatelessWidget {
  const GuestPgAppBarDisplay({super.key});

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
    final loc = AppLocalizations.of(context);
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
          const SizedBox(width: AppSpacing.paddingXS),
          CaptionText(
            text: loc?.noPgSelected ?? _text('noPgSelected', 'No PG Selected'),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  /// Builds the display when a PG is selected
  Widget _buildPgSelected(BuildContext context, dynamic selectedPg) {
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
          const SizedBox(width: AppSpacing.paddingXS),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(
                text: pgName,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              CaptionText(
                text: pgLocation,
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
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

  /// Gets color for PG status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'inactive':
        return AppColors.warning;
      case 'maintenance':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
