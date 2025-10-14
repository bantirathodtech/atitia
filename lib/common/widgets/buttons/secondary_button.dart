import 'package:flutter/material.dart';

import '../../lifecycle/stateful/adaptive_stateful_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class SecondaryButton extends AdaptiveStatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.borderColor,
    this.textColor,
    this.width,
  });

  @override
  SecondaryButtonState createState() => SecondaryButtonState();
}

class SecondaryButtonState
    extends AdaptiveStatefulWidgetState<SecondaryButton> {
  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: widget.width,
      child: OutlinedButton(
        onPressed:
            widget.enabled && !widget.isLoading ? widget.onPressed : null,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingL,
            vertical: AppSpacing.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          side: BorderSide(
            color: widget.borderColor ?? theme.primaryColor,
          ),
        ),
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.borderColor ?? Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 20,
            color: widget.textColor ?? Theme.of(context).primaryColor,
          ),
          const SizedBox(width: AppSpacing.paddingS),
        ],
        Text(
          widget.label,
          style: AppTypography.button.copyWith(
            color: widget.textColor ?? Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
