import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../utils/responsive/responsive_system.dart';

class AdaptiveCard extends AdaptiveStatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin; // NEW: Added margin property
  final double elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool interactive;
  final bool hasShadow; // NEW: Optional shadow control

  const AdaptiveCard({
    super.key,
    required this.child,
    EdgeInsets? padding,
    this.margin = EdgeInsets.zero, // NEW: Default to zero margin
    this.elevation = AppSpacing.elevationLow,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.interactive = true,
    this.hasShadow = true, // NEW: Shadow control
  }) : padding = padding ?? const EdgeInsets.all(AppSpacing.paddingM);

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final responsivePadding =
        padding == const EdgeInsets.all(AppSpacing.paddingM)
            ? context.responsivePadding
            : padding;

    return Container(
      margin: margin, // NEW: Apply margin here
      child: Card(
        elevation: hasShadow ? elevation : 0, // NEW: Conditional shadow
        color: backgroundColor ??
            (isDark ? AppColors.darkInputFill : Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
        child: interactive
            ? InkWell(
                onTap: onTap,
                borderRadius: borderRadius ??
                    BorderRadius.circular(AppSpacing.borderRadiusM),
                child: Padding(
                  padding: responsivePadding,
                  child: child,
                ),
              )
            : Padding(
                padding: responsivePadding,
                child: child,
              ),
      ),
    );
  }
}
