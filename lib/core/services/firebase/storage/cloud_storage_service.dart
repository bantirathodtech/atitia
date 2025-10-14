import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Generic Firebase Storage service for file operations.
///
/// Responsibility:
/// - Handle file uploads to Firebase Storage
/// - Manage file downloads and URL generation
/// - Provide file deletion and metadata operations
///
/// Note: This is a reusable core service - never modify for app-specific logic
class CloudStorageServiceWrapper {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageServiceWrapper._privateConstructor();
  static final CloudStorageServiceWrapper _instance =
      CloudStorageServiceWrapper._privateConstructor();

  /// Factory constructor to provide singleton instance
  factory CloudStorageServiceWrapper() => _instance;

  /// Initialize Cloud Storage service
  Future<void> initialize() async {
    // Cloud Storage initializes automatically with Firebase.initializeApp()
    await Future.delayed(Duration.zero);
  }

  /// Uploads file to Firebase Storage under specified path
  ///
  /// Parameters:
  /// - [file]: The file to upload
  /// - [folderPath]: Storage folder path (e.g., 'profile_photos/')
  /// - [fileName]: Name for the uploaded file
  ///
  /// Returns: Public download URL after successful upload
  Future<String> uploadFile(
      File file, String folderPath, String fileName) async {
    final ref = _storage.ref().child(folderPath).child(fileName);
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() {});
    return await ref.getDownloadURL();
  }

  /// Retrieves download URL for a file at specified path
  Future<String> getDownloadUrl(String filePath) async {
    final ref = _storage.ref().child(filePath);
    return await ref.getDownloadURL();
  }

  /// Deletes file from Firebase Storage
  Future<void> deleteFile(String filePath) async {
    final ref = _storage.ref().child(filePath);
    await ref.delete();
  }
}
