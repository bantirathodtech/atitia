// lib/common/widgets/animations/staggered_list_animation.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';

/// 🎨 **STAGGERED LIST ANIMATION - POLISHED LIST ENTRANCES**
///
/// Beautiful staggered animations for list items
/// Creates smooth, professional list entrance effects
class StaggeredListAnimation extends StatelessWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration animationDuration;
  final Curve curve;
  final ScrollPhysics? physics;

  const StaggeredListAnimation({
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.animationDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    this.physics,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedListItem(
          index: index,
          delay: staggerDelay,
          curve: curve,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: children[index],
          ),
        );
      },
    );
  }
}

/// Animated list item wrapper (re-exported from smooth_page_transition)
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Curve curve;

  const AnimatedListItem({
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    Future.delayed(widget.delay * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}

