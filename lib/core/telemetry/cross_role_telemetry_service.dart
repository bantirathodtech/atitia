// lib/core/telemetry/cross_role_telemetry_service.dart

import '../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../common/utils/logging/logging_helper.dart';

/// Centralized telemetry service for tracking cross-role actions
/// Logs both to Firebase Analytics and App Logger for comprehensive tracking
class CrossRoleTelemetryService {
  final _analytics = getIt.analytics;

  /// Track a cross-role action (action by one role that affects another role)
  Future<void> trackCrossRoleAction({
    required String actionType, // e.g., 'booking_approved', 'payment_collected'
    required String actorRole, // 'guest' or 'owner'
    required String targetRole, // 'guest' or 'owner'
    required String actorUserId,
    String? targetUserId,
    String? entityId, // bookingId, paymentId, complaintId, etc.
    String? entityType, // 'booking', 'payment', 'complaint', 'bed_change', etc.
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fullMetadata = {
      'action_type': actionType,
      'actor_role': actorRole,
      'target_role': targetRole,
      'actor_user_id': actorUserId,
      if (targetUserId != null) 'target_user_id': targetUserId,
      if (entityId != null) 'entity_id': entityId,
      if (entityType != null) 'entity_type': entityType,
      'success': success,
      'timestamp': timestamp,
      ...?metadata,
    };

    // Log to Firebase Analytics
    await _analytics.logEvent(
      name: 'cross_role_action',
      parameters: {
        'action_type': actionType,
        'actor_role': actorRole,
        'target_role': targetRole,
        'success': success,
        if (entityType != null) 'entity_type': entityType,
      },
    );

    // Log to App Logger
    LoggingHelper.logRoleAction(
      actorRole,
      actionType,
      feature: 'cross_role_telemetry',
      metadata: fullMetadata,
    );

    // Also log specific action event
    await _analytics.logEvent(
      name: actionType,
      parameters: {
        'actor_role': actorRole,
        'target_role': targetRole,
        'success': success,
        ...?metadata,
      },
    );
  }

  /// Track booking request actions (guest → owner, owner → guest)
  Future<void> trackBookingRequestAction({
    required String action, // 'created', 'approved', 'rejected'
    required String actorRole,
    required String requestId,
    required String guestId,
    required String ownerId,
    String? pgId,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'booking_request_$action',
      actorRole: actorRole,
      targetRole: actorRole == 'guest' ? 'owner' : 'guest',
      actorUserId: actorRole == 'guest' ? guestId : ownerId,
      targetUserId: actorRole == 'guest' ? ownerId : guestId,
      entityId: requestId,
      entityType: 'booking_request',
      metadata: {
        'pg_id': pgId,
        ...?metadata,
      },
      success: success,
    );
  }

  /// Track payment actions (guest → owner, owner → guest)
  Future<void> trackPaymentAction({
    required String action, // 'created', 'collected', 'rejected'
    required String actorRole,
    required String paymentId,
    required String guestId,
    required String ownerId,
    double? amount,
    String? status,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'payment_$action',
      actorRole: actorRole,
      targetRole: actorRole == 'guest' ? 'owner' : 'guest',
      actorUserId: actorRole == 'guest' ? guestId : ownerId,
      targetUserId: actorRole == 'guest' ? ownerId : guestId,
      entityId: paymentId,
      entityType: 'payment',
      metadata: {
        if (amount != null) 'amount': amount,
        if (status != null) 'status': status,
        ...?metadata,
      },
      success: success,
    );
  }

  /// Track complaint actions (guest → owner, owner → guest)
  Future<void> trackComplaintAction({
    required String action, // 'submitted', 'replied', 'resolved'
    required String actorRole,
    required String complaintId,
    required String guestId,
    required String ownerId,
    String? status,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'complaint_$action',
      actorRole: actorRole,
      targetRole: actorRole == 'guest' ? 'owner' : 'guest',
      actorUserId: actorRole == 'guest' ? guestId : ownerId,
      targetUserId: actorRole == 'guest' ? ownerId : guestId,
      entityId: complaintId,
      entityType: 'complaint',
      metadata: {
        if (status != null) 'status': status,
        ...?metadata,
      },
      success: success,
    );
  }

  /// Track bed change request actions (guest → owner, owner → guest)
  Future<void> trackBedChangeAction({
    required String action, // 'requested', 'approved', 'rejected'
    required String actorRole,
    required String requestId,
    required String guestId,
    required String ownerId,
    String? roomNumber,
    String? bedNumber,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'bed_change_$action',
      actorRole: actorRole,
      targetRole: actorRole == 'guest' ? 'owner' : 'guest',
      actorUserId: actorRole == 'guest' ? guestId : ownerId,
      targetUserId: actorRole == 'guest' ? ownerId : guestId,
      entityId: requestId,
      entityType: 'bed_change_request',
      metadata: {
        if (roomNumber != null) 'room_number': roomNumber,
        if (bedNumber != null) 'bed_number': bedNumber,
        ...?metadata,
      },
      success: success,
    );
  }

  /// Track food feedback actions (guest → owner)
  Future<void> trackFoodFeedbackAction({
    required String action, // 'submitted', 'liked', 'disliked'
    required String guestId,
    required String ownerId,
    String? mealId,
    String? mealType,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'food_feedback_$action',
      actorRole: 'guest',
      targetRole: 'owner',
      actorUserId: guestId,
      targetUserId: ownerId,
      entityId: mealId,
      entityType: 'food_feedback',
      metadata: {
        if (mealType != null) 'meal_type': mealType,
        ...?metadata,
      },
      success: success,
    );
  }

  /// Track room/bed assignment actions (owner → guest)
  Future<void> trackRoomBedAssignment({
    required String action, // 'assigned', 'updated'
    required String ownerId,
    required String guestId,
    String? roomNumber,
    String? bedNumber,
    String? bookingId,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'room_bed_$action',
      actorRole: 'owner',
      targetRole: 'guest',
      actorUserId: ownerId,
      targetUserId: guestId,
      entityId: bookingId,
      entityType: 'room_bed_assignment',
      metadata: {
        if (roomNumber != null) 'room_number': roomNumber,
        if (bedNumber != null) 'bed_number': bedNumber,
        ...?metadata,
      },
      success: success,
    );
  }

  /// Track notification delivery (system → user)
  Future<void> trackNotificationSent({
    required String notificationType,
    required String userId,
    required String targetRole,
    String? relatedEntityId,
    String? relatedEntityType,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'notification_sent',
      actorRole: 'system',
      targetRole: targetRole,
      actorUserId: 'system',
      targetUserId: userId,
      entityId: relatedEntityId,
      entityType: relatedEntityType ?? 'notification',
      metadata: {
        'notification_type': notificationType,
        ...?metadata,
      },
      success: success,
    );
  }

  /// Track vehicle detail sharing (guest → owner)
  Future<void> trackVehicleDetailShared({
    required String guestId,
    required String ownerId,
    String? vehicleNo,
    Map<String, dynamic>? metadata,
    bool success = true,
  }) async {
    await trackCrossRoleAction(
      actionType: 'vehicle_detail_shared',
      actorRole: 'guest',
      targetRole: 'owner',
      actorUserId: guestId,
      targetUserId: ownerId,
      entityType: 'vehicle_detail',
      metadata: {
        if (vehicleNo != null) 'vehicle_number': vehicleNo,
        ...?metadata,
      },
      success: success,
    );
  }
}
