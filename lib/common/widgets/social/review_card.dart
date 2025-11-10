// lib/common/widgets/social/review_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/review_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../images/adaptive_image.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';

/// ⭐ **REVIEW CARD - PRODUCTION READY**
///
/// **Features:**
/// - Star ratings display
/// - Review text and photos
/// - Helpful voting
/// - Owner responses
/// - Theme-aware styling
class ReviewCard extends StatefulWidget {
  final ReviewModel review;
  final VoidCallback? onVoteHelpful;
  final VoidCallback? onViewPhotos;
  final bool showPGName;

  const ReviewCard({
    required this.review,
    this.onVoteHelpful,
    this.onViewPhotos,
    this.showPGName = false,
    super.key,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  static const _reviewDatePattern = 'MMM dd, yyyy';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: Card(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        elevation: isDarkMode ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewHeader(context, isDarkMode, loc),
              const SizedBox(height: AppSpacing.paddingM),
              _buildRatingDisplay(context),
              const SizedBox(height: AppSpacing.paddingM),
              _buildReviewText(context, loc),
              if (widget.review.photos.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.paddingM),
                _buildReviewPhotos(context, isDarkMode, loc),
              ],
              if (widget.review.ownerResponse != null) ...[
                const SizedBox(height: AppSpacing.paddingM),
                _buildOwnerResponse(context, isDarkMode, loc),
              ],
              const SizedBox(height: AppSpacing.paddingM),
              _buildReviewFooter(context, loc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewHeader(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    final theme = Theme.of(context);
    final reviewDate = _formatDate(loc, widget.review.reviewDate);
    final fallbackInitials = loc?.guestInitialsFallback ?? 'G';
    final initialsSource = widget.review.guestName.trim().isNotEmpty
        ? widget.review.guestName.trim()
        : fallbackInitials;
    final trimmedInitials = initialsSource.trim();
    final displayInitial = trimmedInitials.isNotEmpty
        ? trimmedInitials[0].toUpperCase()
        : 'G';
    final displayName = widget.review.guestName.trim().isNotEmpty
        ? widget.review.guestName
        : (loc?.anonymousGuest ?? 'Anonymous Guest');

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
          backgroundImage: widget.review.guestPhotoUrl != null
              ? NetworkImage(widget.review.guestPhotoUrl!)
              : null,
          child: widget.review.guestPhotoUrl == null
              ? Text(
                  displayInitial,
                  style: AppTypography.bodyLarge.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.showPGName)
                CaptionText(
                  text: widget.review.pgName,
                  color: AppColors.textSecondary,
                ),
              CaptionText(
                text: reviewDate,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        if (widget.review.status == 'pending')
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              loc?.pending ?? 'Pending',
              style: AppTypography.caption.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingDisplay(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < widget.review.rating ? Icons.star : Icons.star_border,
            color: AppColors.warning,
            size: 16,
          );
        }),
        const SizedBox(width: AppSpacing.paddingS),
        Text(
          widget.review.rating.toString(),
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewText(BuildContext context, AppLocalizations? loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.review.comment.isNotEmpty) ...[
          BodyText(text: widget.review.comment),
          const SizedBox(height: AppSpacing.paddingS),
        ],
        if (_hasAspectRatings()) ...[
          _buildAspectRatings(context, loc),
        ],
      ],
    );
  }

  bool _hasAspectRatings() {
    return widget.review.cleanlinessRating > 0 || 
           widget.review.amenitiesRating > 0 || 
           widget.review.locationRating > 0 || 
           widget.review.foodRating > 0 || 
           widget.review.staffRating > 0;
  }

  Map<String, double> _getAspectRatings(AppLocalizations? loc) {
    final ratings = <String, double>{};
    if (widget.review.cleanlinessRating > 0) {
      ratings[loc?.cleanliness ?? 'Cleanliness'] =
          widget.review.cleanlinessRating;
    }
    if (widget.review.amenitiesRating > 0) {
      ratings[loc?.amenities ?? 'Amenities'] = widget.review.amenitiesRating;
    }
    if (widget.review.locationRating > 0) {
      ratings[loc?.locationLabel ?? 'Location'] =
          widget.review.locationRating;
    }
    if (widget.review.foodRating > 0) {
      ratings[loc?.foodQuality ?? 'Food Quality'] = widget.review.foodRating;
    }
    if (widget.review.staffRating > 0) {
      ratings[loc?.staffLabel ?? 'Staff'] = widget.review.staffRating;
    }
    return ratings;
  }

  Widget _buildAspectRatings(BuildContext context, AppLocalizations? loc) {
    final theme = Theme.of(context);
    final aspectRatings = _getAspectRatings(loc);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: aspectRatings.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingXS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    entry.value.toStringAsFixed(1),
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingXS),
                  ...List.generate(5, (index) {
                    return Icon(
                      index < entry.value ? Icons.star : Icons.star_border,
                      color: AppColors.warning,
                      size: 12,
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewPhotos(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc?.photos ?? 'Photos',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.paddingS),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.review.photos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: AppSpacing.paddingS),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  child: AdaptiveImage(
                    imageUrl: widget.review.photos[index],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      width: 80,
                      height: 80,
                      color: isDarkMode 
                          ? AppColors.darkSurface.withValues(alpha: 0.5)
                          : AppColors.background.withValues(alpha: 0.5),
                      child: const Icon(Icons.image, color: AppColors.textSecondary),
                    ),
                    errorWidget: Container(
                      width: 80,
                      height: 80,
                      color: isDarkMode 
                          ? AppColors.darkSurface.withValues(alpha: 0.5)
                          : AppColors.background.withValues(alpha: 0.5),
                      child: const Icon(Icons.broken_image, color: AppColors.error),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerResponse(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    final theme = Theme.of(context);
    final responseDate = widget.review.ownerResponseDate != null
        ? _formatDate(loc, widget.review.ownerResponseDate!)
        : null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: isDarkMode 
              ? AppColors.borderDark.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.business,
                color: theme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.paddingXS),
              Text(
                loc?.ownerResponse ?? 'Owner Response',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
              const Spacer(),
              if (widget.review.ownerResponseDate != null)
                CaptionText(
                  text: responseDate!,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          BodyText(text: widget.review.ownerResponse!),
        ],
      ),
    );
  }

  Widget _buildReviewFooter(BuildContext context, AppLocalizations? loc) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (widget.onVoteHelpful != null) ...[
          TextButton.icon(
            onPressed: widget.onVoteHelpful,
            icon: Icon(
              Icons.thumb_up_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
            label: Text(
              loc?.helpfulWithCount(widget.review.helpfulVotes) ??
                  'Helpful (${widget.review.helpfulVotes})',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (widget.review.photos.isNotEmpty && widget.onViewPhotos != null)
          TextButton(
            onPressed: widget.onViewPhotos,
            child: Text(
              loc?.viewPhotos ?? 'View Photos',
              style: AppTypography.bodySmall.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(AppLocalizations? loc, DateTime date) {
    final localeName = loc?.localeName ?? 'en';
    final formatter = DateFormat(_reviewDatePattern, localeName);
    return formatter.format(date);
  }
}