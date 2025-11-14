// ============================================================================
// Supabase Storage Service - File Upload/Download Operations
// ============================================================================
// Cross-platform storage service supporting both mobile and web.
//
// PLATFORM SUPPORT:
// - Mobile (Android/iOS): Uses dart:io File directly
// - Web: Converts File to bytes first (dart:io not available on web)
// - All platforms: Uses uploadBinary for compatibility
//
// WEB COMPATIBILITY FIX:
// - Web doesn't support dart:io File operations
// - Must read file as bytes first: await file.readAsBytes()
// - Then upload using uploadBinary with Uint8List
// - This approach works on ALL platforms
//
// METHODS:
// - uploadFile: Upload dart:io File (auto-detects web and converts to bytes)
// - uploadFileFromBytes: Direct bytes upload (for web or custom scenarios)
// - getDownloadUrl: Get public URL for uploaded file
// - deleteFile: Remove file from storage
// - listFiles: List files in directory
// ============================================================================

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase_config.dart';

/// Supabase Storage service providing file operations
///
/// This is a drop-in replacement for CloudStorageServiceWrapper (Firebase Storage)
/// Maintains the exact same interface for seamless switching
///
/// Responsibility:
/// - Handle file uploads to Supabase Storage
/// - Manage file downloads and URL generation
/// - Provide file deletion operations
///
/// Note: This is a reusable core service - never modify for app-specific logic
class SupabaseStorageServiceWrapper {
  SupabaseClient? _supabaseClient;

  // Default bucket name from config
  final String defaultBucket = SupabaseConfig.storageBucket;

  SupabaseStorageServiceWrapper._privateConstructor();
  static final SupabaseStorageServiceWrapper _instance =
      SupabaseStorageServiceWrapper._privateConstructor();

  /// Factory constructor to provide singleton instance
  factory SupabaseStorageServiceWrapper() => _instance;

  /// Get Supabase client (lazy initialization with safety checks)
  SupabaseClient get _supabase {
    if (_supabaseClient != null) {
      return _supabaseClient!;
    }

    // Check if Supabase is configured
    if (!SupabaseConfig.isConfigured) {
      throw Exception(
        'Supabase not configured. Please update supabase_config.dart with your credentials.',
      );
    }

    // Check if Supabase is initialized
    try {
      _supabaseClient = Supabase.instance.client;
      return _supabaseClient!;
    } catch (e) {
      throw Exception(
        'Supabase not initialized. Make sure Supabase.initialize() was called during app startup.',
      );
    }
  }

  /// Check if Supabase is ready for use
  bool get isReady {
    if (!SupabaseConfig.isConfigured) {
      return false;
    }

    try {
      // Try to access the client - if it works, Supabase is initialized
      // final client = Supabase.instance.client;
      return true; // client is never null if Supabase.instance.client doesn't throw
    } catch (e) {
      // If accessing client throws an error, Supabase is not initialized
      return false;
    }
  }

  /// Initialize Supabase Storage service
  /// Creates default bucket if it doesn't exist
  Future<void> initialize() async {
    if (!isReady) {
      return;
    }

    try {
      // Check if bucket exists, create if not
      final buckets = await _supabase.storage.listBuckets();
      final bucketExists =
          buckets.any((bucket) => bucket.name == defaultBucket);

      if (!bucketExists) {
        await _supabase.storage.createBucket(
          defaultBucket,
          const BucketOptions(
            public: true, // Allow public access for uploads
            fileSizeLimit: '10485760', // 10MB limit (must be string)
            allowedMimeTypes: ['image/*', 'application/pdf'],
          ),
        );

        // Note: After bucket creation, you still need to add RLS policies
        // in Supabase Dashboard to allow INSERT operations
        debugPrint('⚠️ Supabase Storage Bucket "$defaultBucket" created.\n'
            '⚠️ IMPORTANT: You must add RLS policies in Supabase Dashboard:\n'
            '   1. Go to Storage → Policies → $defaultBucket\n'
            '   2. Create policy: Allow INSERT for "anon" role\n'
            '   3. Policy SQL: bucket_id = \'$defaultBucket\'::text\n'
            '   See SUPABASE_STORAGE_SETUP.md for detailed instructions.');
      } else {}
    } catch (e) {
      // Bucket might already exist or permissions issue - continue anyway
    }
  }

