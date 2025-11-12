// lib/feature/owner_dashboard/mypg/presentation/widgets/owner_pg_info_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../guest_dashboard/pgs/data/models/guest_pg_model.dart';
import '../../screens/new_pg_setup_screen.dart';

/// Displays selected PG's complete information card
/// Shows PG name, address, contact, floors/rooms/beds structure, amenities
/// Even if no guests, shows complete structure
class OwnerPgInfoCard extends StatelessWidget {
  final Map<String, dynamic>? pgDetails;

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const OwnerPgInfoCard({
    super.key,
    required this.pgDetails,
  });

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
        return loc?.pgAmenityLighting ?? _text('pgAmenityLighting', 'Lighting');
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
        return loc?.pgAmenityIntercom ?? _text('pgAmenityIntercom', 'Intercom');
      case 'Maintenance Staff':
        return loc?.pgAmenityMaintenanceStaff ??
            _text('pgAmenityMaintenanceStaff', 'Maintenance Staff');
      default:
        return amenity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (pgDetails == null) {
      return AdaptiveCard(
        child: Column(
          children: [
            Icon(Icons.home_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: AppSpacing.paddingM),
            HeadingMedium(
              text: loc?.pgInfoNoPgSelected ??
                  _text('pgInfoNoPgSelected', 'No PG selected'),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: loc?.pgInfoSelectPgPrompt ??
                  _text('pgInfoSelectPgPrompt',
                      'Please select a PG from the dropdown above'),
            ),
          ],
        ),
      );
    }

