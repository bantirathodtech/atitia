import 'package:flutter/material.dart';

import '../spacing.dart';

/// Border decoration utilities for consistent border styling
class BorderDecorations {
  // MARK: - BorderSide Presets
  // ==========================================

  /// Standard border side
  static BorderSide get standard => BorderSide(
        color: Colors.grey.shade300,
        width: 1.0,
      );

  /// Light border side for subtle separation
  static BorderSide get light => BorderSide(
        color: Colors.grey.shade200,
        width: 0.5,
      );

  /// Strong border side for emphasis
  static BorderSide get strong => BorderSide(
        color: Colors.grey.shade400,
        width: 2.0,
      );

  /// No border side
  static BorderSide get none => BorderSide.none;

  // MARK: - Colored Border Sides
  // ==========================================

  /// Primary color border side
  static BorderSide get primary => BorderSide(
        color: Colors.blue.shade500,
        width: 1.5,
      );

  /// Success color border side
  static BorderSide get success => BorderSide(
        color: Colors.green.shade500,
        width: 1.5,
      );

  /// Warning color border side
  static BorderSide get warning => BorderSide(
        color: Colors.orange.shade500,
        width: 1.5,
      );

  /// Error color border side
  static BorderSide get error => BorderSide(
        color: Colors.red.shade500,
        width: 1.5,
      );

  // MARK: - BoxBorder Presets
  // ==========================================

  /// Standard border for containers
  static BoxBorder get standardBorder => Border.all(
        color: Colors.grey.shade300,
        width: 1.0,
      );

  /// Light border for subtle separation
  static BoxBorder get lightBorder => Border.all(
        color: Colors.grey.shade200,
        width: 0.5,
      );

  /// Strong border for emphasis
  static BoxBorder get strongBorder => Border.all(
        color: Colors.grey.shade400,
        width: 2.0,
      );

  /// No border
  static BoxBorder get noBorder => Border.all(
        color: Colors.transparent,
        width: 0.0,
      );

  /// Primary color border
  static BoxBorder get primaryBorder => Border.all(
        color: Colors.blue.shade500,
        width: 1.5,
      );

  /// Success color border
  static BoxBorder get successBorder => Border.all(
        color: Colors.green.shade500,
        width: 1.5,
      );

  /// Warning color border
  static BoxBorder get warningBorder => Border.all(
        color: Colors.orange.shade500,
        width: 1.5,
      );

  /// Error color border
  static BoxBorder get errorBorder => Border.all(
        color: Colors.red.shade500,
        width: 1.5,
      );

  // MARK: - Border Radius Presets
  // ==========================================

  /// Small border radius
  static BorderRadius get radiusSmall =>
      BorderRadius.circular(AppSpacing.borderRadiusS);

  /// Medium border radius
  static BorderRadius get radiusMedium =>
      BorderRadius.circular(AppSpacing.borderRadiusM);

  /// Large border radius
  static BorderRadius get radiusLarge =>
      BorderRadius.circular(AppSpacing.borderRadiusL);

  /// Circular border radius (fully rounded)
  static BorderRadius get radiusCircle => BorderRadius.circular(1000);

  /// Top only border radius
  static BorderRadius get radiusTopOnly => BorderRadius.only(
        topLeft: Radius.circular(AppSpacing.borderRadiusM),
        topRight: Radius.circular(AppSpacing.borderRadiusM),
      );

  /// Bottom only border radius
  static BorderRadius get radiusBottomOnly => BorderRadius.only(
        bottomLeft: Radius.circular(AppSpacing.borderRadiusM),
        bottomRight: Radius.circular(AppSpacing.borderRadiusM),
      );

  // MARK: - Complex Border Combinations
  // ==========================================

  /// Border with shadow effect
  static BoxDecoration borderedWithShadow({
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      border: border ?? standardBorder,
      borderRadius: borderRadius ?? radiusMedium,
      boxShadow: boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
    );
  }

  /// Outline input border with custom color
  static OutlineInputBorder outlineInput({
    Color color = Colors.grey,
    double width = 1.0,
    double borderRadius = AppSpacing.borderRadiusM,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Underline input border with custom color
  static UnderlineInputBorder underlineInput({
    Color color = Colors.grey,
    double width = 1.0,
  }) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
    );
  }

  // MARK: - Utility Methods
  // ==========================================

  /// Create custom border with specific sides
  static BoxBorder fromSides({
    BorderSide left = BorderSide.none,
    BorderSide top = BorderSide.none,
    BorderSide right = BorderSide.none,
    BorderSide bottom = BorderSide.none,
  }) {
    return Border(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  /// Create border with only specific sides
  static BoxBorder only({
    bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
    Color color = Colors.grey,
    double width = 1.0,
  }) {
    final borderSide = BorderSide(color: color, width: width);
    return Border(
      left: left ? borderSide : BorderSide.none,
      top: top ? borderSide : BorderSide.none,
      right: right ? borderSide : BorderSide.none,
      bottom: bottom ? borderSide : BorderSide.none,
    );
  }

  /// Create symmetric vertical borders
  static BoxBorder vertical({
    Color color = Colors.grey,
    double width = 1.0,
  }) {
    final borderSide = BorderSide(color: color, width: width);
    return Border.symmetric(
      vertical: borderSide,
    );
  }

  /// Create symmetric horizontal borders
  static BoxBorder horizontal({
    Color color = Colors.grey,
    double width = 1.0,
  }) {
    final borderSide = BorderSide(color: color, width: width);
    return Border.symmetric(
      horizontal: borderSide,
    );
  }

  // MARK: - Border Style Helpers
  // ==========================================

  /// Create a border with rounded corners
  static BoxDecoration roundedBorder({
    Color color = Colors.grey,
    double width = 1.0,
    double borderRadius = AppSpacing.borderRadiusM,
    Color? fillColor,
  }) {
    return BoxDecoration(
      color: fillColor,
      border: Border.all(color: color, width: width),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Create a border with different radius per corner
  static BoxDecoration customRadiusBorder({
    Color color = Colors.grey,
    double width = 1.0,
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
    Color? fillColor,
  }) {
    return BoxDecoration(
      color: fillColor,
      border: Border.all(color: color, width: width),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    );
  }
}
