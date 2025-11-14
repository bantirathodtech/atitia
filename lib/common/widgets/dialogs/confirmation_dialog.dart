import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
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
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final finalConfirmText = confirmText ?? loc?.confirm ?? 'Confirm';
    final finalCancelText = cancelText ?? loc?.cancel ?? 'Cancel';

    return AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color:
                  isDestructive ? theme.colorScheme.error : theme.primaryColor,
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
          label: finalCancelText,
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
        ),
        const SizedBox(width: AppSpacing.sm),
        PrimaryButton(
          label: finalConfirmText,
          onPressed: () {
            onConfirm?.call();
          },
          backgroundColor:
              isDestructive ? Theme.of(context).colorScheme.error : null,
        ),
      ],
      actionsPadding: const EdgeInsets.all(AppSpacing.md),
      actionsAlignment: MainAxisAlignment.end,
    );
  }
}
