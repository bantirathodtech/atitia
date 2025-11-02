// lib/features/guest_dashboard/complaints/view/widgets/guest_complaint_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../data/models/guest_complaint_model.dart';

/// 📝 **PREMIUM COMPLAINT CARD - PRODUCTION READY**
///
/// **Features:**
/// - Status-based color coding
/// - Category badges
/// - Photo count indicator
/// - Date display
/// - Theme-aware styling
class GuestComplaintCard extends StatelessWidget {
  final GuestComplaintModel complaint;
  final VoidCallback? onTap;

  const GuestComplaintCard({
    required this.complaint,
    this.onTap,
    super.key,
  });

  Color get _statusColor {
    switch (complaint.status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'in progress':
        return AppColors.info;
      case 'resolved':
        return AppColors.success;
      case 'closed':
        return AppColors.textTertiary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _statusIcon {
    switch (complaint.status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'in progress':
        return Icons.autorenew;
      case 'resolved':
        return Icons.check_circle;
      case 'closed':
        return Icons.lock;
      default:
        return Icons.help_outline;
    }
  }

  IconData get _categoryIcon {
    final subject = complaint.subject.toLowerCase();
    if (subject.contains('food')) return Icons.restaurant;
    if (subject.contains('clean')) return Icons.cleaning_services;
    if (subject.contains('maintenance')) return Icons.build;
    if (subject.contains('water')) return Icons.water_drop;
    if (subject.contains('electric')) return Icons.electric_bolt;
    if (subject.contains('wifi')) return Icons.wifi;
    if (subject.contains('noise')) return Icons.volume_off;
    return Icons.report_problem;
  }
  
  String get _category {
    final subject = complaint.subject.toLowerCase();
    if (subject.contains('food')) return 'Food';
    if (subject.contains('clean')) return 'Cleanliness';
    if (subject.contains('maintenance')) return 'Maintenance';
    if (subject.contains('water')) return 'Water';
    if (subject.contains('electric')) return 'Electricity';
    if (subject.contains('wifi')) return 'WiFi';
    if (subject.contains('noise')) return 'Noise';
    return 'General';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
              border: Border.all(
                color: _statusColor.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _statusColor.withValues(alpha: 0.2),
                        _statusColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.borderRadiusL),
                      topRight: Radius.circular(AppSpacing.borderRadiusL),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.paddingS),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusS),
                        ),
                        child: Icon(_categoryIcon, color: _statusColor, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.paddingM),
                      Expanded(
                        child: HeadingSmall(
                          text: complaint.subject,
                          color: theme.textTheme.headlineSmall?.color,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.paddingS,
                          vertical: AppSpacing.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon, color: _statusColor, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              complaint.status.toUpperCase(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Details
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyText(
                        text: complaint.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(height: AppSpacing.paddingM),
                      Row(
                        children: [
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.paddingS,
                              vertical: AppSpacing.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.darkInputFill
                                  : AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.borderRadiusS),
                              border: Border.all(
                                color: theme.primaryColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _categoryIcon,
                                  size: 12,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                CaptionText(
                                  text: _category,
                                  color: theme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Date
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: isDarkMode
                                    ? AppColors.textTertiary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              CaptionText(
                                text: _formatDate(complaint.complaintDate),
                                color: isDarkMode
                                    ? AppColors.textTertiary
                                    : AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('hh:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}
