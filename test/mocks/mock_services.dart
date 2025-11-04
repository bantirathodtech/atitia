// test/mocks/mock_services.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Mock implementations of Firebase services for testing
/// These mocks allow us to test ViewModels and Repositories without
/// actual Firebase connections
///
/// Note: Using stub implementations instead of extending classes with
/// factory constructors (which is not allowed in Dart)

// Mock Firebase Auth Service - using composition instead of extension
class MockAuthenticationServiceWrapper {
  User? get currentUser => _mockUser;
  String? get currentUserId => _mockUser?.uid;
  bool get isSignedIn => _isSignedIn;

  User? _mockUser;
  bool _isSignedIn = false;
  String? _mockToken;

  Future<void> initialize() async {}
  Future<void> signOut() async {
    _isSignedIn = false;
    _mockUser = null;
  }

  Future<String?> getIdToken() async => _mockToken;
  Future<void> refreshIdToken() async {}

  void setMockUser(User? user) {
    _mockUser = user;
    _isSignedIn = user != null;
  }

  void setMockToken(String? token) {
    _mockToken = token;
  }
}

// Mock Firestore Service
class MockFirestoreServiceWrapper {
  final Map<String, Map<String, dynamic>> _mockData = {};

  Future<void> initialize() async {}
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    throw UnimplementedError('Use Firestore emulator for integration tests');
  }

  Future<void> setDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    _mockData['$collection/$docId'] = data;
  }

  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    final key = '$collection/$docId';
    _mockData[key] = {...?_mockData[key], ...data};
  }

  Future<void> deleteDocument(String collection, String docId) async {
    _mockData.remove('$collection/$docId');
  }

  Stream<DocumentSnapshot> getDocumentStream(String collection, String docId) {
    throw UnimplementedError('Use Firestore emulator for stream tests');
  }
}

// Mock Analytics Service
class MockAnalyticsServiceWrapper {
  Future<void> initialize() async {}
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {}
}

// Mock Cloud Messaging Service
class MockCloudMessagingServiceWrapper {
  Future<void> initialize() async {}
  Future<String?> getToken() async => 'mock_token';
  void setupForegroundHandler(Function(dynamic) handler) {}
  void setupBackgroundHandler(Function(dynamic) handler) {}
}

// Mock Crashlytics Service
class MockCrashlyticsServiceWrapper {
  Future<void> initialize() async {}
  Future<bool> isCrashlyticsCollectionEnabled() async => true;
  Future<void> enableCrashReporting() async {}
  Future<void> disableCrashReporting() async {}
}

// Mock Remote Config Service
class MockRemoteConfigServiceWrapper {
  final Map<String, dynamic> _config = {};

  Future<void> initialize() async {}
  Future<bool> fetchAndActivate() async => true;
  Map<String, dynamic> getAll() => _config;
  bool getBool(String key) => _config[key] ?? false;
  double getDouble(String key) => _config[key] ?? 0.0;
  String getString(String key) => _config[key] ?? '';

  void setConfig(Map<String, dynamic> config) {
    _config.addAll(config);
  }
}

// Mock Performance Monitoring Service
class MockPerformanceMonitoringServiceWrapper {
  Future<void> initialize() async {}
  Future<bool> isPerformanceCollectionEnabled() async => true;
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {}
  Future<void> startHttpMetric(String url) async {}
  Future<void> stopHttpMetric() async {}
}

// Mock Cloud Functions Service
class MockCloudFunctionsServiceWrapper {
  Future<void> initialize() async {}
  Future<Map<String, dynamic>> callFunction(
    String functionName,
    Map<String, dynamic> data,
  ) async {
    return {'success': true};
  }

  Future<void> createUserProfile(
      String userId, Map<String, dynamic> data) async {}
  Future<void> processPayment(Map<String, dynamic> paymentData) async {}
}

// Mock App Integrity Service
class MockAppIntegrityServiceWrapper {
  Future<void> initialize() async {}
  Future<String?> getFreshToken() async => 'mock_token';
  Future<void> checkIntegrity() async {}
}

// Mock Supabase Storage Service
class MockSupabaseStorageServiceWrapper {
  final Map<String, List<int>> _files = {};

  Future<void> initialize() async {}
  Future<String> uploadFile(String path, List<int> fileBytes) async {
    _files[path] = fileBytes;
    return 'https://mock-storage.url/$path';
  }

  Future<void> deleteFile(String path) async {
    _files.remove(path);
  }

  Future<String> getDownloadUrl(String path) async {
    return 'https://mock-storage.url/$path';
  }
}

// Mock Local Storage Service
class MockLocalStorageService {
  final Map<String, String> _storage = {};

  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  Future<String?> read(String key) async {
    return _storage[key];
  }

  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  Future<void> deleteAll() async {
    _storage.clear();
  }
}

/// Test data factories for creating mock data
class TestDataFactory {
  /// Creates mock Firestore document data
  static Map<String, dynamic> createMockDocumentData({
    String? id,
    Map<String, dynamic>? data,
  }) {
    return {
      'id': id ?? 'test_doc_id',
      ...?data,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates mock user document data
  static Map<String, dynamic> createMockUserDocumentData({
    String? userId,
    String? role,
    String? phoneNumber,
  }) {
    return {
      'userId': userId ?? 'test_user_123',
      'phoneNumber': phoneNumber ?? '+919876543210',
      'role': role ?? 'guest',
      'fullName': 'Test User',
      'email': 'test@example.com',
      'isActive': true,
      'isVerified': true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'lastLoginAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates mock PG document data
  static Map<String, dynamic> createMockPgDocumentData({
    String? pgId,
    String? ownerId,
    String? pgName,
  }) {
    return {
      'pgId': pgId ?? 'test_pg_123',
      'ownerId': ownerId ?? 'test_owner_123',
      'pgName': pgName ?? 'Test PG',
      'address': 'Test Address, Test City',
      'city': 'Test City',
      'area': 'Test Area',
      'pincode': '500001',
      'pgType': 'Boys',
      'mealType': 'Veg',
      'pricing': {
        'monthly': 8000,
        'security': 5000,
      },
      'amenities': ['WiFi', 'AC', 'Parking'],
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates mock booking request document data
  static Map<String, dynamic> createMockBookingRequestData({
    String? requestId,
    String? guestId,
    String? pgId,
    String? ownerId,
  }) {
    return {
      'requestId': requestId ?? 'test_request_123',
      'guestId': guestId ?? 'test_guest_123',
      'guestName': 'Test Guest',
      'guestPhone': '+919876543210',
      'guestEmail': 'guest@example.com',
      'pgId': pgId ?? 'test_pg_123',
      'pgName': 'Test PG',
      'ownerId': ownerId ?? 'test_owner_123',
      'ownerUid': ownerId ?? 'test_owner_123',
      'status': 'pending',
      'message': 'Test booking request',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates mock guest document data
  static Map<String, dynamic> createMockGuestDocumentData({
    String? guestId,
    String? ownerId,
    String? pgId,
  }) {
    return {
      'guestId': guestId ?? 'test_guest_123',
      'ownerId': ownerId ?? 'test_owner_123',
      'pgId': pgId ?? 'test_pg_123',
      'guestName': 'Test Guest',
      'phoneNumber': '+919876543210',
      'email': 'guest@example.com',
      'roomAssignment': 'Room 101',
      'checkInDate': DateTime.now().toIso8601String(),
      'checkOutDate':
          DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      'status': 'active',
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
