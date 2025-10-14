import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';

/// Photos Upload Form Widget
class PgPhotosFormWidget extends AdaptiveStatelessWidget {
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
        
        // Add Photo Button
        PrimaryButton(
          onPressed: () => _addPhoto(context),
          label: 'Add Photo',
          icon: Icons.add_a_photo,
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
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
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