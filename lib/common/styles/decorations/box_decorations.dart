import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';
import 'border_decorations.dart';
import 'shadow_decorations.dart';

/// Predefined box decoration styles for consistent UI elements
class BoxDecorations {
  // MARK: - Card Decorations
  // ==========================================

  /// Standard card decoration with subtle shadow
  static BoxDecoration card({
    Color? color,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.lightScaffold,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
      boxShadow: ShadowDecorations.card(elevation: elevation),
    );
  }

  /// Elevated card with stronger shadow
  static BoxDecoration elevatedCard({
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.lightScaffold,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
      boxShadow: ShadowDecorations.elevated,
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
      color: Colors.green.shade50,
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
      color: Colors.orange.shade50,
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
      color: Colors.red.shade50,
      border: BorderDecorations.errorBorder,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusM),
    );
  }

  // MARK: - Button Decorations
  // ==========================================

  /// Primary button decoration
  static BoxDecoration primaryButton({
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
              colors: [Colors.grey.shade400, Colors.grey.shade500],
            ),
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      boxShadow: enabled ? ShadowDecorations.button : ShadowDecorations.none,
    );
  }

  /// Secondary button decoration
  static BoxDecoration secondaryButton({
    BorderRadius? borderRadius,
    bool enabled = true,
  }) {
    return BoxDecoration(
      color: enabled ? Colors.transparent : Colors.grey.shade300,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      border: Border.all(
        color: enabled ? AppColors.lightPrimary : Colors.grey.shade400,
        width: 2,
      ),
    );
  }

  // MARK: - Special Effects
  // ==========================================

  /// Glass morphism effect
  static BoxDecoration glassmorphism({
    double blur = 10.0,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusL),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
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
      border: Border.all(color: glowColor.withOpacity(0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.4),
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
