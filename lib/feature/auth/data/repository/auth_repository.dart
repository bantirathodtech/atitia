import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../../../common/utils/exceptions/exceptions.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../model/user_model.dart';

/// Repository for authentication operations
/// Handles phone OTP, Google sign-in, and user session management
/// Enhanced with analytics tracking and comprehensive error handling
class AuthRepository {
  final _authService = getIt.auth;
  final _googleSignInService = getIt.googleSignIn;
  final _appleSignInService = getIt.appleSignIn;
  final _analyticsService = getIt.analytics;

  /// Sends OTP verification code
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    try {
      await _analyticsService.logEvent(
        name: 'auth_send_otp_start',
        parameters: {'phone_number': phoneNumber},
      );

      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      await _analyticsService.logEvent(
        name: 'auth_otp_sent',
        parameters: {'phone_number': phoneNumber},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_send_otp_error',
        parameters: {'phone_number': phoneNumber, 'error': e.toString()},
      );
      throw AppException(
        message: 'Failed to send OTP',
        details: e.toString(),
        severity: ErrorSeverity.medium,
        recoverySuggestion: 'Please check your phone number and try again',
      );
    }
  }


  /// Verifies OTP and signs in user
  Future<UserModel> verifySmsCode(fb_auth.PhoneAuthCredential credential) async {
    try {
      await _analyticsService.logEvent(
        name: 'auth_verify_otp_start',
      );

      final userCredential = await _authService.signInWithCredential(credential);
      final fbUser = userCredential.user;

      if (fbUser == null) {
        throw AppException(
          message: 'User not found after sign in',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'auth_otp_verified',
        parameters: {'user_id': fbUser.uid},
      );

      return UserModel(
        userId: fbUser.uid,
        phoneNumber: fbUser.phoneNumber ?? '',
        role: 'guest',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_verify_otp_error',
        parameters: {'error': e.toString()},
      );
      throw AppException(
        message: 'OTP verification failed',
        details: e.toString(),
        severity: ErrorSeverity.high,
        recoverySuggestion: 'Please check the OTP and try again',
      );
    }
  }

  /// Signs in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      await _analyticsService.logEvent(
        name: 'auth_google_signin_start',
      );

      final fbUser = await _googleSignInService.signInWithGoogle();

      if (fbUser == null) {
        throw AppException(
          message: 'Google sign-in was cancelled',
          severity: ErrorSeverity.low,
        );
      }

      await _analyticsService.logEvent(
        name: 'auth_google_signin_success',
        parameters: {'user_id': fbUser.uid},
      );

      return UserModel(
        userId: fbUser.uid,
        phoneNumber: fbUser.phoneNumber ?? '',
        role: 'guest',
        email: fbUser.email,
        fullName: fbUser.displayName,
        profilePhotoUrl: fbUser.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_google_signin_error',
        parameters: {'error': e.toString()},
      );
      throw AppException(
        message: 'Google sign-in failed',
        details: e.toString(),
        severity: ErrorSeverity.medium,
        recoverySuggestion: 'Please try again or use phone authentication',
      );
    }
  }

  /// Signs in with Apple
  Future<UserModel> signInWithApple() async {
    try {
      await _analyticsService.logEvent(
        name: 'auth_apple_signin_start',
      );

      final fbUser = await _appleSignInService.signInWithApple();

      if (fbUser == null) {
        throw AppException(
          message: 'Apple sign-in was cancelled',
          severity: ErrorSeverity.low,
        );
      }

      await _analyticsService.logEvent(
        name: 'auth_apple_signin_success',
        parameters: {'user_id': fbUser.uid},
      );

      return UserModel(
        userId: fbUser.uid,
        phoneNumber: fbUser.phoneNumber ?? '',
        role: 'guest',
        email: fbUser.email,
        fullName: fbUser.displayName,
        profilePhotoUrl: fbUser.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_apple_signin_error',
        parameters: {'error': e.toString()},
      );
      throw AppException(
        message: 'Apple sign-in failed',
        details: e.toString(),
        severity: ErrorSeverity.medium,
        recoverySuggestion: 'Please try again or use phone authentication',
      );
    }
  }

  /// Signs out user
  Future<void> logout() async {
    try {
      final userId = _authService.currentUserId;

      await _analyticsService.logEvent(
        name: 'auth_logout_start',
        parameters: {'user_id': userId ?? 'unknown'},
      );

      await _authService.signOut();

      await _analyticsService.logEvent(
        name: 'auth_logout_success',
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_logout_error',
        parameters: {'error': e.toString()},
      );
      throw AppException(
        message: 'Logout failed',
        details: e.toString(),
        severity: ErrorSeverity.medium,
      );
    }
  }

  /// Checks if user is authenticated
  bool get isAuthenticated => _authService.isSignedIn;

  /// Gets current user ID
  String? get currentUserId => _authService.currentUserId;
}
