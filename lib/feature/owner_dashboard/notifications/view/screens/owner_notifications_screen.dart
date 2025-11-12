// ============================================================================
// Owner Notifications Screen
// ============================================================================
// Notifications screen for owner users with real-time Firestore data
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
import '../../../shared/widgets/owner_drawer.dart';

/// Notifications screen for owners
class OwnerNotificationsScreen extends StatefulWidget {
  const OwnerNotificationsScreen({super.key});

  @override
  State<OwnerNotificationsScreen> createState() =>
      _OwnerNotificationsScreenState();
}

class _OwnerNotificationsScreenState extends State<OwnerNotificationsScreen> {
  static const List<String> _filterKeys = [
    'all',
    'unread',
    'bookings',
    'payments',
    'complaints',
    'bed_changes',
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
        title: loc.ownerNotificationsTitle,
        actions: [
          Consumer<NotificationViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: const Icon(Icons.mark_email_read),
                onPressed: viewModel.loading
                    ? null
                    : () async {
                        await viewModel.markAllAsRead();
                      },
                tooltip: loc.ownerNotificationsMarkAll,
              );
            },
          ),
        ],
      ),
      drawer: const OwnerDrawer(
        currentTabIndex: 0,
      ),
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
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(
                    text: viewModel.errorMessage ??
                        loc.ownerNotificationsLoadFailed,
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
                        title: loc.ownerNotificationsEmptyTitle,
                        message: loc.ownerNotificationsEmptyMessage,
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
        return loc.ownerNotificationsFilterUnread;
      case 'bookings':
        return loc.ownerNotificationsFilterBookings;
      case 'payments':
        return loc.ownerNotificationsFilterPayments;
      case 'complaints':
        return loc.ownerNotificationsFilterComplaints;
      case 'bed_changes':
        return loc.ownerNotificationsFilterBedChanges;
      case 'services':
        return loc.ownerNotificationsFilterServices;
      case 'all':
      default:
        return loc.ownerNotificationsFilterAll;
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
        notification['title'] as String? ?? loc.ownerNotificationsDefaultTitle;
    final body =
        notification['body'] as String? ?? loc.ownerNotificationsDefaultBody;

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
                    text: _formatTimestamp(timestamp, loc),
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
      case 'booking_request':
        return AppColors.secondary;
      case 'payment_received':
        return Colors.green;
      case 'complaint_filed':
        return Colors.red;
      case 'bed_change_request':
        return Colors.blue;
      case 'service_request':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking_request':
        return Icons.hotel;
      case 'payment_received':
        return Icons.payment;
      case 'complaint_filed':
        return Icons.report_problem;
      case 'bed_change_request':
        return Icons.bed;
      case 'service_request':
        return Icons.build;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp, AppLocalizations loc) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return loc.ownerNotificationsDaysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return loc.ownerNotificationsHoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return loc.ownerNotificationsMinutesAgo(difference.inMinutes);
    } else {
      return loc.ownerNotificationsJustNow;
    }
  }
}
