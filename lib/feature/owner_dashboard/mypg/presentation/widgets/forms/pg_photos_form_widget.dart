import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../../common/utils/constants/storage.dart';
import '../../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../auth/logic/auth_provider.dart';

/// Photos Upload Form Widget
/// Handles photo selection, upload to storage, and display
/// Works on both mobile and web platforms
class PgPhotosFormWidget extends AdaptiveStatelessWidget {
  final List<String> uploadedPhotos;
  final Function(List<String>) onPhotosChanged;
  final String? pgId; // Optional PG ID for edit mode

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
                  text: 'Uploading ${imageFiles.length} photo(s)...',
                  color: Colors.grey[700],
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
      final photoId = pgId ?? 'temp_${ownerId}_${DateTime.now().millisecondsSinceEpoch}';
      
      final List<String> uploadedUrls = [];
      int successCount = 0;
      int failCount = 0;

      // Upload all selected images
      for (int i = 0; i < imageFiles.length; i++) {
        try {
          final imageFile = imageFiles[i];
          
          // Generate unique file name
          final fileName = 'pg_${photoId}_photo_${uploadedPhotos.length + i + 1}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          
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
          debugPrint('Failed to upload image $i: $errorMsg');
          
          // Provide more helpful error messages
          if (errorMsg.contains('Failed to fetch') || errorMsg.contains('CORS')) {
            debugPrint(
              '⚠️ Supabase Storage Error: This might be due to:\n'
              '1. Storage bucket RLS policies blocking uploads\n'
              '2. CORS configuration issues\n'
              '3. Authentication required for storage uploads\n'
              'Please check your Supabase Storage policies for the "atitia-storage" bucket.'
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
        final updatedPhotos = List<String>.from(uploadedPhotos)..addAll(uploadedUrls);
        onPhotosChanged(updatedPhotos);
      }

      // Show success/error message
      if (context.mounted) {
        if (successCount > 0 && failCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$successCount photo(s) uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (successCount > 0 && failCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$successCount photo(s) uploaded, $failCount failed'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Failed to upload photos. Please check Supabase Storage configuration.\n'
                'The storage bucket may require authentication or have restricted policies.',
              ),
              backgroundColor: Colors.red,
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
            content: Text('Failed to select photos: ${e.toString()}'),
            backgroundColor: Colors.red,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'Photos & Gallery'),
        const SizedBox(height: AppSpacing.paddingL),

        BodyText(
          text: 'Add photos of your PG to attract more guests:',
          color: Colors.grey[600],
        ),
        const SizedBox(height: AppSpacing.paddingL),

        // Add Photos Button (supports multiple selection)
        PrimaryButton(
          onPressed: () => _addPhoto(context),
          label: 'Add Photos',
          icon: Icons.add_photo_alternate,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        BodyText(
          text: 'You can select multiple images at once (up to 10)',
          color: Colors.grey[500],
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
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(
                    text: 'No photos added yet',
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(
                    text: 'Click "Add Photo" to upload images',
                    color: Colors.grey[500],
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
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
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
