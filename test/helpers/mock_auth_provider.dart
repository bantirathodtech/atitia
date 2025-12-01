// test/helpers/mock_auth_provider.dart

import 'package:atitia/feature/auth/logic/auth_provider.dart';
import 'package:atitia/feature/auth/data/model/user_model.dart';
import 'package:atitia/core/services/firebase/database/firestore_database_service.dart';
import 'package:atitia/core/services/supabase/storage/supabase_storage_service.dart';
import 'package:atitia/core/navigation/navigation_service.dart';
import 'package:atitia/core/db/flutter_secure_storage.dart';
import 'package:atitia/feature/auth/data/repository/auth_repository.dart';
import 'package:atitia/core/interfaces/auth/extended_auth_service_interface.dart';
import 'package:atitia/core/interfaces/auth/auth_service_interface.dart';
import 'package:atitia/core/interfaces/analytics/analytics_service_interface.dart';
import 'package:atitia/core/services/external/google/google_sign_in_service.dart';
import 'package:atitia/core/services/external/apple/apple_sign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'mock_google_sign_in_service.dart';
import 'mock_apple_sign_in_service.dart';

/// Mock AuthProvider for unit testing
/// Provides a minimal implementation that doesn't require Firebase initialization
class MockAuthProvider extends AuthProvider {
  final String? _mockUserId;
  final UserModel? _mockUser;

  MockAuthProvider({
    String? mockUserId,
    UserModel? mockUser,
    IExtendedAuthService? authService,
    FirestoreServiceWrapper? firestoreService,
    LocalStorageService? localStorage,
    SupabaseStorageServiceWrapper? storageService,
    NavigationService? navigation,
    IAnalyticsService? analyticsService,
    AuthRepository? repository,
  })  : _mockUserId = mockUserId,
        _mockUser = mockUser,
        super(
          authService:
              authService ?? _MockExtendedAuthService(mockUserId: mockUserId),
          firestoreService: firestoreService ?? _createMockFirestoreService(),
          localStorage: localStorage ?? LocalStorageService(),
          storageService: storageService ?? _createMockStorageService(),
          navigation: navigation ?? NavigationService(createMockGoRouter()),
          analyticsService: analyticsService ?? _MockIAnalyticsService(),
          repository: repository ??
              _MockAuthRepository(
                authService: _MockIAuthService(mockUserId: mockUserId),
                analyticsService: analyticsService ?? _MockIAnalyticsService(),
              ),
        );

  @override
  UserModel? get user {
    if (_mockUser != null) return _mockUser;
    if (_mockUserId == null) return null;
    return UserModel(
      userId: _mockUserId!,
      phoneNumber: '+919876543210',
      role: 'guest',
      createdAt: DateTime.now(),
    );
  }

  // Override methods that might cause issues in tests
  @override
  Future<void> _initializeUserData() async {
    // Skip initialization in tests - user is set via getter
  }
}

/// Mock AuthRepository that accepts all dependencies via constructor
/// Now that AuthRepository accepts GoogleSignInServiceWrapper and AppleSignInServiceWrapper
/// as constructor parameters, we can create a mock without GetIt dependencies
class _MockAuthRepository extends AuthRepository {
  _MockAuthRepository({
    IAuthService? authService,
    IAnalyticsService? analyticsService,
    GoogleSignInServiceWrapper? googleSignInService,
    AppleSignInServiceWrapper? appleSignInService,
  }) : super(
          authService: authService ?? _MockIAuthService(),
          analyticsService: analyticsService ?? _MockIAnalyticsService(),
          googleSignInService:
              googleSignInService ?? MockGoogleSignInServiceWrapper(),
          appleSignInService:
              appleSignInService ?? MockAppleSignInServiceWrapper(),
        );
}

/// Mock IAuthService implementation
class _MockIAuthService implements IAuthService {
  final String? _mockUserId;

  _MockIAuthService({String? mockUserId}) : _mockUserId = mockUserId;

  @override
  String? get currentUserId => _mockUserId;

  @override
  fb_auth.User? get currentUser => null;

  @override
  bool get isAuthenticated => _mockUserId != null;

  @override
  Future<String?> getIdToken() async => null;

