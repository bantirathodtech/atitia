// lib/feature/owner_dashboard/shared/widgets/pg_selector_dropdown.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/styles/colors.dart';
import '../../../auth/logic/auth_provider.dart';
import '../viewmodel/selected_pg_provider.dart';

/// Reusable PG Selector Dropdown for Owner Dashboard
/// 
/// Shows list of owner's PGs and allows switching between them.
/// Only visible when owner has multiple PGs.
/// Persists selection across app restarts.
class PgSelectorDropdown extends StatelessWidget {
  final bool compact;

  const PgSelectorDropdown({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedPgProvider = Provider.of<SelectedPgProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Show empty state if no PGs (user needs to create one)
    if (!selectedPgProvider.hasPgs) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.home_outlined,
              size: compact ? 16 : 18,
              color: isDarkMode ? AppColors.warning : AppColors.warning,
            ),
            const SizedBox(width: 6),
            Text(
              'No PGs - Create One',
              style: TextStyle(
                color: isDarkMode ? AppColors.warning : AppColors.warning,
                fontSize: compact ? 13 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxWidth: compact ? 200 : 250),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, // Prevents overflow
          value: selectedPgProvider.selectedPgId,
          icon: Icon(
            Icons.arrow_drop_down,
            color: isDarkMode ? AppColors.textOnPrimary : theme.primaryColor,
          ),
          style: TextStyle(
            color: isDarkMode ? AppColors.textOnPrimary : theme.primaryColor,
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          items: selectedPgProvider.ownerPgs.map((pg) {
            return DropdownMenuItem<String>(
              value: pg.pgId,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pg.pgName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 11,
                            color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${pg.city}, ${pg.state}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (pgId) {
            if (pgId != null) {
              final selectedPg = selectedPgProvider.ownerPgs.firstWhere(
                (pg) => pg.pgId == pgId,
              );
              final ownerId = authProvider.user?.userId ?? '';
              selectedPgProvider.selectPg(selectedPg, ownerId);
            }
          },
          selectedItemBuilder: (context) {
            return selectedPgProvider.ownerPgs.map((pg) {
              final isSelected = pg.pgId == selectedPgProvider.selectedPgId;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.business,
                    size: compact ? 16 : 18,
                    color: isDarkMode ? AppColors.textOnPrimary : theme.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      pg.pgName,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.textOnPrimary : theme.primaryColor,
                        fontSize: compact ? 13 : 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

