import 'package:flutter/material.dart';

import '../../lifecycle/stateful/adaptive_stateful_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class AdaptiveDropdown<T> extends AdaptiveStatefulWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? error;
  final String? hint;
  final bool enabled;

  const AdaptiveDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.error,
    this.hint,
    this.enabled = true,
  });

  @override
  AdaptiveDropdownState<T> createState() => AdaptiveDropdownState<T>();
}

class AdaptiveDropdownState<T>
    extends AdaptiveStatefulWidgetState<AdaptiveDropdown<T>> {
  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingXS),
          child: Text(
            widget.label,
            style: AppTypography.inputLabel.copyWith(
              color: widget.error != null
                  ? Colors.red
                  : theme.textTheme.labelMedium?.color,
            ),
          ),
        ),

        // Dropdown
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            border: Border.all(
              color: widget.error != null ? Colors.red : Colors.transparent,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: widget.value,
              items: widget.items,
              onChanged: widget.enabled ? widget.onChanged : null,
              isExpanded: true,
              hint: widget.hint != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.paddingM),
                      child: Text(
                        widget.hint!,
                        style: AppTypography.input.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    )
                  : null,
              style: AppTypography.input.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingM,
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: AppSpacing.paddingM),
                child: Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        ),

        // Error
        if (widget.error != null) ...[
          const SizedBox(height: AppSpacing.paddingXS),
          Text(
            widget.error!,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
