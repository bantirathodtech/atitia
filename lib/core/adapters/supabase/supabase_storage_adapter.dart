// lib/core/adapters/supabase/supabase_storage_adapter.dart

import '../../interfaces/storage/storage_service_interface.dart';
import '../../services/supabase/storage/supabase_storage_service.dart';

/// Adapter that wraps Supabase StorageServiceWrapper to implement IStorageService
/// This allows using Supabase Storage through the interface
class SupabaseStorageAdapter implements IStorageService {
  final SupabaseStorageServiceWrapper _storageService;

  SupabaseStorageAdapter(this._storageService);

  @override
  Future<String> uploadFile({
    required String path,
    required dynamic file, // File or XFile
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    // Extract folder path and filename from path
    final pathParts = path.split('/');
    final folderPath = pathParts.length > 1
        ? pathParts.sublist(0, pathParts.length - 1).join('/')
        : '';
    final finalFileName = fileName ?? pathParts.last;

    return await _storageService.uploadFile(
      file,
      folderPath.isEmpty ? '' : '$folderPath/',
      finalFileName,
    );
  }

  @override
  Future<void> deleteFile(String path) {
    return _storageService.deleteFile(path);
  }

  @override
  Future<String> getDownloadUrl(String path) {
    return _storageService.getDownloadUrl(path);
  }

  @override
  Future<List<String>> listFiles(String path) async {
    final fileObjects = await _storageService.listFiles(path);
    return fileObjects.map((file) => file.name).toList();
  }

  @override
  Future<String> uploadFileWithProgress({
    required String path,
    required dynamic file,
    String? fileName,
    Function(double progress)? onProgress,
    Map<String, String>? metadata,
  }) async {
    // Supabase doesn't have built-in progress tracking
    // For now, just call uploadFile (can be enhanced later)
    return await uploadFile(
      path: path,
      file: file,
      fileName: fileName,
      metadata: metadata,
    );
  }

  @override
  Future<String> downloadFile(String path, String localPath) {
    // Supabase doesn't have direct download-to-file
    // Get URL and download using HTTP (can be enhanced later)
    throw UnimplementedError(
      'Direct file download not yet implemented for Supabase adapter',
    );
  }
}
