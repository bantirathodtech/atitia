// lib/core/services/optimization/image_compression_service.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Image compression service using native compression
/// Reduces storage costs by compressing images before upload
/// Expected savings: 60-80% reduction in storage size and costs
class ImageCompressionService {
  static final ImageCompressionService _instance =
      ImageCompressionService._internal();
  factory ImageCompressionService() => _instance;
  ImageCompressionService._internal();

  static ImageCompressionService get instance => _instance;

  // Default compression settings
  static const int defaultQuality = 85; // Good balance between quality and size
  static const int defaultMinWidth = 1920;
  static const int defaultMinHeight = 1080;

  /// Compress image file (File or XFile)
  /// Returns compressed Uint8List ready for upload
  Future<Uint8List?> compressImage(
    dynamic imageFile, {
    int quality = defaultQuality,
    int? minWidth,
    int? minHeight,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    try {
      if (imageFile == null) return null;

      // Handle File (mobile/desktop)
      if (imageFile is File) {
        return await _compressFile(
          imageFile,
          quality: quality,
          minWidth: minWidth ?? defaultMinWidth,
          minHeight: minHeight ?? defaultMinHeight,
          format: format,
        );
      }

      // Handle XFile (web/mobile)
      if (imageFile is XFile) {
        return await _compressXFile(
          imageFile,
          quality: quality,
          minWidth: minWidth ?? defaultMinWidth,
          minHeight: minHeight ?? defaultMinHeight,
          format: format,
        );
      }

      // If already Uint8List, return as-is (already compressed or can't compress)
      if (imageFile is Uint8List) {
        return imageFile;
      }

      return null;
    } catch (e) {
      debugPrint('Image compression error: $e');
      // Return null on error - caller should handle fallback
      return null;
    }
  }

  /// Compress File (mobile/desktop)
  Future<Uint8List?> _compressFile(
    File file, {
    required int quality,
    required int minWidth,
    required int minHeight,
    required CompressFormat format,
  }) async {
    try {
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: quality,
        format: format,
      );

      if (result == null) return null;
      return Uint8List.fromList(result);
    } catch (e) {
      debugPrint('File compression error: $e');
      return null;
    }
  }

  /// Compress XFile (web/mobile)
  Future<Uint8List?> _compressXFile(
    XFile xFile, {
    required int quality,
    required int minWidth,
    required int minHeight,
    required CompressFormat format,
  }) async {
    try {
      // Read bytes from XFile
      final bytes = await xFile.readAsBytes();

      // Compress using list compression (works on all platforms)
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: quality,
        format: format,
      );

      if (result.isEmpty) return null;
      return Uint8List.fromList(result);
    } catch (e) {
      debugPrint('XFile compression error: $e');
      return null;
    }
  }

  /// Compress image and save to temporary file
  /// Returns compressed File ready for upload
  /// Note: Web not supported - use compressImage instead
  Future<File?> compressAndSaveToFile(
    dynamic imageFile, {
    int quality = defaultQuality,
    int? minWidth,
    int? minHeight,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    try {
      if (kIsWeb) {
        // Web doesn't support File operations
        debugPrint('compressAndSaveToFile not supported on web, use compressImage instead');
        return null;
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = path.join(tempDir.path, fileName);

      if (imageFile is File) {
        // Compress File and save
        final result = await FlutterImageCompress.compressAndGetFile(
          imageFile.absolute.path,
          targetPath,
          minWidth: minWidth ?? defaultMinWidth,
          minHeight: minHeight ?? defaultMinHeight,
          quality: quality,
          format: format,
        );

        if (result != null) {
          final resultFile = File(result.path);
          if (await resultFile.exists()) {
            return resultFile;
          }
        }
      } else if (imageFile is XFile) {
        // Compress XFile bytes first, then save to File
        final compressedBytes = await compressImage(
          imageFile,
          quality: quality,
          minWidth: minWidth,
          minHeight: minHeight,
          format: format,
        );

        if (compressedBytes != null) {
          final compressedFile = File(targetPath);
          await compressedFile.writeAsBytes(compressedBytes);
          if (await compressedFile.exists()) {
            return compressedFile;
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('compressAndSaveToFile error: $e');
      return null;
    }
  }

  /// Compress multiple images
  Future<List<Uint8List?>> compressImages(
    List<dynamic> imageFiles, {
    int quality = defaultQuality,
    int? minWidth,
    int? minHeight,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    final results = <Uint8List?>[];

    for (final imageFile in imageFiles) {
      final compressed = await compressImage(
        imageFile,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: format,
      );
      results.add(compressed);
    }

    return results;
  }

  /// Get compression ratio (before/after sizes)
  double getCompressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0.0;
    return (1 - (compressedSize / originalSize)) * 100;
  }
}

