// lib/feature/owner_dashboard/mypg/presentation/widgets/pg_photos_form_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';

/// Photos Upload Form Widget
class PgPhotosFormWidget extends StatelessWidget {
  final List<String> uploadedPhotos;
  final Function(List<String>) onPhotosChanged;

  const PgPhotosFormWidget({
    super.key,
    required this.uploadedPhotos,
    required this.onPhotosChanged,
  });

  Future<void> _addPhoto(BuildContext context) async {
    try {
      // TODO: Implement image picker and upload
      final imageUrl =
          'https://via.placeholder.com/300x200?text=PG+Photo+${uploadedPhotos.length + 1}';
      final updatedPhotos = List<String>.from(uploadedPhotos)..add(imageUrl);
      onPhotosChanged(updatedPhotos);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add photo: $e')),
      );
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<String>.from(uploadedPhotos)..removeAt(index);
    onPhotosChanged(updatedPhotos);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '📸 Photos'),
            const SizedBox(height: AppSpacing.paddingM),

            BodyText(
              text: 'Add photos of your PG to attract more guests:',
              color: Colors.grey[600],
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // Photo Grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Existing photos
                ...uploadedPhotos.asMap().entries.map((entry) {
                  final index = entry.key;
                  final photoUrl = entry.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusM),
                        child: Image.network(
                          photoUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
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
                }).toList(),

                // Add photo button
                GestureDetector(
                  onTap: () => _addPhoto(context),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.5),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: theme.primaryColor,
                          size: 32,
                        ),
                        const SizedBox(height: 4),
                        BodyText(
                          text: 'Add Photo',
                          color: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (uploadedPhotos.isEmpty) ...[
              const SizedBox(height: AppSpacing.paddingM),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingL),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: AppSpacing.paddingM),
                    BodyText(
                      text: 'No photos added yet',
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: AppSpacing.paddingS),
                    BodyText(
                      text:
                          'Add photos to showcase your PG and attract more guests',
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: 'Tips for great photos:',
            ),
            const SizedBox(height: AppSpacing.paddingS),
            const BodyText(text: '• Take photos in good lighting'),
            const BodyText(
                text: '• Show different areas (rooms, common areas, kitchen)'),
            const BodyText(text: '• Include amenities in photos'),
            const BodyText(text: '• Keep photos clear and well-framed'),
          ],
        ),
      ),
    );
  }
}
