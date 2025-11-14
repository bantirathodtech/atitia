import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';

/// Shadow and elevation decoration utilities
class ShadowDecorations {
  // MARK: - Shadow Presets
  // ==========================================

  /// No shadow
  static List<BoxShadow> get none => [];

  /// Subtle shadow for slight elevation - theme-aware via BuildContext
  static List<BoxShadow> subtle(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Standard shadow for cards - theme-aware via BuildContext
  static List<BoxShadow> standard(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Elevated shadow for raised elements - theme-aware via BuildContext
  static List<BoxShadow> elevated(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
          blurRadius: 8,
          offset: const Offset(0, 3),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
          blurRadius: 3,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Strong shadow for prominent elements - theme-aware via BuildContext
  static List<BoxShadow> strong(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Floating shadow for dialogs and menus - theme-aware via BuildContext
  static List<BoxShadow> floating(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 3),
          spreadRadius: 0,
        ),
      ];

  // MARK: - Specialized Shadows
  // ==========================================

  /// Button shadow - theme-aware via BuildContext
  static List<BoxShadow> button(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Primary colored shadow
  static List<BoxShadow> get primary => [
        BoxShadow(
          color: AppColors.info.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 2,
        ),
      ];

  /// Success colored shadow
  static List<BoxShadow> get success => [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 2,
        ),
      ];

  /// Error colored shadow
  static List<BoxShadow> get error => [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 2,
        ),
      ];

  // MARK: - Dynamic Shadow Generators
  // ==========================================

  /// Generate shadow based on elevation level - theme-aware via BuildContext
  static List<BoxShadow> card(BuildContext context, {double? elevation}) {
    final level = elevation ?? AppSpacing.elevationMedium;

    switch (level) {
      case AppSpacing.elevationLow:
        return subtle(context);
      case AppSpacing.elevationMedium:
        return standard(context);
      case AppSpacing.elevationHigh:
        return elevated(context);
      default:
        return standard(context);
    }
  }

  /// Generate shadow with custom parameters - theme-aware via BuildContext
  static List<BoxShadow> custom(
    BuildContext context, {
    Color? color,
    double opacity = 0.1,
    double blurRadius = 4.0,
    double spreadRadius = 0.0,
    Offset offset = Offset.zero,
  }) {
    final shadowColor = color ?? Theme.of(context).colorScheme.shadow;
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: opacity),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: offset,
      ),
    ];
  }

  /// Inner shadow effect (requires CustomPainter) - theme-aware via BuildContext
  static List<BoxShadow> inner(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ];

  // MARK: - Glow Effects
  // ==========================================

  /// Soft glow effect
  static List<BoxShadow> glow({
    Color color = AppColors.info,
    double blurRadius = 15.0,
    double spreadRadius = 2.0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.2),
        blurRadius: blurRadius * 2,
        spreadRadius: spreadRadius * 2,
        offset: Offset.zero,
      ),
    ];
  }

  /// Neon glow effect
  static List<BoxShadow> neonGlow({
    Color color = AppColors.accent,
    double blurRadius = 20.0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.6),
        blurRadius: blurRadius,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blurRadius * 1.5,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.2),
        blurRadius: blurRadius * 2,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
    ];
  }

  // MARK: - Directional Shadows
  // ==========================================

  /// Top shadow only - theme-aware via BuildContext
  static List<BoxShadow> topShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, -2),
          spreadRadius: 0,
        ),
      ];

  /// Bottom shadow only - theme-aware via BuildContext
  static List<BoxShadow> bottomShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Left shadow only - theme-aware via BuildContext
  static List<BoxShadow> leftShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(-2, 0),
          spreadRadius: 0,
        ),
      ];

  /// Right shadow only - theme-aware via BuildContext
  static List<BoxShadow> rightShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(2, 0),
          spreadRadius: 0,
        ),
      ];

  // MARK: - Material Design Elevation
  // ==========================================

  /// Material design elevation levels - theme-aware via BuildContext
  static List<BoxShadow> materialElevation(BuildContext context, int level) {
    final shadowColor = Theme.of(context).colorScheme.shadow;
    switch (level) {
      case 1:
        return [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.14),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.12),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.12),
            blurRadius: 3,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ];
      case 4:
        return [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.16),
            blurRadius: 3,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ];
      case 6:
        return [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 9),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.22),
            blurRadius: 5,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ];
      default:
        return standard(context);
    }
  }
}
