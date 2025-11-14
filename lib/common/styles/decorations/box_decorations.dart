import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';
import 'border_decorations.dart';
import 'shadow_decorations.dart';

/// Predefined box decoration styles for consistent UI elements
class BoxDecorations {
  // MARK: - Card Decorations
  // ==========================================

  /// Standard card decoration with subtle shadow - theme-aware via BuildContext
  static BoxDecoration card(
    BuildContext context, {
    Color? color,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    return BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
      boxShadow: ShadowDecorations.card(context, elevation: elevation),
    );
  }

  /// Elevated card with stronger shadow - theme-aware via BuildContext
  static BoxDecoration elevatedCard(
    BuildContext context, {
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
      boxShadow: ShadowDecorations.elevated(context),
    );
  }

  /// Flat card without shadow (for contained sections)
  static BoxDecoration flatCard({
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.lightInputFill,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
    );
  }

  // MARK: - Container Decorations
  // ==========================================

  /// Primary container with gradient
  static BoxDecoration primaryContainer({
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lightPrimary, AppColors.lightAccent],
      ),
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      boxShadow: ShadowDecorations.primary,
    );
  }

  /// Success state container
  static BoxDecoration success({
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: AppColors.successContainer,
      border: BorderDecorations.successBorder,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
    );
  }

  /// Warning state container
  static BoxDecoration warning({
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: AppColors.warningContainer,
      border: BorderDecorations.warningBorder,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
    );
  }

  /// Error state container
  static BoxDecoration error({
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: AppColors.errorContainer,
      border: BorderDecorations.errorBorder,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
    );
  }

  // MARK: - Button Decorations
  // ==========================================

  /// Primary button decoration - theme-aware via BuildContext
  static BoxDecoration primaryButton(
    BuildContext context, {
    BorderRadius? borderRadius,
    bool enabled = true,
  }) {
    return BoxDecoration(
      gradient: enabled
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.lightPrimary, AppColors.lightAccent],
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.statusGrey, AppColors.statusGrey],
            ),
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      boxShadow: enabled ? ShadowDecorations.button(context) : ShadowDecorations.none,
    );
  }

  /// Secondary button decoration
  static BoxDecoration secondaryButton({
    BorderRadius? borderRadius,
    bool enabled = true,
  }) {
    return BoxDecoration(
      color: enabled ? Colors.transparent : AppColors.surfaceVariant,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      border: Border.all(
        color: enabled ? AppColors.lightPrimary : AppColors.outline,
        width: 2,
      ),
    );
  }

  // MARK: - Special Effects
  // ==========================================

  /// Glass morphism effect - theme-aware via BuildContext
  static BoxDecoration glassmorphism(
    BuildContext context, {
    double blur = 10.0,
    BorderRadius? borderRadius,
  }) {
    final theme = Theme.of(context);
    return BoxDecoration(
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      border: Border.all(color: theme.colorScheme.onPrimary.withValues(alpha: 0.2)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.onPrimary.withValues(alpha: 0.1),
          theme.colorScheme.onPrimary.withValues(alpha: 0.05),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: blur,
          spreadRadius: 1,
        ),
      ],
    );
  }

  /// Neon glow effect
  static BoxDecoration neonGlow({
    Color glowColor = AppColors.lightAccent,
    double spreadRadius = 4.0,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      border: Border.all(color: glowColor.withValues(alpha: 0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: glowColor.withValues(alpha: 0.4),
          spreadRadius: spreadRadius,
          blurRadius: 15,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  // MARK: - Utility Methods
  // ==========================================

  /// Create decoration with custom parameters
  static BoxDecoration custom({
    Color? color,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    Border? border,
    BorderRadius? borderRadius,
    DecorationImage? image,
  }) {
    return BoxDecoration(
      color: color,
      gradient: gradient,
      boxShadow: boxShadow,
      border: border,
      borderRadius: borderRadius,
      image: image,
    );
  }
}
