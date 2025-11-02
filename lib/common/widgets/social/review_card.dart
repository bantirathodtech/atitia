// lib/common/widgets/social/review_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';
import '../images/adaptive_image.dart';
import '../../../core/models/review_model.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
              _buildReviewHeader(context, isDarkMode),
              const SizedBox(height: AppSpacing.paddingM),
              _buildRatingDisplay(context),
              const SizedBox(height: AppSpacing.paddingM),
              _buildReviewText(context),
              if (widget.review.photos.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.paddingM),
                _buildReviewPhotos(context, isDarkMode),
              ],
              if (widget.review.ownerResponse != null) ...[
                const SizedBox(height: AppSpacing.paddingM),
                _buildOwnerResponse(context, isDarkMode),
              ],
              const SizedBox(height: AppSpacing.paddingM),
              _buildReviewFooter(context, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewHeader(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    
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
                  widget.review.guestName.isNotEmpty 
                      ? widget.review.guestName[0].toUpperCase()
                      : 'G',
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
                widget.review.guestName.isNotEmpty 
                    ? widget.review.guestName 
                    : 'Anonymous Guest',
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
                text: DateFormat('MMM dd, yyyy').format(widget.review.reviewDate),
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
              'Pending',
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

  Widget _buildReviewText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.review.comment.isNotEmpty) ...[
          BodyText(text: widget.review.comment),
          const SizedBox(height: AppSpacing.paddingS),
        ],
        if (_hasAspectRatings()) ...[
          _buildAspectRatings(context),
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

  Map<String, double> _getAspectRatings() {
    final ratings = <String, double>{};
    if (widget.review.cleanlinessRating > 0) ratings['Cleanliness'] = widget.review.cleanlinessRating;
    if (widget.review.amenitiesRating > 0) ratings['Amenities'] = widget.review.amenitiesRating;
    if (widget.review.locationRating > 0) ratings['Location'] = widget.review.locationRating;
    if (widget.review.foodRating > 0) ratings['Food Quality'] = widget.review.foodRating;
    if (widget.review.staffRating > 0) ratings['Staff'] = widget.review.staffRating;
    return ratings;
  }

  Widget _buildAspectRatings(BuildContext context) {
    final theme = Theme.of(context);
    final aspectRatings = _getAspectRatings();
    
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

  Widget _buildReviewPhotos(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos',
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

  Widget _buildOwnerResponse(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    
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
                'Owner Response',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
              const Spacer(),
              if (widget.review.ownerResponseDate != null)
                CaptionText(
                  text: DateFormat('MMM dd, yyyy').format(widget.review.ownerResponseDate!),
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

  Widget _buildReviewFooter(BuildContext context, bool isDarkMode) {
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
              'View Photos',
              style: AppTypography.bodySmall.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}