// test/helpers/mock_google_sign_in_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:atitia/core/services/external/google/google_sign_in_service.dart';
import 'package:atitia/common/utils/exceptions/exceptions.dart';

/// Mock GoogleSignInServiceWrapper for unit testing
/// Note: Does not extend the real class to avoid Firebase initialization
/// Implements the same interface for testing purposes
class MockGoogleSignInServiceWrapper implements GoogleSignInServiceWrapper {
  User? _mockFirebaseUser;
  GoogleSignInAccount? _mockGoogleAccount;
  bool _shouldThrow = false;
  Exception? _exceptionToThrow;

  MockGoogleSignInServiceWrapper({
    User? mockFirebaseUser,
    GoogleSignInAccount? mockGoogleAccount,
  })  : _mockFirebaseUser = mockFirebaseUser,
        _mockGoogleAccount = mockGoogleAccount;

  void setMockFirebaseUser(User? user) {
    _mockFirebaseUser = user;
  }

  void setMockGoogleAccount(GoogleSignInAccount? account) {
    _mockGoogleAccount = account;
  }

  void setShouldThrow(bool shouldThrow, [Exception? exception]) {
    _shouldThrow = shouldThrow;
    _exceptionToThrow = exception;
  }

  @override
  Future<void> initialize({String? clientId, String? serverClientId}) async {
    // Mock implementation - do nothing
  }

  @override
  Future<User?> signInWithGoogle() async {
    if (_shouldThrow) {
      throw _exceptionToThrow ??
          AppException(
            message: 'Mock Google sign-in error',
            severity: ErrorSeverity.medium,
          );
    }
    return _mockFirebaseUser;
  }

  @override
  Future<void> signOut() async {
    _mockFirebaseUser = null;
    _mockGoogleAccount = null;
  }

  @override
  GoogleSignInAccount? get currentUser => _mockGoogleAccount;

  // Implement other required methods from GoogleSignInServiceWrapper
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
