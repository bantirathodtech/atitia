import 'package:flutter/material.dart';

import '../../lifecycle/stateful/adaptive_stateful_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class TextInput extends AdaptiveStatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? error;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autoFocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final int? maxLength;
  final bool showCounter;

  const TextInput({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.error,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onSubmitted,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.maxLength,
    this.showCounter = false,
  });

  @override
  TextInputState createState() => TextInputState();
}

class TextInputState extends AdaptiveStatefulWidgetState<TextInput> {
  late TextEditingController _controller;

  @override
  void onInit() {
    super.onInit();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void onDispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.onDispose();
  }

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

        // Text Field
        TextField(
          controller: _controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          autofocus: widget.autoFocus,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          style: AppTypography.input.copyWith(
            color: theme.textTheme.bodyLarge?.color,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.input.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            errorText: widget.error,
            counterText: widget.showCounter ? null : '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              borderSide: BorderSide(
                color: widget.error != null ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              borderSide: BorderSide(
                color: widget.error != null ? Colors.red : theme.primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor:
                isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
            contentPadding: const EdgeInsets.all(AppSpacing.paddingM),
          ),
        ),
      ],
    );
  }
}
