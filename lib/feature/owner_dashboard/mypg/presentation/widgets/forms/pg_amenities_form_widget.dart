// lib/feature/owner_dashboard/mypg/presentation/widgets/pg_amenities_form_widget.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';

/// Amenities Selection Form Widget
class PgAmenitiesFormWidget extends StatelessWidget {
  final List<String> selectedAmenities;
  final Function(List<String>) onAmenitiesChanged;

  const PgAmenitiesFormWidget({
    super.key,
    required this.selectedAmenities,
    required this.onAmenitiesChanged,
  });

  static const List<String> _availableAmenities = [
    'WiFi',
    'Parking',
    'Security',
    'CCTV',
    'Laundry',
    'Kitchen',
    'AC',
    'Geyser',
    'TV',
    'Refrigerator',
    'Power Backup',
    'Gym',
    'Curtains',
    'Bucket',
    'Water Cooler',
    'Washing Machine',
    'Microwave',
    'Lift',
    'Housekeeping',
    'Attached Bathroom',
    'RO Water',
    '24x7 Water Supply',
    'Bed with Mattress',
    'Wardrobe',
    'Study Table',
    'Chair',
    'Fan',
    'Lighting',
    'Balcony',
    'Common Area',
    'Dining Area',
    'Induction Stove',
    'Cooking Allowed',
    'Fire Extinguisher',
    'First Aid Kit',
    'Smoke Detector',
    'Visitor Parking',
    'Intercom',
    'Maintenance Staff'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '🧰 Amenities'),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: 'Select all amenities available in your PG:',
              color: Colors.grey[600],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableAmenities.map((amenity) {
                final isSelected = selectedAmenities.contains(amenity);
                return ChoiceChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) {
                    final updatedAmenities =
                        List<String>.from(selectedAmenities);
                    if (selected) {
                      updatedAmenities.add(amenity);
                    } else {
                      updatedAmenities.remove(amenity);
                    }
                    onAmenitiesChanged(updatedAmenities);
                  },
                  selectedColor: theme.primaryColor.withOpacity(0.2),
                  checkmarkColor: theme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? theme.primaryColor
                        : theme.textTheme.bodyLarge?.color,
                  ),
                );
              }).toList(),
            ),
            if (selectedAmenities.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingM),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingM),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text: 'Selected Amenities (${selectedAmenities.length}):',
                    ),
                    const SizedBox(height: AppSpacing.paddingS),
                    BodyText(
                      text: selectedAmenities.join(', '),
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
