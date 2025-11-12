import 'package:flutter/material.dart';

import '../styles/spacing.dart';

/// Shimmer loading effect for placeholder content
///
/// ## Usage:
/// ```dart
/// ShimmerEffect(
///   child: Container(
///     height: 100,
///     decoration: BoxDecoration(
///       color: Colors.white,
///       borderRadius: BorderRadius.circular(8),
///     ),
///   ),
/// )
/// ```
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  ShimmerEffectState createState() => ShimmerEffectState();
}

class ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: const Alignment(-1.0, 0.0),
              end: const Alignment(1.0, 0.0),
              transform: _SlidingGradientTransform(_controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final slideWidth = bounds.width * 2;
    final slideTranslation = -slideWidth + (slideWidth * slidePercent * 2);
    return Matrix4.translationValues(slideTranslation, 0.0, 0.0);
  }
}

/// Pre-built shimmer loading widgets
class ShimmerLoading {
  /// Shimmer effect for text line
  static Widget textLine({
    double width = double.infinity,
    double height = 16,
    double borderRadius = 4,
  }) {
    return ShimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Shimmer effect for circular avatar
  static Widget circle({
    double size = 40,
  }) {
    return ShimmerEffect(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Shimmer effect for card
  static Widget card({
    double width = double.infinity,
    double height = 100,
    double borderRadius = 8,
  }) {
    return ShimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Shimmer effect for list item
  static Widget listItem() {
    return Row(
      children: [
        ShimmerLoading.circle(size: 48),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading.textLine(width: double.infinity, height: 16),
              const SizedBox(height: AppSpacing.paddingS),
              ShimmerLoading.textLine(width: 200, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}
