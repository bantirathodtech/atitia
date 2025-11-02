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
}
