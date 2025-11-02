// lib/core/repositories/bed_change_request_repository.dart

import '../di/common/unified_service_locator.dart';
import '../../common/utils/constants/firestore.dart';
import '../interfaces/analytics/analytics_service_interface.dart';
import '../interfaces/database/database_service_interface.dart';
import '../models/bed_change_request_model.dart';
import 'notification_repository.dart';

/// Repository for managing bed change requests
/// Uses interface-based services for dependency injection (swappable backends)
class BedChangeRequestRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;
  final NotificationRepository _notifications;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  BedChangeRequestRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
    NotificationRepository? notificationRepository,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics,
        _notifications = notificationRepository ?? NotificationRepository();

  Future<void> createRequest(BedChangeRequestModel request) async {
    await _databaseService.setDocument(
      FirestoreConstants.bedChangeRequests,
      request.requestId,
      request.toMap(),
    );
    await _analyticsService.logEvent(
      name: 'bed_change_request_created',
      parameters: {
        'request_id': request.requestId,
        'guest_id': request.guestId,
        'owner_id': request.ownerId,
        'pg_id': request.pgId,
      },
    );
    // Notify owner
    await _notifications.sendUserNotification(
      userId: request.ownerId,
      type: 'bed_change_request',
      title: 'New bed change request',
      body: 'Guest requested a change: ${request.reason}',
      data: {
        'requestId': request.requestId,
        'guestId': request.guestId,
        'pgId': request.pgId,
        'preferredRoomNumber': request.preferredRoomNumber,
        'preferredBedNumber': request.preferredBedNumber,
      },
    );
  }

  Stream<List<BedChangeRequestModel>> streamOwnerRequests(String ownerId) {
    return _databaseService
        .getCollectionStreamWithFilter(
            FirestoreConstants.bedChangeRequests, 'ownerId', ownerId)
        .map((snap) => snap.docs
            .map((d) =>
                BedChangeRequestModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<BedChangeRequestModel>> streamGuestRequests(String guestId) {
    return _databaseService
        .getCollectionStreamWithFilter(
            FirestoreConstants.bedChangeRequests, 'guestId', guestId)
        .map((snap) => snap.docs
            .map((d) =>
                BedChangeRequestModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateStatus(
    String requestId,
    String status, {
    String? decisionNotes,
    required String guestId,
  }) async {
    await _databaseService.updateDocument(
      FirestoreConstants.bedChangeRequests,
      requestId,
      {
        'status': status,
        if (decisionNotes != null) 'decisionNotes': decisionNotes,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
    await _analyticsService.logEvent(
      name: 'bed_change_request_status_updated',
      parameters: {'request_id': requestId, 'status': status},
    );
    // Notify guest
    await _notifications.sendUserNotification(
      userId: guestId,
      type:
          status == 'approved' ? 'bed_change_approved' : 'bed_change_rejected',
      title:
          status == 'approved' ? 'Bed change approved' : 'Bed change rejected',
      body: decisionNotes ?? 'Your bed change request was $status.',
      data: {
        'requestId': requestId,
        'status': status,
      },
    );
  }
}
