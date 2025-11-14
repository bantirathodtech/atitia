// lib/core/viewmodels/notification_viewmodel.dart

import 'dart:async';

import '../../common/lifecycle/mixin/stream_subscription_mixin.dart';
import '../../common/lifecycle/state/provider_state.dart';
import '../../core/di/firebase/di/firebase_service_locator.dart';
import '../repositories/notification_repository.dart';

/// ViewModel for managing notifications UI state and business logic
/// Handles real-time notification streaming from Firestore
class NotificationViewModel extends BaseProviderState
    with StreamSubscriptionMixin {
  final NotificationRepository _repository;
  final _authService = getIt.auth;
  final _analyticsService = getIt.analytics;

  /// Constructor with dependency injection
  NotificationViewModel({
    NotificationRepository? repository,
  }) : _repository = repository ?? NotificationRepository();

  StreamSubscription<List<Map<String, dynamic>>>? _notificationsSubscription;
  List<Map<String, dynamic>> _notifications = [];

  /// Read-only list of notifications for UI consumption
  List<Map<String, dynamic>> get notifications => _notifications;

  /// Get unread notifications count
  int get unreadCount =>
      _notifications.where((n) => !(n['read'] as bool? ?? false)).length;

  /// Initialize and start listening to notifications
  Future<void> loadNotifications([String? userId]) async {
    final userIdToUse = userId ?? _authService.currentUserId ?? '';

    if (userIdToUse.isEmpty) {
      _notifications = [];
      notifyListeners();
      return;
    }

    setLoading(true);
    clearError();

    try {
      // Cancel existing subscription if any
      _notificationsSubscription?.cancel();

      // Start listening to real-time notifications
      _notificationsSubscription =
          _repository.streamNotificationsForUser(userIdToUse).listen(
        (notificationList) {
          _notifications = notificationList;
          setLoading(false);
          notifyListeners();

          _analyticsService.logEvent(
            name: 'notifications_loaded',
            parameters: {
              'user_id': userIdToUse,
              'count': notificationList.length,
              'unread_count': unreadCount,
            },
          );
        },
        onError: (error) {
          setError(true, 'Failed to load notifications: $error');
          setLoading(false);
          notifyListeners();
        },
      );

      if (_notificationsSubscription != null) {
        addSubscription(_notificationsSubscription!);
      }
    } catch (e) {
      setError(true, 'Failed to initialize notifications: $e');
      setLoading(false);
      notifyListeners();
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markNotificationAsRead(notificationId);

      // Update local state
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['read'] = true;
        notifyListeners();
      }

      _analyticsService.logEvent(
        name: 'notification_marked_read',
        parameters: {'notification_id': notificationId},
      );
    } catch (e) {
      _analyticsService.logEvent(
        name: 'notification_mark_read_error',
        parameters: {
          'notification_id': notificationId,
          'error': e.toString(),
        },
      );
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final userId = _authService.currentUserId ?? '';
    if (userId.isEmpty) return;

    try {
      await _repository.markAllNotificationsAsRead(userId);

      // Update local state
      for (var notification in _notifications) {
        notification['read'] = true;
      }
      notifyListeners();

      _analyticsService.logEvent(
        name: 'all_notifications_marked_read',
        parameters: {'user_id': userId},
      );
    } catch (e) {
      _analyticsService.logEvent(
        name: 'mark_all_read_error',
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
    }
  }

  /// Get filtered notifications by type
  List<Map<String, dynamic>> getFilteredNotifications(String filter) {
    if (filter == 'all') {
      return _notifications;
    } else if (filter == 'unread') {
      return _notifications
          .where((n) => !(n['read'] as bool? ?? false))
          .toList();
    } else {
      // Filter by type based on filter key
      return _notifications
          .where((n) => _matchesFilter(n['type'] as String? ?? '', filter))
          .toList();
    }
  }

  /// Check if notification type matches filter
  bool _matchesFilter(String type, String filter) {
    switch (filter) {
      case 'bookings':
        return type == 'booking_request' ||
            type == 'booking_approved' ||
            type == 'booking_rejected';
      case 'payments':
        return type == 'payment_received' ||
            type == 'payment_reminder' ||
            type == 'payment_confirmed' ||
            type == 'payment_overdue' ||
            type == 'payment_collected' ||
            type == 'payment_rejected';
      case 'complaints':
        return type == 'complaint_filed' ||
            type == 'complaint_response' ||
            type == 'complaint_reply' ||
            type == 'complaint_status';
      case 'bed_changes':
        return type == 'bed_change_request' ||
            type == 'bed_change_approved' ||
            type == 'bed_change_rejected';
      case 'services':
        return type == 'service_request' || type == 'service_response';
      case 'pg_updates':
        return type == 'pg_announcement';
      default:
        return false;
    }
  }

  @override
  void dispose() {
    cancelAllSubscriptions();
    super.dispose();
  }
}
