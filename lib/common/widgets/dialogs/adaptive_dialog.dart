import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../text/body_text.dart';
import '../text/heading_medium.dart';

class AdaptiveDialog extends AdaptiveStatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final bool destructive;

  const AdaptiveDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.destructive = false,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    bool destructive = false,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdaptiveDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm ?? () => Navigator.of(context).pop(true),
        onCancel: onCancel ?? () => Navigator.of(context).pop(false),
        confirmColor: confirmColor,
        destructive: destructive,
      ),
    );
  }

  @override
  Widget buildAdaptive(BuildContext context) {
    return AlertDialog(
      title: HeadingMedium(text: title),
      content: BodyText(text: message),
      actions: [
        SecondaryButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          label: cancelText,
        ),
        PrimaryButton(
          onPressed: onConfirm,
          label: confirmText,
          backgroundColor: destructive ? Colors.red : confirmColor,
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
    );
  }
}