  @override
  Future<void> refreshToken() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<fb_auth.UserCredential> signInWithCredential(
      fb_auth.AuthCredential credential) async {
    throw UnimplementedError('signInWithCredential not implemented in mock');
  }

  @override
  Future<bool> tryAutoLogin() async => false;

  @override
  Future<fb_auth.UserCredential> verifyOTPAndSignIn({
    required String verificationId,
    required String smsCode,
  }) async {
    throw UnimplementedError('verifyOTPAndSignIn not implemented in mock');
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    throw UnimplementedError('verifyPhoneNumber not implemented in mock');
  }
}

/// Mock IAnalyticsService implementation
class _MockIAnalyticsService implements IAnalyticsService {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {}

  @override
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {}

  @override
  Future<void> resetAnalyticsData() async {}
}

/// Mock implementation of IExtendedAuthService for unit testing
class _MockExtendedAuthService implements IExtendedAuthService {
  final String? _mockUserId;

  _MockExtendedAuthService({String? mockUserId}) : _mockUserId = mockUserId;

  // IAuthService implementation
  @override
  String? get currentUserId => _mockUserId;

  @override
  fb_auth.User? get currentUser => null;

  @override
  bool get isAuthenticated => _mockUserId != null;

  @override
  Future<String?> getIdToken() async => 'mock_token';

  @override
  Future<void> refreshToken() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<fb_auth.UserCredential> signInWithCredential(
      fb_auth.AuthCredential credential) async {
    throw UnimplementedError('signInWithCredential not implemented in mock');
  }

  @override
  Future<bool> tryAutoLogin() async => _mockUserId != null;

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    throw UnimplementedError('verifyPhoneNumber not implemented in mock');
  }

  @override
  Future<fb_auth.UserCredential> verifyOTPAndSignIn({
    required String verificationId,
    required String smsCode,
  }) async {
    throw UnimplementedError('verifyOTPAndSignIn not implemented in mock');
  }

  // IExtendedAuthService implementation
  @override
  String get platformName => 'Test';

  @override
  List<String> getAvailableAuthMethods() => ['phone', 'google'];

  @override
  bool isAuthMethodAvailable(String method) => true;

  @override
  Future<fb_auth.UserCredential?> signInWithGoogle() async => null;

  @override
  Future<fb_auth.UserCredential?> silentSignInWithGoogle() async => null;

  @override
  Future<fb_auth.UserCredential?> signInWithGoogleWeb(
      GoogleSignInCredentials credentials) async {
    throw UnimplementedError('signInWithGoogleWeb not implemented in mock');
  }

  @override
  Widget? getGoogleSignInButton() => null;

  @override
  Stream<GoogleSignInCredentials?> get googleSignInState => Stream.value(null);

  @override
  Future<void> signOutFromGoogle() async {}

  @override
  Future<fb_auth.UserCredential?> signInWithApple() async => null;

  @override
  Future<void> sendOTPToPhone({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    throw UnimplementedError('sendOTPToPhone not implemented in mock');
  }

  @override
  Future<void> signOutFromAll() async {}

  @override
  bool get isSignedIn => _mockUserId != null;
}

/// Helper functions to create mocks for FirestoreServiceWrapper and SupabaseStorageServiceWrapper
/// Since these classes have factory constructors and require Firebase, we try to get them from GetIt
/// If they're not available, we'll let AuthProvider throw a helpful error
FirestoreServiceWrapper? _createMockFirestoreService() {
  try {
    // Try to get from GetIt if registered
    return GetIt.instance.isRegistered<FirestoreServiceWrapper>()
        ? GetIt.instance<FirestoreServiceWrapper>()
        : null;
  } catch (_) {
    return null;
  }
}

SupabaseStorageServiceWrapper? _createMockStorageService() {
  try {
    // Try to get from GetIt if registered
    return GetIt.instance.isRegistered<SupabaseStorageServiceWrapper>()
        ? GetIt.instance<SupabaseStorageServiceWrapper>()
        : null;
  } catch (_) {
    return null;
  }
}

/// Mock GoRouter for testing
/// GoRouter has a factory constructor, so we can't extend it
/// We'll use a simple approach: create a minimal GoRouter instance
GoRouter createMockGoRouter() {
  return GoRouter(
    routes: [],
    initialLocation: '/',
    debugLogDiagnostics: false,
  );
}
