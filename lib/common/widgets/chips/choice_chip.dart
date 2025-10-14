import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class CustomChoiceChip extends AdaptiveStatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: AppSpacing.paddingXS),
          ],
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingXS,
      ),
    );
  }
}
