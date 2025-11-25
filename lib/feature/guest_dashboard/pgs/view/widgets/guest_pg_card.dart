// lib/features/guest_dashboard/pgs/view/widgets/guest_pg_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/sharing_summary.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../data/models/guest_pg_model.dart';
import '../../viewmodel/guest_favorite_pg_viewmodel.dart';
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
  final bool isFeatured; // Whether this PG is featured
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const GuestPgCard({
    required this.pg,
    this.onTap,
    this.userLatitude,
    this.userLongitude,
    this.isFeatured = false,
    super.key,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Material(
        color: Colors
            .transparent, // Material color for InkWell - transparent is fine
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context, isDarkMode, loc),
                _buildDetailsSection(context, isDarkMode, loc),
                _buildActionSection(context, isDarkMode, loc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📸 Image section with status indicator, badges, and PG info overlay
  Widget _buildImageSection(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
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
                  height: 150,
                  child: AdaptiveImage(
                    imageUrl: pg.photos.first,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: _buildImagePlaceholder(context, isDarkMode),
                  ),
                )
              : _buildImagePlaceholder(context, isDarkMode),
        ),

        // Gradient Overlay for text readability
        Container(
          height: 150,
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
                Theme.of(context).colorScheme.shadow.withValues(alpha: 0.6),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),

        // Top badges row
        Positioned(
          top: AppSpacing.paddingS,
          left: AppSpacing.paddingS,
          right: AppSpacing.paddingS,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Indicator Badge and Featured Badge
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isFeatured) ...[
                    _buildFeaturedBadge(context, loc),
                    const SizedBox(width: AppSpacing.paddingXS),
                  ],
                  _buildStatusBadge(loc),
                ],
              ),
              // Action buttons (Favorite, Share)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFavoriteButton(context),
                  const SizedBox(width: AppSpacing.paddingXS),
                  _buildShareButton(context, loc),
                  if (pg.hasPhotos) ...[
                    const SizedBox(width: AppSpacing.paddingXS),
                    _buildBadge(
                      loc?.photosBadge(pg.photos.length) ??
                          _text(
                            'photosBadge',
                            '{count} Photo(s)',
                            parameters: {
                              'count': pg.photos.length.toString(),
                            },
                          ),
                      Theme.of(context)
                          .colorScheme
                          .shadow
                          .withValues(alpha: 0.7),
                      Icons.photo_library,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Bottom overlay: PG Name and Location
        Positioned(
          bottom: AppSpacing.paddingS,
          left: AppSpacing.paddingS,
          right: AppSpacing.paddingS,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(
                text: pg.pgName,
                color: AppColors.textOnPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.paddingS),
              _buildLocationRow(context, loc),
            ],
          ),
        ),
      ],
    );
  }

  /// 📋 Details section with quick decision factors
  Widget _buildDetailsSection(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Decision Factors Row
          _buildQuickDecisionFactors(context, isDarkMode, loc),
          const SizedBox(height: AppSpacing.paddingS),
          // Sharing Summary Preview
          _buildSharingPreview(context, isDarkMode, loc),
        ],
      ),
    );
  }

  /// 🏷️ Quick decision factors: PG Type, Meal Type
  Widget _buildQuickDecisionFactors(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    return Wrap(
      spacing: AppSpacing.paddingS,
      runSpacing: AppSpacing.paddingS,
      children: [
        // PG Type Badge
        if (pg.pgType != null)
          _buildDecisionFactorBadge(
            _getPgTypeIcon(pg.pgType!),
            loc?.pgTypeLabel(pg.pgType!) ?? pg.pgType!,
            AppColors.info,
            isDarkMode,
          ),
        // Meal Type Badge
        if (pg.mealType != null)
          _buildDecisionFactorBadge(
            _getMealTypeIcon(pg.mealType!),
            loc?.mealTypeLabel(pg.mealType!) ?? pg.mealType!,
            AppColors.secondary,
            isDarkMode,
          ),
      ],
    );
  }

  /// 👥 Sharing summary preview
  Widget _buildSharingPreview(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    final summary = getSharingSummary(pg);

    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get unique sharing types (1, 2, 3, 4, 5 sharing)
    final sharingTypes = summary.keys.toList()
      ..sort((a, b) {
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
          loc,
          info.vacantBedsCount > 0,
          isDarkMode,
        );
      }).toList(),
    );
  }

  /// 🎯 Action section with buttons
  Widget _buildActionSection(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.paddingS,
        0,
        AppSpacing.paddingS,
        AppSpacing.paddingS,
      ),
      child: Row(
        children: [
          // View Details Button (Primary)
          Expanded(
            child: SecondaryButton(
              label: loc?.viewDetails ?? _text('viewDetails', 'View Details'),
              icon: Icons.arrow_forward,
              onPressed: onTap,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          // Book Now Button (Optional)
          PrimaryButton(
            label: loc?.bookNow ?? _text('bookNow', 'Book Now'),
            icon: Icons.home_work,
            onPressed: () => _showBookingRequestDialog(context),
          ),
        ],
      ),
    );
  }

  /// ⭐ Featured badge
  Widget _buildFeaturedBadge(BuildContext context, AppLocalizations? loc) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade600,
            Colors.orange.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 14,
            color: AppColors.textOnPrimary,
          ),
          const SizedBox(width: AppSpacing.paddingXS),
          Text(
            _text('featured', 'Featured'),
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 🏷️ Status badge (Available/Unavailable)
  Widget _buildStatusBadge(AppLocalizations? loc) {
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
          const SizedBox(width: AppSpacing.paddingXS),
          Text(
            isAvailable
                ? (loc?.available ?? _text('available', 'Available'))
                : (loc?.unavailable ?? _text('unavailable', 'Unavailable')),
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
          const SizedBox(width: AppSpacing.paddingXS),
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
  Widget _buildLocationRow(BuildContext context, AppLocalizations? loc) {
    final distanceText = _getDistanceText(loc);

    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 14,
          color: AppColors.textOnPrimary.withValues(alpha: 0.9),
        ),
        const SizedBox(width: AppSpacing.paddingXS),
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
          const SizedBox(width: AppSpacing.paddingS),
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
          const SizedBox(width: AppSpacing.paddingXS),
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
    AppLocalizations? loc,
    bool hasVacancy,
    bool isDarkMode,
  ) {
    final sharingNumber = sharingType.replaceAll(RegExp(r'[^0-9]'), '');
    final number = int.tryParse(sharingNumber) ?? 0;
    final displayText = loc?.sharingLabel(number) ??
        _text(
          'sharingLabel',
          '{count} Sharing',
          parameters: {'count': number.toString()},
        );

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
          const SizedBox(width: AppSpacing.paddingXS),
          CaptionText(
            text: displayText,
            color: AppColors.primary,
          ),
          if (hasVacancy) ...[
            const SizedBox(width: AppSpacing.paddingXS),
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
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
          const SizedBox(height: AppSpacing.paddingS),
          CaptionText(
            text: AppLocalizations.of(context)?.noImageAvailable ??
                _text('noImageAvailable', 'No Image Available'),
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  /// 📍 Get distance text from user location
  String? _getDistanceText(AppLocalizations? loc) {
    if (userLatitude == null || userLongitude == null || !pg.hasLocation) {
      return null;
    }

    final distance = pg.getDistanceFrom(userLatitude, userLongitude);
    if (distance == null) return null;

    if (distance < 1) {
      final meters = (distance * 1000).round();
      return loc?.distanceMeters(meters) ??
          _text(
            'distanceMeters',
            '{meters}m away',
            parameters: {'meters': meters.toString()},
          );
    } else {
      final kilometers = double.parse(distance.toStringAsFixed(1));
      return loc?.distanceKilometers(kilometers) ??
          _text(
            'distanceKilometers',
            '{kilometers}km away',
            parameters: {'kilometers': kilometers.toString()},
          );
    }
  }

  /// 🗺️ Open map with PG location
  Future<void> _openMap(BuildContext context) async {
    if (!pg.hasLocation) {
      // Fallback to Google Maps search if coordinates not available
      final query = Uri.encodeComponent(pg.fullAddress);
      final googleMapsUrl =
          Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

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
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.couldNotOpenMaps ??
                  _text('couldNotOpenMaps', 'Could not open maps'),
            ),
          ),
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

  /// ⭐ Favorite button
  Widget _buildFavoriteButton(BuildContext context) {
    return Consumer<GuestFavoritePgViewModel>(
      builder: (context, favoriteVM, _) {
        final isFavorite = favoriteVM.isFavorite(pg.pgId);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final guestId = authProvider.user?.userId;

        if (guestId == null) return const SizedBox.shrink();

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.error : AppColors.textOnPrimary,
          ),
          onPressed: () async {
            try {
              await favoriteVM.toggleFavorite(guestId, pg.pgId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? _text('pgRemovedFromFavorites',
                              'Removed from favorites')
                          : _text('pgAddedToFavorites', 'Added to favorites'),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _text('failedToToggleFavorite',
                          'Failed to update favorite'),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          },
          tooltip: isFavorite
              ? _text('removeFromFavorites', 'Remove from favorites')
              : _text('addToFavorites', 'Add to favorites'),
        );
      },
    );
  }

  /// 📤 Share button
  Widget _buildShareButton(BuildContext context, AppLocalizations? loc) {
    return IconButton(
      icon: const Icon(Icons.share, color: AppColors.textOnPrimary),
      onPressed: () => _sharePG(context, loc),
      tooltip: _text('share', 'Share'),
    );
  }

  /// 📤 Share PG details
  Future<void> _sharePG(BuildContext context, AppLocalizations? loc) async {
    try {
      final shareText = StringBuffer();
      shareText.writeln('🏠 ${pg.pgName}');
      shareText.writeln();
      shareText.writeln('📍 ${pg.fullAddress}');
      shareText.writeln();

      // Add pricing if available
      final rentConfig = pg.rentConfig;
      if (rentConfig != null && rentConfig.isNotEmpty) {
        shareText.writeln('💰 Pricing:');
        if (rentConfig['oneShare'] != null) {
          shareText.writeln('1 Share: ₹${rentConfig['oneShare']}');
        }
        if (rentConfig['twoShare'] != null) {
          shareText.writeln('2 Share: ₹${rentConfig['twoShare']}');
        }
        if (rentConfig['threeShare'] != null) {
          shareText.writeln('3 Share: ₹${rentConfig['threeShare']}');
        }
      }

      shareText.writeln();
      shareText.writeln('Check out this PG on Atitia!');

      await Share.share(
        shareText.toString(),
        subject: '${pg.pgName} - Atitia',
      );

      // Log analytics
      getIt.analytics.logEvent(
        name: 'pg_shared_from_card',
        parameters: {
          'pg_id': pg.pgId,
          'pg_name': pg.pgName,
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _text('failedToShare', 'Failed to share: {error}',
                  parameters: {'error': e.toString()}),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
