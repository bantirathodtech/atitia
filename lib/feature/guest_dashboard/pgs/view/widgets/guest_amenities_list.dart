import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/text/body_text.dart';

/// Widget displaying PG amenities as filter chips
/// Uses common UI components for consistent styling
class GuestAmenitiesList extends StatelessWidget {
  final List<String> amenities;

  const GuestAmenitiesList({required this.amenities, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    if (amenities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          color: isDark 
              ? colorScheme.surfaceVariant 
              : colorScheme.surface.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.paddingS),
            BodyText(
              text: 'No amenities listed for this PG',
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDark 
            ? colorScheme.surfaceVariant 
            : colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: AppSpacing.paddingS,
        runSpacing: AppSpacing.paddingS / 2,
        children: amenities
            .map((amenity) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingS / 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: BodyText(
                    text: amenity,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
