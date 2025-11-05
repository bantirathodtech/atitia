// ============================================================================
// Guest Notifications Screen
// ============================================================================
// Notifications screen for guest users with real-time Firestore data
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../core/viewmodels/notification_viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    // Load notifications when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<NotificationViewModel>();
      viewModel.loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Notifications',
        actions: [
          Consumer<NotificationViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: const Icon(Icons.mark_email_read),
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        await viewModel.markAllAsRead();
                      },
                tooltip: 'Mark all as read',
              );
            },
          ),
        ],
      ),
      drawer: const GuestDrawer(),
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.notifications.isEmpty) {
            return const AdaptiveLoader();
          }

          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(
                    text: viewModel.errorMessage ?? 'Failed to load notifications',
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  ElevatedButton(
                    onPressed: () => viewModel.loadNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final filteredNotifications =
              viewModel.getFilteredNotifications(_selectedFilter);

          return Column(
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
                          return _buildNotificationCard(
                            context,
                            notification,
                            viewModel,
                          );
                        },
                      ),
              ),
            ],
          );
        },
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

  Widget _buildNotificationCard(
    BuildContext context,
    Map<String, dynamic> notification,
    NotificationViewModel viewModel,
  ) {
    final isUnread = !(notification['read'] as bool? ?? false);
    final timestamp = notification['timestamp'] as DateTime? ??
        DateTime.now().subtract(const Duration(days: 1));
    final type = notification['type'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
        child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        onTap: () {
          final notificationId = notification['id'] as String?;
          if (notificationId != null && isUnread) {
            viewModel.markAsRead(notificationId);
          }
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
                  CaptionText(
                    text: notification['body'] as String? ?? 'No message',
                  ),
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

}
