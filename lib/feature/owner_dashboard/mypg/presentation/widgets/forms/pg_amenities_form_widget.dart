import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';

/// Amenities Selection Form Widget
class PgAmenitiesFormWidget extends AdaptiveStatelessWidget {
  final List<String> selectedAmenities;
  final Function(List<String>) onAmenitiesChanged;

  const PgAmenitiesFormWidget({
    super.key,
    required this.selectedAmenities,
    required this.onAmenitiesChanged,
  });

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

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

  String _amenityLabel(AppLocalizations? loc, String amenity) {
    switch (amenity) {
      case 'WiFi':
        return loc?.pgAmenityWifi ?? _text('pgAmenityWifi', 'Wi-Fi');
      case 'Parking':
        return loc?.pgAmenityParking ?? _text('pgAmenityParking', 'Parking');
      case 'Security':
        return loc?.pgAmenitySecurity ?? _text('pgAmenitySecurity', 'Security');
      case 'CCTV':
        return loc?.pgAmenityCctv ?? _text('pgAmenityCctv', 'CCTV');
      case 'Laundry':
        return loc?.pgAmenityLaundry ?? _text('pgAmenityLaundry', 'Laundry');
      case 'Kitchen':
        return loc?.pgAmenityKitchen ?? _text('pgAmenityKitchen', 'Kitchen');
      case 'AC':
        return loc?.pgAmenityAc ?? _text('pgAmenityAc', 'AC');
      case 'Geyser':
        return loc?.pgAmenityGeyser ?? _text('pgAmenityGeyser', 'Geyser');
      case 'TV':
        return loc?.pgAmenityTv ?? _text('pgAmenityTv', 'TV');
      case 'Refrigerator':
        return loc?.pgAmenityRefrigerator ??
            _text('pgAmenityRefrigerator', 'Refrigerator');
      case 'Power Backup':
        return loc?.pgAmenityPowerBackup ??
            _text('pgAmenityPowerBackup', 'Power Backup');
      case 'Gym':
        return loc?.pgAmenityGym ?? _text('pgAmenityGym', 'Gym');
      case 'Curtains':
        return loc?.pgAmenityCurtains ?? _text('pgAmenityCurtains', 'Curtains');
      case 'Bucket':
        return loc?.pgAmenityBucket ?? _text('pgAmenityBucket', 'Bucket');
      case 'Water Cooler':
        return loc?.pgAmenityWaterCooler ??
            _text('pgAmenityWaterCooler', 'Water Cooler');
      case 'Washing Machine':
        return loc?.pgAmenityWashingMachine ??
            _text('pgAmenityWashingMachine', 'Washing Machine');
      case 'Microwave':
        return loc?.pgAmenityMicrowave ??
            _text('pgAmenityMicrowave', 'Microwave');
      case 'Lift':
        return loc?.pgAmenityLift ?? _text('pgAmenityLift', 'Lift');
      case 'Housekeeping':
        return loc?.pgAmenityHousekeeping ??
            _text('pgAmenityHousekeeping', 'Housekeeping');
      case 'Attached Bathroom':
        return loc?.pgAmenityAttachedBathroom ??
            _text('pgAmenityAttachedBathroom', 'Attached Bathroom');
      case 'RO Water':
        return loc?.pgAmenityRoWater ?? _text('pgAmenityRoWater', 'RO Water');
      case '24x7 Water Supply':
        return loc?.pgAmenityWaterSupply ??
            _text('pgAmenityWaterSupply', '24x7 Water Supply');
      case 'Bed with Mattress':
        return loc?.pgAmenityBedWithMattress ??
            _text('pgAmenityBedWithMattress', 'Bed with Mattress');
      case 'Wardrobe':
        return loc?.pgAmenityWardrobe ?? _text('pgAmenityWardrobe', 'Wardrobe');
      case 'Study Table':
        return loc?.pgAmenityStudyTable ??
            _text('pgAmenityStudyTable', 'Study Table');
      case 'Chair':
        return loc?.pgAmenityChair ?? _text('pgAmenityChair', 'Chair');
      case 'Fan':
        return loc?.pgAmenityFan ?? _text('pgAmenityFan', 'Fan');
      case 'Lighting':
        return loc?.pgAmenityLighting ??
            _text('pgAmenityLighting', 'Lighting');
      case 'Balcony':
        return loc?.pgAmenityBalcony ?? _text('pgAmenityBalcony', 'Balcony');
      case 'Common Area':
        return loc?.pgAmenityCommonArea ??
            _text('pgAmenityCommonArea', 'Common Area');
      case 'Dining Area':
        return loc?.pgAmenityDiningArea ??
            _text('pgAmenityDiningArea', 'Dining Area');
      case 'Induction Stove':
        return loc?.pgAmenityInductionStove ??
            _text('pgAmenityInductionStove', 'Induction Stove');
      case 'Cooking Allowed':
        return loc?.pgAmenityCookingAllowed ??
            _text('pgAmenityCookingAllowed', 'Cooking Allowed');
      case 'Fire Extinguisher':
        return loc?.pgAmenityFireExtinguisher ??
            _text('pgAmenityFireExtinguisher', 'Fire Extinguisher');
      case 'First Aid Kit':
        return loc?.pgAmenityFirstAidKit ??
            _text('pgAmenityFirstAidKit', 'First Aid Kit');
      case 'Smoke Detector':
        return loc?.pgAmenitySmokeDetector ??
            _text('pgAmenitySmokeDetector', 'Smoke Detector');
      case 'Visitor Parking':
        return loc?.pgAmenityVisitorParking ??
            _text('pgAmenityVisitorParking', 'Visitor Parking');
      case 'Intercom':
        return loc?.pgAmenityIntercom ??
            _text('pgAmenityIntercom', 'Intercom');
      case 'Maintenance Staff':
        return loc?.pgAmenityMaintenanceStaff ??
            _text('pgAmenityMaintenanceStaff', 'Maintenance Staff');
      default:
        return amenity;
    }
  }

  @override
  Widget buildAdaptive(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final title = loc?.pgAmenitiesTitle ??
        _text('pgAmenitiesTitle', 'Amenities & Facilities');
    final description = loc?.pgAmenitiesDescription ??
        _text('pgAmenitiesDescription', 'Select all amenities available in your PG:');
    final selectedLabel = loc?.pgAmenitiesSelectedLabel ??
        _text('pgAmenitiesSelectedLabel', 'Selected');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: title),
        const SizedBox(height: AppSpacing.paddingL),
        BodyText(
          text: description,
          color: Colors.grey[600],
        ),
        const SizedBox(height: AppSpacing.paddingL),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableAmenities.map((amenity) {
            final isSelected = selectedAmenities.contains(amenity);
            final amenityText = _amenityLabel(loc, amenity);

            return CustomChoiceChip(
              label: amenityText,
              selected: isSelected,
              onSelected: (selected) {
                final updatedAmenities = List<String>.from(selectedAmenities);
                if (selected) {
                  updatedAmenities.add(amenity);
                } else {
                  updatedAmenities.remove(amenity);
                }
                onAmenitiesChanged(updatedAmenities);
              },
            );
          }).toList(),
        ),
        if (selectedAmenities.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.paddingL),
          BodyText(
            text:
                '$selectedLabel: ${selectedAmenities.map((amenity) => _amenityLabel(loc, amenity)).join(', ')}',
            color: Colors.grey[700],
          ),
        ],
      ],
    );
  }
}
