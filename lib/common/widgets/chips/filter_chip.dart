import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class CustomFilterChip extends AdaptiveStatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;
  final Color? selectedColor;
  final Color? backgroundColor;
  final double borderRadius;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    this.selectedColor,
    this.backgroundColor,
    this.borderRadius = AppSpacing.borderRadiusL,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);

    return InputChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
            ),
            const SizedBox(width: AppSpacing.paddingXS),
          ],
          Text(
            label,
            style: AppTypography.bodySmall,
          ),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: selectedColor ?? theme.primaryColor,
      backgroundColor: backgroundColor ?? theme.cardTheme.color,
      checkmarkColor: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingXS,
      ),
    );
  }
}
