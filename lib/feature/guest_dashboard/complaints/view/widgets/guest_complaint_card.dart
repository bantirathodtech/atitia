// lib/features/guest_dashboard/complaints/view/widgets/guest_complaint_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../l10n/app_localizations.dart';
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
        return AppColors.statusOrange;
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

  String get _categoryKey {
    final subject = complaint.subject.toLowerCase();
    if (subject.contains('food')) return 'food';
    if (subject.contains('clean')) return 'cleanliness';
    if (subject.contains('maintenance')) return 'maintenance';
    if (subject.contains('water')) return 'water';
    if (subject.contains('electric')) return 'electricity';
    if (subject.contains('wifi')) return 'wifi';
    if (subject.contains('noise')) return 'noise';
    return 'general';
  }

  String _categoryLabel(AppLocalizations? loc) {
    switch (_categoryKey) {
      case 'food':
        return loc?.complaintCategoryFood ?? 'Food';
      case 'cleanliness':
        return loc?.complaintCategoryCleanliness ?? 'Cleanliness';
      case 'maintenance':
        return loc?.complaintCategoryMaintenance ?? 'Maintenance';
      case 'water':
        return loc?.complaintCategoryWater ?? 'Water';
      case 'electricity':
        return loc?.complaintCategoryElectricity ?? 'Electricity';
      case 'wifi':
        return loc?.complaintCategoryWifi ?? 'Wi-Fi';
      case 'noise':
        return loc?.complaintCategoryNoise ?? 'Noise';
      default:
        return loc?.complaintCategoryGeneral ?? 'General';
    }
  }

  String _statusLabel(AppLocalizations? loc) {
    switch (complaint.status.toLowerCase()) {
      case 'pending':
        return loc?.pending ?? 'Pending';
      case 'in progress':
        return loc?.statusInProgress ?? 'In Progress';
      case 'resolved':
        return loc?.statusResolved ?? 'Resolved';
      case 'closed':
        return loc?.statusClosed ?? 'Closed';
      default:
        return complaint.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final categoryLabel = _categoryLabel(loc);
    final statusLabel = _statusLabel(loc);
    final displayStatus = (loc?.localeName ?? '').startsWith('en')
        ? statusLabel.toUpperCase()
        : statusLabel;

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
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: isDarkMode ? 0.3 : 0.05),
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
                        child:
                            Icon(_categoryIcon, color: _statusColor, size: 20),
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
                            const SizedBox(width: AppSpacing.paddingXS),
                            Text(
                              displayStatus,
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
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusS),
                              border: Border.all(
                                color:
                                    theme.primaryColor.withValues(alpha: 0.3),
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
                                const SizedBox(width: AppSpacing.paddingXS),
                                CaptionText(
                                  text: categoryLabel,
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
                              const SizedBox(width: AppSpacing.paddingXS),
                              CaptionText(
                                text: _formatDate(complaint.complaintDate, loc),
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

  String _formatDate(DateTime date, AppLocalizations? loc) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      final time = DateFormat('hh:mm a', loc?.localeName).format(date);
      return loc?.todayAt(time) ?? 'Today $time';
    } else if (difference.inDays == 1) {
      return loc?.yesterday ?? 'Yesterday';
    } else if (difference.inDays < 7) {
      return loc?.daysAgo(difference.inDays) ?? '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy', loc?.localeName).format(date);
    }
  }
}
