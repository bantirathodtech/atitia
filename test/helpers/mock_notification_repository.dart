// test/helpers/mock_notification_repository.dart

import 'package:atitia/core/repositories/notification_repository.dart';
import 'mock_repositories.dart';

/// Mock NotificationRepository for testing
class MockNotificationRepository extends NotificationRepository {
  MockNotificationRepository({
    MockDatabaseService? databaseService,
    MockAnalyticsService? analyticsService,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
        );

  @override
  Future<void> sendUserNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    // Mock implementation - do nothing
  }
}