    // Parse PG data
    final pgModel = GuestPgModel.fromMap(pgDetails!);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textPrimary =
        theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final numberFormatter = NumberFormat.decimalPattern(loc?.localeName);
    final city = pgModel.city.trim();
    final state = pgModel.state.trim();
    final locationText = city.isNotEmpty && state.isNotEmpty
        ? loc?.pgSummaryLocationValue(city, state) ??
            _text('pgSummaryLocationValue', '{city}, {state}',
                parameters: {'city': city, 'state': state})
        : city.isNotEmpty
            ? city
            : state.isNotEmpty
                ? state
                : loc?.pgInfoLocationFallback ??
                    _text('pgInfoLocationFallback', 'Location not available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PG Header Card with Gradient
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor.withValues(alpha: 0.1),
                theme.colorScheme.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
            border: Border.all(
              color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : theme.primaryColor.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PG Name with icon and edit button
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingS),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.home_rounded,
                      color: AppColors.textOnPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingMedium(
                          text: pgModel.pgName,
                          color: textPrimary,
                        ),
                        const SizedBox(height: AppSpacing.paddingXS),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: AppColors.info),
                            const SizedBox(width: AppSpacing.paddingXS),
                            Expanded(
                              child: BodyText(
                                text: locationText,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Edit PG Button
                  IconButton(
                    onPressed: () => _editPG(context, pgModel.pgId),
                    icon: Icon(
                      Icons.edit_rounded,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    tooltip: loc?.pgInfoEditTooltip ??
                        _text('pgInfoEditTooltip', 'Edit PG details'),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          theme.primaryColor.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.paddingM),

              // Address and Contact
              _buildInfoRow(
                  context, Icons.location_city, pgModel.address, textSecondary),
              const SizedBox(height: AppSpacing.paddingS),
              _buildInfoRow(
                  context,
                  Icons.phone,
                  pgModel.contactNumber ??
                      (loc?.pgInfoContactNotProvided ??
                          _text('pgInfoContactNotProvided', 'Not provided')),
                  textSecondary),
              const SizedBox(height: AppSpacing.paddingS),
              _buildInfoRow(
                  context,
                  Icons.business,
                  pgModel.pgType ??
                      (loc?.pgInfoPgTypeFallback ??
                          _text('pgInfoPgTypeFallback', 'PG')),
                  textSecondary),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Structure Stats Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkCard : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
            border: Border.all(
              color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics_rounded,
                      color: AppColors.info, size: 20),
                  const SizedBox(width: AppSpacing.paddingS),
                  HeadingSmall(
                      text: loc?.pgInfoStructureOverview ??
                          _text('pgInfoStructureOverview',
                              'PG structure overview'),
                      color: textPrimary),
                ],
              ),
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                children: [
                  Expanded(
                      child: _buildStatItem(
                          context,
                          numberFormatter.format(pgModel.totalFloors),
                          loc?.pgInfoFloorsLabel ??
                              _text('pgInfoFloorsLabel', 'Floors'),
                          Icons.layers,
                          AppColors.info)),
                  Expanded(
                      child: _buildStatItem(
                          context,
                          numberFormatter.format(pgModel.totalRooms),
                          loc?.pgInfoRoomsLabel ??
                              _text('pgInfoRoomsLabel', 'Rooms'),
                          Icons.meeting_room,
                          AppColors.success)),
                  Expanded(
                      child: _buildStatItem(
                          context,
                          numberFormatter.format(pgModel.totalBeds),
                          loc?.pgInfoBedsLabel ??
                              _text('pgInfoBedsLabel', 'Beds'),
                          Icons.bed,
                          AppColors.warning)),
                  if (pgModel.totalRevenuePotential > 0)
                    Expanded(
                        child: _buildStatItem(
                            context,
                            NumberFormat.currency(
                              locale: loc?.localeName,
                              symbol: '₹',
                              decimalDigits: 0,
                            ).format(pgModel.totalRevenuePotential),
                            loc?.pgInfoPotentialLabel ??
                                _text('pgInfoPotentialLabel', 'Potential'),
                            Icons.currency_rupee,
                            theme.primaryColor)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Floor Structure Details
        if (pgModel.hasFlexibleStructure) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
              border: Border.all(
                color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.apartment_rounded,
                        color: AppColors.success, size: 20),
                    const SizedBox(width: AppSpacing.paddingS),
                    HeadingSmall(
                        text: loc?.pgInfoFloorRoomDetails ??
                            _text('pgInfoFloorRoomDetails',
                                'Floor & room details'),
                        color: textPrimary),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingM),
                ...pgModel.floorStructure.map((floor) => _buildFloorInfo(
                    context,
                    floor,
                    isDarkMode,
                    textPrimary,
                    textSecondary,
                    loc)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),
        ],

        // Amenities
        if (pgModel.hasAmenities) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
              border: Border.all(
                color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: AppColors.warning, size: 20),
                    const SizedBox(width: AppSpacing.paddingS),
                    HeadingSmall(
                        text: loc?.pgAmenitiesTitle ??
                            _text('pgAmenitiesTitle', 'Amenities & Facilities'),
                        color: textPrimary),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingM),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pgModel.amenities.map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              size: 14, color: AppColors.info),
                          const SizedBox(width: AppSpacing.paddingXS),
                          CaptionText(
                              text: _amenityLabel(loc, amenity),
                              color: AppColors.info),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String text, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textColor),
        const SizedBox(width: AppSpacing.paddingS),
        Expanded(
          child: BodyText(text: text, color: textColor),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label,
      IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.paddingS),
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDarkMode ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          CaptionText(text: label, color: color.withValues(alpha: 0.8)),
        ],
      ),
    );
  }

  Widget _buildFloorInfo(
    BuildContext context,
    dynamic floor,
    bool isDarkMode,
    Color textPrimary,
    Color textSecondary,
    AppLocalizations? loc,
  ) {
    final floorName = floor.floorName ??
        (floor.floorNumber is int
            ? loc?.pgFloorNthLabel(floor.floorNumber as int) ??
                _text('pgFloorNthLabel', 'Floor {number}',
                    parameters: {'number': floor.floorNumber})
            : _text('pgFloorLabelFallback', 'Floor'));
    final rooms = floor.rooms as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.layers, size: 14, color: AppColors.success),
                    const SizedBox(width: AppSpacing.paddingXS),
                    BodyText(
                        text: floorName,
                        color: AppColors.success,
                        medium: true),
                  ],
                ),
              ),
              const Spacer(),
              CaptionText(
                  text: loc?.pgInfoRoomsSummary(rooms.length) ??
                      _text('pgInfoRoomsSummary', '{count} rooms',
                          parameters: {'count': rooms.length}),
                  color: textSecondary),
            ],
          ),
          if (rooms.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingS),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: rooms.map<Widget>((room) {
                final roomNumber = room.roomNumber ?? '?';
                final sharingType = room.sharingType ?? '?';
                final bedsCount = room.bedsCount ?? 0;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkCard.withValues(alpha: 0.5)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.darkDivider
                          : AppColors.outline,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.meeting_room, size: 12, color: textSecondary),
                      const SizedBox(width: AppSpacing.paddingXS),
                      CaptionText(
                          text: loc?.pgInfoRoomChip(
                                  roomNumber, sharingType, bedsCount) ??
                              _text(
                                'pgInfoRoomChip',
                                '{roomNumber} ({sharingType}, {bedsCount} beds)',
                                parameters: {
                                  'roomNumber': roomNumber,
                                  'sharingType': sharingType,
                                  'bedsCount': bedsCount,
                                },
                              ),
                          color: textSecondary),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Navigate to PG edit screen
  void _editPG(BuildContext context, String pgId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewPgSetupScreen(pgId: pgId),
      ),
    );
  }
}
