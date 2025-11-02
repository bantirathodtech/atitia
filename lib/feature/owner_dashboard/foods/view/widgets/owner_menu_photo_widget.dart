// ============================================================================
// Owner Menu Photo Widget - Photo Gallery Display
// ============================================================================
// Displays menu photos in carousel or single view with theme support
//
// FEATURES:
// - Single photo view for 1 image
// - Horizontal carousel for multiple images
// - Empty state when no photos
// - Theme-aware colors for day/night modes
//
// THEME SUPPORT:
// - Empty state adapts to light/dark mode
// - Loading placeholders use theme colors
// - Icons and text adapt for visibility
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/text/caption_text.dart';

/// OwnerMenuPhotoWidget shows a carousel or single image of menu photos for a day.
/// Enhanced with common widgets for consistent styling and theme support
/// Displays empty state with theme-aware colors when no photos available
class OwnerMenuPhotoWidget extends StatelessWidget {
  final List<String> photoUrls;

  const OwnerMenuPhotoWidget({
    required this.photoUrls,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    // final surfaceColor = theme.colorScheme.surface;
    // final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    // final dividerColor = theme.dividerColor;

    // ========================================================================
    // Empty State - No Photos Added
    // ========================================================================
    if (photoUrls.isEmpty) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkCard // Dark background in dark mode
              : AppColors.surfaceVariant, // Light background in light mode
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkDivider // Subtle border in dark mode
                : AppColors.outline, // Medium border in light mode
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library,
                size: 48,
                color: isDarkMode
                    ? AppColors.textTertiary // Light icon in dark mode
                    : AppColors.textSecondary, // Medium icon in light mode
              ),
              const SizedBox(height: AppSpacing.paddingS),
              CaptionText(
                text: 'No photos added',
                color: AppColors.textSecondary, // Theme-aware text
              ),
            ],
          ),
        ),
      );
    }

    // ========================================================================
    // Single Photo View
    // ========================================================================
    if (photoUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        child: SizedBox(
          width: double.infinity,
          height: 180,
          child: AdaptiveImage(
            imageUrl: photoUrls.first,
            height: 180,
            fit: BoxFit.cover,
            placeholder: Container(
              height: 180,
              color: isDarkMode
                  ? AppColors.darkCard // Dark placeholder in dark mode
                  : AppColors.surfaceVariant, // Light placeholder in light mode
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: isDarkMode
                      ? AppColors.textTertiary // Light icon in dark mode
                      : AppColors.textSecondary, // Medium icon in light mode
                ),
              ),
            ),
          ),
        ),
      );
    }

    // ========================================================================
    // Multiple Photos Carousel
    // ========================================================================
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photoUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.paddingS),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          child: AdaptiveImage(
            imageUrl: photoUrls[index],
            height: 180,
            width: 180,
            fit: BoxFit.cover,
            placeholder: Container(
              height: 180,
              width: 180,
              color: isDarkMode
                  ? AppColors.darkCard // Dark placeholder in dark mode
                  : AppColors.surfaceVariant, // Light placeholder in light mode
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: isDarkMode
                      ? AppColors.textTertiary // Light icon in dark mode
                      : AppColors.textSecondary, // Medium icon in light mode
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
