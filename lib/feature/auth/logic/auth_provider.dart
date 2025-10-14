import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../common/lifecycle/state/provider_state.dart';
import '../../../common/utils/constants/firestore.dart';
import '../../../common/utils/exceptions/exceptions.dart';
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
class AuthProvider extends BaseProviderState {
  // Service access via GetIt
  final AuthenticationServiceWrapper _authService = getIt.auth;
  final FirestoreServiceWrapper _firestoreService = getIt.firestore;
  final LocalStorageService _localStorage = getIt.localStorage;
  final SupabaseStorageServiceWrapper _storageService = getIt.storage;
  final NavigationService _navigation = getIt<NavigationService>();
  final _analyticsService = getIt.analytics;
  final _appleSignInService = getIt.appleSignIn;
  final AuthRepository _repository = AuthRepository();

  UserModel? _user;
  String? _verificationId;
  bool _sendingOtp = false;

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
        print('🔄 AuthProvider: User data loaded from storage on init: ${_user!.userId}');
      } else {
        print('🔄 AuthProvider: No cached user data found');
      }
    } catch (e) {
      print('⚠️ AuthProvider: Failed to load cached user: $e');
    }
  }

  // ==========================================================================
  // Photo/Document Upload State
  // ==========================================================================
  // Files can be File (mobile) or XFile (web) - using dynamic for compatibility
  // ==========================================================================
  dynamic _profilePhotoFile;  // File on mobile, XFile on web
  String? _profilePhotoUrl;
  bool _uploadingProfile = false;

  dynamic _aadhaarFile;  // File on mobile, XFile on web
  String? _aadhaarUrl;
  bool _uploadingAadhaar = false;

  dynamic get profilePhotoFile => _profilePhotoFile;
  String? get profilePhotoUrl => _profilePhotoUrl;
  bool get uploadingProfile => _uploadingProfile;

  dynamic get aadhaarFile => _aadhaarFile;
  String? get aadhaarUrl => _aadhaarUrl;
  bool get uploadingAadhaar => _uploadingAadhaar;

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
        print('✅ User restored from local storage: ${_user!.userId}');
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
      print('⚠️ Auto login error: $e');
      // Even if Firestore sync fails, keep the locally restored user
      // This allows offline access
      if (_user != null) {
        print('⚠️ Using cached user data despite sync error');
        return true;  // Continue with cached data
      }
      setError(true, 'Auto login failed: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Navigates user based on role and profile completion
  Future<void> navigateAfterSplash() async {
    try {
      await _analyticsService.logEvent(name: 'auth_navigate_after_splash');

      if (_user == null) {
        await _analyticsService.logEvent(name: 'auth_navigate_to_role_selection');
        _navigation.goToRoleSelection();
        return;
      }

      final role = _user!.role;

      await _analyticsService.logEvent(
        name: 'auth_navigate_by_role',
        parameters: {'role': role, 'user_id': _user!.userId},
      );

      // Check if profile is complete
      if (!_user!.isProfileComplete) {
        await _analyticsService.logEvent(
          name: 'auth_navigate_to_registration',
          parameters: {'role': role, 'user_id': _user!.userId},
        );
        _navigation.goToRegistration();
        return;
      }

      // Navigate based on role
      if (role == 'guest') {
        _navigation.goToGuestHome();
      } else if (role == 'owner') {
        _navigation.goToOwnerHome();
      } else {
        _navigation.goToRoleSelection();
      }
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_navigate_error',
        parameters: {'error': e.toString()},
      );
      _navigation.goToRoleSelection();
    }
  }

  /// Clears session and signs out user
  /// After logout, user must select their role again (Owner/Guest)
  Future<void> signOut() async {
    try {
      setLoading(true);

      await _analyticsService.logEvent(
        name: 'auth_logout_start',
        parameters: {'user_id': _user?.userId ?? 'unknown'},
      );

      await _repository.logout();
      _user = null;
      await _localStorage.delete('userData');
      clearUploadData();
      notifyListeners();
      clearError();

      await _analyticsService.logEvent(name: 'auth_logout_success');

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

  /// Sets the user's role and updates the cached user model
  void setRole(String role) {
    try {
      _analyticsService.logEvent(
        name: 'auth_role_selected',
        parameters: {'role': role},
      );

      if (_user == null) {
        _user = UserModel(
          userId: _authService.currentUserId ?? '',
          phoneNumber: _authService.currentUser?.phoneNumber ?? '',
          role: role,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        _user = _user!.copyWith(role: role);
      }
      notifyListeners();
    } catch (e) {
      setError(true, 'Failed to set role: $e');
    }
  }

  /// Sends OTP for login - Platform-aware implementation
  Future<void> sendOTP(
    String phoneNumber,
    PhoneCodeSent onCodeSent,
    PhoneVerificationFailed onError,
  ) async {
    try {
      _sendingOtp = true;
      notifyListeners();

      final fullPhoneNumber = '+91$phoneNumber';

      await _analyticsService.logEvent(
        name: 'auth_send_otp_request',
        parameters: {'phone_number': fullPhoneNumber},
      );

      // Check if running on macOS - phone OTP is not supported
      if (Platform.isMacOS) {
        await _analyticsService.logEvent(
          name: 'auth_send_otp_error',
          parameters: {'phone_number': fullPhoneNumber, 'error': 'Phone OTP not supported on macOS'},
        );
        throw AppException(
          message: 'Phone OTP authentication is not available on macOS',
          details: 'Please use Google Sign-In instead',
          severity: ErrorSeverity.medium,
          recoverySuggestion: 'Use Google Sign-In button below for macOS authentication',
        );
      }

      await _repository.sendVerificationCode(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          await _authService.signInWithCredential(credential);
        },
        verificationFailed: (error) {
          _analyticsService.logEvent(
            name: 'auth_otp_verification_failed',
            parameters: {'error': error.message ?? 'Unknown error'},
          );
          onError(error);
        },
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _analyticsService.logEvent(name: 'auth_otp_code_sent');
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_send_otp_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Failed to send OTP: $e');
      rethrow;
    } finally {
      _sendingOtp = false;
      notifyListeners();
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
        // New user - set basic user data and return false
        // IMPORTANT: Keep userModel (has phone number from Firebase)
        // Only update the role if it was pre-selected during role selection
        _user = userModel.copyWith(
          role: _user?.role ?? userModel.role,
        );
        
        // Debug log to verify phone number
        await _analyticsService.logEvent(
          name: 'auth_new_user_data_set',
          parameters: {
            'user_id': _user!.userId,
            'phone_number': _user!.phoneNumber,
            'role': _user!.role,
          },
        );
        
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

  /// Sign in with Google and navigate accordingly
  Future<void> signInWithGoogle() async {
    try {
      setLoading(true);

      await _analyticsService.logEvent(name: 'auth_google_signin_attempt');

      final signedInUser = await _repository.signInWithGoogle();

      // Check if user exists in Firestore
      final doc = await _firestoreService.getDocument(
        FirestoreConstants.users,
        signedInUser.userId,
      );

      if (!doc.exists) {
        // New user - save basic profile
        final newUser = signedInUser.copyWith(
          role: _user?.role ?? 'guest',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await _firestoreService.setDocument(
          FirestoreConstants.users,
          newUser.userId,
          newUser.toFirestore(),
        );

        _user = newUser;
      } else {
        // Existing user - load profile and update last login
        _user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        _user = _user!.copyWith(lastLoginAt: DateTime.now());

        await _firestoreService.updateDocument(
          FirestoreConstants.users,
          _user!.userId,
          {'lastLoginAt': DateTime.now()},
        );
      }

      await _saveUserToPrefs(_user!);
      notifyListeners();
      clearError();

      await _analyticsService.logEvent(
        name: 'auth_google_signin_success',
        parameters: {'user_id': _user!.userId, 'role': _user!.role},
      );

      // Navigate based on role
      _navigateByRole();
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_google_signin_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Google sign-in failed: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Sign in with Apple and navigate accordingly
  Future<void> signInWithApple() async {
    try {
      setLoading(true);

      await _analyticsService.logEvent(name: 'auth_apple_signin_attempt');

      final signedInUser = await _repository.signInWithApple();

      // Check if user exists in Firestore
      final doc = await _firestoreService.getDocument(
        FirestoreConstants.users,
        signedInUser.userId,
      );

      if (!doc.exists) {
        // New user - save basic profile
        final newUser = signedInUser.copyWith(
          role: _user?.role ?? 'guest',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await _firestoreService.setDocument(
          FirestoreConstants.users,
          newUser.userId,
          newUser.toFirestore(),
        );

        _user = newUser;
      } else {
        // Existing user - load profile and update last login
        _user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        _user = _user!.copyWith(lastLoginAt: DateTime.now());

        await _firestoreService.updateDocument(
          FirestoreConstants.users,
          _user!.userId,
          {'lastLoginAt': DateTime.now()},
        );
      }

      await _saveUserToPrefs(_user!);
      notifyListeners();
      clearError();

      await _analyticsService.logEvent(
        name: 'auth_apple_signin_success',
        parameters: {'user_id': _user!.userId, 'role': _user!.role},
      );

      // Navigate based on role
      _navigateByRole();
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'auth_apple_signin_error',
        parameters: {'error': e.toString()},
      );
      setError(true, 'Apple sign-in failed: $e');
      rethrow;
    } finally {
      setLoading(false);
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

  /// Navigate user based on role
  void _navigateByRole() {
    if (_user == null) {
      _navigation.goToPhoneAuth();
      return;
    }

    if (_user!.role == 'owner') {
      _navigation.goToOwnerHome();
    } else {
      _navigation.goToGuestHome();
    }
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
        print('✅ Sample data created for guest: $userId');
      } catch (e) {
        print('⚠️ Failed to create sample data for guest: $e');
      }
    });
  }
}
