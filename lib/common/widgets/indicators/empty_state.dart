import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../text/body_text.dart';
import '../text/heading_large.dart';

class EmptyState extends AdaptiveStatelessWidget {
  final String title;
  final String message; // Changed from description to message
  final IconData icon;
  final String? actionLabel; // Changed from actionText to actionLabel
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.title,
    required this.message, // Changed parameter name
    this.icon = Icons.inbox,
    this.actionLabel, // Changed parameter name
    this.onAction,
    this.iconColor,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? Theme.of(context).disabledColor,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            HeadingLarge(
              text: title,
              color: Theme.of(context).disabledColor,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: message, // Changed from description to message
              color: Theme.of(context).disabledColor,
              align: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.paddingL),
              PrimaryButton(
                onPressed: onAction,
                label: actionLabel!, // PrimaryButton uses 'label' parameter
              ),
            ],
          ],
        ),
      ),
    );
  }
}
