import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../text/body_text.dart';
import '../text/heading_medium.dart';

class AdaptiveDialog extends AdaptiveStatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final bool destructive;

  const AdaptiveDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.destructive = false,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    bool destructive = false,
  }) async {
    final loc = AppLocalizations.of(context);
    final finalConfirmText = confirmText ?? loc?.confirm ?? 'Confirm';
    final finalCancelText = cancelText ?? loc?.cancel ?? 'Cancel';
    return showDialog<bool>(
      context: context,
      builder: (context) => AdaptiveDialog(
        title: title,
        message: message,
        confirmText: finalConfirmText,
        cancelText: finalCancelText,
        onConfirm: onConfirm ?? () => Navigator.of(context).pop(true),
        onCancel: onCancel ?? () => Navigator.of(context).pop(false),
        confirmColor: confirmColor,
        destructive: destructive,
      ),
    );
  }

  @override
  Widget buildAdaptive(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final finalConfirmText = confirmText ?? loc?.confirm ?? 'Confirm';
    final finalCancelText = cancelText ?? loc?.cancel ?? 'Cancel';

    return AlertDialog(
      title: HeadingMedium(text: title),
      content: BodyText(text: message),
      actions: [
        SecondaryButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          label: finalCancelText,
        ),
        PrimaryButton(
          onPressed: onConfirm,
          label: finalConfirmText,
          backgroundColor: destructive ? Theme.of(context).colorScheme.error : confirmColor,
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
    );
  }
}
