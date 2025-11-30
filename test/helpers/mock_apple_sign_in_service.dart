// test/helpers/mock_apple_sign_in_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:atitia/core/services/external/apple/apple_sign_in_service.dart';
import 'package:atitia/common/utils/exceptions/exceptions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Mock AppleSignInServiceWrapper for unit testing
/// Note: Does not extend the real class to avoid Firebase initialization
/// Implements the same interface for testing purposes
class MockAppleSignInServiceWrapper implements AppleSignInServiceWrapper {
  User? _mockUser;
  bool _shouldThrow = false;
  Exception? _exceptionToThrow;

  MockAppleSignInServiceWrapper({
    User? mockUser,
  }) : _mockUser = mockUser;

  void setMockUser(User? user) {
    _mockUser = user;
  }

  void setShouldThrow(bool shouldThrow, [Exception? exception]) {
    _shouldThrow = shouldThrow;
    _exceptionToThrow = exception;
  }

  @override
  Future<void> initialize() async {
    // Mock implementation - do nothing
  }

  @override
  Future<User?> signInWithApple() async {
    if (_shouldThrow) {
      throw _exceptionToThrow ??
          AppException(
            message: 'Mock Apple sign-in error',
            severity: ErrorSeverity.medium,
          );
    }
    return _mockUser;
  }

  @override
  Future<void> signOut() async {
    _mockUser = null;
  }

  @override
  AuthorizationCredentialAppleID? get currentCredential => null;

  @override
  bool get isSignedIn => _mockUser != null;

  @override
  String? get currentUserId => _mockUser?.uid;

  @override
  String? get currentUserEmail => _mockUser?.email;

  @override
  String? get currentUserFullName => _mockUser?.displayName;

  @override
  Future<bool> get isAvailable async => true;

  // Implement other required methods from AppleSignInServiceWrapper
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

