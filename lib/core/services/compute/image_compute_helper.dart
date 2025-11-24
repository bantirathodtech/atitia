// lib/core/services/compute/image_compute_helper.dart

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Isolate helper functions for image processing
/// Must be top-level or static for isolate execution

/// Process image in isolate - OPTIMIZED for heavy computation
Future<Uint8List> _processImageInIsolate(Map<String, dynamic> params) async {
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
