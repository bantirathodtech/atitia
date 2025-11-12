// lib/features/guest_dashboard/foods/view/widgets/guest_food_card.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/spacing.dart';
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
  Color get _categoryColor {
    switch (food.category.toLowerCase()) {
      case 'veg':
        return Colors.green.shade50;
      case 'non-veg':
        return Colors.red.shade50;
      case 'beverage':
        return Colors.blue.shade50;
      default:
        return Colors.grey.shade50;
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
  Color get _categoryTextColor {
    switch (food.category.toLowerCase()) {
      case 'veg':
        return Colors.green.shade800;
      case 'non-veg':
        return Colors.red.shade800;
      case 'beverage':
        return Colors.blue.shade800;
      default:
        return Colors.grey.shade800;
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
        color: Colors.grey.shade200,
      ),
      child: food.photos.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food.photos.first,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            )
          : _buildImagePlaceholder(),
    );
  }

  /// Builds placeholder when no image is available
  Widget _buildImagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.fastfood,
        size: 40,
        color: Colors.grey,
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
            color: Colors.grey.shade600,
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
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Text(
              'Available',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              'Out of Stock',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade800,
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: AppSpacing.paddingS),
        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _categoryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _categoryIcon,
                size: 14,
                color: _categoryTextColor,
              ),
              const SizedBox(width: AppSpacing.paddingXS),
              Text(
                food.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _categoryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
