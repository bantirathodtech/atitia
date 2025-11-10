// lib/feature/owner_dashboard/shared/widgets/pg_selector_dropdown.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/styles/colors.dart';
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
          return const SizedBox(
            width: 20,
            height: 20,
            child: AdaptiveLoader(),
          );
        }

        // Show error state
        if (provider.error != null) {
          return Tooltip(
            message: provider.error!,
            child: IconButton(
              icon: const Icon(Icons.error_outline, color: Colors.red),
              onPressed: () => provider.refreshPgs(),
              tooltip: 'Retry loading PGs',
            ),
          );
        }

        // Show "Add PG" button if no PGs found
        if (!provider.hasPgs) {
          return Tooltip(
            message: 'Click to create your first PG',
            child: TextButton.icon(
              onPressed: () {
                // Navigate to new PG setup screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NewPgSetupScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_business, size: 16),
              label: BodyText(text: compact ? 'Add PG' : 'Create New PG'),
            ),
          );
        }

        // Build dropdown items from Firebase data
        // Also create a map for easy lookup of PG names by ID
        final pgNameMap = <String, String>{};
        final items = provider.pgs.map((pg) {
          final pgId = pg['pgId'] as String? ?? pg['id'] as String? ?? '';
          final pgName =
              pg['pgName'] as String? ?? pg['name'] as String? ?? 'Unnamed PG';
          pgNameMap[pgId] = pgName;

          return DropdownMenuItem<String>(
            value: pgId,
            child: Text(
              pgName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList();

        // If compact, use responsive dropdown for app bar with dynamic width based on text
        if (compact) {
          final responsive = context.responsive;
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          final selectedPgId = provider.selectedPgId;

          // Get selected PG name to calculate width dynamically
          final selectedPgName =
              selectedPgId != null && pgNameMap.containsKey(selectedPgId)
                  ? pgNameMap[selectedPgId]!
                  : 'Select PG';

          return LayoutBuilder(
            builder: (context, constraints) {
              final theme = Theme.of(context);

              // Calculate text width based on selected PG name
              final textPainter = TextPainter(
                text: TextSpan(
                  text: selectedPgName,
                  style: TextStyle(
                    fontSize: responsive.isMobile ? 13 : 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                  ),
                ),
                textDirection: TextDirection.ltr,
              );
              textPainter.layout();
              final textWidth = textPainter.size.width;

              // Dynamic width calculation: text width + all UI elements
              final iconSpace =
                  36.0; // Apartment icon (16) + spacing (8) + extra (12)
              final paddingSpace = 48.0; // Horizontal padding on both sides
              final dropdownIconSpace = 36.0; // Dropdown arrow icon + padding
              final calculatedWidth =
                  textWidth + iconSpace + paddingSpace + dropdownIconSpace;

              // Screen width constraints to prevent overflow
              final screenWidth = MediaQuery.of(context).size.width;
              final availableWidth =
                  screenWidth - 256; // Reserve space for leading + actions

              // Use calculated width, but constrain to available screen space to prevent overflow
              final minimumWidth = responsive.isMobile ? 140.0 : 160.0;
              final maximumWidth =
                  availableWidth > minimumWidth ? availableWidth : minimumWidth;

              final effectiveWidth = calculatedWidth.clamp(
                minimumWidth,
                maximumWidth,
              );

              return Container(
                width: effectiveWidth,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkInputFill : Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                  border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    onTap: null, // Handled by DropdownButton
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPgId,
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingM,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.apartment,
                                size: 18,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: AppSpacing.paddingS),
                              Flexible(
                                child: BodyText(
                                  text: 'Select PG',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        items: items,
                        isExpanded: true, // Allow expansion to show full text
                        onChanged: (value) {
                          if (value != null) {
                            provider.setSelectedPg(value);
                          }
                        },
                        underline: const SizedBox.shrink(),
                        icon: Padding(
                          padding: const EdgeInsets.only(
                            right: AppSpacing.paddingS,
                          ),
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: theme.primaryColor,
                          ),
                        ),
                        iconSize: 24,
                        dropdownColor:
                            isDark ? AppColors.darkCard : Colors.white,
                        selectedItemBuilder: (context) {
                          // Custom builder for selected item with icon - show full name
                          return items.map((item) {
                            final pgName =
                                pgNameMap[item.value] ?? 'Unnamed PG';
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.paddingM,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.apartment,
                                    size: 16,
                                    color: theme.primaryColor,
                                  ),
                                  const SizedBox(width: AppSpacing.paddingS),
                                  Flexible(
                                    child: BodyText(
                                      text: pgName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      medium: true,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 13 : 15,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.paddingXS,
                          vertical: AppSpacing.paddingS,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        // Non-compact version with Row/Expanded for wider spaces
        return Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: provider.selectedPgId,
                hint: BodyText(text: 'Select Property'),
                items: items,
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) {
                    provider.setSelectedPg(value);
                  }
                },
                underline: null,
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ],
        );
      },
    );
  }
}
