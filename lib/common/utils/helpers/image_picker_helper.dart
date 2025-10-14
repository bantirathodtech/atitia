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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

/// A small helper to pick images using image_picker with consistent defaults.
class ImagePickerHelper {
  // Static cache for web file bytes (workaround for File limitations on web)
  static final Map<String, List<int>> _webFileCache = {};

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
      return pickedFile;  // Returns XFile
    } else {
      // Mobile/Desktop: Return File from path
      // Works normally with file system
      return File(pickedFile.path);  // Returns File
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
}
