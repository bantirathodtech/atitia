// ============================================================================
// Upload Card - Cross-Platform File Upload Widget
// ============================================================================
// Beautiful upload card with preview support for both mobile and web.
//
// PLATFORM SUPPORT:
// - Mobile: Displays File using Image.file()
// - Web: Displays XFile using Image.memory() with bytes
// - Both: Can display URL using network image
//
// WEB COMPATIBILITY:
// - Accepts dynamic imageFile (can be File or XFile)
// - Auto-detects type and displays appropriately
// - No breaking changes for existing mobile code
// ============================================================================

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../images/adaptive_image.dart';
import '../loaders/adaptive_loader.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';
import '../text/heading_small.dart';

/// Beautiful upload card for document/photo uploads
/// Shows preview, upload progress, and status
class UploadCard extends AdaptiveStatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? imageUrl;
  final dynamic imageFile;  // Can be File (mobile) or XFile (web)
  final bool isUploading;
  final bool isRequired;
  final VoidCallback onUpload;
  final Color? accentColor;

  const UploadCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.imageUrl,
    this.imageFile,
    this.isUploading = false,
    this.isRequired = false,
    required this.onUpload,
    this.accentColor,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.primaryColor;
    final hasImage =
        (imageUrl != null && imageUrl!.isNotEmpty) || imageFile != null;

    return Card(
      elevation: hasImage ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: hasImage
            ? BorderSide(color: accent.withOpacity(0.3), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isUploading ? null : onUpload,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: accent, size: 28),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            HeadingSmall(text: title),
                            if (isRequired) ...[
                              const SizedBox(width: 4),
                              const Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        CaptionText(
                          text: description,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ],
                    ),
                  ),
                  
                  // Status indicator (theme-aware)
                  if (hasImage && !isUploading)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.successContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ),
                ],
              ),

              // Upload progress or image preview
              if (isUploading) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const AdaptiveLoader(),
                      const SizedBox(height: AppSpacing.sm),
                      BodyText(
                        text: 'Uploading...',
                        color: accent,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      LinearProgressIndicator(
                        backgroundColor: theme.brightness == Brightness.dark
                            ? AppColors.darkDivider
                            : AppColors.outline,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    ],
                  ),
                ),
              ] else if (hasImage) ...[
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // =======================================================
                      // Image Display - Cross-Platform Support
                      // =======================================================
                      // File (mobile): Use Image.file()
                      // XFile (web): Use FutureBuilder + Image.memory()
                      // URL: Use AdaptiveImage (network)
                      // =======================================================
                      imageFile != null
                          ? _buildImagePreview(imageFile!)
                          : imageUrl != null
                              ? AdaptiveImage(
                                  imageUrl: imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox.shrink(),
                      
                      // Overlay with edit button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle,
                          size: 16, color: AppColors.success),
                      const SizedBox(width: 4),
                      CaptionText(
                        text: 'Document uploaded successfully',
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerColor,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 48,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      BodyText(
                        text: 'Tap to upload',
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const CaptionText(
                        text: 'JPG, PNG up to 10MB',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // Build Image Preview - Cross-Platform Support
  // ==========================================================================
  // Handles both File (mobile) and XFile (web) for image display
  // ==========================================================================
  Widget _buildImagePreview(dynamic file) {
    if (file is XFile) {
      // Web: XFile - read as bytes and display with Image.memory()
      return FutureBuilder<List<int>>(
        future: file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              Uint8List.fromList(snapshot.data!),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          } else if (snapshot.hasError) {
            return Container(
              height: 200,
              color: AppColors.errorContainer,
              child: Center(
                child: Icon(Icons.error, color: AppColors.error),
              ),
            );
          } else {
            return Container(
              height: 200,
              color: AppColors.surfaceVariant,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    } else if (file is File) {
      // Mobile: File - use Image.file() normally
      return Image.file(
        file,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      // Unsupported type - show error
      return Container(
        height: 200,
        color: AppColors.errorContainer,
        child: Center(
          child: Text(
            'Unsupported file type: ${file.runtimeType}',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      );
    }
  }
}

