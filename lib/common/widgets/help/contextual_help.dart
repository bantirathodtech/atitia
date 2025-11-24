// lib/common/widgets/help/contextual_help.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/theme_colors.dart';
import '../text/body_text.dart';

/// 🎨 **CONTEXTUAL HELP - IN-APP GUIDANCE**
///
/// Tooltip and help system for providing contextual guidance
/// Shows helpful hints and tips throughout the app
class ContextualHelp extends StatelessWidget {
  final String message;
  final Widget child;
  final String? title;
  final HelpType type;
  final bool showIcon;

  const ContextualHelp({
    required this.message,
    required this.child,
    this.title,
    this.type = HelpType.tooltip,
    this.showIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HelpType.tooltip:
        return Tooltip(
          message: message,
          child: child,
        );
      case HelpType.helpIcon:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child),
            if (showIcon)
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  size: 20,
                  color: ThemeColors.getTextTertiary(context),
                ),
                onPressed: () => _showHelpDialog(context),
                tooltip: 'Help',
              ),
          ],
        );
      case HelpType.infoBanner:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            const SizedBox(height: AppSpacing.paddingS),
            _buildInfoBanner(context),
          ],
        );
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Help'),
        content: BodyText(text: message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: theme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: BodyText(
              text: message,
              small: true,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum HelpType {
  tooltip,
  helpIcon,
  infoBanner,
}

/// Help button widget
class HelpButton extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final Color? iconColor;

  const HelpButton({
    required this.message,
    this.title,
    this.icon = Icons.help_outline,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: iconColor ?? ThemeColors.getTextTertiary(context),
      ),
      onPressed: () => _showHelpDialog(context),
      tooltip: 'Help',
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Help'),
        content: SingleChildScrollView(
          child: BodyText(text: message),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

/// Search hints widget
class SearchHints extends StatelessWidget {
  final List<String> hints;
  final ValueChanged<String>? onHintSelected;

  const SearchHints({
    required this.hints,
    this.onHintSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (hints.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyText(
            text: 'Try searching for:',
            small: true,
            color: ThemeColors.getTextTertiary(context),
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Wrap(
            spacing: AppSpacing.paddingS,
            runSpacing: AppSpacing.paddingS,
            children: hints
                .take(5)
                .map(
                  (hint) => ActionChip(
                    label: BodyText(text: hint, small: true),
                    onPressed: () => onHintSelected?.call(hint),
                    backgroundColor: Theme.of(context)
                        .primaryColor
                        .withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

