// lib/core/services/optimization/image_optimization_service.dart

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import '../../di/firebase/di/firebase_service_locator.dart';

/// Image optimization service for better performance
/// Handles image compression, resizing, and caching
class ImageOptimizationService {
  static final ImageOptimizationService _instance =
      ImageOptimizationService._internal();
  factory ImageOptimizationService() => _instance;
  ImageOptimizationService._internal();

  static ImageOptimizationService get instance => _instance;

  // Logger not available - removed for now
  final _analyticsService = getIt.analytics;

  // Image quality settings
  static const int _defaultQuality = 85;
  static const int _thumbnailQuality = 70;
  static const int _maxImageWidth = 1920;
  static const int _maxImageHeight = 1080;
  static const int _thumbnailWidth = 300;
  static const int _thumbnailHeight = 300;

  /// Optimize image for web/mobile display
  Future<Uint8List> optimizeImage(
    Uint8List imageBytes, {
    int? maxWidth,
    int? maxHeight,
    int quality = _defaultQuality,
    bool createThumbnail = false,
  }) async {
    try {
      // Logger not available: _logger call removed

      // Decode image
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Calculate new dimensions
      final targetWidth = maxWidth ?? _maxImageWidth;
      final targetHeight = maxHeight ?? _maxImageHeight;

      final aspectRatio = originalImage.width / originalImage.height;
      int newWidth = targetWidth;
      int newHeight = targetHeight;

      if (aspectRatio > 1) {
        // Landscape
        newHeight = (targetWidth / aspectRatio).round();
      } else {
        // Portrait or square
        newWidth = (targetHeight * aspectRatio).round();
      }

      // Resize image
      final resizedImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.cubic,
      );

      // Encode with specified quality
      final optimizedBytes = img.encodeJpg(resizedImage, quality: quality);

      await _analyticsService.logEvent(
        name: 'image_optimized',
        parameters: {
          'original_size': imageBytes.length,
          'optimized_size': optimizedBytes.length,
          'compression_ratio':
              (1 - (optimizedBytes.length / imageBytes.length)) * 100,
          'quality': quality,
        },
      );

      // Logger not available: _logger.info call removed

      return optimizedBytes;
    } catch (e) {
      // Logger not available: _logger call removed
      return imageBytes; // Return original if optimization fails
    }
  }

  /// Create thumbnail from image
  Future<Uint8List> createThumbnail(
    Uint8List imageBytes, {
    int width = _thumbnailWidth,
    int height = _thumbnailHeight,
    int quality = _thumbnailQuality,
  }) async {
    try {
      // Logger not available: _logger call removed

      final thumbnailBytes = await optimizeImage(
        imageBytes,
        maxWidth: width,
        maxHeight: height,
        quality: quality,
      );

      await _analyticsService.logEvent(
        name: 'thumbnail_created',
        parameters: {
          'original_size': imageBytes.length,
          'thumbnail_size': thumbnailBytes.length,
          'width': width,
          'height': height,
        },
      );

      return thumbnailBytes;
    } catch (e) {
      // Logger not available: _logger call removed
      return imageBytes;
    }
  }

  /// Optimize image for different use cases
  Future<Map<String, Uint8List>> optimizeForMultipleUseCases(
      Uint8List imageBytes) async {
    try {
      // Logger not available: _logger call removed

      final results = <String, Uint8List>{};

      // Original optimized
      results['original'] = await optimizeImage(imageBytes);

      // Thumbnail
      results['thumbnail'] = await createThumbnail(imageBytes);

      // Profile picture (square, medium size)
      results['profile'] = await optimizeImage(
        imageBytes,
        maxWidth: 400,
        maxHeight: 400,
        quality: 80,
      );

      // Card image (landscape, medium size)
      results['card'] = await optimizeImage(
        imageBytes,
        maxWidth: 600,
        maxHeight: 400,
        quality: 75,
      );

      await _analyticsService.logEvent(
        name: 'multi_use_optimization_completed',
        parameters: {
          'original_size': imageBytes.length,
          'variants_created': results.length,
          'total_optimized_size':
              results.values.fold<int>(0, (sum, bytes) => sum + bytes.length),
        },
      );

      return results;
    } catch (e) {
      // Logger not available: _logger call removed
      return {'original': imageBytes};
    }
  }

  /// Get image metadata
  Future<Map<String, dynamic>> getImageMetadata(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      return {
        'width': image.width,
        'height': image.height,
        'size': imageBytes.length,
        'format': _getImageFormat(imageBytes),
        'aspectRatio': image.width / image.height,
        'isLandscape': image.width > image.height,
        'isPortrait': image.height > image.width,
        'isSquare': image.width == image.height,
      };
    } catch (e) {
      // Logger not available: _logger call removed
      return {};
    }
  }

  /// Detect image format
  String _getImageFormat(Uint8List bytes) {
    if (bytes.length < 4) return 'unknown';

    // Check for common image formats
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'JPEG';
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'PNG';
    }
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) return 'GIF';
    if (bytes[0] == 0x42 && bytes[1] == 0x4D) return 'BMP';
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) {
      return 'WEBP';
    }

    return 'unknown';
  }

  /// Calculate optimal quality based on image size
  int calculateOptimalQuality(int imageSize, int targetSize) {
    if (imageSize <= targetSize) return 95;

    final ratio = targetSize / imageSize;
    if (ratio >= 0.8) return 90;
    if (ratio >= 0.6) return 85;
    if (ratio >= 0.4) return 80;
    if (ratio >= 0.2) return 75;
    return 70;
  }

  /// Batch optimize multiple images
  Future<List<Uint8List>> batchOptimizeImages(
    List<Uint8List> imageBytesList, {
    int quality = _defaultQuality,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      // Logger not available: _logger call removed

      final optimizedImages = <Uint8List>[];

      for (int i = 0; i < imageBytesList.length; i++) {
        try {
          final optimized = await optimizeImage(
            imageBytesList[i],
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            quality: quality,
          );
          optimizedImages.add(optimized);
        } catch (e) {
          // Logger not available: _logger call removed
          optimizedImages
              .add(imageBytesList[i]); // Use original if optimization fails
        }
      }

      await _analyticsService.logEvent(
        name: 'batch_optimization_completed',
        parameters: {
          'total_images': imageBytesList.length,
          'successful_optimizations': optimizedImages.length,
          'quality': quality,
        },
      );

      return optimizedImages;
    } catch (e) {
      // Logger not available: _logger call removed
      return imageBytesList; // Return originals if batch optimization fails
    }
  }

  /// Get optimization recommendations
  Map<String, dynamic> getOptimizationRecommendations(
      Map<String, dynamic> metadata) {
    final width = metadata['width'] as int? ?? 0;
    final height = metadata['height'] as int? ?? 0;
    final size = metadata['size'] as int? ?? 0;

    final recommendations = <String, dynamic>{};

    // Size recommendations
    if (size > 2 * 1024 * 1024) {
      // > 2MB
      recommendations['size'] = 'Image is large (>2MB). Consider compression.';
    }

    // Dimension recommendations
    if (width > _maxImageWidth || height > _maxImageHeight) {
      recommendations['dimensions'] =
          'Image dimensions are large. Consider resizing.';
    }

    // Quality recommendations
    if (size > 1024 * 1024) {
      // > 1MB
      recommendations['quality'] =
          'Consider reducing quality to 80-85% for better performance.';
    }

    // Format recommendations
    final format = metadata['format'] as String? ?? '';
    if (format == 'PNG' && size > 500 * 1024) {
      // > 500KB
      recommendations['format'] =
          'PNG file is large. Consider converting to JPEG for photos.';
    }

    return {
      'hasRecommendations': recommendations.isNotEmpty,
      'recommendations': recommendations,
      'suggestedQuality':
          calculateOptimalQuality(size, 1024 * 1024), // Target 1MB
      'suggestedMaxWidth': width > _maxImageWidth ? _maxImageWidth : null,
      'suggestedMaxHeight': height > _maxImageHeight ? _maxImageHeight : null,
    };
  }
}
