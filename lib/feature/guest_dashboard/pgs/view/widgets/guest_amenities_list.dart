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
    if (amenities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade600),
            const SizedBox(width: AppSpacing.paddingS),
            BodyText(
              text: 'No amenities listed for this PG',
              color: Colors.grey.shade600,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
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
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: BodyText(
                    text: amenity,
                    color: Theme.of(context).primaryColor,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
