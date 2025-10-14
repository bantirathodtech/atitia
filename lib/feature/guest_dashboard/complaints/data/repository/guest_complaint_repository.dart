// lib/features/guest_dashboard/complaints/repository/guest_complaint_repository.dart

import 'dart:io';

import 'package:atitia/core/di/firebase/di/firebase_service_locator.dart'
    hide getIt;

import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/di/firebase/container/firebase_dependency_container.dart';
import '../models/guest_complaint_model.dart';

/// Repository layer for guest complaints data operations
/// Uses GetIt service locator for Firebase service access
/// Handles both Firestore operations and Cloud Storage uploads
class GuestComplaintRepository {
  // Get Firebase services via centralized GetIt
  final _firestoreService = getIt.firestore;
  final _storageService = getIt.storage;

  /// Streams complaints for a specific guest with real-time updates
  /// Uses Firestore query to filter complaints by guestId
  Stream<List<GuestComplaintModel>> getComplaintsForGuest(String guestId) {
    return _firestoreService
        .getCollectionStreamWithFilter(
          FirestoreConstants.complaints, // Collection name from constants
          'guestId',
          guestId,
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => GuestComplaintModel.fromMap(
                  doc.data()! as Map<String, dynamic>,
                ))
            .toList());
  }

  /// Adds a new complaint document to Firestore
  /// Uses complaintId as the document ID for direct access
  Future<void> addComplaint(GuestComplaintModel complaint) async {
    await _firestoreService.setDocument(
      FirestoreConstants.complaints, // Collection name from constants
      complaint.complaintId,
      complaint.toMap(),
    );
  }

  /// Updates an existing complaint document in Firestore
  /// Overwrites entire document with updated complaint data
  Future<void> updateComplaint(GuestComplaintModel complaint) async {
    await _firestoreService.updateDocument(
      FirestoreConstants.complaints, // Collection name from constants
      complaint.complaintId,
      complaint.toMap(),
    );
  }

  /// Uploads complaint image to Cloud Storage and returns download URL
  /// Organizes files by guestId and complaintId for easy management
  Future<String> uploadComplaintImage(
    String guestId,
    String complaintId,
    File file,
  ) async {
    // Use a centralized path: store under 'complaints/' directory using StorageConstants
    final path = '${FirestoreConstants.complaints}/$guestId/$complaintId';
    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return await _storageService.uploadFile(
      file,
      path,
      fileName,
    );
  }
}
