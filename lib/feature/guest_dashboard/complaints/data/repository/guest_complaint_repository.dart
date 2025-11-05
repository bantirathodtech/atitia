// lib/features/guest_dashboard/complaints/repository/guest_complaint_repository.dart

import 'dart:io';

import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/interfaces/storage/storage_service_interface.dart';
import '../../../../../core/repositories/notification_repository.dart';
import '../models/guest_complaint_model.dart';

/// Repository layer for guest complaints data operations
/// Uses interface-based services for dependency injection (swappable backends)
/// Handles both Firestore operations and Cloud Storage uploads
class GuestComplaintRepository {
  final IDatabaseService _databaseService;
  final IStorageService _storageService;
  final NotificationRepository _notificationRepository;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  GuestComplaintRepository({
    IDatabaseService? databaseService,
    IStorageService? storageService,
    NotificationRepository? notificationRepository,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _storageService =
            storageService ?? UnifiedServiceLocator.serviceFactory.storage,
        _notificationRepository =
            notificationRepository ?? NotificationRepository();

  /// Streams complaints for a specific guest with real-time updates
  /// Uses Firestore query to filter complaints by guestId
  Stream<List<GuestComplaintModel>> getComplaintsForGuest(String guestId) {
    return _databaseService
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
    await _databaseService.setDocument(
      FirestoreConstants.complaints, // Collection name from constants
      complaint.complaintId,
      complaint.toMap(),
    );

    // Notify owner about new complaint if ownerId is available
    // Note: ownerId might be null initially, so we'll need to get it from PG
    if (complaint.pgId.isNotEmpty) {
      try {
        // Get owner ID from PG document
        final pgDoc = await _databaseService.getDocument(
          FirestoreConstants.pgs,
          complaint.pgId,
        );
        final pgData = pgDoc.data() as Map<String, dynamic>?;
        final ownerId = pgData?['ownerUid'] as String? ?? pgData?['ownerId'] as String?;

        if (ownerId != null && ownerId.isNotEmpty) {
          await _notificationRepository.sendUserNotification(
            userId: ownerId,
            type: 'complaint_filed',
            title: 'New Complaint Filed',
            body: 'Guest filed a complaint: ${complaint.subject}',
            data: {
              'complaintId': complaint.complaintId,
              'pgId': complaint.pgId,
              'guestId': complaint.guestId,
              'subject': complaint.subject,
              'status': complaint.status,
            },
          );
        }
      } catch (e) {
        // Log but don't fail the complaint if notification fails
        // Notification failure is non-critical
      }
    }
  }

  /// Updates an existing complaint document in Firestore
  /// Overwrites entire document with updated complaint data
  Future<void> updateComplaint(GuestComplaintModel complaint) async {
    await _databaseService.updateDocument(
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
      path: path,
      file: file,
      fileName: fileName,
    );
  }
}
