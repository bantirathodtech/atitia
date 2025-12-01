// lib/core/adapters/firebase/extended_auth_service_adapter.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import '../../interfaces/auth/extended_auth_service_interface.dart';
import '../../services/firebase/auth/firebase_auth_service.dart';

/// Adapter that wraps AuthenticationServiceWrapper to implement IExtendedAuthService
/// This allows using Firebase implementation through the extended interface
class ExtendedAuthServiceAdapter implements IExtendedAuthService {
  final AuthenticationServiceWrapper _authService;

  ExtendedAuthServiceAdapter(this._authService);

  // IAuthService implementation (delegated)
  @override
  String? get currentUserId => _authService.currentUserId;

  @override
  fb_auth.User? get currentUser => _authService.currentUser;

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) {
    return _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Future<fb_auth.UserCredential> verifyOTPAndSignIn({
    required String verificationId,
    required String smsCode,
  }) {
    return _authService.verifyOTPAndSignIn(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  Future<void> refreshToken() {
    return _authService.refreshIdToken();
  }

  @override
  Future<String?> getIdToken() {
    return _authService.getIdToken();
  }

  @override
  Future<bool> tryAutoLogin() {
    return _authService.tryAutoLogin();
  }

  @override
  Future<fb_auth.UserCredential> signInWithCredential(
      fb_auth.AuthCredential credential) {
    return _authService.signInWithCredential(credential);
  }

  @override
  bool get isAuthenticated => _authService.isSignedIn;

  // IExtendedAuthService implementation
  @override
  String get platformName => _authService.platformName;

  @override
  List<String> getAvailableAuthMethods() {
    return _authService.getAvailableAuthMethods();
  }

  @override
  bool isAuthMethodAvailable(String method) {
    return _authService.isAuthMethodAvailable(method);
  }

  @override
  Future<fb_auth.UserCredential?> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }

  @override
  Future<fb_auth.UserCredential?> silentSignInWithGoogle() {
    return _authService.silentSignInWithGoogle();
  }

  @override
  Future<fb_auth.UserCredential?> signInWithGoogleWeb(
      GoogleSignInCredentials credentials) {
    return _authService.signInWithGoogleWeb(credentials);
  }

  @override
  Widget? getGoogleSignInButton() {
    return _authService.getGoogleSignInButton();
  }

  @override
  Stream<GoogleSignInCredentials?> get googleSignInState {
    return _authService.googleSignInState;
  }

  @override
  Future<void> signOutFromGoogle() {
    return _authService.signOutFromGoogle();
  }

  @override
  Future<fb_auth.UserCredential?> signInWithApple() {
    return _authService.signInWithApple();
  }

  @override
  Future<void> sendOTPToPhone({
    required String phoneNumber,
    required Duration timeout,
    required fb_auth.PhoneVerificationCompleted verificationCompleted,
    required fb_auth.PhoneVerificationFailed verificationFailed,
    required fb_auth.PhoneCodeSent codeSent,
    required fb_auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) {
    return _authService.sendOTPToPhone(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Future<void> signOutFromAll() {
    return _authService.signOutFromAll();
  }

  @override
  bool get isSignedIn => _authService.isSignedIn;
}
