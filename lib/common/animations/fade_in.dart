import 'package:flutter/material.dart';

/// Fade-in animation widget
///
/// ## Usage:
/// ```dart
/// FadeInAnimation(
///   child: Text('Hello'),
///   duration: Duration(milliseconds: 500),
/// )
/// ```
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
  });

  @override
  FadeInAnimationState createState() => FadeInAnimationState();
}

class FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    // Start animation after delay
    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// Sequential fade-in animation for multiple children
class StaggeredFadeInAnimation extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration delayBetween;
  final Curve curve;

  const StaggeredFadeInAnimation({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 400),
    this.delayBetween = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < children.length; i++)
          FadeInAnimation(
            duration: duration,
            delay: delayBetween * i,
            curve: curve,
            child: children[i],
          ),
      ],
    );
  }
}
