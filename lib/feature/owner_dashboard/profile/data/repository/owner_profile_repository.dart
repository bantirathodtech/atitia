// lib/features/owner_dashboard/profile/data/repository/owner_profile_repository.dart

import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../common/utils/exceptions/exceptions.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/interfaces/storage/storage_service_interface.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../models/owner_profile_model.dart';

/// Repository for Owner Profile Firestore and Storage operations
/// Uses interface-based services for dependency injection (swappable backends)
/// Handles owner profile CRUD operations and document uploads
/// Enhanced with analytics tracking and error handling
class OwnerProfileRepository {
  final IDatabaseService _databaseService;
  final IStorageService _storageService;
  final IAnalyticsService _analyticsService;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerProfileRepository({
    IDatabaseService? databaseService,
    IStorageService? storageService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _storageService =
            storageService ?? UnifiedServiceLocator.serviceFactory.storage,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Fetches the OwnerProfile document for the given ownerId
  Future<OwnerProfile?> getOwnerProfile(String ownerId) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_fetch',
        parameters: {'owner_id': ownerId},
      );

      final doc = await _databaseService.getDocument(
        FirestoreConstants.users,
        ownerId,
      );

      if (!doc.exists) {
        await _analyticsService.logEvent(
          name: 'owner_profile_not_found',
          parameters: {'owner_id': ownerId},
        );
        return null;
      }

      return OwnerProfile.fromFirestore(doc);
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_profile_fetch_error',
        parameters: {'owner_id': ownerId, 'error': e.toString()},
      );
      throw AppException(
        message: _text(
          'ownerProfileLoadFailed',
          'Failed to load profile',
        ),
        details: e.toString(),
      );
    }
  }

  /// Streams the OwnerProfile document for real-time updates
  Stream<OwnerProfile?> streamOwnerProfile(String ownerId) {
    try {
      _analyticsService.logEvent(
        name: 'owner_profile_stream_started',
        parameters: {'owner_id': ownerId},
      );

      return _databaseService
          .getDocumentStream(
            FirestoreConstants.users,
            ownerId,
          )
          .map((doc) => doc.exists ? OwnerProfile.fromFirestore(doc) : null);
    } catch (e) {
      _analyticsService.logEvent(
        name: 'owner_profile_stream_error',
        parameters: {'owner_id': ownerId, 'error': e.toString()},
      );
      throw AppException(
        message: _text(
          'ownerProfileStreamFailed',
          'Failed to stream profile',
        ),
        details: e.toString(),
      );
    }
  }

  /// Creates a new owner profile
  Future<void> createOwnerProfile(OwnerProfile profile) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_create',
        parameters: {'owner_id': profile.ownerId},
      );

      await _databaseService.setDocument(
        FirestoreConstants.users,
        profile.ownerId,
        profile.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_profile_created',
        parameters: {
          'owner_id': profile.ownerId,
          'has_business_info': profile.hasBusinessInfo.toString(),
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_profile_create_error',
        parameters: {'owner_id': profile.ownerId, 'error': e.toString()},
      );
      throw AppException(
        message: _text(
          'ownerProfileCreateFailed',
          'Failed to create profile',
        ),
        details: e.toString(),
      );
    }
  }

  /// Updates specific fields in OwnerProfile document
  Future<void> updateOwnerProfile(
    String ownerId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_update',
        parameters: {
          'owner_id': ownerId,
          'fields_updated': updatedData.keys.join(','),
        },
      );

      // Add updatedAt timestamp
      updatedData['updatedAt'] = DateTime.now();

      await _databaseService.updateDocument(
        FirestoreConstants.users,
        ownerId,
        updatedData,
      );

      await _analyticsService.logEvent(
        name: 'owner_profile_updated',
        parameters: {'owner_id': ownerId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_profile_update_error',
        parameters: {'owner_id': ownerId, 'error': e.toString()},
      );
      throw AppException(
        message: _text(
          'ownerProfileUpdateFailed',
          'Failed to update profile',
        ),
        details: e.toString(),
      );
    }
  }

  /// Updates the profile photo URL
  Future<void> updateProfilePhoto(String ownerId, String photoUrl) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_photo_update',
        parameters: {'owner_id': ownerId},
      );

      await _databaseService.updateDocument(
        FirestoreConstants.users,
        ownerId,
        {'profilePhoto': photoUrl, 'updatedAt': DateTime.now()},
      );
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerProfilePhotoUpdateFailed',
          'Failed to update profile photo',
        ),
        details: e.toString(),
      );
    }
  }

  /// Updates the Aadhaar photo URL
  Future<void> updateAadhaarPhoto(String ownerId, String photoUrl) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_aadhaar_photo_update',
        parameters: {'owner_id': ownerId},
      );

      await _databaseService.updateDocument(
        FirestoreConstants.users,
        ownerId,
        {'aadhaarPhoto': photoUrl, 'updatedAt': DateTime.now()},
      );
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerAadhaarUpdateFailed',
          'Failed to update Aadhaar photo',
        ),
        details: e.toString(),
      );
    }
  }

  /// Updates the UPI QR code URL
  Future<void> updateUpiQrCode(String ownerId, String qrCodeUrl) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_upi_qr_update',
        parameters: {'owner_id': ownerId},
      );

      await _databaseService.updateDocument(
        FirestoreConstants.users,
        ownerId,
        {
          'upiDetails.qrCodeUrl': qrCodeUrl,
          'updatedAt': DateTime.now(),
        },
      );
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerUpiQrUpdateFailed',
          'Failed to update UPI QR code',
        ),
        details: e.toString(),
      );
    }
  }

  /// Updates bank details
  Future<void> updateBankDetails(
    String ownerId,
    Map<String, String> bankDetails,
  ) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_bank_details_update',
        parameters: {'owner_id': ownerId},
      );

      await _databaseService.updateDocument(
        FirestoreConstants.users,
        ownerId,
        {
          'bankDetails': bankDetails,
          'updatedAt': DateTime.now(),
        },
      );
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerBankDetailsUpdateFailed',
          'Failed to update bank details',
        ),
        details: e.toString(),
      );
    }
  }

  /// Updates business information
  Future<void> updateBusinessInfo(
    String ownerId,
    Map<String, dynamic> businessInfo,
  ) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_business_info_update',
        parameters: {'owner_id': ownerId},
      );

      businessInfo['updatedAt'] = DateTime.now();

      await _databaseService.updateDocument(
        FirestoreConstants.users,
        ownerId,
        businessInfo,
      );
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerBusinessInfoUpdateFailed',
          'Failed to update business information',
        ),
        details: e.toString(),
      );
    }
  }

  /// Uploads profile photo to Cloud Storage
  Future<String> uploadProfilePhoto(
    String ownerId,
    String fileName,
    dynamic file,
  ) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_photo_upload_start',
        parameters: {'owner_id': ownerId},
      );

      final path = 'owners/$ownerId/profile_photos';
      final photoUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: 'owner_profile_photo_uploaded',
        parameters: {'owner_id': ownerId},
      );

      return photoUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_profile_photo_upload_error',
        parameters: {'owner_id': ownerId, 'error': e.toString()},
      );
      throw AppException(
        message: _text(
          'ownerProfilePhotoUploadFailed',
          'Failed to upload profile photo',
        ),
        details: e.toString(),
      );
    }
  }

  /// Uploads Aadhaar document to Cloud Storage
  Future<String> uploadAadhaarDocument(
    String ownerId,
    String fileName,
    dynamic file,
  ) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_aadhaar_upload_start',
        parameters: {'owner_id': ownerId},
      );

      final path = 'owners/$ownerId/documents/aadhaar';
      final documentUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: 'owner_aadhaar_uploaded',
        parameters: {'owner_id': ownerId},
      );

      return documentUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_aadhaar_upload_error',
        parameters: {'owner_id': ownerId, 'error': e.toString()},
      );
      throw AppException(
        message: _text(
          'ownerAadhaarUploadFailed',
          'Failed to upload Aadhaar document',
        ),
        details: e.toString(),
      );
    }
  }

  /// Uploads UPI QR code to Cloud Storage
  Future<String> uploadUpiQrCode(
    String ownerId,
    String fileName,
    dynamic file,
  ) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_upi_qr_upload_start',
        parameters: {'owner_id': ownerId},
      );

      final path = 'owners/$ownerId/upi_qr_codes';
      final qrCodeUrl = await _storageService.uploadFile(
        path: path,
        file: file,
        fileName: fileName,
      );

      await _analyticsService.logEvent(
        name: 'owner_upi_qr_uploaded',
        parameters: {'owner_id': ownerId},
      );

      return qrCodeUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_upi_qr_upload_error',
        parameters: {'owner_id': ownerId, 'error': e.toString()},
      );
      throw AppException(
        message: _text(
          'ownerUpiQrUploadFailed',
          'Failed to upload UPI QR code',
        ),
        details: e.toString(),
      );
    }
  }

  /// Deletes a file from storage
  Future<void> deleteFile(String filePath) async {
    try {
      await _storageService.deleteFile(filePath);
    } catch (e) {
      throw AppException(
        message: _text('ownerFileDeleteFailed', 'Failed to delete file'),
        details: e.toString(),
      );
    }
  }

  /// Gets all PG IDs for an owner
  Future<List<String>> getOwnerPGIds(String ownerId) async {
    try {
      final profile = await getOwnerProfile(ownerId);
      return profile?.pgIds ?? [];
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerPgFetchFailed',
          'Failed to fetch owner PG IDs',
        ),
        details: e.toString(),
      );
    }
  }

  /// Adds a PG ID to owner's profile
  Future<void> addPGToOwner(String ownerId, String pgId) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_pg_added',
        parameters: {'owner_id': ownerId, 'pg_id': pgId},
      );

      final profile = await getOwnerProfile(ownerId);
      if (profile != null && !profile.pgIds.contains(pgId)) {
        final updatedPgIds = [...profile.pgIds, pgId];
        await updateOwnerProfile(ownerId, {'pgIds': updatedPgIds});
      }
    } catch (e) {
      throw AppException(
        message: _text('ownerAddPgFailed', 'Failed to add PG'),
        details: e.toString(),
      );
    }
  }

  /// Removes a PG ID from owner's profile
  Future<void> removePGFromOwner(String ownerId, String pgId) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_pg_removed',
        parameters: {'owner_id': ownerId, 'pg_id': pgId},
      );

      final profile = await getOwnerProfile(ownerId);
      if (profile != null && profile.pgIds.contains(pgId)) {
        final updatedPgIds = profile.pgIds.where((id) => id != pgId).toList();
        await updateOwnerProfile(ownerId, {'pgIds': updatedPgIds});
      }
    } catch (e) {
      throw AppException(
        message: _text('ownerRemovePgFailed', 'Failed to remove PG'),
        details: e.toString(),
      );
    }
  }

  /// Verifies owner profile
  Future<void> verifyOwnerProfile(String ownerId) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_verified',
        parameters: {'owner_id': ownerId},
      );

      await updateOwnerProfile(ownerId, {'isVerified': true});
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerProfileVerifyFailed',
          'Failed to verify profile',
        ),
        details: e.toString(),
      );
    }
  }

  /// Deactivates owner profile
  Future<void> deactivateOwnerProfile(String ownerId) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_deactivated',
        parameters: {'owner_id': ownerId},
      );

      await updateOwnerProfile(ownerId, {'isActive': false});
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerProfileDeactivateFailed',
          'Failed to deactivate profile',
        ),
        details: e.toString(),
      );
    }
  }

  /// Activates owner profile
  Future<void> activateOwnerProfile(String ownerId) async {
    try {
      await _analyticsService.logEvent(
        name: 'owner_profile_activated',
        parameters: {'owner_id': ownerId},
      );

      await updateOwnerProfile(ownerId, {'isActive': true});
    } catch (e) {
      throw AppException(
        message: _text(
          'ownerProfileActivateFailed',
          'Failed to activate profile',
        ),
        details: e.toString(),
      );
    }
  }
}
