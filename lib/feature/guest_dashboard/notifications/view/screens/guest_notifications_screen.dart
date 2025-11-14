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
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../core/viewmodels/notification_viewmodel.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/guest_drawer.dart';

/// Notifications screen for guests
class GuestNotificationsScreen extends StatefulWidget {
  const GuestNotificationsScreen({super.key});

  @override
  State<GuestNotificationsScreen> createState() =>
      _GuestNotificationsScreenState();
}

class _GuestNotificationsScreenState extends State<GuestNotificationsScreen> {
  static const List<String> _filterKeys = [
    'all',
    'unread',
    'bookings',
    'payments',
    'complaints',
    'bed_changes',
    'pg_updates',
    'services',
  ];

  String _selectedFilter = 'all';

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
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc.guestNotificationsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: loc.refresh,
            onPressed: () {
              final viewModel = context.read<NotificationViewModel>();
              viewModel.loadNotifications();
            },
          ),
        ],
      ),
      drawer: const GuestDrawer(),
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.loading && viewModel.notifications.isEmpty) {
            return const AdaptiveLoader();
          }

          if (viewModel.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(
                    text: viewModel.errorMessage ??
                        loc.guestNotificationsLoadFailed,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  PrimaryButton(
                    onPressed: () => viewModel.loadNotifications(),
                    label: loc.retry,
                  ),
                ],
              ),
            );
          }

          final filteredNotifications =
              viewModel.getFilteredNotifications(_selectedFilter);

          return Column(
            children: [
              _buildFilterChips(loc),
              Expanded(
                child: filteredNotifications.isEmpty
                    ? EmptyState(
                        icon: Icons.notifications_none,
                        title: loc.guestNotificationsEmptyTitle,
                        message: loc.guestNotificationsEmptyMessage,
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
                            loc,
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

  Widget _buildFilterChips(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filterKeys
              .map(
                (key) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS),
                  child: _buildFilterChip(key, loc),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, AppLocalizations loc) {
    final isSelected = _selectedFilter == key;
    return FilterChip(
      label: Text(_filterLabel(key, loc)),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = key;
        });
      },
    );
  }

  String _filterLabel(String key, AppLocalizations loc) {
    switch (key) {
      case 'unread':
        return loc.guestNotificationsFilterUnread;
      case 'bookings':
        return loc.guestNotificationsFilterBookings;
      case 'payments':
        return loc.guestNotificationsFilterPayments;
      case 'complaints':
        return loc.guestNotificationsFilterComplaints;
      case 'bed_changes':
        return loc.guestNotificationsFilterBedChanges;
      case 'pg_updates':
        return loc.guestNotificationsFilterPgUpdates;
      case 'services':
        return loc.guestNotificationsFilterServices;
      case 'all':
      default:
        return loc.guestNotificationsFilterAll;
    }
  }

  Widget _buildNotificationCard(
    BuildContext context,
    Map<String, dynamic> notification,
    NotificationViewModel viewModel,
    AppLocalizations loc,
  ) {
    final isUnread = !(notification['read'] as bool? ?? false);
    final timestamp = notification['timestamp'] as DateTime? ??
        DateTime.now().subtract(const Duration(days: 1));
    final type = notification['type'] as String? ?? '';
    final title =
        notification['title'] as String? ?? loc.guestNotificationsDefaultTitle;
    final body =
        notification['body'] as String? ?? loc.guestNotificationsDefaultBody;

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
                          text: title,
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
                  const SizedBox(height: AppSpacing.paddingXS),
                  CaptionText(
                    text: body,
                  ),
                  const SizedBox(height: AppSpacing.paddingXS),
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
        return AppColors.success;
      case 'booking_rejected':
        return AppColors.error;
      case 'payment_reminder':
        return AppColors.statusOrange;
      case 'payment_confirmed':
        return AppColors.success;
      case 'payment_overdue':
        return AppColors.error;
      case 'complaint_response':
        return AppColors.info;
      case 'bed_change_approved':
        return AppColors.success;
      case 'bed_change_rejected':
        return AppColors.error;
      case 'pg_announcement':
        return AppColors.secondary;
      case 'service_response':
        return AppColors.info;
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
