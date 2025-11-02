// lib/core/adapters/firebase/firebase_auth_adapter.dart

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../interfaces/auth/auth_service_interface.dart';
import '../../services/firebase/auth/firebase_auth_service.dart';

/// Adapter that wraps Firebase AuthenticationServiceWrapper to implement IAuthService
/// This allows using Firebase implementation through the interface
class FirebaseAuthAdapter implements IAuthService {
  final AuthenticationServiceWrapper _authService;

  FirebaseAuthAdapter(this._authService);

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
    // Create PhoneAuthCredential from verification ID and SMS code
    final credential = fb_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    // Sign in with the credential
    return _authService.signInWithCredential(credential);
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
}
