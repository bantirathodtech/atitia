// lib/core/repositories/notification_repository.dart

import '../di/common/unified_service_locator.dart';
import '../../common/utils/constants/firestore.dart';
import '../../common/utils/date/converter/date_service_converter.dart';
import '../interfaces/analytics/analytics_service_interface.dart';
import '../interfaces/database/database_service_interface.dart';

/// Lightweight repository for app-wide in-app notifications
/// Persists notifications to Firestore for delivery to target users
/// Uses interface-based services for dependency injection (swappable backends)
class NotificationRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  NotificationRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Send a notification to a single user
  Future<void> sendUserNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final now = DateTime.now();
    final notificationId = '${userId}_${now.millisecondsSinceEpoch}_$type';

    final payload = {
      'id': notificationId,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data ?? {},
      'read': false,
      'createdAt': DateServiceConverter.toService(now),
      'updatedAt': DateServiceConverter.toService(now),
    };

    await _databaseService.setDocument(
      FirestoreConstants.notifications,
      notificationId,
      payload,
    );

    await _analyticsService.logEvent(
      name: 'notification_sent',
      parameters: {
        'notification_id': notificationId,
        'user_id': userId,
        'type': type,
      },
    );
  }

  /// Stream notifications for a specific user in real-time
  /// Returns notifications ordered by creation date (newest first)
  Stream<List<Map<String, dynamic>>> streamNotificationsForUser(String userId) {
    return _databaseService
        .getCollectionStreamWithFilter(
      FirestoreConstants.notifications,
      'userId',
      userId,
    )
        .map((snapshot) {
      final notifications = snapshot.docs
          .take(50) // COST OPTIMIZATION: Limit to 50 most recent notifications
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': data['id'] ?? doc.id,
          'timestamp': _parseTimestamp(data['createdAt']),
        };
      }).toList();

      // Sort by timestamp (newest first)
      notifications.sort((a, b) {
        final aTime = a['timestamp'] as DateTime? ?? DateTime(1970);
        final bTime = b['timestamp'] as DateTime? ?? DateTime(1970);
        return bTime.compareTo(aTime);
      });

      return notifications;
    });
  }

  /// Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await _databaseService.updateDocument(
      FirestoreConstants.notifications,
      notificationId,
      {
        'read': true,
        'updatedAt': DateServiceConverter.toService(DateTime.now()),
      },
    );
  }

  /// Mark all notifications as read for a user
  Future<void> markAllNotificationsAsRead(String userId) async {
    // COST OPTIMIZATION: Limit to first 100 unread notifications
    final snapshot = await _databaseService.queryDocuments(
      FirestoreConstants.notifications,
      field: 'userId',
      isEqualTo: userId,
    );

    final batch = <String>[];
    // COST OPTIMIZATION: Process only first 100 notifications
    for (final doc in snapshot.docs.take(100)) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['read'] != true) {
        batch.add(doc.id);
      }
    }

    // Update all unread notifications
    for (final notificationId in batch) {
      await markNotificationAsRead(notificationId);
    }
  }

  /// Parse timestamp from Firestore data
  DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is DateTime) return timestamp;
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
