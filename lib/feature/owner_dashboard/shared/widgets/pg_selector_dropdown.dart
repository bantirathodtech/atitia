// lib/feature/owner_dashboard/shared/widgets/pg_selector_dropdown.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/styles/spacing.dart';
import '../../mypg/presentation/screens/new_pg_setup_screen.dart';
import '../viewmodel/selected_pg_provider.dart';

/// Dropdown for selecting PG in owner dashboard
/// Loads real PG data from Firebase via SelectedPgProvider
class PgSelectorDropdown extends StatelessWidget {
  final bool compact;

  const PgSelectorDropdown({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedPgProvider>(
      builder: (context, provider, child) {
        // Show loading indicator while fetching
        if (provider.isLoading) {
          return Semantics(
            label: 'Loading properties',
            child: SizedBox(
              width: 20,
              height: 20,
              child: AdaptiveLoader(),
            ),
          );
        }

        // Show error state
        if (provider.error != null) {
          return Semantics(
            label: 'Failed to load properties',
            hint: 'Tap to retry',
            child: Tooltip(
              message: provider.error!,
              child: IconButton(
                icon: const Icon(Icons.error_outline, color: Colors.red),
                onPressed: () => provider.refreshPgs(),
                tooltip: 'Retry loading PGs',
              ),
            ),
          );
        }

        // Show "Add PG" button if no PGs found
        if (!provider.hasPgs) {
          return Semantics(
            label: 'No properties found',
            hint: 'Tap to create a new paying guest property',
            child: Tooltip(
              message: 'Click to create your first PG',
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NewPgSetupScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_business, size: 16),
                label: BodyText(text: compact ? 'Add PG' : 'Create New PG'),
              ),
            ),
          );
        }

        // Build dropdown options with stable IDs and localized labels
        final options = provider.pgs
            .map((pg) {
              final pgId = pg['pgId'] as String? ?? pg['id'] as String? ?? '';
              final pgName = pg['pgName'] as String? ??
                  pg['name'] as String? ??
                  'Unnamed PG';
              return MapEntry(pgId, pgName);
            })
            .where((entry) => entry.key.isNotEmpty)
            .toList();

        // If compact, use responsive dropdown for app bar with dynamic width based on text
        if (compact) {
          return _CompactPgSelector(
            options: options,
            selectedPgId: provider.selectedPgId,
            onSelected: provider.setSelectedPg,
          );
        }

        return _FullWidthPgSelector(
          options: options,
          selectedPgId: provider.selectedPgId,
          onSelected: provider.setSelectedPg,
        );
      },
    );
  }
}

class _CompactPgSelector extends StatelessWidget {
  const _CompactPgSelector({
    required this.options,
    required this.selectedPgId,
    required this.onSelected,
  });

  final List<MapEntry<String, String>> options;
  final String? selectedPgId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    final labelText = selectedPgId != null
        ? options
            .firstWhere(
              (entry) => entry.key == selectedPgId,
              orElse: () => const MapEntry('', 'Select PG'),
            )
            .value
        : 'Select PG';

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
          return Semantics(
            label: 'Selected paying guest property',
            hint: 'Tap to change property',
            button: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: isMobile ? 160 : 200,
                maxWidth: 320,
              ),
              child: OutlinedButton(
                onPressed: options.isEmpty
                    ? null
                    : () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                    vertical: AppSpacing.paddingS,
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.apartment,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    Flexible(
                      child: BodyText(
                        text: labelText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        medium: true,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    Icon(
                      controller.isOpen
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FullWidthPgSelector extends StatelessWidget {
  const _FullWidthPgSelector({
    required this.options,
    required this.selectedPgId,
    required this.onSelected,
  });

  final List<MapEntry<String, String>> options;
  final String? selectedPgId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Select paying guest property',
      child: DropdownButtonFormField<String>(
        value: selectedPgId,
        items: options
            .map(
              (entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null && value != selectedPgId) {
            onSelected(value);
          }
        },
        decoration: InputDecoration(
          labelText: 'Property',
          hintText: 'Select property',
          prefixIcon: Icon(
            Icons.apartment,
            color: theme.colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingM,
            vertical: AppSpacing.paddingS,
          ),
        ),
      ),
    );
  }
}
