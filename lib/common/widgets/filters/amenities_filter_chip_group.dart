// lib/common/widgets/filters/amenities_filter_chip_group.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../chips/filter_chip.dart';
import '../text/heading_small.dart';
import '../../styles/colors.dart';

/// 🎨 **AMENITIES FILTER CHIP GROUP - REUSABLE COMPONENT**
///
/// Theme-aware, responsive amenities filter with multiple selection
class AmenitiesFilterChipGroup extends StatelessWidget {
  final List<String> availableAmenities;
  final List<String> selectedAmenities;
  final ValueChanged<List<String>> onSelectionChanged;
  final String title;

  const AmenitiesFilterChipGroup({
    super.key,
    required this.availableAmenities,
    required this.selectedAmenities,
    required this.onSelectionChanged,
    this.title = 'Amenities',
  });

  void _toggleAmenity(String amenity) {
    final updated = List<String>.from(selectedAmenities);
    if (updated.contains(amenity)) {
      updated.remove(amenity);
    } else {
      updated.add(amenity);
    }
    onSelectionChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (availableAmenities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingSmall(
          text: title,
          color: isDark ? AppColors.lightText : AppColors.textPrimary,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        Wrap(
          spacing: AppSpacing.paddingS,
          runSpacing: AppSpacing.paddingS,
          children: availableAmenities.map((amenity) {
            final isSelected = selectedAmenities.contains(amenity);
            return CustomFilterChip(
              label: amenity,
              selected: isSelected,
              onSelected: (_) => _toggleAmenity(amenity),
            );
          }).toList(),
        ),
      ],
    );
  }
}

