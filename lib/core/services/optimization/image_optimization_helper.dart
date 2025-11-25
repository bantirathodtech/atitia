// lib/core/services/optimization/image_optimization_helper.dart

import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Isolate helper for image optimization (must be top-level)
Future<Uint8List> _processImageInIsolateHelper(
    Map<String, dynamic> params) async {
  final imageBytes = params['imageBytes'] as Uint8List;
  final maxWidth = params['maxWidth'] as int;
  final maxHeight = params['maxHeight'] as int;
  final quality = params['quality'] as int? ?? 85;

  try {
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      return imageBytes;
    }

    final aspectRatio = originalImage.width / originalImage.height;
    int newWidth = maxWidth;
    int newHeight = maxHeight;

    if (aspectRatio > 1) {
      // Landscape
      newHeight = (maxWidth / aspectRatio).round();
    } else {
      // Portrait or square
      newWidth = (maxHeight * aspectRatio).round();
    }

    // Resize image
    final resizedImage = img.copyResize(
      originalImage,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.cubic,
    );

    // Encode with specified quality
    return Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
  } catch (e) {
    return imageBytes; // Return original on error
  }
}
