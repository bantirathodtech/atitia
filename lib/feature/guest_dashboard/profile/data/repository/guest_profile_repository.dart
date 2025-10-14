// lib/features/guest_dashboard/profile/data/repository/guest_profile_repository.dart

import 'dart:io';

import '../../../../../common/utils/constants/storage.dart';
import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../models/guest_profile_model.dart';

/// Repository handling guest profile data operations and file uploads
/// Uses Firebase service locator for dependency injection
/// Manages guest profile CRUD operations, document uploads, and analytics tracking
class GuestProfileRepository {
  // Get Firebase services through service locator
  final _firestoreService = getIt.firestore;
  final _storageService = getIt.storage;
  final _analyticsService = getIt.analytics;

  /// Retrieves guest profile document from Firestore by userId
  /// Returns null if profile document doesn't exist
  /// Tracks analytics for profile views
  Future<GuestProfileModel?> getGuestProfile(String userId) async {
    try {
      final doc = await _firestoreService.getDocument(
        FirestoreConstants.users,
        userId,
      );

      if (!doc.exists) {
        await _analyticsService.logEvent(
          name: 'guest_profile_not_found',
          parameters: {'user_id': userId},
        );
        return null;
      }

      final profile = GuestProfileModel.fromMap(
        doc.data() as Map<String, dynamic>,
      );

      await _analyticsService.logEvent(
        name: 'guest_profile_viewed',
        parameters: {
          'user_id': userId,
          'profile_completion': profile.profileCompletionPercentage,
        },
      );

      return profile;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'guest_profile_fetch_error',
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch guest profile: $e');
    }
  }

  /// Updates guest profile data in Firestore
  /// Overwrites entire profile document with updated data
  /// Tracks analytics for profile updates
  Future<void> updateGuestProfile(GuestProfileModel guest) async {
    try {
      final updatedGuest = guest.copyWith(lastUpdated: DateTime.now());
      
      await _firestoreService.setDocument(
        FirestoreConstants.users,
        guest.userId,
        updatedGuest.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'guest_profile_updated',
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
        name: 'guest_profile_update_error',
        parameters: {
          'user_id': guest.userId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update guest profile: $e');
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
      
      await _firestoreService.updateDocument(
        FirestoreConstants.users,
        userId,
        fields,
      );

      await _analyticsService.logEvent(
        name: 'guest_profile_fields_updated',
        parameters: {
          'user_id': userId,
          'fields_updated': fields.keys.toList(),
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'guest_profile_fields_update_error',
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update profile fields: $e');
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
      final downloadUrl = await _storageService.uploadFile(file, path, fileName);

      await _analyticsService.logEvent(
        name: 'profile_photo_uploaded',
        parameters: {
          'user_id': userId,
          'file_name': fileName,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'profile_photo_upload_error',
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to upload profile photo: $e');
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
      final downloadUrl = await _storageService.uploadFile(file, path, fileName);

      await _analyticsService.logEvent(
        name: 'aadhaar_photo_uploaded',
        parameters: {
          'user_id': userId,
          'file_name': fileName,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'aadhaar_photo_upload_error',
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to upload Aadhaar photo: $e');
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
      final path = '${StorageConstants.aadhaarDocs}user_$userId/$idProofType.pdf';
      final downloadUrl = await _storageService.uploadFile(file, path, fileName);

      await _analyticsService.logEvent(
        name: 'id_proof_uploaded',
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'id_proof_type': idProofType,
        },
      );

      return downloadUrl;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'id_proof_upload_error',
        parameters: {
          'user_id': userId,
          'file_name': fileName,
          'id_proof_type': idProofType,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to upload ID proof: $e');
    }
  }

  /// Deletes guest profile document from Firestore
  /// Tracks analytics for profile deletions
  Future<void> deleteGuestProfile(String userId) async {
    try {
      await _firestoreService.deleteDocument(
        FirestoreConstants.users,
        userId,
      );

      await _analyticsService.logEvent(
        name: 'guest_profile_deleted',
        parameters: {'user_id': userId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'guest_profile_delete_error',
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to delete guest profile: $e');
    }
  }

  /// Streams guest profile data for real-time updates
  /// Returns continuous stream for reactive UI updates
  Stream<GuestProfileModel?> getGuestProfileStream(String userId) {
    return _firestoreService
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
        name: 'guest_status_updated',
        parameters: {
          'user_id': userId,
          'is_active': isActive,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'guest_status_update_error',
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update guest status: $e');
    }
  }
}
