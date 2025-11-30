// lib/core/interfaces/auth/extended_auth_service_interface.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import 'auth_service_interface.dart';

/// Extended authentication service interface that includes platform-specific methods
/// This interface is used by AuthProvider which needs both basic auth and platform-specific features
abstract class IExtendedAuthService implements IAuthService {
  // Platform Detection
  String get platformName;
  List<String> getAvailableAuthMethods();
  bool isAuthMethodAvailable(String method);

  // Google Sign-In
  Future<fb_auth.UserCredential?> signInWithGoogle();
  Future<fb_auth.UserCredential?> silentSignInWithGoogle();
  Future<fb_auth.UserCredential?> signInWithGoogleWeb(
      GoogleSignInCredentials credentials);
  Widget? getGoogleSignInButton();
  Stream<GoogleSignInCredentials?> get googleSignInState;
  Future<void> signOutFromGoogle();

  // Apple Sign-In
  Future<fb_auth.UserCredential?> signInWithApple();

  // Phone Authentication (alias for verifyPhoneNumber)
  Future<void> sendOTPToPhone({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  });

  // Enhanced Sign Out
  Future<void> signOutFromAll();

  // Additional properties
  bool get isSignedIn;
}

