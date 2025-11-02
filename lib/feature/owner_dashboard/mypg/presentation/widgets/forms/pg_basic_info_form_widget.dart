import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/utils/data/indian_states_cities.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/grids/responsive_grid.dart';

/// Basic PG Information Form Widget
class PgBasicInfoFormWidget extends AdaptiveStatelessWidget {
  final TextEditingController pgNameController;
  final TextEditingController addressController;
  final TextEditingController contactController;
  final TextEditingController descriptionController;
  final TextEditingController mapLinkController;
  final TextEditingController areaController;
  final String? selectedState;
  final String? selectedCity;
  final String? selectedPgType;
  final String? selectedMealType;
  final Function(String?) onStateChanged;
  final Function(String?) onCityChanged;
  final Function(String?) onPgTypeChanged;
  final Function(String?) onMealTypeChanged;
  final TextEditingController? mealTimingsController;
  final TextEditingController? foodQualityController;
  final String? pgNameError;
  final String? addressError;
  final String? contactError;
  final String? stateError;
  final String? cityError;

  const PgBasicInfoFormWidget({
    super.key,
    required this.pgNameController,
    required this.addressController,
    required this.contactController,
    required this.descriptionController,
    required this.mapLinkController,
    required this.areaController,
    required this.selectedState,
    required this.selectedCity,
    required this.selectedPgType,
    required this.selectedMealType,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.onPgTypeChanged,
    required this.onMealTypeChanged,
    this.mealTimingsController,
    this.foodQualityController,
    this.pgNameError,
    this.addressError,
    this.contactError,
    this.stateError,
    this.cityError,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    // Get cities for selected state
    final availableCities = selectedState != null
        ? IndianStatesCities.getCitiesForState(selectedState!)
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'Basic Information'),
        const SizedBox(height: AppSpacing.paddingL),

        // Full-width Address first for clarity
        TextInput(
          controller: addressController,
          label: 'Complete Address',
          hint: 'Full address with landmark',
          maxLines: 3,
          error: addressError,
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // Responsive grid for concise fields
        ResponsiveGrid(
          targetTileWidth: 320,
          horizontalGap: AppSpacing.paddingM,
          verticalGap: AppSpacing.paddingM,
          childAspectRatio: 3.6,
          children: [
            TextInput(
              controller: pgNameController,
              label: 'PG Name',
              hint: 'e.g., Green Meadows PG',
              error: pgNameError,
            ),
            TextInput(
              controller: contactController,
              label: 'Contact Number',
              hint: 'e.g., +91 9876543210',
              keyboardType: TextInputType.phone,
              error: contactError,
            ),
            AdaptiveDropdown<String>(
              label: 'State',
              value: selectedState,
              items: IndianStatesCities.states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: onStateChanged,
              hint: 'Select State',
              error: stateError,
            ),
            AdaptiveDropdown<String>(
              label: 'City',
              value: selectedCity,
              items: availableCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: onCityChanged,
              hint: 'Select City',
              enabled: selectedState != null,
              error: cityError,
            ),
            TextInput(
              controller: areaController,
              label: 'Area',
              hint: 'e.g., Sector 5, HSR Layout',
              error: null,
            ),
            AdaptiveDropdown<String>(
              label: 'PG Type',
              value: selectedPgType,
              items: const [
                DropdownMenuItem(value: 'Boys', child: Text('Boys')),
                DropdownMenuItem(value: 'Girls', child: Text('Girls')),
                DropdownMenuItem(value: 'Co-ed', child: Text('Co-ed')),
              ],
              onChanged: onPgTypeChanged,
              hint: 'Select PG Type',
            ),
            AdaptiveDropdown<String>(
              label: 'Meal Type',
              value: selectedMealType,
              items: const [
                DropdownMenuItem(value: 'Veg', child: Text('Veg')),
                DropdownMenuItem(value: 'Non-Veg', child: Text('Non-Veg')),
                DropdownMenuItem(value: 'Both', child: Text('Both')),
              ],
              onChanged: onMealTypeChanged,
              hint: 'Select Meal Type',
            ),
          ],
        ),
        
        // Food & Meal Details Section
        if (mealTimingsController != null || foodQualityController != null) ...[
          const SizedBox(height: AppSpacing.paddingL),
          HeadingMedium(text: 'Food & Meal Details'),
          const SizedBox(height: AppSpacing.paddingM),
          if (mealTimingsController != null)
            TextInput(
              controller: mealTimingsController!,
              label: 'Meal Timings',
              hint: 'e.g., Breakfast: 8:00 AM - 10:00 AM, Lunch: 1:00 PM - 2:00 PM, Dinner: 8:00 PM - 9:30 PM',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),
          if (mealTimingsController != null && foodQualityController != null)
            const SizedBox(height: AppSpacing.paddingM),
          if (foodQualityController != null)
            TextInput(
              controller: foodQualityController!,
              label: 'Food Quality Description',
              hint: 'Describe the food quality, cuisine type, specialities, etc.',
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
        ],

        const SizedBox(height: AppSpacing.paddingM),

        // Full-width Description at the end
        TextInput(
          controller: descriptionController,
          label: 'Description',
          hint: 'Brief description of your PG',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 6,
        ),
      ],
    );
  }
}
