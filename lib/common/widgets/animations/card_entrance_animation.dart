// lib/common/widgets/animations/card_entrance_animation.dart

import 'package:flutter/material.dart';
import 'smooth_page_transition.dart';

/// 🎨 **CARD ENTRANCE ANIMATION - POLISHED CARD ANIMATIONS**
///
/// Wraps cards with smooth entrance animations
/// Creates professional card entrance effects
class CardEntranceAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration staggerDelay;
  final Curve curve;
  final bool enableAnimation;

  const CardEntranceAnimation({
    required this.child,
    required this.index,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
    this.enableAnimation = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableAnimation) return child;

    return AnimatedListItem(
      index: index,
      delay: staggerDelay,
      curve: curve,
      child: child,
    );
  }
}

/// Grid card entrance animation
class GridCardAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration staggerDelay;
  final Curve curve;

  const GridCardAnimation({
    required this.child,
    required this.index,
    this.staggerDelay = const Duration(milliseconds: 30),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleInAnimation(
      delay: staggerDelay * index,
      curve: curve,
      child: child,
    );
  }
}

