import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/utils/exceptions/exceptions.dart';
import '../../firebase/auth/firebase_auth_service.dart';

/// Google Sign-In service for Firebase authentication
///
/// Responsibility:
/// - Handle Google OAuth authentication
/// - Integrate with Firebase Auth
/// - Manage Google Sign-In lifecycle
///
/// Note: This is a reusable core service - never modify for app-specific logic
class GoogleSignInServiceWrapper {
  final AuthenticationServiceWrapper _authService;
  final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;

  // Private constructor for dependency injection
  GoogleSignInServiceWrapper({
    required AuthenticationServiceWrapper authService,
    GoogleSignIn? googleSignIn,
  })  : _authService = authService,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  /// Initialize Google Sign-In service
  Future<void> initialize({String? clientId, String? serverClientId}) async {
    try {
      // Client ID configuration checked
      // Server Client ID configuration checked

      await _googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );

      // Listen for authentication events to track current user
      _googleSignIn.authenticationEvents
          .listen(_handleAuthenticationEvent)
          .onError(_handleAuthenticationError);

      // Attempt lightweight authentication
      await _googleSignIn.attemptLightweightAuthentication();

      // Google Sign-In service initialized successfully
    } catch (e) {
      // Don't throw - let the app continue without Google Sign-In
    }
  }

  /// Signs in a user with Google and returns Firebase [User]
  Future<User?> signInWithGoogle() async {
    try {
      // Check if running on iOS
      if (defaultTargetPlatform == TargetPlatform.iOS && !kIsWeb) {}

      // Web platform requires special handling
      if (kIsWeb) {
        throw AppException(
          message:
              'Web platform requires signInButton() widget instead of direct signIn() call',
          details:
              'Google Sign-In on web must use the signInButton() widget for user interaction',
          severity: ErrorSeverity.medium,
          recoverySuggestion:
              'Use getGoogleSignInButton() method to get the widget for web platform',
        );
      }

      if (!_googleSignIn.supportsAuthenticate()) {
        throw AppException(
            message: 'Google Sign-In not supported on this platform');
      }

      // Use authenticate() method which returns GoogleSignInAccount directly
      final GoogleSignInAccount account = await _googleSignIn.authenticate();
      _currentUser = account;

      // Get authentication tokens from the account
      final GoogleSignInAuthentication auth = account.authentication;

      if (auth.idToken == null) {
        throw AppException(
            message: 'Google Sign-In failed: No ID token received');
      }

      // For Firebase Auth, we only need the ID token
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      final userCredential =
          await _authService.signInWithCredential(credential);

      return userCredential.user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AppException(message: 'Google sign-in canceled by user');
      }
      throw AppException(message: 'Google sign-in failed: ${e.description}');
    } catch (e) {
      if (e.toString().contains('404') ||
          e.toString().contains('accounts.google.com')) {
        throw AppException(
          message: 'Google Sign-In not available on iOS Simulator',
          details:
              'Google Sign-In requires a real iOS device. The iOS Simulator cannot handle Google OAuth properly.',
          severity: ErrorSeverity.medium,
          recoverySuggestion:
              'Please test Google Sign-In on a real iOS device or use phone authentication instead.',
        );
      }
      throw AppException(message: 'Google sign-in failed: ${e.toString()}');
    }
  }

  /// Alternative method using authorization client to get access token
  Future<User?> signInWithGoogleWithAccessToken() async {
    try {
      if (_googleSignIn.supportsAuthenticate()) {
        final GoogleSignInAccount account = await _googleSignIn.authenticate();
        _currentUser = account;

        // Get ID token from authentication
        final GoogleSignInAuthentication auth = account.authentication;

        // Get access token from authorization client for basic scopes
        const List<String> scopes = <String>['email', 'profile'];
        final GoogleSignInClientAuthorization? authorization =
            await account.authorizationClient.authorizationForScopes(scopes);

        // Use both tokens if available, or just ID token if not
        final credential = GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: authorization?.accessToken,
        );

        final userCredential =
            await _authService.signInWithCredential(credential);
        return userCredential.user;
      } else {
        throw AppException(
            message: 'Google Sign-In not supported on this platform');
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AppException(message: 'Google sign-in canceled by user');
      }
      throw AppException(message: 'Google sign-in failed: ${e.description}');
    } catch (e) {
      throw AppException(message: 'Google sign-in failed: ${e.toString()}');
    }
  }

  /// Alternative method using event-based approach
  Future<User?> signInWithGoogleEventBased() async {
    try {
      if (_googleSignIn.supportsAuthenticate()) {
        final completer = Completer<User?>();
        late final StreamSubscription<GoogleSignInAuthenticationEvent>
            subscription;

        subscription = _googleSignIn.authenticationEvents.listen((event) async {
          if (event is GoogleSignInAuthenticationEventSignIn) {
            _currentUser = event.user;

            try {
              // Get authentication tokens from the user account
              final GoogleSignInAuthentication auth = event.user.authentication;

              final credential = GoogleAuthProvider.credential(
                idToken: auth.idToken,
              );

              final userCredential =
                  await _authService.signInWithCredential(credential);
              subscription.cancel();
              completer.complete(userCredential.user);
            } catch (e) {
              subscription.cancel();
              completer.completeError(AppException(
                  message: 'Firebase sign-in failed: ${e.toString()}'));
            }
          }
        });

        // Start the authentication process
        await _googleSignIn.authenticate();

        // Set timeout
        Future.delayed(const Duration(seconds: 30), () {
          if (!completer.isCompleted) {
            subscription.cancel();
            completer.completeError(
                AppException(message: 'Google sign-in timed out'));
          }
        });

        return await completer.future;
      } else {
        throw AppException(
            message: 'Google Sign-In not supported on this platform');
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AppException(message: 'Google sign-in canceled by user');
      }
      throw AppException(message: 'Google sign-in failed: ${e.description}');
    } catch (e) {
      throw AppException(message: 'Google sign-in failed: ${e.toString()}');
    }
  }

  /// Attempts silent sign-in without user interaction
  Future<User?> signInSilently() async {
    try {
      final GoogleSignInAccount? account =
          await _googleSignIn.attemptLightweightAuthentication();
      if (account != null) {
        _currentUser = account;

        // Get authentication tokens from the account
        final GoogleSignInAuthentication auth = account.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: auth.idToken,
        );

        final userCredential =
            await _authService.signInWithCredential(credential);
        return userCredential.user;
      }
      return null;
    } on GoogleSignInException {
      // Silent sign-in failures are expected, don't throw
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Signs out user from Google and Firebase
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _googleSignIn.signOut();
      _currentUser = null;
    } catch (e) {
      throw AppException(message: 'Google sign-out failed: ${e.toString()}');
    }
  }

  /// Disconnects user from Google (more thorough than signOut)
  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      throw AppException(message: 'Google disconnect failed: ${e.toString()}');
    }
  }

  /// Checks if user is currently signed in with Google
  bool get isSignedIn => _currentUser != null;

  /// Gets the current Google user
  GoogleSignInAccount? get currentUser => _currentUser;

  /// Handle authentication events
  void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    switch (event) {
      case GoogleSignInAuthenticationEventSignIn():
        _currentUser = event.user;

      case GoogleSignInAuthenticationEventSignOut():
        _currentUser = null;
    }
  }

  /// Handle authentication errors
  void _handleAuthenticationError(Object error) {
    _currentUser = null;
  }

  /// Request additional scopes for the current user
  Future<void> requestScopes(List<String> scopes) async {
    if (_currentUser == null) {
      throw AppException(message: 'No user signed in');
    }

    try {
      await _currentUser!.authorizationClient.authorizeScopes(scopes);
    } catch (e) {
      throw AppException(message: 'Failed to request scopes: ${e.toString()}');
    }
  }

  /// Get server auth code for backend authentication
  Future<String?> getServerAuthCode(List<String> scopes) async {
    if (_currentUser == null) {
      throw AppException(message: 'No user signed in');
    }

    try {
      final serverAuth =
          await _currentUser!.authorizationClient.authorizeServer(scopes);
      return serverAuth?.serverAuthCode;
    } catch (e) {
      throw AppException(
          message: 'Failed to get server auth code: ${e.toString()}');
    }
  }

  /// Get authorization headers for API calls (as shown in the example)
  Future<Map<String, String>?> getAuthorizationHeaders(
      List<String> scopes) async {
    if (_currentUser == null) {
      return null;
    }

    try {
      return await _currentUser!.authorizationClient
          .authorizationHeaders(scopes);
    } catch (e) {
      return null;
    }
  }

  /// Check if user has authorized specific scopes
  Future<bool> hasScopesAuthorized(List<String> scopes) async {
    if (_currentUser == null) {
      return false;
    }

    try {
      final authorization = await _currentUser!.authorizationClient
          .authorizationForScopes(scopes);
      return authorization != null;
    } catch (e) {
      return false;
    }
  }

  /// Get access token for specific scopes (for API calls)
  Future<String?> getAccessToken(List<String> scopes) async {
    if (_currentUser == null) {
      return null;
    }

    try {
      final authorization = await _currentUser!.authorizationClient
          .authorizationForScopes(scopes);
      return authorization?.accessToken;
    } catch (e) {
      return null;
    }
  }
}
