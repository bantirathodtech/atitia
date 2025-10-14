import 'package:flutter/material.dart';

import '../../lifecycle/stateful/adaptive_stateful_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class PrimaryButton extends AdaptiveStatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
  });

  @override
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends AdaptiveStatefulWidgetState<PrimaryButton> {
  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        onPressed:
            widget.enabled && !widget.isLoading ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? theme.primaryColor,
          foregroundColor: widget.foregroundColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingL,
            vertical: AppSpacing.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          elevation: AppSpacing.elevationMedium,
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.foregroundColor ?? Colors.white,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 20),
          const SizedBox(width: AppSpacing.paddingS),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: AppTypography.buttonBold,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
