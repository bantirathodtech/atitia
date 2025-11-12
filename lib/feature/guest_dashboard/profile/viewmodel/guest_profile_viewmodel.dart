// lib/features/guest_dashboard/profile/viewmodel/guest_profile_viewmodel.dart

import 'dart:io';

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/services/localization/internationalization_service.dart';
import '../data/models/guest_profile_model.dart';
import '../data/repository/guest_profile_repository.dart';

/// ViewModel for managing guest profile data, updates, and file uploads
/// Extends BaseProviderState for automatic service access and state management
/// Handles profile loading, updates, document upload operations, and analytics tracking
class GuestProfileViewModel extends BaseProviderState {
  final GuestProfileRepository _repository;
  final _analyticsService = getIt.analytics;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  GuestProfileViewModel({
    GuestProfileRepository? repository,
  }) : _repository = repository ?? GuestProfileRepository();

  GuestProfileModel? _guest;
  bool _isEditing = false;
  Map<String, dynamic> _editedFields = {};

  /// Read-only guest profile data for UI consumption
  GuestProfileModel? get guest => _guest;

  /// Returns true if profile is in edit mode
  bool get isEditing => _isEditing;

  /// Returns edited fields
  Map<String, dynamic> get editedFields => _editedFields;

  /// Loads guest profile data by userId from Firestore
  /// Handles loading state and error management automatically
  /// Sets up real-time listener for profile updates
  Future<void> loadGuestProfile(String userId) async {
    try {
      setLoading(true);
      clearError();
      _guest = await _repository.getGuestProfile(userId);

      _analyticsService.logEvent(
        name: _i18n.translate('guestProfileLoadedEvent'),
        parameters: {
          'user_id': userId,
          'profile_completion': _guest?.profileCompletionPercentage ?? 0,
        },
      );
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToLoadProfile', parameters: {
            'error': e.toString(),
          }));
      _guest = null;
    } finally {
      setLoading(false);
    }
  }

  /// Streams guest profile data for real-time updates
  /// Sets up continuous listener for profile changes
  void streamGuestProfile(String userId) {
    setLoading(true);
    clearError();

    _repository.getGuestProfileStream(userId).listen(
      (profile) {
        _guest = profile;
        setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        setError(
            true,
            _i18n.translate('failedToStreamProfile', parameters: {
              'error': error.toString(),
            }));
        setLoading(false);
      },
    );
  }

  /// Updates guest profile data in Firestore
  /// Returns true on success, false on failure
  /// Tracks analytics for profile updates
  Future<bool> updateGuestProfile(GuestProfileModel updatedGuest) async {
    try {
      setLoading(true);
      clearError();
      await _repository.updateGuestProfile(updatedGuest);
      _guest = updatedGuest;

      _analyticsService.logEvent(
        name: _i18n.translate('guestProfileUpdateSuccessEvent'),
        parameters: {
          'user_id': updatedGuest.userId,
          'profile_completion': updatedGuest.profileCompletionPercentage,
        },
      );

      return true;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUpdateGuestProfile', parameters: {
            'error': e.toString(),
          }));
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Partially updates guest profile fields
  /// Only updates specified fields without overwriting entire document
  Future<bool> updateProfileFields(
    String userId,
    Map<String, dynamic> fields,
  ) async {
    try {
      setLoading(true);
      clearError();
      await _repository.updateGuestProfileFields(userId, fields);

      // Reload profile to get updated data
      await loadGuestProfile(userId);

      _analyticsService.logEvent(
        name: _i18n.translate('guestProfileFieldsUpdateSuccessEvent'),
        parameters: {
          'user_id': userId,
          'fields_count': fields.length,
        },
      );

      return true;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUpdateProfileFields', parameters: {
            'error': e.toString(),
          }));
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Uploads profile photo and returns the download URL
  /// Handles file upload to Cloud Storage with proper error handling
  /// Updates profile with new photo URL
  Future<String?> uploadProfilePhoto(
    String userId,
    String fileName,
    File file,
  ) async {
    try {
      setLoading(true);
      clearError();
      final downloadUrl =
          await _repository.uploadProfilePhoto(userId, fileName, file);

      // Update profile with new photo URL
      await updateProfileFields(userId, {'profilePhotoUrl': downloadUrl});

      _analyticsService.logEvent(
        name: _i18n.translate('profilePhotoUploadSuccessEvent'),
        parameters: {'user_id': userId},
      );

      return downloadUrl;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUploadProfilePhoto', parameters: {
            'error': e.toString(),
          }));
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Uploads Aadhaar photo and returns the download URL
  /// Handles document upload to Cloud Storage securely
  /// Updates profile with new Aadhaar photo URL
  Future<String?> uploadAadhaarPhoto(
    String userId,
    String fileName,
    File file,
  ) async {
    try {
      setLoading(true);
      clearError();
      final downloadUrl =
          await _repository.uploadAadhaarPhoto(userId, fileName, file);

      // Update profile with new Aadhaar photo URL
      await updateProfileFields(userId, {'aadhaarPhotoUrl': downloadUrl});

      _analyticsService.logEvent(
        name: _i18n.translate('aadhaarPhotoUploadSuccessEvent'),
        parameters: {'user_id': userId},
      );

      return downloadUrl;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUploadAadhaarPhoto', parameters: {
            'error': e.toString(),
          }));
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Uploads ID proof document and returns the download URL
  /// Supports various ID proof types
  Future<String?> uploadIdProof(
    String userId,
    String fileName,
    File file,
    String idProofType,
  ) async {
    try {
      setLoading(true);
      clearError();
      final downloadUrl = await _repository.uploadIdProof(
        userId,
        fileName,
        file,
        idProofType,
      );

      // Update profile with new ID proof URL
      await updateProfileFields(userId, {
        'idProofUrl': downloadUrl,
        'idProofType': idProofType,
      });

      _analyticsService.logEvent(
        name: _i18n.translate('idProofUploadSuccessEvent'),
        parameters: {
          'user_id': userId,
          'id_proof_type': idProofType,
        },
      );

      return downloadUrl;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUploadIdProof', parameters: {
            'error': e.toString(),
          }));
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Updates guest status (active/inactive)
  Future<bool> updateGuestStatus(String userId, bool isActive) async {
    try {
      setLoading(true);
      clearError();
      await _repository.updateGuestStatus(userId, isActive);

      // Reload profile to get updated status
      await loadGuestProfile(userId);

      _analyticsService.logEvent(
        name: _i18n.translate('guestStatusUpdateSuccessEvent'),
        parameters: {
          'user_id': userId,
          'is_active': isActive,
        },
      );

      return true;
    } catch (e) {
      setError(
          true,
          _i18n.translate('failedToUpdateGuestStatus', parameters: {
            'error': e.toString(),
          }));
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Clears current guest profile data
  /// Useful for logout or profile switching scenarios
  void clearProfile() {
    _guest = null;
    _isEditing = false;
    _editedFields = {};
    clearError();
    notifyListeners();

    _analyticsService.logEvent(
      name: _i18n.translate('guestProfileClearedEvent'),
      parameters: {},
    );
  }

  /// Enables edit mode for profile
  void startEditing() {
    _isEditing = true;
    _editedFields = {};
    notifyListeners();

    _analyticsService.logEvent(
      name: _i18n.translate('guestProfileEditStartedEvent'),
      parameters: {},
    );
  }

  /// Disables edit mode and discards changes
  void cancelEditing() {
    _isEditing = false;
    _editedFields = {};
    notifyListeners();

    _analyticsService.logEvent(
      name: _i18n.translate('guestProfileEditCancelledEvent'),
      parameters: {},
    );
  }

  /// Updates a field in the edited fields map
  void updateField(String key, dynamic value) {
    _editedFields[key] = value;
    notifyListeners();
  }

  /// Saves edited fields to Firestore
  Future<bool> saveEditedFields(String userId) async {
    if (_editedFields.isEmpty) {
      setError(true, _i18n.translate('noChangesToSave'));
      return false;
    }

    final success = await updateProfileFields(userId, _editedFields);
    if (success) {
      _isEditing = false;
      _editedFields = {};
      notifyListeners();
    }
    return success;
  }

  /// Refreshes profile data
  Future<void> refreshProfile(String userId) async {
    await loadGuestProfile(userId);

    _analyticsService.logEvent(
      name: _i18n.translate('guestProfileRefreshedEvent'),
      parameters: {'user_id': userId},
    );
  }

  /// Checks if guest profile has basic required information
  bool get hasCompleteProfile => _guest?.hasCompleteProfile ?? false;

  /// Gets formatted display name for UI
  String get displayName => _guest?.displayName ?? _i18n.translate('guestUser');

  /// Gets profile initials for avatar
  String get initials =>
      _guest?.initials ?? _i18n.translate('guestInitialsFallback');

  /// Gets profile completion percentage
  int get profileCompletionPercentage =>
      _guest?.profileCompletionPercentage ?? 0;

  /// Checks if profile has emergency contact
  bool get hasEmergencyContact => _guest?.hasEmergencyContact ?? false;

  /// Checks if profile has guardian information
  bool get hasGuardianInfo => _guest?.hasGuardianInfo ?? false;

  /// Checks if profile has vehicle information
  bool get hasVehicleInfo => _guest?.hasVehicleInfo ?? false;

  /// Checks if profile has medical information
  bool get hasMedicalInfo => _guest?.hasMedicalInfo ?? false;

  /// Checks if profile has professional information
  bool get hasProfessionalInfo => _guest?.hasProfessionalInfo ?? false;

  /// Checks if profile has ID proof
  bool get hasIdProof => _guest?.hasIdProof ?? false;

  /// Checks if profile is active
  bool get isActive => _guest?.isActive ?? false;
}
