// lib/features/owner_dashboard/profile/viewmodel/owner_profile_viewmodel.dart

import 'dart:async';

import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../common/utils/exceptions/exceptions.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../data/models/owner_profile_model.dart';
import '../data/repository/owner_profile_repository.dart';

/// ViewModel for managing owner profile data, updates, and document uploads
/// Extends BaseProviderState for automatic state management
/// Handles profile CRUD operations, file uploads, and business logic
/// Enhanced with real-time streaming and comprehensive error handling
class OwnerProfileViewModel extends BaseProviderState {
  final OwnerProfileRepository _repository;
  final _authService = getIt.auth;
  final _analyticsService = getIt.analytics;

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  OwnerProfileViewModel({
    OwnerProfileRepository? repository,
  }) : _repository = repository ?? OwnerProfileRepository();

  OwnerProfile? _profile;
  StreamSubscription<OwnerProfile?>? _profileSubscription;
  bool _isUploading = false;

  /// Read-only owner profile data for UI consumption
  OwnerProfile? get profile => _profile;

  /// Check if file upload is in progress
  bool get isUploading => _isUploading;

  /// Gets current owner ID from auth service
  String? get currentOwnerId => _authService.currentUserId;

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  /// Loads owner profile data from Firestore
  Future<void> loadProfile({String? ownerId}) async {
    try {
      setLoading(true);

      final id = ownerId ?? currentOwnerId;
      if (id == null || id.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_profile_load',
        parameters: {'owner_id': id},
      );

      _profile = await _repository.getOwnerProfile(id);

      if (_profile == null) {
        throw AppException(
          message: 'Profile not found',
          severity: ErrorSeverity.high,
        );
      }

      notifyListeners();
    } catch (e) {
      final exception = AppException(
        message: 'Failed to load profile',
        details: e.toString(),
      );
      setError(true, exception.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Streams owner profile for real-time updates
  void streamProfile({String? ownerId}) {
    try {
      final id = ownerId ?? currentOwnerId;
      if (id == null || id.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      _analyticsService.logEvent(
        name: 'owner_profile_stream',
        parameters: {'owner_id': id},
      );

      _profileSubscription?.cancel();
      _profileSubscription = _repository.streamOwnerProfile(id).listen(
        (profile) {
          _profile = profile;
          notifyListeners();
        },
        onError: (error) {
          final exception = AppException(
            message: 'Failed to stream profile',
            details: error.toString(),
          );
          setError(true, exception.toString());
        },
      );
    } catch (e) {
      final exception = AppException(
        message: 'Failed to start profile stream',
        details: e.toString(),
      );
      setError(true, exception.toString());
    }
  }

  /// Creates a new owner profile
  Future<void> createProfile(OwnerProfile profile) async {
    try {
      setLoading(true);

      await _analyticsService.logEvent(
        name: 'owner_profile_create_start',
        parameters: {'owner_id': profile.ownerId},
      );

      await _repository.createOwnerProfile(profile);
      _profile = profile;

      await _analyticsService.logEvent(
        name: 'owner_profile_created',
        parameters: {'owner_id': profile.ownerId},
      );

      notifyListeners();
    } catch (e) {
      final exception = AppException(
        message: 'Failed to create profile',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Updates owner profile with specific fields
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_profile_update_start',
        parameters: {
          'owner_id': ownerId,
          'fields': updatedData.keys.join(','),
        },
      );

      await _repository.updateOwnerProfile(ownerId, updatedData);
      await loadProfile();

      await _analyticsService.logEvent(
        name: 'owner_profile_updated',
        parameters: {'owner_id': ownerId},
      );
    } catch (e) {
      final exception = AppException(
        message: 'Failed to update profile',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Updates bank details
  Future<void> updateBankDetails(Map<String, String> bankDetails) async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_bank_details_update_start',
        parameters: {'owner_id': ownerId},
      );

      await _repository.updateBankDetails(ownerId, bankDetails);
      await loadProfile();

      await _analyticsService.logEvent(
        name: 'owner_bank_details_updated',
        parameters: {'owner_id': ownerId},
      );
    } catch (e) {
      final exception = AppException(
        message: 'Failed to update bank details',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Updates business information
  Future<void> updateBusinessInfo(Map<String, dynamic> businessInfo) async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_business_info_update_start',
        parameters: {'owner_id': ownerId},
      );

      await _repository.updateBusinessInfo(ownerId, businessInfo);
      await loadProfile();

      await _analyticsService.logEvent(
        name: 'owner_business_info_updated',
        parameters: {'owner_id': ownerId},
      );
    } catch (e) {
      final exception = AppException(
        message: 'Failed to update business information',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Uploads profile photo and updates profile
  Future<String> uploadProfilePhoto(String fileName, dynamic file) async {
    try {
      _isUploading = true;
      notifyListeners();

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_profile_photo_upload_start',
        parameters: {'owner_id': ownerId},
      );

      final photoUrl = await _repository.uploadProfilePhoto(
        ownerId,
        fileName,
        file,
      );

      await _repository.updateProfilePhoto(ownerId, photoUrl);
      await loadProfile();

      await _analyticsService.logEvent(
        name: 'owner_profile_photo_uploaded',
        parameters: {'owner_id': ownerId},
      );

      return photoUrl;
    } catch (e) {
      final exception = AppException(
        message: 'Failed to upload profile photo',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Uploads Aadhaar document and updates profile
  Future<String> uploadAadhaarDocument(String fileName, dynamic file) async {
    try {
      _isUploading = true;
      notifyListeners();

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_aadhaar_upload_start',
        parameters: {'owner_id': ownerId},
      );

      final documentUrl = await _repository.uploadAadhaarDocument(
        ownerId,
        fileName,
        file,
      );

      await _repository.updateAadhaarPhoto(ownerId, documentUrl);
      await loadProfile();

      await _analyticsService.logEvent(
        name: 'owner_aadhaar_uploaded',
        parameters: {'owner_id': ownerId},
      );

      return documentUrl;
    } catch (e) {
      final exception = AppException(
        message: 'Failed to upload Aadhaar document',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Uploads UPI QR code and updates profile
  Future<String> uploadUpiQrCode(String fileName, dynamic file) async {
    try {
      _isUploading = true;
      notifyListeners();

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_upi_qr_upload_start',
        parameters: {'owner_id': ownerId},
      );

      final qrCodeUrl = await _repository.uploadUpiQrCode(
        ownerId,
        fileName,
        file,
      );

      await _repository.updateUpiQrCode(ownerId, qrCodeUrl);
      await loadProfile();

      await _analyticsService.logEvent(
        name: 'owner_upi_qr_uploaded',
        parameters: {'owner_id': ownerId},
      );

      return qrCodeUrl;
    } catch (e) {
      final exception = AppException(
        message: 'Failed to upload UPI QR code',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Adds a PG to owner's profile
  Future<void> addPG(String pgId) async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _repository.addPGToOwner(ownerId, pgId);
      await loadProfile();
    } catch (e) {
      final exception = AppException(
        message: 'Failed to add PG',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Removes a PG from owner's profile
  Future<void> removePG(String pgId) async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _repository.removePGFromOwner(ownerId, pgId);
      await loadProfile();
    } catch (e) {
      final exception = AppException(
        message: 'Failed to remove PG',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Verifies owner profile
  Future<void> verifyProfile() async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _repository.verifyOwnerProfile(ownerId);
      await loadProfile();
    } catch (e) {
      final exception = AppException(
        message: 'Failed to verify profile',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Deactivates owner profile
  Future<void> deactivateProfile() async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _repository.deactivateOwnerProfile(ownerId);
      await loadProfile();
    } catch (e) {
      final exception = AppException(
        message: 'Failed to deactivate profile',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Activates owner profile
  Future<void> activateProfile() async {
    try {
      setLoading(true);

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: 'Owner ID not available',
          severity: ErrorSeverity.high,
        );
      }

      await _repository.activateOwnerProfile(ownerId);
      await loadProfile();
    } catch (e) {
      final exception = AppException(
        message: 'Failed to activate profile',
        details: e.toString(),
      );
      setError(true, exception.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Clears current profile data
  void clearProfile() {
    _profile = null;
    _profileSubscription?.cancel();
    clearError();
    notifyListeners();
  }

  /// Checks if owner profile has complete business information
  bool get hasCompleteBusinessInfo => _profile?.hasCompleteProfile ?? false;

  /// Checks if owner has UPI payment setup configured
  bool get hasUpiSetup => _profile?.hasUpiSetup ?? false;

  /// Gets profile completion percentage
  int get profileCompletionPercentage =>
      _profile?.profileCompletionPercentage ?? 0;

  /// Checks if profile is verified
  bool get isVerified => _profile?.isVerified ?? false;

  /// Checks if profile is active
  bool get isActive => _profile?.isActive ?? true;
}