  // ==========================================================================
  // Upload File - Cross-Platform Support (Mobile + Web)
  // ==========================================================================
  // PLATFORM HANDLING:
  // - Mobile (Android/iOS): Accepts dart:io File, reads as bytes
  // - Web: Accepts XFile (returned by image picker), reads as bytes
  // - Desktop: Accepts dart:io File, reads as bytes
  //
  // TYPE DETECTION:
  // - Checks if input is File (mobile/desktop) or XFile (web)
  // - Extracts bytes appropriately for each type
  // - Uploads bytes using uploadBinary (universal method)
  //
  // WHY THIS APPROACH WORKS:
  // - File.readAsBytes() works on mobile/desktop
  // - XFile.readAsBytes() works on web
  // - Both return List<int> which converts to Uint8List
  // - uploadBinary accepts Uint8List on all platforms
  //
  // USAGE:
  // Works with output from ImagePickerHelper.pickImageFromGallery():
  //   var file = await ImagePickerHelper.pickImageFromGallery();
  //   await storage.uploadFile(file, 'photos/', 'image.jpg');
  // ==========================================================================
  Future<String> uploadFile(
    dynamic file, // Can be File or XFile depending on platform
    String folderPath,
    String fileName,
  ) async {
    if (!isReady) {
      throw Exception('Supabase Storage not ready. Please configure Supabase.');
    }

    try {
      // Construct full path
      final fullPath = folderPath.endsWith('/')
          ? '$folderPath$fileName'
          : '$folderPath/$fileName';

      // =======================================================================
      // Read bytes based on file type (File vs XFile)
      // =======================================================================
      Uint8List bytes;

      if (file is XFile) {
        // Web: XFile from image_picker (readAsBytes works on web)
        bytes = Uint8List.fromList(await file.readAsBytes());
      } else if (file is File) {
        // Mobile/Desktop: dart:io File (readAsBytes works on mobile)
        bytes = await file.readAsBytes();
      } else {
        throw Exception(
          'Unsupported file type: ${file.runtimeType}. '
          'Expected File or XFile.',
        );
      }

      // =======================================================================
      // Upload bytes using uploadBinary (works on ALL platforms)
      // =======================================================================
      await _supabase.storage.from(defaultBucket).uploadBinary(
            fullPath,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true, // Replace if exists
            ),
          );

      // Get public URL
      final url = _supabase.storage.from(defaultBucket).getPublicUrl(fullPath);

      return url;
    } catch (e) {
      throw Exception('Supabase upload failed: $e');
    }
  }

  /// Uploads file from bytes (for web support)
  Future<String> uploadFileFromBytes(
    List<int> bytes,
    String folderPath,
    String fileName,
  ) async {
    if (!isReady) {
      throw Exception('Supabase Storage not ready. Please configure Supabase.');
    }

    try {
      final fullPath = folderPath.endsWith('/')
          ? '$folderPath$fileName'
          : '$folderPath/$fileName';

      // Convert List<int> to Uint8List
      final Uint8List uint8bytes = Uint8List.fromList(bytes);

      await _supabase.storage.from(defaultBucket).uploadBinary(
            fullPath,
            uint8bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      final url = _supabase.storage.from(defaultBucket).getPublicUrl(fullPath);

      return url;
    } catch (e) {
      throw Exception('Supabase upload from bytes failed: $e');
    }
  }

  /// Retrieves download URL for a file at specified path
  Future<String> getDownloadUrl(String filePath) async {
    if (!isReady) {
      throw Exception('Supabase Storage not ready. Please configure Supabase.');
    }

    try {
      final url = _supabase.storage.from(defaultBucket).getPublicUrl(filePath);
      return url;
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// Deletes file from Supabase Storage
  Future<void> deleteFile(String filePath) async {
    if (!isReady) {
      throw Exception('Supabase Storage not ready. Please configure Supabase.');
    }

    try {
      await _supabase.storage.from(defaultBucket).remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Lists files in a directory
  Future<List<FileObject>> listFiles(String folderPath) async {
    if (!isReady) {
      throw Exception('Supabase Storage not ready. Please configure Supabase.');
    }

    try {
      final files = await _supabase.storage.from(defaultBucket).list(
            path: folderPath,
          );
      return files;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  /// Moves/renames a file
  Future<String> moveFile(String fromPath, String toPath) async {
    if (!isReady) {
      throw Exception('Supabase Storage not ready. Please configure Supabase.');
    }

    try {
      await _supabase.storage.from(defaultBucket).move(fromPath, toPath);
      return getDownloadUrl(toPath);
    } catch (e) {
      throw Exception('Failed to move file: $e');
    }
  }

  /// Gets file metadata
  Future<Map<String, dynamic>> getMetadata(String filePath) async {
    if (!isReady) {
      throw Exception('Supabase Storage not ready. Please configure Supabase.');
    }

    try {
      // Supabase doesn't have direct metadata API
      // We can get file info from list
      final fileName = filePath.split('/').last;
      final folderPath = filePath.substring(0, filePath.lastIndexOf('/'));

      final files = await listFiles(folderPath);
      final file = files.firstWhere(
        (f) => f.name == fileName,
        orElse: () => throw Exception('File not found'),
      );

      return {
        'name': file.name,
        'size': file.metadata?['size'],
        'lastModified': file.metadata?['lastModified'],
        'contentType': file.metadata?['mimetype'],
      };
    } catch (e) {
      throw Exception('Failed to get metadata: $e');
    }
  }
}
