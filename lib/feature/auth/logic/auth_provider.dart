import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

import '../../../common/lifecycle/state/provider_state.dart';
import '../../../common/utils/constants/firestore.dart';
import '../../../common/utils/exceptions/exceptions.dart';
import '../../../common/utils/logging/logging_mixin.dart';
import '../../../core/db/flutter_secure_storage.dart';
import '../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/services/firebase/auth/firebase_auth_service.dart';
import '../../../core/services/firebase/database/firestore_database_service.dart';
import '../../../core/services/supabase/storage/supabase_storage_service.dart';
import '../../../core/utils/sample_data_creator.dart';
import '../data/model/user_model.dart';
import '../data/repository/auth_repository.dart';

/// AuthProvider manages authentication state and user session
/// Extends BaseProviderState for proper state management
/// Handles phone OTP, Google sign-in, role-based navigation, and profile management
/// Enhanced with analytics tracking and comprehensive error handling
class AuthProvider extends BaseProviderState with LoggingMixin {
  // Service access via GetIt
  final AuthenticationServiceWrapper _authService = getIt.auth;
  final FirestoreServiceWrapper _firestoreService = getIt.firestore;
  final LocalStorageService _localStorage = getIt.localStorage;
  final SupabaseStorageServiceWrapper _storageService = getIt.storage;
  final NavigationService _navigation = getIt<NavigationService>();
  final _analyticsService = getIt.analytics;
  // final _appleSignInService = getIt.appleSignIn;
  final AuthRepository _repository = AuthRepository();

  UserModel? _user;
  String? _verificationId;
  bool _sendingOtp = false;
  String? _selectedRole; // Store the selected role separately

  UserModel? get user => _user;
  bool get sendingOtp => _sendingOtp;
  String? get verificationId => _verificationId;

  /// Constructor that triggers initial user data load
  /// This ensures user data is available immediately when provider is created
  AuthProvider() {
    _initializeUserData();
  }

  /// Initialize user data from local storage on provider creation
  /// This runs in background and doesn't block provider creation
  Future<void> _initializeUserData() async {
    try {
      await loadUserFromPrefs();
      if (_user != null) {
        // SECURITY FIX: Validate cached user against current Firebase Auth session
        final currentFirebaseUser = _authService.currentUser;
        if (currentFirebaseUser == null) {
          debugPrint(
              '🔒 AuthProvider: No Firebase Auth session - clearing cached user');
          _user = null;
          _selectedRole = null;
          await _localStorage.delete('userData');
        } else if (currentFirebaseUser.uid != _user!.userId) {
          debugPrint(
              '🔒 AuthProvider: Firebase Auth user mismatch - clearing cached user');
          _user = null;
          _selectedRole = null;
          await _localStorage.delete('userData');
        } else {}
      } else {}
    } catch (e) {
      // Clear any corrupted cached data
      _user = null;
      _selectedRole = null;
      await _localStorage.delete('userData');
    }
  }

  // ==========================================================================
  // Photo/Document Upload State
  // ==========================================================================
  // Files can be File (mobile) or XFile (web) - using dynamic for compatibility
  // ==========================================================================
  dynamic _profilePhotoFile; // File on mobile, XFile on web
  String? _profilePhotoUrl;
  bool _uploadingProfile = false;

  dynamic _aadhaarFile; // File on mobile, XFile on web
  String? _aadhaarUrl;
  bool _uploadingAadhaar = false;

  dynamic get profilePhotoFile => _profilePhotoFile;
  String? get profilePhotoUrl => _profilePhotoUrl;
  bool get uploadingProfile => _uploadingProfile;

  dynamic get aadhaarFile => _aadhaarFile;
  String? get aadhaarUrl => _aadhaarUrl;
  bool get uploadingAadhaar => _uploadingAadhaar;

  // ==========================================================================
  // Platform-Specific Authentication Methods
  // ==========================================================================

  /// Get available authentication methods for current platform
  List<String> getAvailableAuthMethods() {
    return _authService.getAvailableAuthMethods();
  }

  /// Check if specific authentication method is available
  bool isAuthMethodAvailable(String method) {
    return _authService.isAuthMethodAvailable(method);
  }

  /// Get current platform name
  String get platformName => _authService.platformName;

  // ==========================================================================
  // Google Sign-In Authentication
  // ==========================================================================

  /// Sign in with Google (Android, iOS, macOS, Web, Windows, Linux)
  Future<bool> signInWithGoogle() async {
    logMethodEntry('signInWithGoogle', feature: 'authentication');

    try {
      setLoading(true);
      clearError();

      logUserAction('Google Sign-In Attempt', feature: 'authentication');
      await _analyticsService.logEvent(name: 'auth_google_signin_attempt');

      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) {
        logUserAction('Google Sign-In Cancelled', feature: 'authentication');
        await _analyticsService.logEvent(name: 'auth_google_signin_cancelled');
        return false;
      }

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Google sign-in failed: No user returned');
      }

