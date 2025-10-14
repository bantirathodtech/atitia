import 'package:flutter/material.dart';

import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../text/body_text.dart';
import '../text/heading_medium.dart';

/// Reusable confirmation dialog for destructive or important actions
/// 
/// Features:
/// - Customizable title and message
/// - Primary and secondary action buttons
/// - Optional destructive styling (red confirm button)
/// - Consistent design across app
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isDestructive ? Colors.red : theme.primaryColor,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: HeadingMedium(text: title),
          ),
        ],
      ),
      content: BodyText(text: message),
      actions: [
        SecondaryButton(
          label: cancelText,
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
        ),
        const SizedBox(width: AppSpacing.sm),
        PrimaryButton(
          label: confirmText,
          onPressed: () {
            onConfirm?.call();
          },
          backgroundColor: isDestructive ? Colors.red : null,
        ),
      ],
      actionsPadding: const EdgeInsets.all(AppSpacing.md),
      actionsAlignment: MainAxisAlignment.end,
    );
  }
}

