// test/helpers/viewmodel_test_setup.dart

import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/core/services/firebase/analytics/firebase_analytics_service.dart';
import 'package:atitia/core/services/firebase/auth/firebase_auth_service.dart';
import 'package:atitia/core/services/firebase/database/firestore_database_service.dart';
import 'package:atitia/core/services/supabase/storage/supabase_storage_service.dart';
import 'package:atitia/core/services/localization/internationalization_service.dart';
import 'package:atitia/core/services/external/google/google_sign_in_service.dart';
import 'package:atitia/core/services/external/apple/apple_sign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:atitia/firebase_options.dart';
import 'mock_google_sign_in_service.dart';
import 'mock_apple_sign_in_service.dart';

/// Mock AuthenticationServiceWrapper for unit tests
/// Note: Cannot extend AuthenticationServiceWrapper due to private constructor
/// So we create a simple mock that provides the same interface
class MockAuthenticationServiceWrapper {
  final String? _mockUserId;
  final User? _mockUser;

  MockAuthenticationServiceWrapper({String? mockUserId, User? mockUser})
      : _mockUserId = mockUserId ?? 'test_user_123',
        _mockUser = mockUser;

  String? get currentUserId => _mockUserId;

  User? get currentUser => _mockUser;

  bool get isSignedIn => _mockUserId != null;

  Future<void> signOut() async {
    // Mock implementation - do nothing
  }

  Future<String?> getIdToken() async {
    return 'mock_token';
  }

  Future<void> refreshIdToken() async {
    // Mock implementation - do nothing
  }
}

/// Test setup for ViewModel unit tests
/// Mocks GetIt services to allow testing without Firebase
class ViewModelTestSetup {
  static bool _isInitialized = false;
  static String? _mockUserId;

  /// Initialize GetIt with mock services
  /// Call this in setUpAll() before any ViewModel tests
  /// [mockUserId] - Optional user ID to use for currentUser (default: 'test_user_123')
  static Future<void> initialize({String? mockUserId}) async {
    if (_isInitialized) return;
    _mockUserId = mockUserId ?? 'test_user_123';

    // Initialize Flutter binding first (required for Firebase in tests)
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase minimally for unit tests
    // This is required for AuthenticationServiceWrapper to work
    try {
      // Check if Firebase is already initialized
      try {
        Firebase.app();
        // Firebase is already initialized
      } catch (_) {
        // Firebase not initialized, initialize it now
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      // Firebase might already be initialized - that's fine
      if (!e.toString().contains('duplicate-app') &&
          !e.toString().contains('already exists') &&
          !e.toString().contains('Binding has not yet been initialized')) {
        print('Warning: Firebase initialization failed: $e');
      }
    }

    // Reset GetIt if already initialized
    if (GetIt.instance.isRegistered<GetIt>()) {
      try {
        GetIt.instance.reset();
      } catch (e) {
        // Ignore reset errors
      }
    }

    // Register mock analytics service
    if (!GetIt.instance.isRegistered<AnalyticsServiceWrapper>()) {
      GetIt.instance.registerSingleton<AnalyticsServiceWrapper>(
        _MockAnalyticsService(),
      );
    }

    // Register auth service
    // Note: AuthenticationServiceWrapper is a singleton that requires Firebase to be initialized.
    // Try to register it, but if it fails (Firebase not initialized), we'll skip it.
    // Tests that require auth will fail with a clear error.
    if (!GetIt.instance.isRegistered<AuthenticationServiceWrapper>()) {
      try {
        GetIt.instance.registerSingleton<AuthenticationServiceWrapper>(
          AuthenticationServiceWrapper(),
        );
      } catch (e) {
        // If registration fails (Firebase not initialized), that's okay for unit tests.
        // Tests that require auth will fail, but that's expected.
        print('Note: AuthenticationServiceWrapper not registered (Firebase not initialized).');
        print('This is expected in unit tests. Tests requiring auth will fail.');
      }
    }

    // Register mock GoogleSignInServiceWrapper for AuthRepository
    if (!GetIt.instance.isRegistered<GoogleSignInServiceWrapper>()) {
      try {
        GetIt.instance.registerSingleton<GoogleSignInServiceWrapper>(
          MockGoogleSignInServiceWrapper(),
        );
      } catch (e) {
        // If registration fails, that's okay for unit tests
        print('Note: MockGoogleSignInServiceWrapper not registered: $e');
      }
    }

    // Register mock AppleSignInServiceWrapper for AuthRepository
    if (!GetIt.instance.isRegistered<AppleSignInServiceWrapper>()) {
      try {
        GetIt.instance.registerSingleton<AppleSignInServiceWrapper>(
          MockAppleSignInServiceWrapper(),
        );
      } catch (e) {
        // If registration fails, that's okay for unit tests
        print('Note: MockAppleSignInServiceWrapper not registered: $e');
      }
    }

    // Register FirestoreServiceWrapper and SupabaseStorageServiceWrapper
    // These are required by AuthProvider. They require Firebase to be initialized.
    // Use lazy registration so they're only created when needed (after Firebase is initialized)
    if (!GetIt.instance.isRegistered<FirestoreServiceWrapper>()) {
      GetIt.instance.registerLazySingleton<FirestoreServiceWrapper>(
        () {
          // FirestoreServiceWrapper is a singleton with factory constructor
          // It will be created when first accessed, after Firebase is initialized
          return FirestoreServiceWrapper();
        },
      );
    }

    if (!GetIt.instance.isRegistered<SupabaseStorageServiceWrapper>()) {
      GetIt.instance.registerLazySingleton<SupabaseStorageServiceWrapper>(
        () {
          // SupabaseStorageServiceWrapper is a singleton with factory constructor
          // It will be created when first accessed, after Firebase is initialized
          return SupabaseStorageServiceWrapper();
        },
      );
    }

    // Register mock internationalization service
    // Note: InternationalizationService is a singleton, so we need to handle it differently
    // For now, we'll let it use the real instance but it should work in tests

    _isInitialized = true;
  }

  /// Reset GetIt after tests
  /// Call this in tearDownAll()
  static void reset() {
    try {
      if (GetIt.instance.isRegistered<GetIt>()) {
        GetIt.instance.reset();
      }
    } catch (e) {
      // Ignore reset errors
    }
    _isInitialized = false;
  }
}

/// Mock Analytics Service for testing
/// Uses composition instead of inheritance since AnalyticsServiceWrapper has private constructor
class _MockAnalyticsService implements AnalyticsServiceWrapper {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserId(String? userId) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> resetAnalyticsData() async {
    // Mock implementation - do nothing
  }

