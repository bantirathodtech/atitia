// ============================================================================
// Guest Notifications Screen
// ============================================================================
// Notifications screen for guest users with guest-specific notification types
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../shared/widgets/guest_drawer.dart';

/// Notifications screen for guests
class GuestNotificationsScreen extends StatefulWidget {
  const GuestNotificationsScreen({super.key});

  @override
  State<GuestNotificationsScreen> createState() =>
      _GuestNotificationsScreenState();
}

class _GuestNotificationsScreenState extends State<GuestNotificationsScreen> {
  String _selectedFilter = 'All';

  // Sample notifications data - Guest receives notifications FROM owner
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Booking Request Approved',
      'body': 'Your booking request for Room 101 has been approved by owner',
      'type': 'booking_approved',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'read': false,
    },
    {
      'id': '2',
      'title': 'Booking Request Rejected',
      'body': 'Your booking request for Room 205 has been rejected due to unavailability',
      'type': 'booking_rejected',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'read': false,
    },
    {
      'id': '3',
      'title': 'Payment Reminder',
      'body': 'Your rent payment of ₹5,000 is due in 3 days',
      'type': 'payment_reminder',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'read': false,
    },
    {
      'id': '4',
      'title': 'Payment Confirmed',
      'body': 'Owner has confirmed your payment of ₹5,000 for November rent',
      'type': 'payment_confirmed',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'read': true,
    },
    {
      'id': '5',
      'title': 'Payment Overdue',
      'body': 'Your payment of ₹5,000 is now overdue. Please pay immediately',
      'type': 'payment_overdue',
      'timestamp': DateTime.now().subtract(const Duration(days: 5)),
      'read': false,
    },
    {
      'id': '6',
      'title': 'Complaint Response',
      'body': 'Owner has responded to your complaint about Wi-Fi connectivity',
      'type': 'complaint_response',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'read': true,
    },
    {
      'id': '7',
      'title': 'Bed Change Approved',
      'body': 'Your bed change request from Room 101 to Room 205 has been approved',
      'type': 'bed_change_approved',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'read': false,
    },
    {
      'id': '8',
      'title': 'PG Announcement',
      'body': 'New food menu available for this week. Check the food section',
      'type': 'pg_announcement',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'read': false,
    },
    {
      'id': '9',
      'title': 'Service Request Resolved',
      'body': 'Owner has resolved your service request for AC repair in Room 205',
      'type': 'service_response',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _getFilteredNotifications();

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      drawer: const GuestDrawer(),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: filteredNotifications.isEmpty
                ? EmptyState(
                    icon: Icons.notifications_none,
                    title: 'No Notifications',
                    message: 'You don\'t have any notifications yet.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.paddingM),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All'),
            const SizedBox(width: AppSpacing.paddingS),
            _buildFilterChip('Unread'),
            const SizedBox(width: AppSpacing.paddingS),
            _buildFilterChip('Bookings'),
            const SizedBox(width: AppSpacing.paddingS),
            _buildFilterChip('Payments'),
            const SizedBox(width: AppSpacing.paddingS),
            _buildFilterChip('Complaints'),
            const SizedBox(width: AppSpacing.paddingS),
            _buildFilterChip('Bed Changes'),
            const SizedBox(width: AppSpacing.paddingS),
            _buildFilterChip('PG Updates'),
            const SizedBox(width: AppSpacing.paddingS),
            _buildFilterChip('Services'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    if (_selectedFilter == 'All') {
      return _notifications;
    } else if (_selectedFilter == 'Unread') {
      return _notifications.where((n) => !(n['read'] as bool)).toList();
    } else if (_selectedFilter == 'Bookings') {
      return _notifications
          .where((n) =>
              n['type'] == 'booking_approved' ||
              n['type'] == 'booking_rejected')
          .toList();
    } else if (_selectedFilter == 'Payments') {
      return _notifications
          .where((n) =>
              n['type'] == 'payment_reminder' ||
              n['type'] == 'payment_confirmed' ||
              n['type'] == 'payment_overdue')
          .toList();
    } else if (_selectedFilter == 'Complaints') {
      return _notifications
          .where((n) => n['type'] == 'complaint_response')
          .toList();
    } else if (_selectedFilter == 'Bed Changes') {
      return _notifications
          .where((n) =>
              n['type'] == 'bed_change_approved' ||
              n['type'] == 'bed_change_rejected')
          .toList();
    } else if (_selectedFilter == 'PG Updates') {
      return _notifications
          .where((n) => n['type'] == 'pg_announcement')
          .toList();
    } else if (_selectedFilter == 'Services') {
      return _notifications
          .where((n) => n['type'] == 'service_response')
          .toList();
    }
    return _notifications;
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUnread = !(notification['read'] as bool);
    final timestamp = notification['timestamp'] as DateTime;
    final type = notification['type'] as String;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        onTap: () {
          setState(() {
            notification['read'] = true;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getNotificationColor(type).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(type),
                color: _getNotificationColor(type),
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BodyText(
                          text: notification['title'] as String,
                          medium: true,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CaptionText(text: notification['body'] as String),
                  const SizedBox(height: 4),
                  CaptionText(
                    text: _formatTimestamp(timestamp),
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking_approved':
        return Colors.green;
      case 'booking_rejected':
        return Colors.red;
      case 'payment_reminder':
        return Colors.orange;
      case 'payment_confirmed':
        return Colors.green;
      case 'payment_overdue':
        return Colors.red;
      case 'complaint_response':
        return Colors.blue;
      case 'bed_change_approved':
        return Colors.green;
      case 'bed_change_rejected':
        return Colors.red;
      case 'pg_announcement':
        return AppColors.secondary;
      case 'service_response':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking_approved':
        return Icons.check_circle;
      case 'booking_rejected':
        return Icons.cancel;
      case 'payment_reminder':
        return Icons.notifications_active;
      case 'payment_confirmed':
        return Icons.verified;
      case 'payment_overdue':
        return Icons.warning;
      case 'complaint_response':
        return Icons.reply;
      case 'bed_change_approved':
        return Icons.check_circle;
      case 'bed_change_rejected':
        return Icons.cancel;
      case 'pg_announcement':
        return Icons.announcement;
      case 'service_response':
        return Icons.build;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
  }
}
