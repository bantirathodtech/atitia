// lib/common/widgets/animations/page_wrapper.dart

import 'package:flutter/material.dart';
import 'smooth_page_transition.dart';

/// 🎨 **PAGE WRAPPER - SMOOTH TRANSITIONS**
///
/// Wraps pages with smooth entrance animations
/// Ensures consistent, polished page transitions
class PageWrapper extends StatelessWidget {
  final Widget child;
  final bool animate;

  const PageWrapper({
    required this.child,
    this.animate = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate) return child;

    return FadeInAnimation(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}

/// Slide in from right wrapper
class SlideInWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const SlideInWrapper({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}

/// Animated builder for staggered content
class AnimatedContentBuilder extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration animationDuration;
  final Curve curve;

  const AnimatedContentBuilder({
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  @override
  State<AnimatedContentBuilder> createState() => _AnimatedContentBuilderState();
}

class _AnimatedContentBuilderState extends State<AnimatedContentBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.children.length; i++)
          FadeInAnimation(
            delay: widget.staggerDelay * i,
            duration: widget.animationDuration,
            curve: widget.curve,
            child: widget.children[i],
          ),
      ],
    );
  }
}
