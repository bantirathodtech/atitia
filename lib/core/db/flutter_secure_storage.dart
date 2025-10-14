import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// LocalStorageService provides secure local key-value storage.
///
/// Responsibility:
/// - Abstract flutter_secure_storage (or similar) for local data caching
/// - Maintain singleton instance for consistent access
/// - Provide simple async get/set/delete methods
///
/// Usage:
/// final storage = ServiceLocator.locator<LocalStorageService>();
/// await storage.write('user_uid', uid);
/// final uid = await storage.read('user_uid');
class LocalStorageService {
  final FlutterSecureStorage _secureStorage;

  LocalStorageService._internal()
      : _secureStorage = const FlutterSecureStorage();

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
