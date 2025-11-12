import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../text/heading_medium.dart';

class SectionContainer extends AdaptiveStatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final EdgeInsets padding;
  final CrossAxisAlignment crossAxisAlignment;
  final String? description;

  const SectionContainer({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.paddingM),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.description,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon,
                      size: 24, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: AppSpacing.paddingS),
                ],
                Expanded(
                  child: HeadingMedium(text: title!),
                ),
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.paddingXS),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.paddingL),
          ],
          child,
        ],
      ),
    );
  }
}
