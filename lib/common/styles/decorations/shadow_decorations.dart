import 'package:flutter/material.dart';

import '../spacing.dart';

/// Shadow and elevation decoration utilities
class ShadowDecorations {
  // MARK: - Shadow Presets
  // ==========================================

  /// No shadow
  static List<BoxShadow> get none => [];

  /// Subtle shadow for slight elevation
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Standard shadow for cards
  static List<BoxShadow> get standard => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Elevated shadow for raised elements
  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 8,
          offset: const Offset(0, 3),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 3,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Strong shadow for prominent elements
  static List<BoxShadow> get strong => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Floating shadow for dialogs and menus
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 3),
          spreadRadius: 0,
        ),
      ];

  // MARK: - Specialized Shadows
  // ==========================================

  /// Button shadow
  static List<BoxShadow> get button => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Primary colored shadow
  static List<BoxShadow> get primary => [
        BoxShadow(
          color: Colors.blue.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 2,
        ),
      ];

  /// Success colored shadow
  static List<BoxShadow> get success => [
        BoxShadow(
          color: Colors.green.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 2,
        ),
      ];

  /// Error colored shadow
  static List<BoxShadow> get error => [
        BoxShadow(
          color: Colors.red.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 2,
        ),
      ];

  // MARK: - Dynamic Shadow Generators
  // ==========================================

  /// Generate shadow based on elevation level
  static List<BoxShadow> card({double? elevation}) {
    final level = elevation ?? AppSpacing.elevationMedium;

    switch (level) {
      case AppSpacing.elevationLow:
        return subtle;
      case AppSpacing.elevationMedium:
        return standard;
      case AppSpacing.elevationHigh:
        return elevated;
      default:
        return standard;
    }
  }

  /// Generate shadow with custom parameters
  static List<BoxShadow> custom({
    Color color = Colors.black,
    double opacity = 0.1,
    double blurRadius = 4.0,
    double spreadRadius = 0.0,
    Offset offset = Offset.zero,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: offset,
      ),
    ];
  }

  /// Inner shadow effect (requires CustomPainter)
  static List<BoxShadow> get inner => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ];

  // MARK: - Glow Effects
  // ==========================================

  /// Soft glow effect
  static List<BoxShadow> glow({
    Color color = Colors.blue,
    double blurRadius = 15.0,
    double spreadRadius = 2.0,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withOpacity(0.2),
        blurRadius: blurRadius * 2,
        spreadRadius: spreadRadius * 2,
        offset: Offset.zero,
      ),
    ];
  }

  /// Neon glow effect
  static List<BoxShadow> neonGlow({
    Color color = Colors.cyan,
    double blurRadius = 20.0,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(0.6),
        blurRadius: blurRadius,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: blurRadius * 1.5,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withOpacity(0.2),
        blurRadius: blurRadius * 2,
        spreadRadius: 0,
        offset: Offset.zero,
      ),
    ];
  }

  // MARK: - Directional Shadows
  // ==========================================

  /// Top shadow only
  static List<BoxShadow> get topShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, -2),
          spreadRadius: 0,
        ),
      ];

  /// Bottom shadow only
  static List<BoxShadow> get bottomShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Left shadow only
  static List<BoxShadow> get leftShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(-2, 0),
          spreadRadius: 0,
        ),
      ];

  /// Right shadow only
  static List<BoxShadow> get rightShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(2, 0),
          spreadRadius: 0,
        ),
      ];

  // MARK: - Material Design Elevation
  // ==========================================

  /// Material design elevation levels
  static List<BoxShadow> materialElevation(int level) {
    switch (level) {
      case 1:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 3,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ];
      case 4:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 3,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ];
      case 6:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 9),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 5,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ];
      default:
        return standard;
    }
  }
}
