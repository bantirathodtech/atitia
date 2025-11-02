import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class AdaptiveListTile extends AdaptiveStatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? leadingColor;

  const AdaptiveListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    required this.onTap,
    this.leadingColor,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return ListTile(
      leading: leadingIcon != null
          ? Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: leadingColor?.withValues(alpha: 0.1) ??
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                leadingIcon,
                color: leadingColor ?? Theme.of(context).primaryColor,
                size: 20,
              ),
            )
          : null,
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
      ),
    );
  }
}
