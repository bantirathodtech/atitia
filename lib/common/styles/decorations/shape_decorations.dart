import 'package:flutter/material.dart';

import '../spacing.dart';

/// Custom shape decorations for advanced UI elements
class ShapeDecorations {
  // MARK: - Basic Shapes
  // ==========================================

  /// Standard rounded rectangle
  static ShapeBorder roundedRectangle({
    double borderRadius = AppSpacing.borderRadiusM,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Circle shape
  static ShapeBorder circle({double? size}) {
    return const CircleBorder();
  }

  /// Stadium shape (pill-shaped)
  static ShapeBorder stadium([double? horizontalPadding]) {
    return const StadiumBorder();
  }

  // MARK: - Custom Shapes
  // ==========================================

  /// Notched rectangle for Floating Action Button
  static CircularNotchedRectangle notchedRectangle({
    required BuildContext context,
  }) {
    return const CircularNotchedRectangle();
  }

  /// Beveled rectangle shape
  static ShapeBorder beveledRectangle({
    double borderRadius = AppSpacing.borderRadiusS,
  }) {
    return BeveledRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Continuous rectangle with smooth curves
  static ShapeBorder continuousRectangle({
    double borderRadius = AppSpacing.borderRadiusM,
  }) {
    return ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  // MARK: - Complex Shapes
  // ==========================================

  /// Speech bubble shape
  static ShapeBorder speechBubble({
    double borderRadius = AppSpacing.borderRadiusM,
    double arrowWidth = 16.0,
    double arrowHeight = 8.0,
    bool arrowOnLeft = false,
  }) {
    return _SpeechBubbleBorder(
      borderRadius: borderRadius,
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      arrowOnLeft: arrowOnLeft,
    );
  }

  /// Tag shape (like a price tag)
  static ShapeBorder tag({
    double borderRadius = AppSpacing.borderRadiusS,
    double notchSize = 8.0,
  }) {
    return _TagShapeBorder(
      borderRadius: borderRadius,
      notchSize: notchSize,
    );
  }

  /// Diamond shape
  static ShapeBorder diamond() {
    return _DiamondShapeBorder();
  }

  // MARK: - Button Shapes
  // ==========================================

  /// Primary button shape
  static ShapeBorder primaryButton({
    double borderRadius = AppSpacing.borderRadiusL,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Secondary button shape (outlined)
  static ShapeBorder secondaryButton({
    double borderRadius = AppSpacing.borderRadiusL,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: BorderSide(
        color: Colors.grey.shade400,
        width: 1.0,
      ),
    );
  }

  /// Icon button shape (circular)
  static ShapeBorder iconButton({
    double? size,
  }) {
    return const CircleBorder();
  }

  // MARK: - Card Shapes
  // ==========================================

  /// Standard card shape
  static ShapeBorder card({
    double borderRadius = AppSpacing.borderRadiusM,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Elevated card shape
  static ShapeBorder elevatedCard({
    double borderRadius = AppSpacing.borderRadiusM,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Dialog shape
  static ShapeBorder dialog({
    double borderRadius = AppSpacing.borderRadiusL,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}

// MARK: - Custom Shape Implementations
// ==========================================

/// Custom speech bubble shape
class _SpeechBubbleBorder extends ShapeBorder {
  final double borderRadius;
  final double arrowWidth;
  final double arrowHeight;
  final bool arrowOnLeft;

  const _SpeechBubbleBorder({
    this.borderRadius = 12.0,
    this.arrowWidth = 16.0,
    this.arrowHeight = 8.0,
    this.arrowOnLeft = false,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final r = borderRadius;
    final w = arrowWidth;
    final h = arrowHeight;

    // Main rectangle
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - h),
      Radius.circular(r),
    ));

    // Arrow
    if (arrowOnLeft) {
      path.moveTo(rect.left + w, rect.bottom - h);
      path.lineTo(rect.left, rect.bottom - h);
      path.lineTo(rect.left + w / 2, rect.bottom);
      path.close();
    } else {
      path.moveTo(rect.right - w, rect.bottom - h);
      path.lineTo(rect.right, rect.bottom - h);
      path.lineTo(rect.right - w / 2, rect.bottom);
      path.close();
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

/// Custom tag shape
class _TagShapeBorder extends ShapeBorder {
  final double borderRadius;
  final double notchSize;

  const _TagShapeBorder({
    this.borderRadius = 8.0,
    this.notchSize = 8.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final r = borderRadius;
    final n = notchSize;

    path.moveTo(rect.left + r, rect.top);
    path.lineTo(rect.right - r - n, rect.top);
    path.arcToPoint(
      Offset(rect.right - n, rect.top + r),
      radius: Radius.circular(r),
    );
    path.lineTo(rect.right - n, rect.bottom - r);
    path.arcToPoint(
      Offset(rect.right - r - n, rect.bottom),
      radius: Radius.circular(r),
    );
    path.lineTo(rect.left + r, rect.bottom);
    path.arcToPoint(
      Offset(rect.left, rect.bottom - r),
      radius: Radius.circular(r),
    );
    path.lineTo(rect.left, rect.top + r);
    path.arcToPoint(
      Offset(rect.left + r, rect.top),
      radius: Radius.circular(r),
    );
    path.close();

    // Notch
    path.moveTo(rect.right - n, rect.top + r);
    path.lineTo(rect.right, rect.top + r + n / 2);
    path.lineTo(rect.right - n, rect.top + r + n);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

/// Diamond shape
class _DiamondShapeBorder extends ShapeBorder {
  const _DiamondShapeBorder();

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final center = rect.center;
    final halfWidth = rect.width / 2;
    final halfHeight = rect.height / 2;

    path.moveTo(center.dx, center.dy - halfHeight); // Top
    path.lineTo(center.dx + halfWidth, center.dy); // Right
    path.lineTo(center.dx, center.dy + halfHeight); // Bottom
    path.lineTo(center.dx - halfWidth, center.dy); // Left
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
