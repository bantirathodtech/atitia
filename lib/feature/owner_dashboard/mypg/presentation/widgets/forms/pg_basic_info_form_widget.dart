import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/utils/data/indian_states_cities.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';

/// Basic PG Information Form Widget
class PgBasicInfoFormWidget extends AdaptiveStatelessWidget {
  final TextEditingController pgNameController;
  final TextEditingController addressController;
  final TextEditingController contactController;
  final TextEditingController descriptionController;
  final TextEditingController mapLinkController;
  final String? selectedState;
  final String? selectedCity;
  final Function(String?) onStateChanged;
  final Function(String?) onCityChanged;

  const PgBasicInfoFormWidget({
    super.key,
    required this.pgNameController,
    required this.addressController,
    required this.contactController,
    required this.descriptionController,
    required this.mapLinkController,
    required this.selectedState,
    required this.selectedCity,
    required this.onStateChanged,
    required this.onCityChanged,
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

        // PG Name
        TextInput(
          controller: pgNameController,
          label: 'PG Name',
          hint: 'e.g., Green Meadows PG',
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // Address
        TextInput(
          controller: addressController,
          label: 'Complete Address',
          hint: 'Full address with landmark',
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // Contact Number
        TextInput(
          controller: contactController,
          label: 'Contact Number',
          hint: 'e.g., +91 9876543210',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // State Selection
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
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // City Selection
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
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // Google Map Link
        TextInput(
          controller: mapLinkController,
          label: 'Google Map Link',
          hint: 'https://maps.google.com/...',
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // Description
        TextInput(
          controller: descriptionController,
          label: 'Description',
          hint: 'Brief description of your PG',
          maxLines: 4,
        ),
      ],
    );
  }
}