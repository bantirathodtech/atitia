import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../../styles/colors.dart';
import '../../utils/extensions/context_extensions.dart';
import '../../utils/responsive/responsive_system.dart';

/// Truly responsive filter chip that expands to fill available width
/// Adapts to all screen sizes and platforms
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
    final responsive = context.responsive;
    final screenWidth = context.screenWidth;

    // Use ResponsiveSystem for true responsive sizing
    final fontScale = ResponsiveSystem.getResponsiveFontScale(context);
    final baseFontSize = AppTypography.bodySmall.fontSize ?? 12.0;

    // Responsive sizing based on screen width and layout type
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;
    final isDesktop = responsive.isDesktop || responsive.isLargeDesktop;

    // Calculate responsive dimensions
    final horizontalPadding = isMobile
        ? AppSpacing.paddingS
        : isTablet
            ? AppSpacing.paddingM
            : AppSpacing.paddingL;

    final verticalPadding = isMobile
        ? AppSpacing.paddingXS
        : isTablet
            ? AppSpacing.paddingS
            : isDesktop
                ? AppSpacing.paddingM
                : AppSpacing.paddingL;

    // Responsive icon size - scales with screen width
    final iconSize = isMobile
        ? 14.0
        : isTablet
            ? 16.0
            : 18.0;

    // Responsive font size - uses fontScale from ResponsiveSystem
    final fontSize = baseFontSize * fontScale;

    // Colors
    final effectiveSelectedColor = selectedColor ?? theme.primaryColor;
    final effectiveBackgroundColor = backgroundColor ??
        (theme.brightness == Brightness.dark
            ? AppColors.darkCard
            : Colors.white);

    final textColor = selected
        ? (theme.brightness == Brightness.dark
            ? AppColors.textOnPrimary
            : Colors.white)
        : (theme.brightness == Brightness.dark
            ? AppColors.darkText
            : AppColors.textPrimary);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Force full width expansion
        final availableWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : screenWidth;

        return SizedBox(
          width: availableWidth,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(!selected),
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: isMobile
                      ? 36.0
                      : isTablet
                          ? 40.0
                          : 44.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? effectiveSelectedColor
                      : effectiveBackgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: selected
                        ? effectiveSelectedColor
                        : theme.dividerColor.withValues(alpha: 0.3),
                    width: selected ? 1.5 : 1.0,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color:
                                effectiveSelectedColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: iconSize,
                        color: textColor,
                      ),
                      SizedBox(width: isMobile ? 4 : AppSpacing.paddingXS),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: fontSize,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    if (selected) ...[
                      SizedBox(width: isMobile ? 4 : AppSpacing.paddingXS),
                      Icon(
                        Icons.check_circle,
                        size: iconSize,
                        color: textColor,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
