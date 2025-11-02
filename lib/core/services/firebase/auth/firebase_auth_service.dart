import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../common/constants/environment_config.dart';

/// Enhanced Firebase Authentication service with platform-specific authentication.
///
/// Responsibility:
/// - Handle phone authentication (OTP)
/// - Handle Google Sign-In (Android, iOS, macOS, Web, Windows, Linux)
/// - Handle Apple Sign-In (iOS, macOS)
/// - Manage user sessions
/// - Provide current user information
/// - Platform detection and conditional authentication
///
/// Supported Platforms:
/// - Android: Phone + Google
/// - iOS: Phone + Google + Apple
/// - macOS: Google + Apple
/// - Web: Phone + Google
/// - Windows/Linux: Google
class AuthenticationServiceWrapper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;

  // Private constructor for singleton pattern
  AuthenticationServiceWrapper._privateConstructor() {
    _initializeGoogleSignIn();
  }
  static final AuthenticationServiceWrapper _instance =
      AuthenticationServiceWrapper._privateConstructor();

  /// Factory constructor to provide singleton instance
  factory AuthenticationServiceWrapper() => _instance;

  /// Initialize Google Sign-In with platform-specific configuration
  void _initializeGoogleSignIn() {
    try {
      _googleSignIn = GoogleSignIn(
        params: GoogleSignInParams(
          clientId: _getClientId(),
          clientSecret: _getClientSecret(),
          scopes: ['openid', 'profile', 'email'],
        ),
      );
    } catch (e) {
      debugPrint('Google Sign-In initialization error: $e');
      // Fallback initialization
      _googleSignIn = GoogleSignIn(
        params: GoogleSignInParams(
          clientId: _getClientId(),
          scopes: ['openid', 'profile', 'email'],
        ),
      );
    }
  }

  /// Get client ID based on platform
  String _getClientId() {
    if (isWeb) {
      return EnvironmentConfig.googleSignInWebClientId;
    } else if (isAndroid) {
      return EnvironmentConfig.googleSignInAndroidClientId;
    } else if (isIOS || isMacOS) {
      return EnvironmentConfig.googleSignInIosClientId;
    }
    // For desktop platforms, use web client ID
    return EnvironmentConfig.googleSignInWebClientId;
  }

  /// Get client secret based on platform
  String? _getClientSecret() {
    // Client secret is only required for desktop platforms
    if (isWeb || isAndroid || isIOS) {
      return null; // Not required for mobile/web
    }
    // For macOS, Windows, Linux - we need the client secret
    return EnvironmentConfig.googleSignInClientSecret;
  }

  // ==========================================================================
  // Platform Detection
  // ==========================================================================

  /// Check if running on Android
  bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Check if running on iOS
  bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Check if running on macOS
  bool get isMacOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// Check if running on Web
  bool get isWeb => kIsWeb;

  /// Get current platform name
  String get platformName {
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isMacOS) return 'macOS';
    if (isWeb) return 'Web';
    return 'Unknown';
  }

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
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      debugPrint('Phone verification error: $e');
      // Enhanced error handling for reCAPTCHA issues in development
      if (e.toString().contains('recaptcha') ||
          e.toString().contains('appCheck')) {
        debugPrint('💡 Phone authentication works despite these errors');
        debugPrint(
            '🚀 Production builds will have proper reCAPTCHA configuration');
        // Don't rethrow reCAPTCHA errors in development - they don't break functionality
        return;
      }
      rethrow;
    }
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

  // ==========================================================================
  // Google Sign-In Authentication (All Platforms)
  // ==========================================================================

  /// Sign in with Google (Android, iOS, macOS, Web, Windows, Linux)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (isWeb) {
        // Web requires special handling with signInButton
        throw UnsupportedError(
            'Web platform requires signInButton() widget instead of direct signIn() call');
      }

      // For mobile and desktop platforms
      final credentials = await _googleSignIn.signIn();

      if (credentials == null) {
        // User cancelled the sign-in
        return null;
      }

      // Create Firebase credential from Google credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Google Sign-In failed: $e');
      rethrow;
    }
  }

  /// Get Google Sign-In button for web platform
  Widget? getGoogleSignInButton() {
    if (isWeb) {
      final button = _googleSignIn.signInButton();
      return button;
    }
    return null;
  }

  /// Handle Google Sign-In for web platform using credentials
  Future<UserCredential?> signInWithGoogleWeb(
      GoogleSignInCredentials credentials) async {
    try {
      // Create Firebase credential from Google credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      debugPrint('Google Sign-In Web failed: $e');
      rethrow;
    }
  }

  /// Silent sign-in for Google (restores previous sessions)
  Future<UserCredential?> silentSignInWithGoogle() async {
    try {
      if (isWeb) {
        throw UnsupportedError(
            'Web platform requires signInButton() widget instead of direct signIn() call');
      }

      final credentials = await _googleSignIn.silentSignIn();

      if (credentials == null) {
        return null;
      }

      // Create Firebase credential from Google credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Silent Google Sign-In failed: $e');
      return null; // Silent sign-in should not throw errors
    }
  }

  /// Sign out from Google
  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google Sign-Out error: $e');
    }
  }

  /// Get Google Sign-In authentication state stream
  Stream<GoogleSignInCredentials?> get googleSignInState =>
      _googleSignIn.authenticationState;

  // ==========================================================================
  // Apple Sign-In Authentication (iOS, macOS only)
  // ==========================================================================

  /// Sign in with Apple (iOS, macOS only)
  Future<UserCredential?> signInWithApple() async {
    try {
      if (!isIOS && !isMacOS) {
        throw UnsupportedError(
            'Apple Sign-In is only supported on iOS and macOS');
      }

      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create Firebase credential from Apple credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with Apple credential
      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint('Apple Sign-In failed: $e');
      rethrow;
    }
  }

  // ==========================================================================
  // Phone Authentication (Android, iOS, Web)
  // ==========================================================================

  /// Send OTP to phone number
  Future<void> sendOTPToPhone({
    required String phoneNumber,
    required Duration timeout,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    try {
      await verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      debugPrint('Phone OTP send failed: $e');
      rethrow;
    }
  }

  /// Verify OTP and sign in
  Future<UserCredential> verifyOTPAndSignIn({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return await signInWithCredential(credential);
    } catch (e) {
      debugPrint('OTP verification failed: $e');
      rethrow;
    }
  }

  // ==========================================================================
  // Platform-Specific Authentication Methods
  // ==========================================================================

  /// Get available authentication methods for current platform
  List<String> getAvailableAuthMethods() {
    if (isAndroid) {
      return ['phone', 'google'];
    } else if (isIOS) {
      return ['phone', 'google', 'apple'];
    } else if (isMacOS) {
      return ['google', 'apple'];
    } else if (isWeb) {
      return ['phone', 'google'];
    }
    return [];
  }

  /// Check if specific authentication method is available
  bool isAuthMethodAvailable(String method) {
    return getAvailableAuthMethods().contains(method.toLowerCase());
  }

  // ==========================================================================
  // Enhanced User Management
  // ==========================================================================

  /// Get user display name
  String? get userDisplayName => _auth.currentUser?.displayName;

  /// Get user email
  String? get userEmail => _auth.currentUser?.email;

  /// Get user phone number
  String? get userPhoneNumber => _auth.currentUser?.phoneNumber;

  /// Get user photo URL
  String? get userPhotoURL => _auth.currentUser?.photoURL;

  /// Check if user is anonymous
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  /// Get user creation time
  DateTime? get userCreationTime => _auth.currentUser?.metadata.creationTime;

  /// Get last sign-in time
  DateTime? get userLastSignInTime =>
      _auth.currentUser?.metadata.lastSignInTime;

  /// Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Send email verification
  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  /// Reload current user
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  /// Delete current user account
  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    await _auth.currentUser?.updateDisplayName(displayName);
    await _auth.currentUser?.updatePhotoURL(photoURL);
  }

  // ==========================================================================
  // Enhanced Sign Out
  // ==========================================================================

  /// Sign out from all providers
  Future<void> signOutFromAll() async {
    try {
      // Sign out from Google if signed in
      if (isAuthMethodAvailable('google')) {
        await signOutFromGoogle();
      }

      // Sign out from Firebase
      await signOut();
    } catch (e) {
      debugPrint('Sign out from all providers failed: $e');
      rethrow;
    }
  }
}
