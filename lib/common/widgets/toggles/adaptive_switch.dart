import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class AdaptiveSwitch extends AdaptiveStatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final String? description;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return Row(
      children: [
        if (label != null || description != null) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.paddingXS),
                  Text(
                    description!,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
        ],
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
