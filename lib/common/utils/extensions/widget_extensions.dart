import 'package:flutter/material.dart';

import '../constants/app.dart';
import '../../styles/colors.dart';

/// Extension methods for Widget for common operations
///
/// ## Usage:
/// ```dart
/// Text('Hello').paddingAll(16)
/// Container().withSize(100, 100)
/// ```
extension WidgetExtensions on Widget {
  // MARK: - Padding Extensions
  // ==========================================

  /// Adds padding to all sides
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Adds symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  /// Adds padding only to specific sides
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Adds default app padding
  Widget withAppPadding() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: this,
    );
  }

  // MARK: - Margin Extensions
  // ==========================================

  /// Adds margin to all sides
  Widget marginAll(double value) {
    return Container(
      margin: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Adds symmetric margin
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  // MARK: - Size & Constraint Extensions
  // ==========================================

  /// Wraps widget with specific width and height
  Widget withSize(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  /// Wraps widget with specific width
  Widget withWidth(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  /// Wraps widget with specific height
  Widget withHeight(double height) {
    return SizedBox(
      height: height,
      child: this,
    );
  }

  /// Expands widget to fill available space
  Widget expand([int flex = 1]) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  /// Centers widget horizontally and vertically
  Widget center() {
    return Center(child: this);
  }

  /// Aligns widget within its parent
  Widget align(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  // MARK: - Decoration Extensions
  // ==========================================

  /// Wraps widget with background color
  Widget withBackground(Color color, {BorderRadius? borderRadius}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  /// Wraps widget with border - theme-aware via BuildContext
  /// Note: This extension method doesn't have direct access to BuildContext
  /// Users should pass theme-aware color when calling this method
  Widget withBorder({
    Color? color,
    double width = 1,
    BorderRadius? borderRadius,
  }) {
    // Note: Default color removed - caller should provide theme-aware color
    // Example: widget.withBorder(color: Theme.of(context).dividerColor)
    final borderColor = color ?? AppColors.outline;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  /// Wraps widget with rounded corners
  Widget withRoundedCorners([double radius = AppConstants.cardBorderRadius]) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  // MARK: - Gesture Extensions
  // ==========================================

  /// Adds tap gesture detection
  Widget onTap(VoidCallback onTap, {bool opaque = true}) {
    return GestureDetector(
      onTap: onTap,
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      child: this,
    );
  }

  /// Adds double tap gesture detection
  Widget onDoubleTap(VoidCallback onDoubleTap) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: this,
    );
  }

  /// Adds long press gesture detection
  Widget onLongPress(VoidCallback onLongPress) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: this,
    );
  }

  // MARK: - Transformation Extensions
  // ==========================================

  /// Wraps widget with opacity
  Widget withOpacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  /// Wraps widget with rotation
  Widget withRotation(double angle) {
    return Transform.rotate(
      angle: angle,
      child: this,
    );
  }

  /// Wraps widget with scale
  Widget withScale(double scale) {
    return Transform.scale(
      scale: scale,
      child: this,
    );
  }

  // MARK: - Utility Extensions
  // ==========================================

  /// Wraps widget with tooltip
  Widget withTooltip(String message) {
    return Tooltip(
      message: message,
      child: this,
    );
  }

  /// Makes widget visible conditionally
  Widget visible(bool visible) {
    return visible ? this : const SizedBox.shrink();
  }

  /// Wraps widget in a safe area
  Widget withSafeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: this,
    );
  }
}
