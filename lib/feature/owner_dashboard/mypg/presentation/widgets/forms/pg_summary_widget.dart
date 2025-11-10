import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/owner_pg_management_model.dart';

/// PG Summary Widget
class PgSummaryWidget extends AdaptiveStatelessWidget {
  final String pgName;
  final String address;
  final String city;
  final String state;
  final List<OwnerFloor> floors;
  final List<OwnerRoom> rooms;
  final List<OwnerBed> beds;
  final Map<String, TextEditingController> rentControllers;
  final double depositAmount;
  final String maintenanceType;
  final double maintenanceAmount;
  final List<String> selectedAmenities;
  final List<String> uploadedPhotos;

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

  const PgSummaryWidget({
    super.key,
    required this.pgName,
    required this.address,
    required this.city,
    required this.state,
    required this.floors,
    required this.rooms,
    required this.beds,
    required this.rentControllers,
    required this.depositAmount,
    required this.maintenanceType,
    required this.maintenanceAmount,
    required this.selectedAmenities,
    required this.uploadedPhotos,
  });

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
    final localeName = loc?.localeName ?? 'en';
    final currencyFormatter = NumberFormat.currency(
      locale: localeName,
      symbol: '₹',
      decimalDigits: 0,
    );
    final totalRent = _calculateTotalRent();
    final totalRentText = currencyFormatter.format(totalRent);
    final depositText = currencyFormatter.format(depositAmount);
    final maintenanceAmountText = currencyFormatter.format(maintenanceAmount);
    final notSpecified =
        loc?.pgSummaryNotSpecified ?? _text('pgSummaryNotSpecified', 'Not specified');
    final maintenanceTypeLabel = _maintenanceTypeLabel(loc, maintenanceType);
    final summaryTitle = loc?.pgSummaryTitle ?? _text('pgSummaryTitle', 'PG Summary');
    final basicInfoTitle = loc?.pgSummaryBasicInfoTitle ??
        _text('pgSummaryBasicInfoTitle', 'Basic Information');
    final floorStructureTitle = loc?.pgFloorStructureTitle ??
        _text('pgFloorStructureTitle', 'Floor Structure');
    final rentInfoTitle =
        loc?.pgSummaryRentInfoTitle ?? _text('pgSummaryRentInfoTitle', 'Rent Information');
    final amenitiesTitle =
        loc?.pgAmenitiesTitle ?? _text('pgAmenitiesTitle', 'Amenities & Facilities');
    final photosTitle =
        loc?.pgSummaryPhotosTitle ?? _text('pgSummaryPhotosTitle', 'Photos');
    final readyAction = pgName.isEmpty
        ? loc?.pgSummaryActionCreate ?? _text('pgSummaryActionCreate', 'create')
        : loc?.pgSummaryActionUpdate ?? _text('pgSummaryActionUpdate', 'update');
    final readyMessage = loc?.pgSummaryReadyMessage(readyAction) ??
        _text('pgSummaryReadyMessage', 'Ready to {action} your PG!',
            parameters: {'action': readyAction});
    final reviewMessage = loc?.pgSummaryReviewMessage ??
        _text('pgSummaryReviewMessage',
            'Review all details above and click the save button to proceed.');

    final pgNameLabel =
        loc?.pgBasicInfoPgNameLabel ?? _text('pgBasicInfoPgNameLabel', 'PG Name');
    final addressLabel = loc?.pgBasicInfoAddressLabel ??
        _text('pgBasicInfoAddressLabel', 'Address');
    final locationLabel = loc?.pgSummaryLocationLabel ??
        _text('pgSummaryLocationLabel', 'Location');

    final totalFloorsLabel = loc?.pgSummaryTotalFloorsLabel ??
        _text('pgSummaryTotalFloorsLabel', 'Total Floors');
    final totalRoomsLabel = loc?.pgSummaryTotalRoomsLabel ??
        _text('pgSummaryTotalRoomsLabel', 'Total Rooms');
    final totalBedsLabel = loc?.pgSummaryTotalBedsLabel ??
        _text('pgSummaryTotalBedsLabel', 'Total Beds');

    final estimatedRevenueLabel = loc?.pgSummaryEstimatedRevenueLabel ??
        _text('pgSummaryEstimatedRevenueLabel', 'Estimated Monthly Revenue');
    final securityDepositLabel = loc?.pgRentConfigDepositLabel ??
        _text('pgRentConfigDepositLabel', 'Security Deposit');
    final maintenanceLabel = loc?.pgSummaryMaintenanceLabel ??
        _text('pgSummaryMaintenanceLabel', 'Maintenance');

