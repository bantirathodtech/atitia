// lib/common/widgets/badges/premium_badge.dart

import 'package:flutter/material.dart';

import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../text/caption_text.dart';

/// Premium badge widget to indicate premium features
/// Small, compact badge for use in menus, buttons, or feature labels
class PremiumBadge extends StatelessWidget {
  final String? label;
  final bool compact;

  const PremiumBadge({
    super.key,
    this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final badgeText = label ?? 'Premium';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.paddingXS : AppSpacing.paddingS,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: compact ? 10 : 12,
            color: Colors.white,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            CaptionText(
              text: badgeText,
              color: Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}

