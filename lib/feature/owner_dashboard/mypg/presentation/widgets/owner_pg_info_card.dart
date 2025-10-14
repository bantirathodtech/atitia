// lib/feature/owner_dashboard/mypg/presentation/widgets/owner_pg_info_card.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../guest_dashboard/pgs/data/models/guest_pg_model.dart';
import '../screens/owner_pg_edit_screen.dart';

/// Displays selected PG's complete information card
/// Shows PG name, address, contact, floors/rooms/beds structure, amenities
/// Even if no guests, shows complete structure
class OwnerPgInfoCard extends StatelessWidget {
  final Map<String, dynamic>? pgDetails;

  const OwnerPgInfoCard({
    super.key,
    required this.pgDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (pgDetails == null) {
      return AdaptiveCard(
        child: Column(
          children: [
            Icon(Icons.home_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: AppSpacing.paddingM),
            const HeadingMedium(text: 'No PG Selected'),
            const SizedBox(height: AppSpacing.paddingS),
            const BodyText(text: 'Please select a PG from the dropdown above'),
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
                theme.primaryColor.withOpacity(0.1),
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
                    ? Colors.black.withOpacity(0.2)
                    : theme.primaryColor.withOpacity(0.05),
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: AppColors.info),
                            const SizedBox(width: 4),
                            Expanded(
                              child: BodyText(
                                text: '${pgModel.city}, ${pgModel.state}',
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
                    tooltip: 'Edit PG Details',
                    style: IconButton.styleFrom(
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
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
              const SizedBox(height: 8),
              _buildInfoRow(context, Icons.phone,
                  pgModel.contactNumber ?? 'Not provided', textSecondary),
              const SizedBox(height: 8),
              _buildInfoRow(context, Icons.business, pgModel.pgType ?? 'PG',
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
                  const SizedBox(width: 8),
                  HeadingSmall(
                      text: 'PG Structure Overview', color: textPrimary),
                ],
              ),
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                children: [
                  Expanded(
                      child: _buildStatItem(context, '${pgModel.totalFloors}',
                          'Floors', Icons.layers, AppColors.info)),
                  Expanded(
                      child: _buildStatItem(context, '${pgModel.totalRooms}',
                          'Rooms', Icons.meeting_room, AppColors.success)),
                  Expanded(
                      child: _buildStatItem(context, '${pgModel.totalBeds}',
                          'Beds', Icons.bed, AppColors.warning)),
                  if (pgModel.totalRevenuePotential > 0)
                    Expanded(
                        child: _buildStatItem(
                            context,
                            '₹${pgModel.totalRevenuePotential}',
                            'Potential',
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
                    const SizedBox(width: 8),
                    HeadingSmall(
                        text: 'Floor & Room Details', color: textPrimary),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingM),
                ...pgModel.floorStructure.map((floor) => _buildFloorInfo(
                    context, floor, isDarkMode, textPrimary, textSecondary)),
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
                    const SizedBox(width: 8),
                    HeadingSmall(text: 'Amenities', color: textPrimary),
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
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppColors.info.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              size: 14, color: AppColors.info),
                          const SizedBox(width: 4),
                          CaptionText(text: amenity, color: AppColors.info),
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
        const SizedBox(width: 8),
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
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(isDarkMode ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          CaptionText(text: label, color: color.withOpacity(0.8)),
        ],
      ),
    );
  }

  Widget _buildFloorInfo(BuildContext context, dynamic floor, bool isDarkMode,
      Color textPrimary, Color textSecondary) {
    final floorName = floor.floorName ?? 'Floor ${floor.floorNumber}';
    final rooms = floor.rooms as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.layers, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    BodyText(
                        text: floorName,
                        color: AppColors.success,
                        medium: true),
                  ],
                ),
              ),
              const Spacer(),
              CaptionText(text: '${rooms.length} rooms', color: textSecondary),
            ],
          ),
          if (rooms.isNotEmpty) ...[
            const SizedBox(height: 8),
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
                        ? AppColors.darkCard.withOpacity(0.5)
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
                      const SizedBox(width: 4),
                      CaptionText(
                          text: '$roomNumber ($sharingType, $bedsCount beds)',
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
        builder: (_) => OwnerPgEditScreen(pgId: pgId),
      ),
    );
  }
}
