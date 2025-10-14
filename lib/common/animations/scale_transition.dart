import 'package:flutter/material.dart';

/// Scale transition animation for widgets
///
/// ## Usage:
/// ```dart
/// ScaleTransitionAnimation(
///   child: ButtonWidget(),
///   scale: 0.95,
/// )
/// ```
class ScaleTransitionAnimation extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool repeat;

  const ScaleTransitionAnimation({
    super.key,
    required this.child,
    this.scale = 0.95,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.repeat = false,
  });

  @override
  ScaleTransitionAnimationState createState() =>
      ScaleTransitionAnimationState();
}

class ScaleTransitionAnimationState extends State<ScaleTransitionAnimation>
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

    _animation = Tween<double>(
      begin: widget.scale,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      if (widget.delay > Duration.zero) {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Bounce animation effect
class BounceAnimation extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Duration delay;
  final int bounces;

  const BounceAnimation({
    super.key,
    required this.child,
    this.scale = 0.9,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.bounces = 2,
  });

  @override
  BounceAnimationState createState() => BounceAnimationState();
}

class BounceAnimationState extends State<BounceAnimation>
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

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: widget.scale), weight: 1),
      TweenSequenceItem(tween: Tween(begin: widget.scale, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: widget.scale), weight: 1),
      TweenSequenceItem(tween: Tween(begin: widget.scale, end: 1.0), weight: 1),
    ]).animate(_controller);

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
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Pulse animation (continuous scaling)
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  PulseAnimationState createState() => PulseAnimationState();
}

class PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
