import 'package:flutter/material.dart';

/// Slide-in animation from specified direction
///
/// ## Usage:
/// ```dart
/// SlideInAnimation(
///   direction: SlideDirection.fromLeft,
///   child: Text('Hello'),
/// )
/// ```
enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
}

class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double distance;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.distance = 50.0,
  });

  @override
  SlideInAnimationState createState() => SlideInAnimationState();
}

class SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final beginOffset = _getBeginOffset();
    final endOffset = Offset.zero;

    _animation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        return Offset(-widget.distance, 0);
      case SlideDirection.fromRight:
        return Offset(widget.distance, 0);
      case SlideDirection.fromTop:
        return Offset(0, -widget.distance);
      case SlideDirection.fromBottom:
        return Offset(0, widget.distance);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

/// Combined slide and fade animation
class SlideFadeInAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double distance;

  const SlideFadeInAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.distance = 30.0,
  });

  @override
  SlideFadeInAnimationState createState() => SlideFadeInAnimationState();
}

class SlideFadeInAnimationState extends State<SlideFadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final beginOffset = _getBeginOffset();
    final endOffset = Offset.zero;

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        return Offset(-widget.distance, 0);
      case SlideDirection.fromRight:
        return Offset(widget.distance, 0);
      case SlideDirection.fromTop:
        return Offset(0, -widget.distance);
      case SlideDirection.fromBottom:
        return Offset(0, widget.distance);
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
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
