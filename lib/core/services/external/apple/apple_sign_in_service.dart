import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../common/utils/exceptions/exceptions.dart';
import '../../firebase/auth/firebase_auth_service.dart';

/// Apple Sign-In service for Firebase authentication
///
/// Responsibility:
/// - Handle Apple ID authentication
/// - Integrate with Firebase Auth
/// - Manage Apple Sign-In lifecycle
/// - Works on iOS and macOS
///
/// Note: This is a reusable core service - never modify for app-specific logic
class AppleSignInServiceWrapper {
  final AuthenticationServiceWrapper _authService;
  AuthorizationCredentialAppleID? _currentCredential;

  // Private constructor for dependency injection
  AppleSignInServiceWrapper({
    required AuthenticationServiceWrapper authService,
  }) : _authService = authService;

  /// Initialize Apple Sign-In service
  Future<void> initialize() async {
    try {
      // Check if Apple Sign-In is available on this platform
      if (!await SignInWithApple.isAvailable()) {
        return;
      }
      
    } catch (e) {
      // Don't throw - let the app continue without Apple Sign-In
    }
  }

  /// Signs in a user with Apple ID and returns Firebase [User]
  Future<User?> signInWithApple() async {
    try {
      
      // Check if Apple Sign-In is available
      if (!await SignInWithApple.isAvailable()) {
        throw AppException(
          message: 'Apple Sign-In not available on this platform',
          details: 'Apple Sign-In is only available on iOS 13+ and macOS 10.15+',
        );
      }

      
      // Request Apple ID authentication
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      _currentCredential = credential;

      // Create Firebase credential from Apple ID credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      
      if (oauthCredential.accessToken == null) {
        throw AppException(message: 'Apple Sign-In failed: No access token received');
      }

      final userCredential = await _authService.signInWithCredential(oauthCredential);
      
      return userCredential.user;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw AppException(message: 'Apple sign-in canceled by user');
      } else if (e.code == AuthorizationErrorCode.failed) {
        throw AppException(message: 'Apple sign-in failed. Please try again.');
      } else if (e.code == AuthorizationErrorCode.invalidResponse) {
        throw AppException(message: 'Invalid response from Apple. Please try again.');
      } else if (e.code == AuthorizationErrorCode.notHandled) {
        throw AppException(message: 'Apple sign-in not handled. Please try again.');
      } else if (e.code == AuthorizationErrorCode.unknown) {
        throw AppException(message: 'Unknown Apple sign-in error. Please try again.');
      }
      throw AppException(message: 'Apple sign-in failed: ${e.message}');
    } catch (e) {
      if (e.toString().contains('not available')) {
        throw AppException(
          message: 'Apple Sign-In not available',
          details: 'Apple Sign-In requires iOS 13+ or macOS 10.15+',
          severity: ErrorSeverity.medium,
          recoverySuggestion: 'Please update your device or use phone authentication instead.',
        );
      }
      throw AppException(message: 'Apple sign-in failed: ${e.toString()}');
    }
  }

  /// Attempts silent sign-in without user interaction
  Future<User?> signInSilently() async {
    try {
      // Apple Sign-In doesn't support silent sign-in like Google
      // This method is kept for API consistency
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Signs out user from Apple and Firebase
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentCredential = null;
    } catch (e) {
      throw AppException(message: 'Apple sign-out failed: ${e.toString()}');
    }
  }

  /// Checks if user is currently signed in with Apple
  bool get isSignedIn => _currentCredential != null;

  /// Gets the current Apple credential
  AuthorizationCredentialAppleID? get currentCredential => _currentCredential;

  /// Gets the current Apple user ID
  String? get currentUserId => _currentCredential?.userIdentifier;

  /// Gets the current Apple user email
  String? get currentUserEmail => _currentCredential?.email;

  /// Gets the current Apple user full name
  String? get currentUserFullName {
    final credential = _currentCredential;
    if (credential == null) return null;
    
    final givenName = credential.givenName ?? '';
    final familyName = credential.familyName ?? '';
    
    if (givenName.isEmpty && familyName.isEmpty) return null;
    if (givenName.isEmpty) return familyName;
    if (familyName.isEmpty) return givenName;
    
    return '$givenName $familyName';
  }

  /// Check if Apple Sign-In is available on this platform
  Future<bool> get isAvailable async {
    return await SignInWithApple.isAvailable();
  }
}
