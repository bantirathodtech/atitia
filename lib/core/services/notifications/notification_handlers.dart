// lib/core/services/notifications/notification_handlers.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/firebase/di/firebase_service_locator.dart';

/// Notification handlers for different user roles and notification types
/// Handles navigation and UI updates based on notification data
class NotificationHandlers {
  static final NotificationHandlers _instance =
      NotificationHandlers._internal();
  factory NotificationHandlers() => _instance;
  NotificationHandlers._internal();

  static NotificationHandlers get instance => _instance;

  final _analyticsService = getIt.analytics;
  // Logger not available - removed for now

  /// Handles notification navigation for Guest users
  Future<void> handleGuestNotification(RemoteMessage message) async {
    final data = message.data;
    final notification = message.notification;

    // Logger not available: _logger.info call removed

    await _analyticsService.logEvent(
      name: 'guest_notification_received',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'title': notification?.title ?? 'no_title',
        'type': data['type'] ?? 'unknown',
        'data': data.toString(),
      },
    );

    // Navigate based on notification type
    switch (data['type']) {
      case 'booking_response':
        await _handleGuestBookingResponse(data);
        break;
      case 'payment_reminder':
        await _handleGuestPaymentReminder(data);
        break;
      case 'food_menu_update':
        await _handleGuestFoodMenuUpdate(data);
        break;
      case 'complaint_response':
        await _handleGuestComplaintResponse(data);
        break;
      case 'general_announcement':
        await _handleGuestGeneralAnnouncement(data);
        break;
      default:
    // Logger not available: _logger call removed
    }
  }

  /// Handles notification navigation for Owner users
  Future<void> handleOwnerNotification(RemoteMessage message) async {
    final data = message.data;
    final notification = message.notification;

    // Logger not available: _logger.info call removed

    await _analyticsService.logEvent(
      name: 'owner_notification_received',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'title': notification?.title ?? 'no_title',
        'type': data['type'] ?? 'unknown',
        'data': data.toString(),
      },
    );

    // Navigate based on notification type
    switch (data['type']) {
      case 'booking_request':
        await _handleOwnerBookingRequest(data);
        break;
      case 'payment_received':
        await _handleOwnerPaymentReceived(data);
        break;
      case 'complaint_submitted':
        await _handleOwnerComplaintSubmitted(data);
        break;
      case 'guest_check_in':
        await _handleOwnerGuestCheckIn(data);
        break;
      case 'maintenance_reminder':
        await _handleOwnerMaintenanceReminder(data);
        break;
      default:
    // Logger not available: _logger call removed
    }
  }

  // ==========================================================================
  // GUEST NOTIFICATION HANDLERS
  // ==========================================================================

  /// Handles booking response notifications for guests
  Future<void> _handleGuestBookingResponse(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    // Navigate to booking status or payments screen
    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to payments screen to show booking status
      context.go('/guest/payments');

      // Show success/error message based on response
      final status = data['status'] ?? 'unknown';
      final message =
          data['message'] ?? 'Your booking request has been processed';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: status == 'approved' ? Colors.green : Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handles payment reminder notifications for guests
  Future<void> _handleGuestPaymentReminder(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to payments screen
      context.go('/guest/payments');

      // Show payment reminder
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Payment reminder: Please complete your pending payment'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handles food menu update notifications for guests
  Future<void> _handleGuestFoodMenuUpdate(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to food menu screen
      context.go('/guest/foods');

      // Show menu update notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food menu has been updated! Check out the new items'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handles complaint response notifications for guests
  Future<void> _handleGuestComplaintResponse(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to complaints screen
      context.go('/guest/complaints');

      // Show response notification
      final response = data['response'] ?? 'Your complaint has been addressed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complaint Response: $response'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handles general announcement notifications for guests
  Future<void> _handleGuestGeneralAnnouncement(
      Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Show announcement dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(data['title'] ?? 'Announcement'),
          content:
              Text(data['message'] ?? 'Important announcement from your PG'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // ==========================================================================
  // OWNER NOTIFICATION HANDLERS
  // ==========================================================================

  /// Handles booking request notifications for owners
  Future<void> _handleOwnerBookingRequest(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to guest management screen (requests tab)
      context.go('/owner/guests');

      // Show booking request notification
      final guestName = data['guestName'] ?? 'A guest';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New booking request from $guestName'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              // Navigate to requests tab
              context.go('/owner/guests?tab=requests');
            },
          ),
        ),
      );
    }
  }

  /// Handles payment received notifications for owners
  Future<void> _handleOwnerPaymentReceived(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to payments screen
      context.go('/owner/guests?tab=payments');

      // Show payment notification
      final amount = data['amount'] ?? '0';
      final guestName = data['guestName'] ?? 'A guest';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment received: ₹$amount from $guestName'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handles complaint submitted notifications for owners
  Future<void> _handleOwnerComplaintSubmitted(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to complaints screen
      context.go('/owner/guests?tab=complaints');

      // Show complaint notification
      final guestName = data['guestName'] ?? 'A guest';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New complaint from $guestName'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handles guest check-in notifications for owners
  Future<void> _handleOwnerGuestCheckIn(Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to guests screen
      context.go('/owner/guests');

      // Show check-in notification
      final guestName = data['guestName'] ?? 'A guest';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$guestName has checked in'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handles maintenance reminder notifications for owners
  Future<void> _handleOwnerMaintenanceReminder(
      Map<String, dynamic> data) async {
    // Logger not available: _logger.info call removed

    final context = _getCurrentContext();
    if (context != null) {
      // Navigate to PG management screen
      context.go('/owner/pgs');

      // Show maintenance reminder
      final task = data['task'] ?? 'maintenance task';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maintenance reminder: $task'),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================

  /// Gets the current navigation context
  BuildContext? _getCurrentContext() {
    // TODO: Implement proper context retrieval
    // This is a placeholder - in a real app, you'd need to maintain
    // a reference to the current navigation context
    return null;
  }

  /// Shows a custom notification banner
  void showNotificationBanner(
    BuildContext context, {
    required String title,
    required String message,
    required Color backgroundColor,
    VoidCallback? onTap,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: onTap != null
            ? SnackBarAction(
                label: 'View',
                textColor: Colors.white,
                onPressed: onTap,
              )
            : null,
      ),
    );
  }
}
