import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';
import '../../styles/colors.dart';

class CustomChoiceChip extends AdaptiveStatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;
  final Color? selectedColor;
  final Color? backgroundColor;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    this.selectedColor,
    this.backgroundColor,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Use provided colors or fall back to theme-aware defaults
    final effectiveSelectedColor = selectedColor ?? theme.primaryColor;
    final effectiveBackgroundColor = backgroundColor ?? 
        (isDark ? AppColors.darkCard : AppColors.lightCard);
    
    // Ensure text color has proper contrast when selected
    final labelColor = selected 
        ? AppColors.textOnPrimary 
        : (isDark ? AppColors.darkText : AppColors.textPrimary);
    
    // Icon color should match label color
    final iconColor = selected 
        ? AppColors.textOnPrimary 
        : (isDark ? AppColors.darkText : AppColors.textPrimary);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon, 
              size: 16,
              color: iconColor,
            ),
            const SizedBox(width: AppSpacing.paddingXS),
          ],
          Text(
            label, 
            style: AppTypography.bodySmall.copyWith(
              color: labelColor,
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: effectiveSelectedColor,
      backgroundColor: effectiveBackgroundColor,
      checkmarkColor: AppColors.textOnPrimary,
      labelStyle: AppTypography.bodySmall.copyWith(
        color: labelColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
    );
  }
}
