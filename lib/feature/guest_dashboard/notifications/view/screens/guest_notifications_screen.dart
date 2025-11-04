// ============================================================================
// Guest Notifications Screen
// ============================================================================
// Notifications screen for guest users with guest-specific notification types
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/drawers/guest_drawer.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/chips/filter_chip.dart';

/// Notifications screen for guests
class GuestNotificationsScreen extends StatefulWidget {
  const GuestNotificationsScreen({super.key});

  @override
  State<GuestNotificationsScreen> createState() =>
      _GuestNotificationsScreenState();
}

class _GuestNotificationsScreenState extends State<GuestNotificationsScreen> {
  String _selectedFilter = 'All';

  // Sample notifications data based on guest usage
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Booking Request Approved',
      'body': 'Your booking request for Room 101 has been approved',
      'type': 'booking',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'read': false,
    },
    {
      'id': '2',
      'title': 'Payment Reminder',
      'body': 'Your rent payment of ₹5,000 is due in 3 days',
      'type': 'payment',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'read': false,
    },
    {
      'id': '3',
      'title': 'Complaint Response',
      'body': 'Owner has responded to your complaint about Room 205',
      'type': 'complaint',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'read': true,
    },
    {
      'id': '4',
      'title': 'PG Announcement',
      'body': 'New food menu available for this week',
      'type': 'pg_update',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'read': false,
    },
    {
      'id': '5',
      'title': 'Payment Overdue',
      'body': 'Your payment of ₹5,000 is now overdue. Please pay immediately',
      'type': 'payment',
      'timestamp': DateTime.now().subtract(const Duration(days: 5)),
      'read': false,
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
            _buildFilterChip('PG Updates'),
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
          .where((n) => n['type'] == 'booking')
          .toList();
    } else if (_selectedFilter == 'Payments') {
      return _notifications
          .where((n) => n['type'] == 'payment')
          .toList();
    } else if (_selectedFilter == 'Complaints') {
      return _notifications
          .where((n) => n['type'] == 'complaint')
          .toList();
    } else if (_selectedFilter == 'PG Updates') {
      return _notifications
          .where((n) => n['type'] == 'pg_update')
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
      case 'booking':
        return AppColors.secondary;
      case 'payment':
        return Colors.green;
      case 'complaint':
        return Colors.orange;
      case 'pg_update':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.hotel;
      case 'payment':
        return Icons.payment;
      case 'complaint':
        return Icons.report_problem;
      case 'pg_update':
        return Icons.announcement;
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

