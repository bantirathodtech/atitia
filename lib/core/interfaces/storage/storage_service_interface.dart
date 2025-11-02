// lib/core/interfaces/storage/storage_service_interface.dart

/// Abstract interface for file storage operations
/// Implementations: Supabase Storage, Firebase Storage, REST API
/// Allows swapping storage backends without changing repository code
abstract class IStorageService {
  /// Uploads a file and returns the download URL
  Future<String> uploadFile({
    required String path,
    required dynamic file, // File or XFile
    String? fileName,
    Map<String, String>? metadata,
  });

  /// Deletes a file by path
  Future<void> deleteFile(String path);

  /// Gets download URL for a file
  Future<String> getDownloadUrl(String path);

  /// Lists files in a directory
  Future<List<String>> listFiles(String path);

  /// Uploads file with progress callback
  Future<String> uploadFileWithProgress({
    required String path,
    required dynamic file,
    String? fileName,
    Function(double progress)? onProgress,
    Map<String, String>? metadata,
  });

  /// Downloads a file to local storage
  Future<String> downloadFile(String path, String localPath);
}
