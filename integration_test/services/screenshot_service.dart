// integration_test/services/screenshot_service.dart
//
// Professional screenshot capture service
// Handles screenshot capture, organization, and metadata

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import '../config/screenshot_config.dart'
    show ScreenshotConfig, ScreenshotDefinition;

/// Professional screenshot capture service
class ScreenshotService {
  final IntegrationTestWidgetsFlutterBinding _binding;
  final String _outputDirectory;
  final Map<String, String> _capturedScreenshots = {};

  ScreenshotService({
    String? outputDirectory,
  })  : _binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized(),
        _outputDirectory = outputDirectory ?? ScreenshotConfig.outputDirectory {
    // Note: Don't create directories on device - integration_test framework
    // handles screenshot storage automatically. Directories are created on host.
  }

  /// Capture a screenshot with proper naming and metadata
  Future<String?> captureScreenshot(
    WidgetTester tester,
    ScreenshotDefinition definition, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Wait for animations to complete
      await tester.pumpAndSettle(
        Duration(seconds: ScreenshotConfig.animationTimeoutSeconds),
      );

      // Additional delay for any remaining animations
      await Future.delayed(
        Duration(milliseconds: ScreenshotConfig.captureDelayMs),
      );

      // Convert Flutter surface to image (required for some platforms)
      try {
        await _binding.convertFlutterSurfaceToImage();
        await tester.pumpAndSettle();
      } catch (e) {
        // Some platforms don't require this, continue anyway
        print('⚠️  convertFlutterSurfaceToImage not required: $e');
      }

      // Capture screenshot using integration_test framework
      // The framework automatically saves screenshots with the provided name
      await _binding.takeScreenshot(definition.name);

      // Also save to external storage for easy retrieval and visibility on device
      try {
        await _saveToExternalStorage(definition.name);
      } catch (e) {
        print('⚠️  Could not save to external storage: $e');
      }

      // Store metadata with expected filename (for reporting)
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filename = '${definition.name}_$timestamp.png';
      final filepath = '$_outputDirectory/$filename';

      // Store metadata
      _capturedScreenshots[definition.name] = filepath;

      // Log capture
      print('📸 Captured: ${definition.name}');
      print('   Description: ${definition.description}');
      print('   Route: ${definition.route}');
      if (metadata != null) {
        print('   Metadata: $metadata');
      }

      return filepath;
    } catch (e) {
      print('❌ Error capturing screenshot ${definition.name}: $e');
      return null;
    }
  }

  /// Capture multiple screenshots in sequence
  Future<Map<String, String?>> captureScreenshots(
    WidgetTester tester,
    List<ScreenshotDefinition> definitions,
  ) async {
    final results = <String, String?>{};

    for (final definition in definitions) {
      final filepath = await captureScreenshot(tester, definition);
      results[definition.name] = filepath;

      // Small delay between captures
      await Future.delayed(
        Duration(milliseconds: ScreenshotConfig.captureDelayMs),
      );
    }

    return results;
  }

  /// Get all captured screenshots
  Map<String, String> get capturedScreenshots =>
      Map.unmodifiable(_capturedScreenshots);

  /// Generate screenshot report
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('# Screenshot Capture Report');
    buffer.writeln('');
    buffer.writeln('**Generated:** ${DateTime.now().toIso8601String()}');
    buffer.writeln('**Total Screenshots:** ${_capturedScreenshots.length}');
    buffer.writeln('');

    if (_capturedScreenshots.isEmpty) {
      buffer.writeln('No screenshots captured.');
      return buffer.toString();
    }

    buffer.writeln('## Captured Screenshots');
    buffer.writeln('');

    _capturedScreenshots.forEach((name, path) {
      buffer.writeln('1. **$name**');
      buffer.writeln('   - Path: `$path`');
      buffer.writeln('');
    });

    return buffer.toString();
  }

  /// Save screenshot to external storage for easy retrieval and visibility on device
  /// Uses image_gallery_saver_plus for proper gallery integration (Android 10+ compatible)
  Future<void> _saveToExternalStorage(String screenshotName) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Get app's files directory where integration_test saves screenshots
        final appDir = await getApplicationDocumentsDirectory();
        final screenshotsDir = Directory('${appDir.path}/../files/screenshots');

        // Look for the screenshot file
        File? foundFile;
        final screenshotFile =
            File('${screenshotsDir.path}/$screenshotName.png');

        if (await screenshotFile.exists()) {
          foundFile = screenshotFile;
        } else {
          // Try to find any file with the screenshot name
          if (await screenshotsDir.exists()) {
            final files = screenshotsDir.listSync();
            for (var file in files) {
              if (file is File && file.path.contains(screenshotName)) {
                foundFile = file;
                break;
              }
            }
          }
        }

        if (foundFile != null && await foundFile.exists()) {
          // Read the screenshot bytes
          final bytes = await foundFile.readAsBytes();

          // Use image_gallery_saver_plus for proper gallery integration
          // This ensures screenshots appear in gallery on all Android versions (including 10+)
          try {
            final result = await ImageGallerySaverPlus.saveImage(
              bytes,
              name: screenshotName,
              quality: 100,
              isReturnImagePathOfIOS: true,
            );

            if (result['isSuccess'] == true) {
              final savedPath = result['filePath'] ?? result['path'];
              print('   📁 Saved to gallery: $savedPath');
              print('   📱 Visible in device gallery');
            } else {
              print(
                  '   ⚠️  Gallery save returned false, trying fallback method');
              throw Exception('Gallery save failed');
            }
          } catch (galleryError) {
            // Fallback: Save to external storage directory (for file manager access)
            print('   ⚠️  Gallery save failed: $galleryError');
            print('   📝 Falling back to external storage directory');

            try {
              final externalDir =
                  Directory('/sdcard/Pictures/AtitiaScreenshots');
              if (!await externalDir.exists()) {
                await externalDir.create(recursive: true);
              }

              final externalFile =
                  File('${externalDir.path}/$screenshotName.png');
              await externalFile.writeAsBytes(bytes);

              print('   📁 Saved to external storage: ${externalFile.path}');
              print('   📱 Accessible via file manager');
            } catch (fallbackError) {
              print('   ⚠️  Fallback save also failed: $fallbackError');
            }
          }
        } else {
          // If file not found, try using shell command to copy (Android only)
          if (Platform.isAndroid) {
            try {
              // Use Process to copy via shell (app has permission to its own files)
              final result = await Process.run(
                'sh',
                [
                  '-c',
                  'cp "/data/data/com.avishio.atitia/files/screenshots/$screenshotName.png" "/sdcard/Pictures/AtitiaScreenshots/$screenshotName.png" 2>/dev/null || true'
                ],
              );

              if (result.exitCode == 0) {
                print('   📁 Copied to external storage via shell');
                // Try to save to gallery after copying
                try {
                  final copiedFile = File(
                      '/sdcard/Pictures/AtitiaScreenshots/$screenshotName.png');
                  if (await copiedFile.exists()) {
                    final bytes = await copiedFile.readAsBytes();
                    final galleryResult = await ImageGallerySaverPlus.saveImage(
                      bytes,
                      name: screenshotName,
                      quality: 100,
                    );
                    if (galleryResult['isSuccess'] == true) {
                      print('   📱 Also saved to gallery');
                    }
                  }
                } catch (e) {
                  print('   ⚠️  Could not save to gallery: $e');
                }
              } else {
                print('   ⚠️  Could not copy via shell, will be pulled later');
              }
            } catch (e) {
              print('   ⚠️  Shell copy failed: $e');
            }
          }
        }
      }
    } catch (e) {
      // External storage might not be available, that's okay
      print('   ⚠️  External storage save failed: $e');
      print('   📝 Screenshot will be pulled from device after test');
    }
  }

  /// Save report to file
  /// Note: This may fail on device - reports are typically saved on host
  Future<void> saveReport(String filepath) async {
    try {
      final report = generateReport();
      final file = File(filepath);
      await file.writeAsString(report);
      print('📄 Report saved: $filepath');
    } catch (e) {
      // Report saving may fail on device - that's okay, script will generate it
      print('⚠️  Could not save report on device: $e');
      print('   Report will be generated by capture script');
    }
  }
}
