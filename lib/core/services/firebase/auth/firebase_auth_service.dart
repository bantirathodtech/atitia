import 'package:firebase_auth/firebase_auth.dart';

/// Generic Firebase Authentication service for auth operations.
///
/// Responsibility:
/// - Handle phone authentication (OTP)
/// - Manage user sessions
/// - Provide current user information
///
/// Note: This is a reusable core service - never modify for app-specific logic
class AuthenticationServiceWrapper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Private constructor for singleton pattern
  AuthenticationServiceWrapper._privateConstructor();
  static final AuthenticationServiceWrapper _instance =
      AuthenticationServiceWrapper._privateConstructor();

  /// Factory constructor to provide singleton instance
  factory AuthenticationServiceWrapper() => _instance;

  /// Initialize authentication service
  Future<void> initialize() async {
    // Firebase Auth initializes automatically with Firebase.initializeApp()
    await Future.delayed(Duration.zero);
  }

  /// Gets the current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Gets the current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Checks if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Gets the current user's ID token
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  /// Refreshes the current user's ID token
  Future<void> refreshIdToken() async {
    await _auth.currentUser?.getIdToken(true);
  }

  /// Verifies phone number for OTP authentication.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  /// Signs in the user with provided phone authentication credential.
  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  /// Attempts to auto-login by checking for an existing user session.
  ///
  /// Returns `true` if a user session is present; `false` otherwise.
  ///
  /// This method does NOT perform any business logic beyond Firebase Auth check.
  /// Higher-level app logic (e.g. fetching additional user data) should be implemented in app-level providers.
  Future<bool> tryAutoLogin() async {
    final user = _auth.currentUser;
    return user != null;
  }
}
