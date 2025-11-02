// lib/core/interfaces/auth/auth_service_interface.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

/// Abstract interface for authentication operations
/// Implementations: Firebase Auth, Supabase Auth, REST API
/// Allows swapping auth backends without changing repository code
///
/// Note: Currently uses Firebase Auth types for compatibility.
/// Future: Create adapter types to fully abstract from Firebase.
abstract class IAuthService {
  /// Gets current authenticated user ID
  String? get currentUserId;

  /// Gets current authenticated user (Firebase User type for now)
  fb_auth.User? get currentUser;

  /// Verifies phone number and sends OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  });

  /// Verifies OTP and signs in
  Future<fb_auth.UserCredential> verifyOTPAndSignIn({
    required String verificationId,
    required String smsCode,
  });

  /// Signs out current user
  Future<void> signOut();

  /// Refreshes authentication token
  Future<void> refreshToken();

  /// Checks if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Gets ID token
  Future<String?> getIdToken();

  /// Attempts auto-login
  Future<bool> tryAutoLogin();

  /// Signs in with credential (for OTP verification)
  Future<fb_auth.UserCredential> signInWithCredential(
      fb_auth.AuthCredential credential);
}