  // Additional methods from AnalyticsServiceWrapper
  @override
  Future<void> logUserRegistration({String method = 'phone'}) async {}

  @override
  Future<void> logPropertySearch({
    required String query,
    int? resultsCount,
  }) async {}

  @override
  Future<void> logBookingInitiated(
    String propertyId,
    String bookingType,
  ) async {}

  @override
  Future<void> logPaymentCompleted(
    double amount,
    String paymentMethod,
  ) async {}

  @override
  Future<void> logPropertyView({
    required String propertyId,
    required String propertyType,
    double? price,
    String? location,
  }) async {}

  @override
  Future<void> logBookingCompleted({
    required String propertyId,
    required double amount,
    required int durationDays,
    String? paymentMethod,
  }) async {}

  @override
  Future<void> logUserProfileUpdate({
    required String updateType,
    bool? hasPhoto,
  }) async {}

  @override
  Future<void> logAppOpened() async {}

  @override
  Future<void> logAppBackgrounded() async {}

  @override
  Future<void> logError({
    required String errorType,
    required String message,
    String? screenName,
  }) async {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}
}

// Note: AuthenticationServiceWrapper has a private constructor, so we can't mock it directly.
// The ViewModel uses `getIt.auth.currentUser?.uid ?? ''`, which handles null gracefully.
// For tests, we'll rely on the null-safe operator and empty string fallback.

/// Mock User for testing
class _MockUser implements User {
  final String _uid;

  _MockUser(this._uid);

  @override
  String get uid => _uid;

  @override
  String? get email => null;

  @override
  String? get displayName => null;

  @override
  String? get photoURL => null;

  @override
  String? get phoneNumber => null;

  @override
  bool get emailVerified => false;

  @override
  bool get isAnonymous => false;

  @override
  UserMetadata get metadata => _MockUserMetadata();

  @override
  List<UserInfo> get providerData => [];

  @override
  String? get refreshToken => null;

  @override
  String? get tenantId => null;

  @override
  Future<void> delete() async {}

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock_token';

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async {
    throw UnimplementedError('Mock getIdTokenResult');
  }

  @override
  Future<void> reload() async {}

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}

  @override
  Future<User> unlink(String providerId) async => this;

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updateEmail(String newEmail) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) async {}

  // Additional methods required by User interface
  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async {
    throw UnimplementedError('Mock linkWithCredential');
  }

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(
    String phoneNumber, [
    RecaptchaVerifier? verifier,
  ]) async {
    throw UnimplementedError('Mock linkWithPhoneNumber');
  }

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) async {
    throw UnimplementedError('Mock linkWithPopup');
  }

  @override
  Future<void> linkWithRedirect(AuthProvider provider) async {
    throw UnimplementedError('Mock linkWithRedirect');
  }

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) async {
    throw UnimplementedError('Mock linkWithProvider');
  }

  @override
  MultiFactor get multiFactor => throw UnimplementedError('Mock multiFactor');

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    throw UnimplementedError('Mock reauthenticateWithCredential');
  }

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) async {
    throw UnimplementedError('Mock reauthenticateWithPopup');
  }

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) async {
    throw UnimplementedError('Mock reauthenticateWithRedirect');
  }

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) async {
    throw UnimplementedError('Mock reauthenticateWithProvider');
  }
}

/// Mock UserMetadata for testing
class _MockUserMetadata implements UserMetadata {
  @override
  DateTime? get creationTime => DateTime.now();

  @override
  DateTime? get lastSignInTime => DateTime.now();
}

