// lib/feature/owner_dashboard/mypg/presentation/widgets/pg_basic_info_form_widget.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/utils/data/indian_states_cities.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';

/// Basic PG Information Form Widget
class PgBasicInfoFormWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get cities for selected state
    final availableCities = selectedState != null
        ? IndianStatesCities.getCitiesForState(selectedState!)
        : <String>[];

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '🏠 Basic Information'),
            const SizedBox(height: AppSpacing.paddingM),

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
              hint: '+91 9876543210',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // State and City
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedState,
                    decoration: InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusM)),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    ),
                    hint: const Text('Select State'),
                    items: IndianStatesCities.states
                        .map((state) =>
                            DropdownMenuItem(value: state, child: Text(state)))
                        .toList(),
                    onChanged: (value) {
                      onStateChanged(value);
                      onCityChanged(null); // Reset city when state changes
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'State is required'
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCity,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusM)),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    ),
                    hint: const Text('Select City'),
                    items: availableCities
                        .map((city) =>
                            DropdownMenuItem(value: city, child: Text(city)))
                        .toList(),
                    onChanged: onCityChanged,
                    validator: (value) => value == null || value.isEmpty
                        ? 'City is required'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // Google Map Link
            TextInput(
              controller: mapLinkController,
              label: 'Google Map Link (Optional)',
              hint: 'Paste Google Maps URL',
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // Description
            TextInput(
              controller: descriptionController,
              label: 'Description',
              hint: 'Brief description about your PG',
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
