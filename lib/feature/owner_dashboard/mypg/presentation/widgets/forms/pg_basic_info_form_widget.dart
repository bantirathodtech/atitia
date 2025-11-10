import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/utils/data/indian_states_cities.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/widgets/grids/responsive_grid.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: loc.pgBasicInfoTitle),
        const SizedBox(height: AppSpacing.paddingL),

        // Full-width Address first for clarity
        TextInput(
          controller: addressController,
          label: loc.pgBasicInfoAddressLabel,
          hint: loc.pgBasicInfoAddressHint,
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
              label: loc.pgBasicInfoPgNameLabel,
              hint: loc.pgBasicInfoPgNameHint,
              error: pgNameError,
            ),
            TextInput(
              controller: contactController,
              label: loc.pgBasicInfoContactLabel,
              hint: loc.pgBasicInfoContactHint,
              keyboardType: TextInputType.phone,
              error: contactError,
            ),
            AdaptiveDropdown<String>(
              label: loc.pgBasicInfoStateLabel,
              value: selectedState,
              items: IndianStatesCities.states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: onStateChanged,
              hint: loc.pgBasicInfoStateHint,
              error: stateError,
            ),
            AdaptiveDropdown<String>(
              label: loc.pgBasicInfoCityLabel,
              value: selectedCity,
              items: availableCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: onCityChanged,
              hint: loc.pgBasicInfoCityHint,
              enabled: selectedState != null,
              error: cityError,
            ),
            TextInput(
              controller: areaController,
              label: loc.pgBasicInfoAreaLabel,
              hint: loc.pgBasicInfoAreaHint,
              error: null,
            ),
            AdaptiveDropdown<String>(
              label: loc.pgBasicInfoPgTypeLabel,
              value: selectedPgType,
              items: [
                DropdownMenuItem(
                  value: 'Boys',
                  child: Text(loc.pgBasicInfoPgTypeBoys),
                ),
                DropdownMenuItem(
                  value: 'Girls',
                  child: Text(loc.pgBasicInfoPgTypeGirls),
                ),
                DropdownMenuItem(
                  value: 'Co-ed',
                  child: Text(loc.pgBasicInfoPgTypeCoed),
                ),
              ],
              onChanged: onPgTypeChanged,
              hint: loc.pgBasicInfoPgTypeHint,
            ),
            AdaptiveDropdown<String>(
              label: loc.pgBasicInfoMealTypeLabel,
              value: selectedMealType,
              items: [
                DropdownMenuItem(
                  value: 'Veg',
                  child: Text(loc.pgBasicInfoMealTypeVeg),
                ),
                DropdownMenuItem(
                  value: 'Non-Veg',
                  child: Text(loc.pgBasicInfoMealTypeNonVeg),
                ),
                DropdownMenuItem(
                  value: 'Both',
                  child: Text(loc.pgBasicInfoMealTypeBoth),
                ),
              ],
              onChanged: onMealTypeChanged,
              hint: loc.pgBasicInfoMealTypeHint,
            ),
          ],
        ),
        
        // Food & Meal Details Section
        if (mealTimingsController != null || foodQualityController != null) ...[
          const SizedBox(height: AppSpacing.paddingL),
          HeadingMedium(text: loc.pgBasicInfoFoodSectionTitle),
          const SizedBox(height: AppSpacing.paddingM),
          if (mealTimingsController != null)
            TextInput(
              controller: mealTimingsController!,
              label: loc.pgBasicInfoMealTimingsLabel,
              hint: loc.pgBasicInfoMealTimingsHint,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),
          if (mealTimingsController != null && foodQualityController != null)
            const SizedBox(height: AppSpacing.paddingM),
          if (foodQualityController != null)
            TextInput(
              controller: foodQualityController!,
              label: loc.pgBasicInfoFoodQualityLabel,
              hint: loc.pgBasicInfoFoodQualityHint,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
        ],

        const SizedBox(height: AppSpacing.paddingM),

        // Full-width Description at the end
        TextInput(
          controller: descriptionController,
          label: loc.pgBasicInfoDescriptionLabel,
          hint: loc.pgBasicInfoDescriptionHint,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 6,
        ),
      ],
    );
  }
}