      // CRITICAL: If no role was selected before Google sign-in, redirect to role selection
      if (_selectedRole == null) {
        await _analyticsService.logEvent(
          name: 'auth_google_signin_no_role_selected',
          parameters: {'user_id': user.uid},
        );
        // Don't proceed with authentication - user needs to select role first
        _navigation.goToRoleSelection();
        return false;
      }

      // Create or update user profile
      await _handleSuccessfulAuthentication(user);

      logUserAction(
        'Google Sign-In Success',
        feature: 'authentication',
        metadata: {
          'userId': user.uid,
          'platform': platformName,
        },
      );

      await _analyticsService.logEvent(
        name: 'auth_google_signin_success',
        parameters: {
          'user_id': user.uid,
          'platform': platformName,
        },
      );

      return true;
    } catch (e) {
      logError(
        'Google Sign-In Failed',
        feature: 'authentication',
        error: e,
      );

      await _analyticsService.logEvent(
        name: 'auth_google_signin_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Google sign-in failed: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
      logMethodExit('signInWithGoogle');
    }
  }

  /// Silent sign-in with Google (restores previous sessions)
  Future<bool> silentSignInWithGoogle() async {
    try {
      setLoading(true);
      clearError();

      await _analyticsService.logEvent(
          name: 'auth_google_silent_signin_attempt');

      final userCredential = await _authService.silentSignInWithGoogle();

      if (userCredential == null) {
        // No previous session found
        await _analyticsService.logEvent(
            name: 'auth_google_silent_signin_no_session');
        return false;
      }

      final user = userCredential.user;
      if (user == null) {
        return false;
      }

      // Create or update user profile
      await _handleSuccessfulAuthentication(user);

      await _analyticsService.logEvent(
        name: 'auth_google_silent_signin_success',
        parameters: {
          'user_id': user.uid,
          'platform': platformName,
        },
      );

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_google_silent_signin_error',
        parameters: {'error': e.toString()},
      );
      // Silent sign-in should not show errors to user
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Get Google Sign-In button for web platform
  Widget? getGoogleSignInButton() {
    return _authService.getGoogleSignInButton();
  }

  /// Get Google Sign-In authentication state stream
  Stream<GoogleSignInCredentials?> get googleSignInState =>
      _authService.googleSignInState;

  /// Handle Google Sign-In for web platform
  Future<bool> signInWithGoogleWeb(GoogleSignInCredentials credentials) async {
    try {
      setLoading(true);
      clearError();

      await _analyticsService.logEvent(name: 'auth_google_web_signin_attempt');

      final userCredential =
          await _authService.signInWithGoogleWeb(credentials);

      if (userCredential == null) {
        await _analyticsService.logEvent(name: 'auth_google_web_signin_failed');
        return false;
      }

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Google web sign-in failed: No user returned');
      }

      // Create or update user profile
      await _handleSuccessfulAuthentication(user);

      await _analyticsService.logEvent(
        name: 'auth_google_web_signin_success',
        parameters: {
          'user_id': user.uid,
          'platform': platformName,
        },
      );

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_google_web_signin_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Google web sign-in failed: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ==========================================================================
  // Apple Sign-In Authentication (iOS, macOS only)
  // ==========================================================================

  /// Sign in with Apple (iOS, macOS only)
  Future<bool> signInWithApple() async {
    try {
      setLoading(true);
      clearError();

      await _analyticsService.logEvent(name: 'auth_apple_signin_attempt');

      final userCredential = await _authService.signInWithApple();

      if (userCredential == null) {
        // User cancelled the sign-in
        await _analyticsService.logEvent(name: 'auth_apple_signin_cancelled');
        return false;
      }

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Apple sign-in failed: No user returned');
      }

      // CRITICAL: If no role was selected before Apple sign-in, redirect to role selection
      if (_selectedRole == null) {
        await _analyticsService.logEvent(
          name: 'auth_apple_signin_no_role_selected',
          parameters: {'user_id': user.uid},
        );
        // Don't proceed with authentication - user needs to select role first
        _navigation.goToRoleSelection();
        return false;
      }

      // Create or update user profile
      await _handleSuccessfulAuthentication(user);

      await _analyticsService.logEvent(
        name: 'auth_apple_signin_success',
        parameters: {
          'user_id': user.uid,
          'platform': platformName,
        },
      );

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_apple_signin_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Apple sign-in failed: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ==========================================================================
  // Enhanced Phone Authentication
  // ==========================================================================

  /// Send OTP to phone number with enhanced error handling
  Future<bool> sendOTPToPhone(String phoneNumber) async {
    try {
      setLoading(true);
      clearError();
      _sendingOtp = true;

      await _analyticsService.logEvent(
        name: 'auth_phone_otp_send_attempt',
        parameters: {'phone_number': phoneNumber},
      );

      await _authService.sendOTPToPhone(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification completed (Android only)
          _handleAutoVerification(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setError(true, 'Phone verification failed: ${e.message}');
          _sendingOtp = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _sendingOtp = false;
          _analyticsService.logEvent(name: 'auth_phone_otp_sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          _sendingOtp = false;
        },
      );

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_phone_otp_send_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Failed to send OTP: ${e.toString()}');
      _sendingOtp = false;
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Verify OTP and sign in with enhanced error handling
  Future<bool> verifyOTPAndSignIn(String smsCode) async {
    try {
      setLoading(true);
      clearError();

      if (_verificationId == null) {
        throw Exception('No verification ID found. Please request OTP first.');
      }

      // CRITICAL: Ensure role was selected before OTP verification
      // This prevents creating users with default 'guest' role
      if (_selectedRole == null) {
        await _analyticsService.logEvent(
          name: 'auth_phone_otp_verify_no_role',
        );
        setError(true,
            'Please select your role (Guest or Owner) before verifying OTP.');
        return false;
      }

      await _analyticsService.logEvent(
        name: 'auth_phone_otp_verify_attempt',
        parameters: {'selected_role': _selectedRole ?? 'none'},
      );

      final userCredential = await _authService.verifyOTPAndSignIn(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('OTP verification failed: No user returned');
      }

      // Create or update user profile (will use _selectedRole)
      await _handleSuccessfulAuthentication(user);

      await _analyticsService.logEvent(
        name: 'auth_phone_otp_verify_success',
        parameters: {
          'user_id': user.uid,
          'platform': platformName,
        },
      );

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_phone_otp_verify_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'OTP verification failed: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ==========================================================================
  // Enhanced Authentication Handler
  // ==========================================================================

  /// Handle auto-verification for phone authentication
  /// STRICT: Validates role selection before proceeding with auto-verification
  Future<void> _handleAutoVerification(PhoneAuthCredential credential) async {
    try {
      // CRITICAL: Ensure role was selected before auto-verification
      // Auto-verification (Android only) can bypass normal OTP flow, so we must check role here
      if (_selectedRole == null || _selectedRole!.isEmpty) {
        debugPrint(
            '⚠️ _handleAutoVerification: No role selected - redirecting to role selection');
        await _analyticsService.logEvent(
          name: 'auth_auto_verification_no_role',
        );
        setError(true,
            'Please select your role (Guest or Owner) before authentication.');
        _navigation.goToRoleSelection();
        return;
      }

      final userRole = _selectedRole!.toLowerCase().trim();

      // STRICT VALIDATION: Only allow 'guest' or 'owner'
      if (userRole != 'guest' && userRole != 'owner') {
        debugPrint(
            '⚠️ _handleAutoVerification: Invalid role "$userRole" - redirecting to role selection');
        await _analyticsService.logEvent(
          name: 'auth_auto_verification_invalid_role',
          parameters: {'invalid_role': userRole},
        );
        setError(true, 'Invalid role selected. Please select Guest or Owner.');
        _navigation.goToRoleSelection();
        return;
      }

      final userCredential =
          await _authService.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _handleSuccessfulAuthentication(userCredential.user!);
      }
    } catch (e) {
      setError(true, 'Auto-verification failed: ${e.toString()}');
    }
  }

  /// Handle successful authentication for any method
  Future<void> _handleSuccessfulAuthentication(User firebaseUser) async {
    try {
      // Check if user exists in Firestore
      final userDoc = await _firestoreService.getDocument(
        FirestoreConstants.users,
        firebaseUser.uid,
      );

      if (userDoc.exists) {
        // User exists, update their data
        final existingUser =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

        // CRITICAL SECURITY FIX: Validate role selection

        // Handle admin role separately - admin doesn't need role selection
        if (existingUser.role == 'admin') {
          // User is admin - allow access without role selection
          _user = existingUser;
          _selectedRole = null;

          // Update phone number from Firebase user to ensure it's current
          if (firebaseUser.phoneNumber != null &&
              firebaseUser.phoneNumber!.isNotEmpty) {
            _user = _user!.copyWith(phoneNumber: firebaseUser.phoneNumber!);
          }

          // Update last login and phone number if changed
          await _firestoreService.updateDocument(
            FirestoreConstants.users,
            firebaseUser.uid,
            {
              'lastLoginAt': DateTime.now(),
              'phoneNumber': _user!.phoneNumber,
            },
          );

          // Save to local storage
          await _saveUserToPrefs(_user!);

          // Navigate to admin dashboard
          await _navigateAfterAuthentication();
          return;
        }

        // For non-admin users, require role selection
        if (_selectedRole == null) {
          // Clear and force sign-out to prevent partial sessions
          _user = null;
          try {
            await _authService.signOut();
          } catch (_) {}

          // Set error and prevent login
          setError(true,
              'Please select your role (Guest or Owner) before logging in.');
          _navigation.goToRoleSelection();
          return;
        }

        // If user has selected a role, validate it matches their stored role
        if (_selectedRole != existingUser.role) {
          // Clear and force sign-out to block cross-role login
          _user = null;
          _selectedRole = null;
          try {
            await _authService.signOut();
          } catch (_) {}

          // Set error and prevent login
          setError(true,
              'This phone number is registered as ${existingUser.role}. Please select the correct role and try again.');
          _navigation.goToRoleSelection();
          return;
        }

        // Role validation passed, proceed with authentication
        _user = existingUser;

        // Clear the selected role after successful validation
        _selectedRole = null;

        // Update phone number from Firebase user to ensure it's current
        if (firebaseUser.phoneNumber != null &&
            firebaseUser.phoneNumber!.isNotEmpty) {
          _user = _user!.copyWith(phoneNumber: firebaseUser.phoneNumber!);
        }

        // Update last login and phone number if changed
        await _firestoreService.updateDocument(
          FirestoreConstants.users,
          firebaseUser.uid,
          {
            'lastLoginAt': DateTime.now(),
            'phoneNumber': _user!.phoneNumber,
          },
        );
      } else {
        // New user, create profile
        _user = await _createUserProfile(firebaseUser);
      }

      // Save to local storage
      await _saveUserToPrefs(_user!);

      // Navigate based on role
      await _navigateAfterAuthentication();
    } catch (e) {
      setError(true, 'Failed to handle authentication: ${e.toString()}');
    }
  }

  /// Create user profile for new users
  /// STRICT: Requires _selectedRole to be set - NO DEFAULT FALLBACK
  Future<UserModel> _createUserProfile(User firebaseUser) async {
    // STRICT: _selectedRole MUST be set before creating profile
    // NO DEFAULT FALLBACK - will throw error if role not selected
    if (_selectedRole == null || _selectedRole!.isEmpty) {
      throw Exception(
          'CRITICAL: Role must be selected before creating user profile. Selected role: $_selectedRole');
    }

    final userRole = _selectedRole!.toLowerCase().trim();

    // STRICT VALIDATION: Only allow 'guest' or 'owner'
    if (userRole != 'guest' && userRole != 'owner') {
      throw Exception(
          'CRITICAL: Invalid role selected: "$userRole". Role must be either "guest" or "owner".');
    }

    final userModel = UserModel(
      userId: firebaseUser.uid,
      phoneNumber: firebaseUser.phoneNumber ?? '',
      role:
          userRole, // Use selected role instead of always defaulting to 'guest'
      fullName: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email,
      profilePhotoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // Save to Firestore
    await _firestoreService.setDocument(
      FirestoreConstants.users,
      firebaseUser.uid,
      userModel.toFirestore(),
    );

    // Clear selected role after creating profile
    _selectedRole = null;

    return userModel;
  }

  /// Navigate after successful authentication
  /// STRICT: Only navigates if role is explicitly 'guest' or 'owner'
  /// NO FALLBACK - Will redirect to role selection if role is invalid
  Future<void> _navigateAfterAuthentication() async {
    if (_user == null) {
      debugPrint(
          '⚠️ _navigateAfterAuthentication: User is null - redirecting to role selection');
      _navigation.goToRoleSelection();
      return;
    }

    final userRole = _user!.role.toLowerCase().trim();

    await _analyticsService.logEvent(
      name: 'auth_navigate_after_signin',
      parameters: {'role': userRole, 'user_id': _user!.userId},
    );

    // STRICT ROLE CHECK: Only allow 'guest' or 'owner', no exceptions
    // role is non-nullable String, so we only check if it's empty
    if (userRole.isEmpty) {
      debugPrint(
          '⚠️ _navigateAfterAuthentication: User has no role - redirecting to role selection');
      await _analyticsService.logEvent(
        name: 'auth_navigate_no_role',
        parameters: {'user_id': _user!.userId},
      );
      _navigation.goToRoleSelection();
      return;
    }

    // Navigate based on role: 'guest', 'owner', or 'admin'
    if (userRole == 'owner') {
      debugPrint(
          '✅ _navigateAfterAuthentication: Role is owner - navigating to owner dashboard');
      _navigation.goToOwnerHome();
    } else if (userRole == 'guest') {
      debugPrint(
          '✅ _navigateAfterAuthentication: Role is guest - navigating to guest dashboard');
      _navigation.goToGuestHome();
    } else if (userRole == 'admin') {
      debugPrint(
          '✅ _navigateAfterAuthentication: Role is admin - navigating to admin dashboard');
      _navigation.goToAdminRevenueDashboard();
    } else {
      // Invalid role value - redirect to role selection
      debugPrint(
          '⚠️ _navigateAfterAuthentication: Invalid role "$userRole" - redirecting to role selection');
      await _analyticsService.logEvent(
        name: 'auth_navigate_invalid_role',
        parameters: {'user_id': _user!.userId, 'invalid_role': userRole},
      );
      _navigation.goToRoleSelection();
    }
  }

  /// Attempts auto-login flow used by splash screen and app start
  /// First tries to restore user from local storage for instant access
  /// Then validates with Firebase and Firestore
  Future<bool> tryAutoLogin() async {
    try {
      setLoading(true);

      await _analyticsService.logEvent(name: 'auth_auto_login_attempt');

      // 🔥 STEP 1: Try to restore user from local storage first (INSTANT)
      // This ensures _user is available immediately even if network is slow
      await loadUserFromPrefs();

      if (_user != null) {
        await _analyticsService.logEvent(
          name: 'auth_user_restored_from_storage',
          parameters: {
            'user_id': _user!.userId,
            'role': _user!.role,
          },
        );
      }

      // 🔥 STEP 2: Validate with Firebase Auth
      if (_authService.currentUser == null) {
        await _analyticsService.logEvent(name: 'auth_auto_login_no_user');
        // Clear stale local data
        _user = null;
        await _localStorage.delete('userData');
        return false;
      }

      final userId = _authService.currentUserId;
      if (userId == null) {
        await _analyticsService.logEvent(name: 'auth_auto_login_no_userid');
        return false;
      }

      // 🔥 STEP 3: Sync with Firestore (update if needed)
      final doc =
          await _firestoreService.getDocument(FirestoreConstants.users, userId);
      if (!doc.exists) {
        await _analyticsService.logEvent(
          name: 'auth_auto_login_no_document',
          parameters: {'user_id': userId},
        );
        return false;
      }

      // Update user data from Firestore (source of truth)
      _user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

      // Update last login timestamp
      await _firestoreService.updateDocument(
        FirestoreConstants.users,
        userId,
        {'lastLoginAt': DateTime.now()},
      );

      // Save updated user data to local storage
      await _saveUserToPrefs(_user!);
      clearError();

      await _analyticsService.logEvent(
        name: 'auth_auto_login_success',
        parameters: {'user_id': userId, 'role': _user!.role},
      );

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_auto_login_error',
        parameters: {'error': e.toString()},
      );
      // Even if Firestore sync fails, keep the locally restored user
      // This allows offline access
      if (_user != null) {
        return true; // Continue with cached data
      }
      setError(true, 'Auto login failed: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Navigates user based on role and profile completion
  /// STRICT: Enforces role-based navigation with no fallbacks
  Future<void> navigateAfterSplash() async {
    try {
      await _analyticsService.logEvent(name: 'auth_navigate_after_splash');

      if (_user == null) {
        debugPrint(
            '⚠️ navigateAfterSplash: User is null - redirecting to role selection');
        await _analyticsService.logEvent(
            name: 'auth_navigate_to_role_selection');
        _navigation.goToRoleSelection();
        return;
      }

      // Guard: if Firebase Auth has no current user, cached user is invalid → reset and re-select role
      if (_authService.currentUser == null) {
        debugPrint(
            '⚠️ navigateAfterSplash: No Firebase Auth user - clearing cache and redirecting');
        await _analyticsService.logEvent(
            name: 'auth_navigate_to_role_selection');
        // Clear stale cached user so we don't carry empty userId/phone
        _user = null;
        await _localStorage.delete('userData');
        _navigation.goToRoleSelection();
        return;
      }

      final role = _user!.role.toLowerCase().trim();

      await _analyticsService.logEvent(
        name: 'auth_navigate_by_role',
        parameters: {'role': role, 'user_id': _user!.userId},
      );

      // STRICT ROLE VALIDATION: Role must be 'guest' or 'owner', no exceptions
      // role is non-nullable String, so we only check if it's empty
      if (role.isEmpty) {
        debugPrint(
            '⚠️ navigateAfterSplash: User has no role - redirecting to role selection');
        await _analyticsService.logEvent(
          name: 'auth_navigate_no_role_splash',
          parameters: {'user_id': _user!.userId},
        );
        _navigation.goToRoleSelection();
        return;
      }

      // Check if profile is complete; only send to registration if we have an authenticated phone user
      final hasPhone = (_authService.currentUser?.phoneNumber ?? '').isNotEmpty;
      if (!_user!.isProfileComplete && hasPhone) {
        await _analyticsService.logEvent(
          name: 'auth_navigate_to_registration',
          parameters: {'role': role, 'user_id': _user!.userId},
        );
        _navigation.goToRegistration();
        return;
      }

      // Navigate based on role: 'guest', 'owner', or 'admin'
      if (role == 'guest') {
        debugPrint(
            '✅ navigateAfterSplash: Role is guest - navigating to guest dashboard');
        _navigation.goToGuestHome();
      } else if (role == 'owner') {
        debugPrint(
            '✅ navigateAfterSplash: Role is owner - navigating to owner dashboard');
        _navigation.goToOwnerHome();
      } else if (role == 'admin') {
        debugPrint(
            '✅ navigateAfterSplash: Role is admin - navigating to admin dashboard');
        _navigation.goToAdminRevenueDashboard();
      } else {
        // Invalid role - redirect to role selection
        debugPrint(
            '⚠️ navigateAfterSplash: Invalid role "$role" - redirecting to role selection');
        await _analyticsService.logEvent(
          name: 'auth_navigate_invalid_role_splash',
          parameters: {'user_id': _user!.userId, 'invalid_role': role},
        );
        _navigation.goToRoleSelection();
      }
    } catch (e) {
      debugPrint(
          '❌ navigateAfterSplash: Error - $e - redirecting to role selection');
      await _analyticsService.logEvent(
        name: 'auth_navigate_error',
        parameters: {'error': e.toString()},
      );
      _navigation.goToRoleSelection();
    }
  }

  /// Clears session and signs out user
  /// After logout, user must select their role again (Owner/Guest)
  /// Enhanced sign out with platform-specific provider cleanup
  Future<void> signOut() async {
    try {
      setLoading(true);

      await _analyticsService.logEvent(
        name: 'auth_logout_start',
        parameters: {
          'user_id': _user?.userId ?? 'unknown',
          'platform': platformName,
        },
      );

      // Sign out from all authentication providers
      await _authService.signOutFromAll();

      // Clear local data
      _user = null;
      _verificationId = null;
      _sendingOtp = false;
      await _localStorage.delete('userData');
      clearUploadData();
      notifyListeners();
      clearError();

      await _analyticsService.logEvent(
        name: 'auth_logout_success',
        parameters: {'platform': platformName},
      );

      // Navigate to Role Selection screen (not Phone Auth)
      // User must select their role first, then login
      _navigation.goToRoleSelection();
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_logout_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Sign out failed: $e');
    } finally {
      setLoading(false);
    }
  }

  // ==========================================================================
  // Upload Profile Photo - Cross-Platform (Mobile + Web)
  // ==========================================================================
  // Accepts dynamic file parameter (File on mobile, XFile on web)
  // Storage service auto-detects type and handles appropriately
  // ==========================================================================
  Future<void> uploadProfilePhoto(dynamic file) async {
    try {
      _uploadingProfile = true;
      notifyListeners();

      await _analyticsService.logEvent(
        name: 'auth_profile_photo_upload_start',
        parameters: {'user_id': _user?.userId ?? 'unknown'},
      );

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_profile.jpg';
      // Storage service handles both File and XFile automatically
      final url = await _storageService.uploadFile(
          file, 'users/${_user?.userId}/profile_photos/', fileName);

      _profilePhotoFile = file;
      _profilePhotoUrl = url;

      await _analyticsService.logEvent(
        name: 'auth_profile_photo_uploaded',
        parameters: {'user_id': _user?.userId ?? 'unknown'},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_profile_photo_upload_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Failed to upload profile photo: $e');
      rethrow;
    } finally {
      _uploadingProfile = false;
      notifyListeners();
    }
  }

  // ==========================================================================
  // Upload Aadhaar Document - Cross-Platform (Mobile + Web)
  // ==========================================================================
  // Accepts dynamic file parameter (File on mobile, XFile on web)
  // Storage service auto-detects type and handles appropriately
  // ==========================================================================
  Future<void> uploadAadhaarDocument(dynamic file) async {
    try {
      _uploadingAadhaar = true;
      notifyListeners();

      await _analyticsService.logEvent(
        name: 'auth_aadhaar_upload_start',
        parameters: {'user_id': _user?.userId ?? 'unknown'},
      );

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_aadhaar.jpg';
      // Storage service handles both File and XFile automatically
      final url = await _storageService.uploadFile(
          file, 'users/${_user?.userId}/documents/', fileName);

      _aadhaarFile = file;
      _aadhaarUrl = url;

      await _analyticsService.logEvent(
        name: 'auth_aadhaar_uploaded',
        parameters: {'user_id': _user?.userId ?? 'unknown'},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_aadhaar_upload_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Failed to upload Aadhaar document: $e');
      rethrow;
    } finally {
      _uploadingAadhaar = false;
      notifyListeners();
    }
  }

  /// Sets intended role for authentication. Does not persist or mutate existing user role.
  void setRole(String role) {
    try {
      _selectedRole = role;
      _analyticsService.logEvent(
        name: 'auth_role_selected',
        parameters: {'role': role},
      );
      // Do NOT modify _user or Firestore here to avoid accidentally switching roles
      notifyListeners();
    } catch (e) {
      // Non-fatal; selection should not error the UI
    }
  }

  /// Clears the current role selection (for role switching)
  void clearRoleSelection() {
    try {
      _selectedRole = null;
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Error clearing role selection: $e');
    }
  }

  /// Sends OTP for login - Platform-aware implementation with retry logic
  Future<void> sendOTP(
    String phoneNumber,
    PhoneCodeSent onCodeSent,
    PhoneVerificationFailed onError,
  ) async {
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 2);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        _sendingOtp = true;
        notifyListeners();

        final fullPhoneNumber = '+91$phoneNumber';

        await _analyticsService.logEvent(
          name: 'auth_send_otp_request',
          parameters: {
            'phone_number': fullPhoneNumber,
            'attempt': attempt.toString(),
          },
        );

        // Check if running on macOS or Web - phone OTP is not supported
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
          await _analyticsService.logEvent(
            name: 'auth_send_otp_error',
            parameters: {
              'phone_number': fullPhoneNumber,
              'error': 'Phone OTP not supported on macOS'
            },
          );
          throw AppException(
            message: 'Phone OTP authentication is not available on macOS',
            details: 'Please use Google Sign-In instead',
            severity: ErrorSeverity.medium,
            recoverySuggestion:
                'Use Google Sign-In button below for macOS authentication',
          );
        }

        await _repository.sendVerificationCode(
          phoneNumber: fullPhoneNumber,
          timeout: kIsWeb
              ? const Duration(seconds: 120)
              : const Duration(seconds: 60),
          verificationCompleted: (credential) async {
            await _authService.signInWithCredential(credential);
          },
          verificationFailed: (error) {
            _analyticsService.logEvent(
              name: 'auth_otp_verification_failed',
              parameters: {
                'error': error.message ?? 'Unknown error',
                'attempt': attempt.toString(),
              },
            );

            // Enhanced error handling for common issues
            String errorMessage = error.message ?? 'Unknown error';
            if (error.code == 'too-many-requests') {
              errorMessage = 'Too many requests. Please try again later.';
            } else if (error.code == 'invalid-phone-number') {
              errorMessage = 'Invalid phone number format.';
            } else if (error.code == 'quota-exceeded') {
              errorMessage = 'SMS quota exceeded. Please try again later.';
            } else if (error.code == 'captcha-check-failed') {
              errorMessage = 'reCAPTCHA verification failed. Please try again.';
            }

            // Create enhanced error with better message
            final enhancedError = FirebaseAuthException(
              code: error.code,
              message: errorMessage,
            );

            onError(enhancedError);
          },
          codeSent: (verificationId, resendToken) {
            _verificationId = verificationId;
            _analyticsService.logEvent(
              name: 'auth_otp_code_sent',
              parameters: {'attempt': attempt.toString()},
            );
            onCodeSent(verificationId, resendToken);
          },
          codeAutoRetrievalTimeout: (verificationId) {
            _verificationId = verificationId;
          },
        );

        // If we reach here, OTP was sent successfully
        return;
      } catch (e) {
        await _analyticsService.logEvent(
          name: 'auth_send_otp_error',
          parameters: {
            'error': e.toString(),
            'attempt': attempt.toString(),
          },
        );

        // If this is the last attempt, throw the error
        if (attempt == maxRetries) {
          setError(true, 'Failed to send OTP after $maxRetries attempts: $e');
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(retryDelay);
      } finally {
        _sendingOtp = false;
        notifyListeners();
      }
    }
  }

  /// Verifies OTP entered by user
  Future<bool> verifyOTP(String smsCode) async {
    if (_verificationId == null) {
      setError(true, 'Verification ID not available');
      return false;
    }

    try {
      setLoading(true);

      await _analyticsService.logEvent(name: 'auth_verify_otp_attempt');

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      final userModel = await _repository.verifySmsCode(credential);
      final userId = userModel.userId;

      // Check if user exists in Firestore
      final isNewUser = !await _checkUserExists(userId);

      await _analyticsService.logEvent(
        name: 'auth_otp_verified',
        parameters: {
          'user_id': userId,
          'is_new_user': isNewUser.toString(),
        },
      );

      if (isNewUser) {
        // STRICT: New user MUST have _selectedRole set before OTP verification
        // NO DEFAULT FALLBACK - This prevents creating users without explicit role selection
        if (_selectedRole == null || _selectedRole!.isEmpty) {
          setError(true,
              'CRITICAL: Role must be selected before verifying OTP. Please select Guest or Owner role.');
          await _analyticsService.logEvent(
            name: 'auth_verify_otp_no_role_critical',
            parameters: {'user_id': userId},
          );
          return false;
        }

        final userRole = _selectedRole!.toLowerCase().trim();

        // VALIDATION: Only allow 'guest' or 'owner' for new user registration
        // Admin role cannot be created through app - must be manually set in Firestore
        if (userRole != 'guest' && userRole != 'owner') {
          setError(true,
              'Invalid role "$userRole". Role must be "guest" or "owner". Admin access must be configured separately.');
          await _analyticsService.logEvent(
            name: 'auth_verify_otp_invalid_role_critical',
            parameters: {'user_id': userId, 'invalid_role': userRole},
          );
          return false;
        }

        _user = userModel.copyWith(
          role: userRole,
        );

        // Debug log to verify phone number and role
        await _analyticsService.logEvent(
          name: 'auth_new_user_data_set',
          parameters: {
            'user_id': _user!.userId,
            'phone_number': _user!.phoneNumber,
            'role': _user!.role,
            'selected_role': _selectedRole ?? 'none',
          },
        );

        // Don't clear _selectedRole yet - keep it for registration screen
        // It will be used when saving the full profile in registration

        await _saveUserToPrefs(_user!);
        notifyListeners();
        return false;
      }

      // Existing user - load full profile
      final userData = await _getUserById(userId);
      if (userData == null) {
        setError(true, 'User data not found');
        return false;
      }

      _user = userData.copyWith(lastLoginAt: DateTime.now());

      // Update last login in Firestore
      await _firestoreService.updateDocument(
        FirestoreConstants.users,
        userId,
        {'lastLoginAt': DateTime.now()},
      );

      await _saveUserToPrefs(_user!);
      notifyListeners();
      clearError();

      await _analyticsService.logEvent(
        name: 'auth_login_success',
        parameters: {'user_id': userId, 'role': _user!.role},
      );

      // Create sample data for testing if user is a guest
      if (_user!.role == 'guest') {
        _createSampleDataForGuest(userId);
      }

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_verify_otp_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'OTP verification failed: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Save user profile to Firestore and cache local storage
  Future<void> saveUser(UserModel user) async {
    try {
      setLoading(true);

      await _analyticsService.logEvent(
        name: 'auth_save_user_start',
        parameters: {
          'user_id': user.userId,
          'role': user.role,
          'is_profile_complete': user.isProfileComplete.toString(),
        },
      );

      // Add profile photo and aadhaar URLs if uploaded
      final userToSave = user.copyWith(
        profilePhotoUrl: _profilePhotoUrl ?? user.profilePhotoUrl,
        aadhaarPhotoUrl: _aadhaarUrl ?? user.aadhaarPhotoUrl,
        createdAt: user.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestoreService.setDocument(
        FirestoreConstants.users,
        userToSave.userId,
        userToSave.toFirestore(),
      );

      _user = userToSave;
      await _saveUserToPrefs(_user!);

      // Clear _selectedRole after successfully saving user to Firestore
      // This ensures the role is persisted and won't be lost
      _selectedRole = null;

      notifyListeners();
      clearError();

      await _analyticsService.logEvent(
        name: 'auth_user_saved',
        parameters: {'user_id': user.userId, 'role': user.role},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_save_user_error',
        parameters: {'user_id': user.userId, 'error': e.toString()},
      );
      setError(true, 'Error saving user: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Loads user from local storage on app start
  Future<void> loadUserFromPrefs() async {
    try {
      final jsonString = await _localStorage.read('userData');
      if (jsonString == null) return;

      final map = json.decode(jsonString) as Map<String, dynamic>;
      _user = UserModel.fromJson(map);
      notifyListeners();

      await _analyticsService.logEvent(
        name: 'auth_user_loaded_from_prefs',
        parameters: {'user_id': _user!.userId},
      );
    } catch (e) {
      // Silent fail - user will need to login again
      await _analyticsService.logEvent(
        name: 'auth_load_prefs_error',
        parameters: {'error': e.toString()},
      );
    }
  }

  /// Update user profile with new data
  Future<void> updateUserProfile({
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? email,
    String? aadhaarNumber,
    Map<String, dynamic>? emergencyContact,
  }) async {
    if (_user == null) {
      setError(true, 'User not authenticated');
      return;
    }

    try {
      setLoading(true);

      await _analyticsService.logEvent(
        name: 'auth_update_profile_start',
        parameters: {'user_id': _user!.userId},
      );

      final updatedUser = _user!.copyWith(
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        email: email,
        aadhaarNumber: aadhaarNumber,
        emergencyContact: emergencyContact,
        updatedAt: DateTime.now(),
      );

      await saveUser(updatedUser);

      await _analyticsService.logEvent(
        name: 'auth_profile_updated',
        parameters: {'user_id': _user!.userId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_update_profile_error',
        parameters: {'user_id': _user!.userId, 'error': e.toString()},
      );
      setError(true, 'Failed to update profile: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // ==================== HELPER METHODS ====================

  /// Check if user exists in Firestore
  Future<bool> _checkUserExists(String userId) async {
    final doc =
        await _firestoreService.getDocument(FirestoreConstants.users, userId);
    return doc.exists;
  }

  /// Get user by ID from Firestore
  Future<UserModel?> _getUserById(String userId) async {
    final doc =
        await _firestoreService.getDocument(FirestoreConstants.users, userId);
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Save user to local preferences
  Future<void> _saveUserToPrefs(UserModel user) async {
    final jsonString = json.encode(user.toJson());
    await _localStorage.write('userData', jsonString);
  }

  /// Clear temporary upload data
  void clearUploadData() {
    _profilePhotoFile = null;
    _profilePhotoUrl = null;
    _aadhaarFile = null;
    _aadhaarUrl = null;
    _uploadingProfile = false;
    _uploadingAadhaar = false;
    notifyListeners();
  }

  // ==================== COMPUTED PROPERTIES ====================

  /// Check if user profile is complete for registration
  bool get isProfileComplete => _user?.isProfileComplete ?? false;

  /// Get user display name for UI
  String get displayName => _user?.displayName ?? 'User';

  /// Get user initials for avatar
  String get initials => _user?.initials ?? 'U';

  /// Check if user is authenticated
  bool get isAuthenticated => _authService.isSignedIn && _user != null;

  /// Check if user is a guest
  bool get isGuest => _user?.isGuest ?? false;

  /// Check if user is an owner
  bool get isOwner => _user?.isOwner ?? false;

  /// Get formatted date of birth
  String? get formattedDateOfBirth => _user?.formattedDateOfBirth;

  /// Creates sample data for guest users for testing purposes
  /// This runs in background and doesn't block the login process
  void _createSampleDataForGuest(String userId) {
    // Run in background to avoid blocking login
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        final sampleDataCreator = SampleDataCreator();
        await sampleDataCreator.createSampleData(userId);
      } catch (e) {
        // Non-critical error - sample data creation failed but login should continue
        debugPrint('⚠️ Failed to create sample data for guest $userId: $e');
      }
    });
  }
}
