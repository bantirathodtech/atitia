// lib/features/owner_dashboard/foods/view/widgets/owner_menu_item_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/styles/spacing.dart';

/// OwnerMenuItemWidget lists meal items under a meal title like Breakfast.
/// Enhanced with common widgets for consistent styling
class OwnerMenuItemWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData? icon;

  const OwnerMenuItemWidget({
    required this.title,
    required this.items,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: AppSpacing.paddingS),
              ],
              HeadingSmall(
                text: title,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: BodyText(
                  text: '${items.length} items',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          if (items.isEmpty)
            BodyText(
              text: 'No items listed for $title',
              color: Colors.grey.shade600,
            )
          else
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.paddingXS / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: BodyText(text: item),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  /// Gets icon based on meal type
  IconData _getIconForMealType(String title) {
    switch (title.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }
}
