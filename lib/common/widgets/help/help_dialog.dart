// lib/common/widgets/help/help_dialog.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../text/body_text.dart';
import '../text/heading_medium.dart';

/// 🎨 **HELP DIALOG - CONTEXTUAL HELP DIALOGS**
///
/// Beautiful help dialogs for providing detailed guidance
/// Used throughout the app for contextual help
class HelpDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<HelpSection>? sections;
  final String? actionLabel;
  final VoidCallback? onAction;

  const HelpDialog({
    required this.title,
    required this.content,
    this.sections,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    List<HelpSection>? sections,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return showDialog(
      context: context,
      builder: (context) => HelpDialog(
        title: title,
        content: content,
        sections: sections,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      title: Row(
        children: [
          Icon(Icons.help_outline, color: theme.primaryColor),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: HeadingMedium(text: title),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyText(text: content),
            if (sections != null && sections!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingL),
              ...sections!.map((section) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.paddingS),
                        BodyText(
                          text: section.description,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (actionLabel != null && onAction != null)
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
              onAction?.call();
            },
            label: actionLabel!,
          ),
      ],
    );
  }
}

class HelpSection {
  final String title;
  final String description;

  HelpSection({
    required this.title,
    required this.description,
  });
}