    final selectedAmenitiesLabel = loc?.pgSummarySelectedAmenitiesLabel ??
        _text('pgSummarySelectedAmenitiesLabel', 'Selected Amenities');
    final listLabel =
        loc?.pgSummaryListLabel ?? _text('pgSummaryListLabel', 'List');
    final uploadedPhotosLabel = loc?.pgSummaryUploadedPhotosLabel ??
        _text('pgSummaryUploadedPhotosLabel', 'Uploaded Photos');

    final pgNameValue = pgName.isNotEmpty ? pgName : notSpecified;
    final addressValue = address.isNotEmpty ? address : notSpecified;
    final locationValue = city.isEmpty && state.isEmpty
        ? notSpecified
        : city.isNotEmpty && state.isNotEmpty
            ? (loc?.pgSummaryLocationValue(city, state) ??
                _text('pgSummaryLocationValue', '{city}, {state}',
                    parameters: {'city': city, 'state': state}))
            : city.isNotEmpty
                ? city
                : state;
    final amenitiesList = selectedAmenities
        .map((amenity) => _amenityLabel(loc, amenity))
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: summaryTitle),
        const SizedBox(height: AppSpacing.paddingL),

        // Basic Information
        _buildSummaryCard(
          context,
          basicInfoTitle,
          [
            _buildSummaryRow(
                pgNameLabel, pgNameValue),
            _buildSummaryRow(addressLabel, addressValue),
            _buildSummaryRow(locationLabel, locationValue),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Floor Structure
        _buildSummaryCard(
          context,
          floorStructureTitle,
          [
            _buildSummaryRow(
                totalFloorsLabel, NumberFormat.decimalPattern(localeName).format(floors.length)),
            _buildSummaryRow(
                totalRoomsLabel, NumberFormat.decimalPattern(localeName).format(rooms.length)),
            _buildSummaryRow(
                totalBedsLabel, NumberFormat.decimalPattern(localeName).format(beds.length)),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Rent Information
        _buildSummaryCard(
          context,
          rentInfoTitle,
          [
            _buildSummaryRow(estimatedRevenueLabel, totalRentText),
            _buildSummaryRow(
              securityDepositLabel,
              depositText,
            ),
            _buildSummaryRow(
              maintenanceLabel,
              '$maintenanceTypeLabel - $maintenanceAmountText',
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Amenities
        _buildSummaryCard(
          context,
          amenitiesTitle,
          [
            _buildSummaryRow(
                selectedAmenitiesLabel,
                NumberFormat.decimalPattern(localeName).format(selectedAmenities.length)),
            if (selectedAmenities.isNotEmpty)
              _buildSummaryRow(listLabel, amenitiesList),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Photos
        _buildSummaryCard(
          context,
          photosTitle,
          [
            _buildSummaryRow(
                uploadedPhotosLabel,
                NumberFormat.decimalPattern(localeName).format(uploadedPhotos.length)),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingL),

        // Ready to Create/Update
        AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600]),
                    const SizedBox(width: AppSpacing.paddingS),
                    BodyText(
                  text: readyMessage,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text:
                  reviewMessage,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, String title, List<Widget> children) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: title),
            const SizedBox(height: AppSpacing.paddingM),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodyText(
              text: '$label:',
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: BodyText(
              text: value,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalRent() {
    double total = 0;
    for (final entry in rentControllers.entries) {
      final rent = double.tryParse(entry.value.text) ?? 0;
      total += rent;
    }
    return total;
  }

  String _maintenanceTypeLabel(AppLocalizations? loc, String type) {
    switch (type) {
      case 'one_time':
        return loc?.pgRentConfigMaintenanceOneTime ??
            _text('pgRentConfigMaintenanceOneTime', 'One-time');
      case 'monthly':
        return loc?.pgRentConfigMaintenanceMonthly ??
            _text('pgRentConfigMaintenanceMonthly', 'Monthly');
      case 'quarterly':
        return loc?.pgRentConfigMaintenanceQuarterly ??
            _text('pgRentConfigMaintenanceQuarterly', 'Quarterly');
      case 'yearly':
        return loc?.pgRentConfigMaintenanceYearly ??
            _text('pgRentConfigMaintenanceYearly', 'Yearly');
      default:
        return type;
    }
  }
}
