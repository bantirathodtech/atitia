// lib/features/guest_dashboard/profile/data/repository/guest_profile_repository.dart

import 'dart:io';

import '../../../../../common/utils/constants/storage.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/interfaces/storage/storage_service_interface.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../models/guest_profile_model.dart';

/// Repository handling guest profile data operations and file uploads
/// Uses interface-based services for dependency injection (swappable backends)
/// Manages guest profile CRUD operations, document uploads, and analytics tracking
class GuestProfileRepository {
  final IDatabaseService _databaseService;
  final IStorageService _storageService;
  final IAnalyticsService _analyticsService;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  GuestProfileRepository({
    IDatabaseService? databaseService,
    IStorageService? storageService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _storageService =
            storageService ?? UnifiedServiceLocator.serviceFactory.storage,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Retrieves guest profile document from Firestore by userId
  /// Returns null if profile document doesn't exist
  /// Tracks analytics for profile views
  Future<GuestProfileModel?> getGuestProfile(String userId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.users,
        userId,
      );

      if (!doc.exists) {
        await _analyticsService.logEvent(
          name: _i18n.translate('guestProfileNotFoundEvent'),
          parameters: {'user_id': userId},
        );
        return null;
      }

      final profile = GuestProfileModel.fromMap(
        doc.data() as Map<String, dynamic>,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileViewedEvent'),
        parameters: {
          'user_id': userId,
          'profile_completion': profile.profileCompletionPercentage,
        },
      );

      return profile;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileFetchErrorEvent'),
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception(_i18n.translate('failedToFetchGuestProfile', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Updates guest profile data in Firestore
  /// Overwrites entire profile document with updated data
  /// Tracks analytics for profile updates
  Future<void> updateGuestProfile(GuestProfileModel guest) async {
    try {
      final updatedGuest = guest.copyWith(lastUpdated: DateTime.now());

      await _databaseService.setDocument(
        FirestoreConstants.users,
        guest.userId,
        updatedGuest.toMap(),
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileUpdatedEvent'),
        parameters: {
          'user_id': guest.userId,
          'profile_completion': guest.profileCompletionPercentage,
          'has_emergency_contact': guest.hasEmergencyContact,
          'has_guardian_info': guest.hasGuardianInfo,
          'has_vehicle_info': guest.hasVehicleInfo,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileUpdateErrorEvent'),
        parameters: {
          'user_id': guest.userId,
          'error': e.toString(),
        },
      );
      throw Exception(
          _i18n.translate('failedToUpdateGuestProfile', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Partially updates guest profile fields in Firestore
  /// Only updates specified fields without overwriting entire document
  Future<void> updateGuestProfileFields(
    String userId,
    Map<String, dynamic> fields,
  ) async {
    try {
      fields['lastUpdated'] = DateTime.now();

      await _databaseService.updateDocument(
        FirestoreConstants.users,
        userId,
        fields,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileFieldsUpdatedEvent'),
        parameters: {
          'user_id': userId,
          'fields_updated': fields.keys.toList(),
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileFieldsUpdateErrorEvent'),
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception(
          _i18n.translate('failedToUpdateProfileFields', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Uploads guest's profile photo to Cloud Storage and returns download URL
  /// Organizes files by userId for easy management
  /// Tracks analytics for photo uploads
  Future<String> uploadProfilePhoto(
    String userId,
    String fileName,
    File file,
  ) async {
    try {
      final path = '${StorageConstants.profilePhotos}user_$userId/profile.jpg';
      final downloadUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('profilePhotoUploadedEvent'),
        parameters: {
          'user_id': userId,
          'file_name': fileName,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('profilePhotoUploadErrorEvent'),
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'error': e.toString(),
        },
      );
      throw Exception(
          _i18n.translate('failedToUploadProfilePhoto', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Uploads guest's Aadhaar photo to Cloud Storage and returns download URL
  /// Uses secure path organization for document storage
  /// Tracks analytics for document uploads
  Future<String> uploadAadhaarPhoto(
    String userId,
    String fileName,
    File file,
  ) async {
    try {
      final path = '${StorageConstants.aadhaarDocs}user_$userId/aadhaar.pdf';
      final downloadUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('aadhaarPhotoUploadedEvent'),
        parameters: {
          'user_id': userId,
          'file_name': fileName,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('aadhaarPhotoUploadErrorEvent'),
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'error': e.toString(),
        },
      );
      throw Exception(
          _i18n.translate('failedToUploadAadhaarPhoto', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Uploads guest's ID proof document to Cloud Storage and returns download URL
  /// Supports various ID proof types (Passport, Driving License, etc.)
  Future<String> uploadIdProof(
    String userId,
    String fileName,
    File file,
    String idProofType,
  ) async {
    try {
      final path =
          '${StorageConstants.aadhaarDocs}user_$userId/$idProofType.pdf';
      final downloadUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('idProofUploadedEvent'),
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'id_proof_type': idProofType,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('idProofUploadErrorEvent'),
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'id_proof_type': idProofType,
          'error': e.toString(),
        },
      );
      throw Exception(_i18n.translate('failedToUploadIdProof', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Deletes guest profile document from Firestore
  /// Tracks analytics for profile deletions
  Future<void> deleteGuestProfile(String userId) async {
    try {
      await _databaseService.deleteDocument(
        FirestoreConstants.users,
        userId,
      );

      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileDeletedEvent'),
        parameters: {'user_id': userId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('guestProfileDeleteErrorEvent'),
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception(
          _i18n.translate('failedToDeleteGuestProfile', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Streams guest profile data for real-time updates
  /// Returns continuous stream for reactive UI updates
  Stream<GuestProfileModel?> getGuestProfileStream(String userId) {
    return _databaseService
        .getDocumentStream(FirestoreConstants.users, userId)
        .map((snapshot) {
      if (!snapshot.exists) return null;
      return GuestProfileModel.fromMap(
        snapshot.data() as Map<String, dynamic>,
      );
    });
  }

  /// Updates guest profile status (active/inactive)
  Future<void> updateGuestStatus(String userId, bool isActive) async {
    try {
      await updateGuestProfileFields(userId, {
        'isActive': isActive,
      });

      await _analyticsService.logEvent(
        name: _i18n.translate('guestStatusUpdatedEvent'),
        parameters: {
          'user_id': userId,
          'is_active': isActive,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: _i18n.translate('guestStatusUpdateErrorEvent'),
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception(_i18n.translate('failedToUpdateGuestStatus', parameters: {
        'error': e.toString(),
      }));
    }
  }
}
