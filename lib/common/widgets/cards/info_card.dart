import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../text/body_text.dart';
import '../text/heading_large.dart';
import 'adaptive_card.dart';

class InfoCard extends AdaptiveStatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return AdaptiveCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: iconColor?.withValues(alpha: 0.1) ??
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingLarge(
                  text: title,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
                const SizedBox(height: AppSpacing.paddingXS),
                BodyText(
                  text: description,
                  small: true,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
