// lib/features/guest_dashboard/foods/view/widgets/guest_food_card.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../../common/utils/extensions/context_extensions.dart';
import '../../data/models/guest_food_model.dart';

/// Card widget representing a single food menu item
/// Displays food image, name, description, price, and category
/// Provides tap interaction for food selection
class GuestFoodCard extends StatelessWidget {
  final GuestFoodModel food;
  final VoidCallback? onTap;

  const GuestFoodCard({
    required this.food,
    this.onTap,
    super.key,
  });

  /// Determines background color based on food category
  /// Helps users quickly identify food types
  Color _categoryColor(BuildContext context) {
    switch (food.category.toLowerCase()) {
      case 'veg':
        return AppColors.success.withValues(alpha: 0.1);
      case 'non-veg':
        return context.decorativeRed.withValues(alpha: 0.1);
      case 'beverage':
        return AppColors.info.withValues(alpha: 0.1);
      default:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  /// Returns category indicator icon for visual food type identification
  IconData get _categoryIcon {
    switch (food.category.toLowerCase()) {
      case 'veg':
        return Icons.eco;
      case 'non-veg':
        return Icons.fitness_center;
      case 'beverage':
        return Icons.local_drink;
      default:
        return Icons.restaurant;
    }
  }

  /// Returns category text color for better contrast and readability
  Color _categoryTextColor(BuildContext context) {
    switch (food.category.toLowerCase()) {
      case 'veg':
        return AppColors.success;
      case 'non-veg':
        return context.decorativeRed;
      case 'beverage':
        return AppColors.info;
      default:
        return Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Image
              _buildFoodImage(context),
              const SizedBox(width: AppSpacing.paddingS),
              // Food Details
              Expanded(
                child: _buildFoodDetails(context),
              ),
              // Price and Category
              _buildPriceAndCategory(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds food image widget with fallback icon
  Widget _buildFoodImage(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: food.photos.isNotEmpty
          ? AdaptiveImage(
              imageUrl: food.photos.first,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              borderRadius: 8,
              errorWidget: _buildImagePlaceholder(context),
            )
          : _buildImagePlaceholder(context),
    );
  }

  /// Builds placeholder when no image is available
  Widget _buildImagePlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.fastfood,
        size: 40,
        color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.5) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  /// Builds food details section with name and description
  Widget _buildFoodDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Food Name
        Text(
          food.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.paddingXS),
        // Food Description
        Text(
          food.description,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7) ??
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        // Availability Badge
        if (food.isAvailable)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border:
                  Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Available',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: context.decorativeRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: context.decorativeRed.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Out of Stock',
              style: TextStyle(
                fontSize: 12,
                color: context.decorativeRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  /// Builds price and category section
  Widget _buildPriceAndCategory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Price
        Text(
          '₹${food.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.paddingS),
        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _categoryColor(context),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _categoryIcon,
                size: 14,
                color: _categoryTextColor(context),
              ),
              const SizedBox(width: AppSpacing.paddingXS),
              Text(
                food.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _categoryTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
