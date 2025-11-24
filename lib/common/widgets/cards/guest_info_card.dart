// lib/common/widgets/cards/guest_info_card.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../text/caption_text.dart';
import '../text/body_text.dart';

/// 🏠 **GUEST INFO CARD - REUSABLE COMMON WIDGET**
///
/// Displays guest information in a compact card format
/// Used in PG room cards, bed maps, and guest lists
class GuestInfoCard extends StatelessWidget {
  final String guestName;
  final String? guestPhotoUrl;
  final String? phoneNumber;
  final String? email;
  final String? status; // 'active', 'payment_pending', 'pending'
  final String? paymentStatus; // 'collected', 'pending', 'partial'
  final VoidCallback? onTap;
  final bool compact;

  const GuestInfoCard({
    required this.guestName,
    this.guestPhotoUrl,
    this.phoneNumber,
    this.email,
    this.status,
    this.paymentStatus,
    this.onTap,
    this.compact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (compact) {
      return _buildCompactCard(context, theme);
    }
    
    return _buildFullCard(context, theme);
  }

  Widget _buildCompactCard(BuildContext context, ThemeData theme) {
    final statusColor = _getStatusColor(theme);
    final paymentColor = _getPaymentStatusColor(theme);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingS),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Guest Avatar
            _buildAvatar(theme, 32),
            const SizedBox(width: AppSpacing.paddingS),
            // Guest Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BodyText(
                    text: guestName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (phoneNumber != null) ...[
                    const SizedBox(height: 2),
                    CaptionText(
                      text: phoneNumber!,
                      color: theme.textTheme.bodySmall?.color,
                      maxLines: 1,
                    ),
                  ],
                ],
              ),
            ),
            // Status Indicators
            if (status != null || paymentStatus != null) ...[
              const SizedBox(width: AppSpacing.paddingXS),
              _buildStatusIndicators(theme, statusColor, paymentColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFullCard(BuildContext context, ThemeData theme) {
    final statusColor = _getStatusColor(theme);
    final paymentColor = _getPaymentStatusColor(theme);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAvatar(theme, 48),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  BodyText(
                    text: guestName,
                    medium: true,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                      if (phoneNumber != null) ...[
                        const SizedBox(height: 4),
                        CaptionText(
                          text: phoneNumber!,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ],
                      if (email != null && email!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        CaptionText(
                          text: email!,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ],
                    ],
                  ),
                ),
                if (status != null || paymentStatus != null)
                  _buildStatusIndicators(theme, statusColor, paymentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme, double size) {
    if (guestPhotoUrl != null && guestPhotoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(guestPhotoUrl!),
        backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
      );
    }

    // Show initials
    final initials = _getInitials(guestName);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicators(
    ThemeData theme,
    Color statusColor,
    Color paymentColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (status != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (paymentStatus != null && paymentStatus != 'collected') ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: paymentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getPaymentStatusText(),
              style: TextStyle(
                color: paymentColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'G';
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  Color _getStatusColor(ThemeData theme) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'payment_pending':
        return AppColors.warning;
      case 'pending':
        return AppColors.info;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  Color _getPaymentStatusColor(ThemeData theme) {
    switch (paymentStatus?.toLowerCase()) {
      case 'collected':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'partial':
        return AppColors.info;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  String _getStatusText() {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'payment_pending':
        return 'Payment Pending';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  String _getPaymentStatusText() {
    switch (paymentStatus?.toLowerCase()) {
      case 'collected':
        return 'Paid';
      case 'pending':
        return 'Unpaid';
      case 'partial':
        return 'Partial';
      default:
        return '';
    }
  }
}

