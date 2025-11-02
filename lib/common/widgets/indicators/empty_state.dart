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
        padding:
            const EdgeInsets.all(AppSpacing.paddingL), // Reduced from XL to L
        child: SingleChildScrollView(
          // Added scrollable wrapper
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 48, // Reduced from 64 to 48
                color: iconColor ?? Theme.of(context).disabledColor,
              ),
              const SizedBox(
                  height: AppSpacing.paddingM), // Reduced from L to M
              HeadingLarge(
                text: title,
                color: Theme.of(context).disabledColor,
                align: TextAlign.center,
              ),
              const SizedBox(
                  height: AppSpacing.paddingS), // Reduced from M to S
              Flexible(
                // Added Flexible wrapper
                child: BodyText(
                  text: message, // Changed from description to message
                  color: Theme.of(context).disabledColor,
                  align: TextAlign.center,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(
                    height: AppSpacing.paddingM), // Reduced from L to M
                PrimaryButton(
                  onPressed: onAction,
                  label: actionLabel!, // PrimaryButton uses 'label' parameter
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
