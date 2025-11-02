// lib/features/guest_dashboard/pgs/view/widgets/guest_pg_card.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/sharing_summary.dart';
import '../../data/models/guest_pg_model.dart';
import 'booking_request_dialog.dart';

/// 🏠 **UPDATED PG PREVIEW CARD**
///
/// **Features:**
/// - Visual identity with photo, photo count, and status
/// - Basic identification with name, location, and distance
/// - Quick decision factors (PG type, meal type, sharing preview)
/// - Action elements (View Details, Book Now)
///
/// **Removed:**
/// - Monthly rent
/// - Amenities icons
/// - Stats (rooms, beds, floors count)
class GuestPgCard extends StatelessWidget {
  final GuestPgModel pg;
  final VoidCallback? onTap;
  final double? userLatitude; // User's current location latitude
  final double? userLongitude; // User's current location longitude

  const GuestPgCard({
    required this.pg,
    this.onTap,
    this.userLatitude,
    this.userLongitude,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
              border: Border.all(
                color: isDarkMode ? AppColors.darkDivider : Colors.grey.shade300,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context, isDarkMode),
                _buildDetailsSection(context, isDarkMode),
                _buildActionSection(context, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📸 Image section with status indicator, badges, and PG info overlay
  Widget _buildImageSection(BuildContext context, bool isDarkMode) {
    return Stack(
      children: [
        // Main Image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.borderRadiusL),
            topRight: Radius.circular(AppSpacing.borderRadiusL),
          ),
          child: pg.hasPhotos
              ? SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: AdaptiveImage(
                    imageUrl: pg.photos.first,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: _buildImagePlaceholder(context, isDarkMode),
                  ),
                )
              : _buildImagePlaceholder(context, isDarkMode),
        ),

        // Gradient Overlay for text readability
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.borderRadiusL),
              topRight: Radius.circular(AppSpacing.borderRadiusL),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),

        // Top badges row
        Positioned(
          top: AppSpacing.paddingM,
          left: AppSpacing.paddingM,
          right: AppSpacing.paddingM,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Indicator Badge
              _buildStatusBadge(),
              // Photo count badge
              if (pg.hasPhotos)
                _buildBadge(
                  '${pg.photos.length} Photos',
                  Colors.black.withValues(alpha: 0.7),
                  Icons.photo_library,
                ),
            ],
          ),
        ),

        // Bottom overlay: PG Name and Location
        Positioned(
          bottom: AppSpacing.paddingM,
          left: AppSpacing.paddingM,
          right: AppSpacing.paddingM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(
                text: pg.pgName,
                color: AppColors.textOnPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              _buildLocationRow(context),
            ],
          ),
        ),
      ],
    );
  }

  /// 📋 Details section with quick decision factors
  Widget _buildDetailsSection(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Decision Factors Row
          _buildQuickDecisionFactors(context, isDarkMode),
          const SizedBox(height: AppSpacing.paddingM),
          // Sharing Summary Preview
          _buildSharingPreview(context, isDarkMode),
        ],
      ),
    );
  }

  /// 🏷️ Quick decision factors: PG Type, Meal Type
  Widget _buildQuickDecisionFactors(BuildContext context, bool isDarkMode) {
    return Wrap(
      spacing: AppSpacing.paddingS,
      runSpacing: AppSpacing.paddingS,
      children: [
        // PG Type Badge
        if (pg.pgType != null)
          _buildDecisionFactorBadge(
            _getPgTypeIcon(pg.pgType!),
            pg.pgType!,
            AppColors.info,
            isDarkMode,
          ),
        // Meal Type Badge
        if (pg.mealType != null)
          _buildDecisionFactorBadge(
            _getMealTypeIcon(pg.mealType!),
            pg.mealType!,
            AppColors.secondary,
            isDarkMode,
          ),
      ],
    );
  }

  /// 👥 Sharing summary preview
  Widget _buildSharingPreview(BuildContext context, bool isDarkMode) {
    final summary = getSharingSummary(pg);
    
    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get unique sharing types (1, 2, 3, 4, 5 sharing)
    final sharingTypes = summary.keys.toList()..sort((a, b) {
      final aNum = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final bNum = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return aNum.compareTo(bNum);
    });

    return Wrap(
      spacing: AppSpacing.paddingS,
      runSpacing: AppSpacing.paddingS,
      children: sharingTypes.map((sharingType) {
        final info = summary[sharingType]!;
        return _buildSharingBadge(
          sharingType,
          info.vacantBedsCount > 0,
          isDarkMode,
        );
      }).toList(),
    );
  }

  /// 🎯 Action section with buttons
  Widget _buildActionSection(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.paddingM,
        0,
        AppSpacing.paddingM,
        AppSpacing.paddingM,
      ),
      child: Row(
        children: [
          // View Details Button (Primary)
          Expanded(
            child: SecondaryButton(
              label: 'View Details',
              icon: Icons.arrow_forward,
              onPressed: onTap,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          // Book Now Button (Optional)
          PrimaryButton(
            label: 'Book Now',
            icon: Icons.home_work,
            onPressed: () => _showBookingRequestDialog(context),
          ),
        ],
      ),
    );
  }

  /// 🏷️ Status badge (Available/Unavailable)
  Widget _buildStatusBadge() {
    final isAvailable = pg.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.success.withValues(alpha: 0.9)
            : AppColors.error.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: AppColors.textOnPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            isAvailable ? 'Available' : 'Unavailable',
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 🏷️ Badge widget for photo count
  Widget _buildBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textOnPrimary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 📍 Location row with clickable map link and distance
  Widget _buildLocationRow(BuildContext context) {
    final distanceText = _getDistanceText();

    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 14,
          color: AppColors.textOnPrimary.withValues(alpha: 0.9),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: GestureDetector(
            onTap: () => _openMap(context),
            child: BodyText(
              text: pg.fullAddress,
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (distanceText != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXS),
            ),
            child: CaptionText(
              text: distanceText,
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ],
    );
  }

  /// 🎯 Decision factor badge (PG Type, Meal Type)
  Widget _buildDecisionFactorBadge(
    IconData icon,
    String label,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? color.withValues(alpha: 0.2)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          CaptionText(
            text: label,
            color: color,
          ),
        ],
      ),
    );
  }

  /// 👥 Sharing badge
  Widget _buildSharingBadge(
    String sharingType,
    bool hasVacancy,
    bool isDarkMode,
  ) {
    final sharingNumber = sharingType.replaceAll(RegExp(r'[^0-9]'), '');
    final displayText = '$sharingNumber Sharing';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          CaptionText(
            text: displayText,
            color: AppColors.primary,
          ),
          if (hasVacancy) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.check_circle,
              size: 12,
              color: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }

  /// 🖼️ Image placeholder
  Widget _buildImagePlaceholder(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkInputFill : Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.borderRadiusL),
          topRight: Radius.circular(AppSpacing.borderRadiusL),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 8),
          CaptionText(
            text: 'No Image Available',
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  /// 📍 Get distance text from user location
  String? _getDistanceText() {
    if (userLatitude == null ||
        userLongitude == null ||
        !pg.hasLocation) {
      return null;
    }

    final distance = pg.getDistanceFrom(userLatitude, userLongitude);
    if (distance == null) return null;

    if (distance < 1) {
      return '${(distance * 1000).toStringAsFixed(0)}m away';
    } else {
      return '${distance.toStringAsFixed(1)}km away';
    }
  }

  /// 🗺️ Open map with PG location
  Future<void> _openMap(BuildContext context) async {
    if (!pg.hasLocation) {
      // Fallback to Google Maps search if coordinates not available
      final query = Uri.encodeComponent(pg.fullAddress);
      final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
      
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // Use coordinates if available
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${pg.latitude},${pg.longitude}',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open maps')),
        );
      }
    }
  }

  /// 🏠 Get icon for PG type
  IconData _getPgTypeIcon(String pgType) {
    final typeLower = pgType.toLowerCase();
    if (typeLower.contains('boys')) return Icons.male;
    if (typeLower.contains('girls')) return Icons.female;
    if (typeLower.contains('co-ed') || typeLower.contains('coed')) {
      return Icons.people;
    }
    return Icons.home;
  }

  /// 🍽️ Get icon for meal type
  IconData _getMealTypeIcon(String mealType) {
    final typeLower = mealType.toLowerCase();
    if (typeLower.contains('veg')) return Icons.eco;
    if (typeLower.contains('non') || typeLower.contains('non-veg')) {
      return Icons.restaurant;
    }
    return Icons.restaurant_menu;
  }

  /// Shows the booking request dialog
  void _showBookingRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BookingRequestDialog(pg: pg),
    );
  }
}
