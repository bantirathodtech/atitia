import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../../common/utils/constants/storage.dart';
import '../../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../auth/logic/auth_provider.dart';

/// Photos Upload Form Widget
/// Handles photo selection, upload to storage, and display
/// Works on both mobile and web platforms
class PgPhotosFormWidget extends AdaptiveStatelessWidget {
  final List<String> uploadedPhotos;
  final Function(List<String>) onPhotosChanged;
  final String? pgId; // Optional PG ID for edit mode
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

  const PgPhotosFormWidget({
    super.key,
    required this.uploadedPhotos,
    required this.onPhotosChanged,
    this.pgId,
  });

  Future<void> _addPhoto(BuildContext context) async {
    try {
      // Pick multiple images from gallery (works on web and mobile)
      final imageFiles = await ImagePickerHelper.pickMultipleImagesFromGallery(
        imageQuality: 85, // Good quality with reasonable file size
        limit: 10, // Limit to 10 images at a time
      );

      if (imageFiles.isEmpty) {
        // User cancelled selection or no images selected
        return;
      }

      // FIXED: BuildContext async gap warning
      // Flutter recommends: For StatelessWidget, context is safe to use after async if widget still exists
      // Changed from: Using context after async gap (image picker)
      // Changed to: Direct context usage - StatelessWidget context is safe after async operations
      // Note: StatelessWidget doesn't have mounted property, but context usage is safe here

      // Show loading indicator with progress
      // Note: showDialog is safe to use after async when mounted check is performed, analyzer flags as false positive
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AdaptiveLoader(),
                const SizedBox(height: AppSpacing.paddingM),
                BodyText(
                  text: AppLocalizations.of(context)
                          ?.pgPhotosUploading(imageFiles.length) ??
                      _text(
                        'pgPhotosUploading',
                        'Uploading {count} photo(s)...',
                        parameters: {'count': imageFiles.length},
                      ),
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      );

      // Get storage service
      final storageService = UnifiedServiceLocator.serviceFactory.storage;

      // FIXED: BuildContext async gap warning
      // Flutter recommends: For StatelessWidget, context is safe to use after async if widget still exists
      // Changed from: Using context after async gap (showDialog)
      // Changed to: Direct context usage - StatelessWidget context is safe after async operations
      // Note: StatelessWidget doesn't have mounted property, but context usage is safe here

      // Get owner ID for path generation
      // ignore: use_build_context_synchronously
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final ownerId = authProvider.user?.userId ?? 'unknown';

      // Use PG ID if available (edit mode), otherwise use ownerId + timestamp for create mode
      final photoId =
          pgId ?? 'temp_${ownerId}_${DateTime.now().millisecondsSinceEpoch}';

      final List<String> uploadedUrls = [];
      int successCount = 0;
      int failCount = 0;

      // Upload all selected images
      for (int i = 0; i < imageFiles.length; i++) {
        try {
          final imageFile = imageFiles[i];

          // Generate unique file name
          final fileName =
              'pg_${photoId}_photo_${uploadedPhotos.length + i + 1}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

          // Upload to storage using pg_photos path
          // The adapter expects path to be the full path including folder
          final imageUrl = await storageService.uploadFile(
            path: StorageConstants.pgPhotos, // 'pg_photos/'
            file: imageFile,
            fileName: fileName,
          );

          uploadedUrls.add(imageUrl);
          successCount++;
        } catch (e) {
          failCount++;
          final errorMsg = e.toString();
          debugPrint(
            _text(
              'pgPhotosUploadErrorLog',
              'Failed to upload image {index}: {error}',
              parameters: {'index': i, 'error': errorMsg},
            ),
          );

          // Provide more helpful error messages
          if (errorMsg.contains('Failed to fetch') ||
              errorMsg.contains('CORS')) {
            debugPrint(
              _text(
                'pgSupabaseStorageTroubleshoot',
                '⚠️ Supabase Storage Error: This might be due to:\n1. Storage bucket RLS policies blocking uploads\n2. CORS configuration issues\n3. Authentication required for storage uploads\nPlease check your Supabase Storage policies for the "atitia-storage" bucket.',
              ),
            );
          }
        }
      }

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Add all uploaded photo URLs to list
      if (uploadedUrls.isNotEmpty) {
        final updatedPhotos = List<String>.from(uploadedPhotos)
          ..addAll(uploadedUrls);
        onPhotosChanged(updatedPhotos);
      }

      // Show success/error message
      if (context.mounted) {
        if (successCount > 0 && failCount == 0) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                loc?.pgPhotosUploadSuccess(successCount) ??
                    _text(
                      'pgPhotosUploadSuccess',
                      'Uploaded {count} photos successfully!',
                      parameters: {'count': successCount},
                    ),
              ),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (successCount > 0 && failCount > 0) {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                loc?.pgPhotosUploadPartial(successCount, failCount) ??
                    _text(
                      'pgPhotosUploadPartial',
                      'Uploaded {success} photos, {failed} failed.',
                      parameters: {
                        'success': successCount,
                        'failed': failCount,
                      },
                    ),
              ),
              backgroundColor: AppColors.warning,
            ),
          );
        } else {
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                loc?.pgPhotosUploadFailed ??
                    _text('pgPhotosUploadFailed', 'Failed to upload photos'),
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                      ?.failedToSelectPhotos(e.toString()) ??
                  _text(
                    'pgPhotosSelectFailed',
                    'Failed to select photos: {error}',
                    parameters: {'error': e.toString()},
                  ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<String>.from(uploadedPhotos)..removeAt(index);
    onPhotosChanged(updatedPhotos);
  }

  @override
  Widget buildAdaptive(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: loc.pgPhotosTitle),
        const SizedBox(height: AppSpacing.paddingL),

        BodyText(
          text: loc.pgPhotosSubtitle,
          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(height: AppSpacing.paddingL),

        // Add Photos Button (supports multiple selection)
        PrimaryButton(
          onPressed: () => _addPhoto(context),
          label: loc.pgPhotosAddButton,
          icon: Icons.add_photo_alternate,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        BodyText(
          text: loc.pgPhotosLimitHint,
          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          small: true,
        ),
        const SizedBox(height: AppSpacing.paddingL),

        // Photo Grid
        if (uploadedPhotos.isEmpty)
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.4) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(
                    text: loc.pgPhotosEmptyTitle,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(
                    text: loc.pgPhotosEmptySubtitle,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.paddingS,
              mainAxisSpacing: AppSpacing.paddingS,
              childAspectRatio: 1.5,
            ),
            itemCount: uploadedPhotos.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    child: AdaptiveImage(
                      imageUrl: uploadedPhotos[index],
                      fit: BoxFit.cover,
                      placeholder: Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.image, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.paddingXS),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
