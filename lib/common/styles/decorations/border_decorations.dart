import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';

/// Border decoration utilities for consistent border styling
class BorderDecorations {
  // MARK: - BorderSide Presets
  // ==========================================

  /// Standard border side - theme-aware via BuildContext
  static BorderSide standard(BuildContext context) => BorderSide(
        color: Theme.of(context).dividerColor,
        width: 1.0,
      );

  /// Light border side for subtle separation - theme-aware via BuildContext
  static BorderSide light(BuildContext context) => BorderSide(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        width: 0.5,
      );

  /// Strong border side for emphasis - theme-aware via BuildContext
  static BorderSide strong(BuildContext context) => BorderSide(
        color: Theme.of(context).dividerColor,
        width: 2.0,
      );

  /// No border side
  static BorderSide get none => BorderSide.none;

  // MARK: - Colored Border Sides
  // ==========================================

  /// Primary color border side
  static BorderSide get primary => BorderSide(
        color: AppColors.info,
        width: 1.5,
      );

  /// Success color border side
  static BorderSide get success => BorderSide(
        color: AppColors.success,
        width: 1.5,
      );

  /// Warning color border side
  static BorderSide get warning => BorderSide(
        color: AppColors.statusOrange,
        width: 1.5,
      );

  /// Error color border side
  static BorderSide get error => BorderSide(
        color: AppColors.error,
        width: 1.5,
      );

  // MARK: - BoxBorder Presets
  // ==========================================

  /// Standard border for containers - theme-aware via BuildContext
  static BoxBorder standardBorder(BuildContext context) => Border.all(
        color: Theme.of(context).dividerColor,
        width: 1.0,
      );

  /// Light border for subtle separation - theme-aware via BuildContext
  static BoxBorder lightBorder(BuildContext context) => Border.all(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        width: 0.5,
      );

  /// Strong border for emphasis - theme-aware via BuildContext
  static BoxBorder strongBorder(BuildContext context) => Border.all(
        color: Theme.of(context).dividerColor,
        width: 2.0,
      );

  /// No border
  static BoxBorder get noBorder => Border.all(
        color: Colors.transparent,
        width: 0.0,
      );

  /// Primary color border
  static BoxBorder get primaryBorder => Border.all(
        color: AppColors.info,
        width: 1.5,
      );

  /// Success color border
  static BoxBorder get successBorder => Border.all(
        color: AppColors.success,
        width: 1.5,
      );

  /// Warning color border
  static BoxBorder get warningBorder => Border.all(
        color: AppColors.statusOrange,
        width: 1.5,
      );

  /// Error color border
  static BoxBorder get errorBorder => Border.all(
        color: AppColors.error,
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

  /// Border with shadow effect - theme-aware via BuildContext
  static BoxDecoration borderedWithShadow(
    BuildContext context, {
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      border: border ?? standardBorder(context),
      borderRadius: borderRadius ?? radiusMedium,
      boxShadow: boxShadow ??
          [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
    );
  }

  /// Outline input border with custom color - theme-aware via BuildContext
  static OutlineInputBorder outlineInput(
    BuildContext context, {
    Color? color,
    double width = 1.0,
    double borderRadius = AppSpacing.borderRadiusM,
  }) {
    final borderColor = color ?? Theme.of(context).dividerColor;
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: width),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Underline input border with custom color - theme-aware via BuildContext
  static UnderlineInputBorder underlineInput(
    BuildContext context, {
    Color? color,
    double width = 1.0,
  }) {
    final borderColor = color ?? Theme.of(context).dividerColor;
    return UnderlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: width),
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

  /// Create border with only specific sides - theme-aware via BuildContext
  static BoxBorder only(
    BuildContext context, {
    bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
    Color? color,
    double width = 1.0,
  }) {
    final borderColor = color ?? Theme.of(context).dividerColor;
    final borderSide = BorderSide(color: borderColor, width: width);
    return Border(
      left: left ? borderSide : BorderSide.none,
      top: top ? borderSide : BorderSide.none,
      right: right ? borderSide : BorderSide.none,
      bottom: bottom ? borderSide : BorderSide.none,
    );
  }

  /// Create symmetric vertical borders - theme-aware via BuildContext
  static BoxBorder vertical(
    BuildContext context, {
    Color? color,
    double width = 1.0,
  }) {
    final borderColor = color ?? Theme.of(context).dividerColor;
    final borderSide = BorderSide(color: borderColor, width: width);
    return Border.symmetric(
      vertical: borderSide,
    );
  }

  /// Create symmetric horizontal borders - theme-aware via BuildContext
  static BoxBorder horizontal(
    BuildContext context, {
    Color? color,
    double width = 1.0,
  }) {
    final borderColor = color ?? Theme.of(context).dividerColor;
    final borderSide = BorderSide(color: borderColor, width: width);
    return Border.symmetric(
      horizontal: borderSide,
    );
  }

  // MARK: - Border Style Helpers
  // ==========================================

  /// Create a border with rounded corners - theme-aware via BuildContext
  static BoxDecoration roundedBorder(
    BuildContext context, {
    Color? color,
    double width = 1.0,
    double borderRadius = AppSpacing.borderRadiusM,
    Color? fillColor,
  }) {
    final borderColor = color ?? Theme.of(context).dividerColor;
    return BoxDecoration(
      color: fillColor,
      border: Border.all(color: borderColor, width: width),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Create a border with different radius per corner - theme-aware via BuildContext
  static BoxDecoration customRadiusBorder(
    BuildContext context, {
    Color? color,
    double width = 1.0,
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
    Color? fillColor,
  }) {
    final borderColor = color ?? Theme.of(context).dividerColor;
    return BoxDecoration(
      color: fillColor,
      border: Border.all(color: borderColor, width: width),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    );
  }
}
