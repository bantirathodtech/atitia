import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';

/// Widget displaying PG photos in a horizontal gallery
/// Uses common UI components for consistent styling
class GuestPhotoGallery extends StatelessWidget {
  final List<String> photos;
  final double height;
  final double width;
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const GuestPhotoGallery({
    required this.photos,
    this.height = 200,
    this.width = 200,
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
    final loc = AppLocalizations.of(context);

    if (photos.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: AppSpacing.paddingS),
              BodyText(
                text: loc?.noPhotosAvailable ??
                    _text('noPhotosAvailable', 'No photos available'),
                color: Colors.grey.shade600,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.paddingS),
        itemBuilder: (context, index) {
          final url = photos[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                height: height,
                width: width,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: height,
                  width: width,
                  color: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: AppSpacing.paddingS / 2),
                      BodyText(
                        text: loc?.failedToLoadImage ??
                            _text('failedToLoadImage', 'Failed to load image'),
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: height,
                    width: width,
                    color: Colors.grey.shade100,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
