// lib/common/utils/helpers/screenshot_helper.dart
//
// Screenshot helper utility for capturing app screens
// Can be used in development or testing scenarios
//
// Usage:
//   await ScreenshotHelper.captureScreen(context, 'screenshot_name');
//
// Note: This requires the screenshot package or integration_test framework
// For gallery saving, use image_gallery_saver package (already added to pubspec.yaml)

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Helper class for capturing screenshots programmatically
class ScreenshotHelper {
  /// Captures a screenshot of the current screen
  ///
  /// This is a placeholder implementation. For actual screenshot capture:
  /// - Use integration_test framework (recommended for automated tests)
  /// - Use screenshot package for manual captures
  /// - Use platform-specific methods (ADB for Android, xcrun for iOS)
  static Future<String?> captureScreen(
    BuildContext context,
    String name, {
    bool saveToDevice = true,
  }) async {
    if (kIsWeb) {
      debugPrint('Screenshot capture not supported on web');
      return null;
    }

    try {
      // Get the directory to save screenshots
      final Directory? directory = await _getScreenshotDirectory();
      if (directory == null) {
        debugPrint('Could not get screenshot directory');
        return null;
      }

      // Generate filename with timestamp
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filename = '${name}_$timestamp.png';
      final filePath = '${directory.path}/$filename';

      // Note: Actual screenshot capture requires:
      // 1. integration_test framework (for automated tests)
      // 2. screenshot package (for manual captures)
      // 3. Platform-specific tools (ADB, xcrun)

      // This is a placeholder - implement based on your needs
      debugPrint('Screenshot capture requested: $filePath');
      debugPrint(
          'Use integration_test or screenshot package for actual capture');

      return filePath;
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
      return null;
    }
  }

  /// Gets the directory where screenshots should be saved
  static Future<Directory?> _getScreenshotDirectory() async {
    try {
      if (Platform.isAndroid) {
        // On Android, save to external storage Pictures directory
        final directory = Directory('/sdcard/Pictures/AtitiaScreenshots');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory;
      } else if (Platform.isIOS) {
        // On iOS, save to app documents directory
        final directory = await getApplicationDocumentsDirectory();
        final screenshotsDir = Directory('${directory.path}/Screenshots');
        if (!await screenshotsDir.exists()) {
          await screenshotsDir.create(recursive: true);
        }
        return screenshotsDir;
      } else {
        // Desktop platforms
        final directory = await getApplicationDocumentsDirectory();
        final screenshotsDir = Directory('${directory.path}/Screenshots');
        if (!await screenshotsDir.exists()) {
          await screenshotsDir.create(recursive: true);
        }
        return screenshotsDir;
      }
    } catch (e) {
      debugPrint('Error getting screenshot directory: $e');
      return null;
    }
  }

  /// Lists all captured screenshots
  static Future<List<File>> listScreenshots() async {
    final directory = await _getScreenshotDirectory();
    if (directory == null) return [];

    try {
      final files = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.png'))
          .toList();

      // Sort by modification time (newest first)
      files
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      return files;
    } catch (e) {
      debugPrint('Error listing screenshots: $e');
      return [];
    }
  }

  /// Deletes a screenshot file
  static Future<bool> deleteScreenshot(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting screenshot: $e');
      return false;
    }
  }

  /// Clears all screenshots
  static Future<bool> clearAllScreenshots() async {
    try {
      final screenshots = await listScreenshots();
      for (final screenshot in screenshots) {
        await screenshot.delete();
      }
      return true;
    } catch (e) {
      debugPrint('Error clearing screenshots: $e');
      return false;
    }
  }
}
