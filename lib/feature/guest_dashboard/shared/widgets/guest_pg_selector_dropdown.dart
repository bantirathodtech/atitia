// lib/feature/guest_dashboard/shared/widgets/guest_pg_selector_dropdown.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../pgs/viewmodel/guest_pg_viewmodel.dart';
import '../viewmodel/guest_pg_selection_provider.dart';
import '../../pgs/data/models/guest_pg_model.dart';

/// Compact dropdown for selecting PG in guest dashboard AppBar
/// Shows list of available PGs from GuestPgViewModel
class GuestPgSelectorDropdown extends StatelessWidget {
  final bool compact;

  const GuestPgSelectorDropdown({
    super.key,
    this.compact = true,
  });

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(String key, String fallback) {
    final translated = _i18n.translate(key);
    if (translated.isEmpty || translated == key) {
      return fallback;
    }
    return translated;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GuestPgViewModel, GuestPgSelectionProvider>(
      builder: (context, pgViewModel, pgSelectionProvider, child) {
        final pgs = pgViewModel.pgList;
        final selectedPg = pgSelectionProvider.selectedPg;
        final selectedPgId = pgSelectionProvider.selectedPgId;

        if (pgViewModel.loading && pgs.isEmpty) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: AdaptiveLoader(size: 16),
          );
        }

        if (pgs.isEmpty) {
          return _buildNoPgsAvailable(context);
        }

        // Build dropdown options
        final options = pgs
            .map((pg) => MapEntry(pg.pgId, pg.pgName))
            .where((entry) => entry.key.isNotEmpty && entry.value.isNotEmpty)
            .toList();

        if (options.isEmpty) {
          return _buildNoPgsAvailable(context);
        }

        // Use compact dropdown for app bar
        return _CompactGuestPgSelector(
          options: options,
          selectedPgId: selectedPgId,
          selectedPg: selectedPg,
          onSelected: (pgId) {
            final pg = pgs.firstWhere(
              (p) => p.pgId == pgId,
              orElse: () => pgs.first,
            );
            pgSelectionProvider.selectPg(pg);
          },
        );
      },
    );
  }

  Widget _buildNoPgsAvailable(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.home_outlined,
            size: 16,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: AppSpacing.paddingXS),
          Text(
            loc?.noPgsAvailable ?? _text('noPgsAvailable', 'No PGs'),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactGuestPgSelector extends StatelessWidget {
  const _CompactGuestPgSelector({
    required this.options,
    required this.selectedPgId,
    required this.selectedPg,
    required this.onSelected,
  });

  final List<MapEntry<String, String>> options;
  final String? selectedPgId;
  final GuestPgModel? selectedPg;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    final labelText = selectedPgId != null && selectedPg != null
        ? selectedPg!.pgName
        : 'Select PG';

    // Truncate text if too long
    final displayText = labelText.length > (isMobile ? 15 : 25)
        ? '${labelText.substring(0, isMobile ? 12 : 22)}...'
        : labelText;

    return FocusTraversalGroup(
      child: MenuAnchor(
        menuChildren: options
            .map(
              (entry) => MenuItemButton(
                onPressed: () {
                  if (entry.key != selectedPgId) {
                    onSelected(entry.key);
                  }
                },
                leadingIcon: Icon(
                  entry.key == selectedPgId
                      ? Icons.check_rounded
                      : Icons.apartment,
                  size: 18,
                  color: entry.key == selectedPgId
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                child: Text(
                  entry.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        builder: (context, controller, child) {
          return InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingS,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: selectedPgId != null
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                border: Border.all(
                  color: selectedPgId != null
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : theme.dividerColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedPgId != null ? Icons.home : Icons.home_outlined,
                    size: 16,
                    color: selectedPgId != null
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.paddingXS),
                  Flexible(
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selectedPgId != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: selectedPgId != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    controller.isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: selectedPgId != null
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
