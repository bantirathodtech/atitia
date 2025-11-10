// ============================================================================
// Image Picker Helper - Cross-Platform Image Selection
// ============================================================================
// Handles image picking for both mobile and web platforms.
//
// PLATFORM COMPATIBILITY:
// - Mobile (Android/iOS): Returns dart:io File from path
// - Web: Returns XFile directly (dart:io File doesn't work on web)
//
// WEB SOLUTION:
// - Return type changed to dynamic to support both File and XFile
// - Mobile: Returns File (backward compatible)
// - Web: Returns XFile (storage service handles conversion)
// - Storage service checks type and handles appropriately
//
// USAGE:
// var file = await ImagePickerHelper.pickImageFromGallery();
// await storageService.uploadFile(file, ...);  // Works on all platforms
// ============================================================================

import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/localization/internationalization_service.dart';

/// A small helper to pick images using image_picker with consistent defaults.
class ImagePickerHelper {
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  static String _translate(
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

  // Static cache for web file bytes (workaround for File limitations on web)
  // static final Map<String, List<int>> _webFileCache = {};

  // ==========================================================================
  // Pick Image from Gallery - Cross-Platform
  // ==========================================================================
  // PLATFORM HANDLING:
  // - Mobile: Returns dart:io File from path
  // - Web: Returns XFile (dart:io File doesn't exist on web)
  //
  // WHY RETURN dynamic:
  // - Mobile needs File for backward compatibility
  // - Web needs XFile because File operations don't work
  // - Storage service checks type and handles both
  //
  // USAGE:
  // Same as before - storage service auto-detects and handles:
  //   var file = await ImagePickerHelper.pickImageFromGallery();
  //   await storage.uploadFile(file, 'folder/', 'name.jpg');
  // ==========================================================================
  static Future<dynamic> pickImageFromGallery({int imageQuality = 75}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );

    if (pickedFile == null) return null;

    // =======================================================================
    // Platform-Specific Return Types
    // =======================================================================
    if (kIsWeb) {
      // Web: Return XFile directly
      // Storage service will call xfile.readAsBytes() which works on web
      return pickedFile; // Returns XFile
    } else {
      // Mobile/Desktop: Return File from path
      // Works normally with file system
      return File(pickedFile.path); // Returns File
    }
  }

  // ==========================================================================
  // Get XFile directly - For advanced usage
  // ==========================================================================
  // Always returns XFile regardless of platform
  // Use this when you need XFile-specific operations
  // ==========================================================================
  static Future<XFile?> pickImageAsXFile({int imageQuality = 75}) async {
    final picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
  }

  // ==========================================================================
  // Pick Multiple Images from Gallery - Cross-Platform
  // ==========================================================================
  // PLATFORM HANDLING:
  // - Web: Uses file picker with multiple selection
  // - Mobile/Desktop: Returns List of Files from paths
  //
  // USAGE:
  // var files = await ImagePickerHelper.pickMultipleImagesFromGallery();
  // for (var file in files) {
  //   await storage.uploadFile(file, 'folder/', 'name.jpg');
  // }
  // ==========================================================================
  static Future<List<dynamic>> pickMultipleImagesFromGallery({
    int imageQuality = 85,
    int? limit,
  }) async {
    final picker = ImagePicker();
    
    try {
      // Use pickMultipleMedia for multiple selection (works on web and mobile)
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        imageQuality: imageQuality,
        limit: limit, // Optional limit on number of images
      );

      if (pickedFiles.isEmpty) return [];

      // =======================================================================
      // Platform-Specific Return Types
      // =======================================================================
      if (kIsWeb) {
        // Web: Return XFile list directly
        return pickedFiles;
      } else {
        // Mobile/Desktop: Return File list from paths
        return pickedFiles.map((xfile) => File(xfile.path)).toList();
      }
    } catch (e) {
      // If pickMultiImage is not available or fails, fallback to single selection
      // This handles older versions or platforms that don't support multiple selection
      debugPrint(
        _translate(
          'imagePickerMultipleSelectionError',
          'Multiple image selection not available, error: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return [];
    }
  }
}
