// lib/common/widgets/dashboard/recently_updated_guests_widget.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../cards/adaptive_card.dart';
import '../text/heading_medium.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';
import '../../utils/extensions/context_extensions.dart';

/// 📊 **RECENTLY UPDATED GUESTS WIDGET - REUSABLE COMMON WIDGET**
///
/// Displays guests that were added or updated in the last 7 days
/// Used in owner dashboard to show recent activity
class RecentlyUpdatedGuestsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> guests; // Guest data as maps for flexibility
  final VoidCallback? onViewAll;
  final int maxDisplayCount;
  final int daysToLookBack;

  const RecentlyUpdatedGuestsWidget({
    required this.guests,
    this.onViewAll,
    this.maxDisplayCount = 5,
    this.daysToLookBack = 7,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final recentGuests = _getRecentlyUpdatedGuests();

    if (recentGuests.isEmpty) {
      return const SizedBox.shrink();
    }

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.update,
                      size: 20,
                      color: context.primaryColor,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    HeadingMedium(
                      text: 'Recently Updated Guests',
                      color: context.primaryColor,
                    ),
                  ],
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: BodyText(
                      text: 'View All',
                      color: context.primaryColor,
                      small: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            if (recentGuests.length <= maxDisplayCount)
              ...recentGuests.map((guest) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
                    child: _buildGuestListItem(context, guest),
                  ))
            else
              Column(
                children: [
                  ...recentGuests.take(maxDisplayCount).map((guest) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.paddingS),
                        child: _buildGuestListItem(context, guest),
                      )),
                  if (onViewAll != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.paddingS),
                      child: Center(
                        child: TextButton(
                          onPressed: onViewAll,
                          child: BodyText(
                            text:
                                '+ ${recentGuests.length - maxDisplayCount} more',
                            color: context.primaryColor,
                            small: true,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getRecentlyUpdatedGuests() {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToLookBack));

    final recentGuests = guests.where((guest) {
      final updatedAt = guest['updatedAt'];
      final createdAt = guest['createdAt'];

      DateTime? lastUpdate;
      if (updatedAt is int) {
        lastUpdate = DateTime.fromMillisecondsSinceEpoch(updatedAt);
      } else if (updatedAt is DateTime) {
        lastUpdate = updatedAt;
      } else if (createdAt is int) {
        lastUpdate = DateTime.fromMillisecondsSinceEpoch(createdAt);
      } else if (createdAt is DateTime) {
        lastUpdate = createdAt;
      }

      if (lastUpdate == null) return false;

      // Check if updated or created in the last N days
      return lastUpdate.isAfter(cutoffDate);
    }).toList();

    // Sort by most recently updated first
    recentGuests.sort((a, b) {
      final aUpdated =
          _getDateTime(a['updatedAt'] ?? a['createdAt']) ?? DateTime(1970);
      final bUpdated =
          _getDateTime(b['updatedAt'] ?? b['createdAt']) ?? DateTime(1970);
      return bUpdated.compareTo(aUpdated);
    });

    return recentGuests;
  }

  DateTime? _getDateTime(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is DateTime) {
      return value;
    }
    return null;
  }

  Widget _buildGuestListItem(BuildContext context, Map<String, dynamic> guest) {
    final theme = Theme.of(context);
    final fullName = guest['fullName'] as String? ?? 'Unknown';
    final roomNumber = guest['roomNumber'] as String?;
    final bedNumber = guest['bedNumber'] as String?;
    final status = guest['status'] as String? ?? 'active';
    final updatedAt = _getDateTime(guest['updatedAt'] ?? guest['createdAt']);
    final timeAgo = updatedAt != null ? _getTimeAgo(updatedAt) : '';

    // Get initials
    final initials = fullName.isNotEmpty
        ? (fullName.length > 1
            ? fullName.substring(0, 2).toUpperCase()
            : fullName.substring(0, 1).toUpperCase())
        : 'G';

    // Get status color
    final statusColor = _getStatusColor(status);

    // Determine payment status from guest status
    String? paymentStatus;
    if (status == 'payment_pending') {
      paymentStatus = 'pending';
    } else if (status == 'active') {
      paymentStatus = 'collected';
    }

    // Get room/bed display
    String roomBedDisplay = 'Not Assigned';
    if (roomNumber != null && bedNumber != null) {
      roomBedDisplay = 'Room $roomNumber, Bed $bedNumber';
    } else if (roomNumber != null) {
      roomBedDisplay = 'Room $roomNumber';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Guest Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: statusColor.withValues(alpha: 0.2),
            child: Text(
              initials,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          // Guest Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BodyText(
                  text: fullName,
                  medium: true,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.bed,
                      size: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: CaptionText(
                        text: roomBedDisplay,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                if (timeAgo.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  CaptionText(
                    text: 'Updated $timeAgo',
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ],
              ],
            ),
          ),
          // Status Badge
          if (paymentStatus != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: paymentStatus == 'collected'
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: paymentStatus == 'collected'
                      ? AppColors.success.withValues(alpha: 0.3)
                      : AppColors.warning.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    paymentStatus == 'collected'
                        ? Icons.check_circle
                        : Icons.pending,
                    size: 12,
                    color: paymentStatus == 'collected'
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const SizedBox(width: 4),
                  CaptionText(
                    text: paymentStatus == 'collected' ? 'Paid' : 'Unpaid',
                    color: paymentStatus == 'collected'
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF4CAF50); // Green
      case 'payment_pending':
        return const Color(0xFFFFA726); // Orange
      case 'pending':
        return const Color(0xFFFFA726); // Orange
      case 'inactive':
        return const Color(0xFFEF5350); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
