// lib/core/services/ui/animation_service.dart

import 'package:flutter/material.dart';

import '../../di/firebase/di/firebase_service_locator.dart';

/// Animation service for consistent and smooth UI animations
/// Provides predefined animation configurations and helpers
class AnimationService {
  static final AnimationService _instance = AnimationService._internal();
  factory AnimationService() => _instance;
  AnimationService._internal();

  static AnimationService get instance => _instance;

  final _analyticsService = getIt.analytics;

  // Animation durations
  static const Duration _fastDuration = Duration(milliseconds: 200);
  static const Duration _normalDuration = Duration(milliseconds: 300);
  static const Duration _slowDuration = Duration(milliseconds: 500);
  static const Duration _verySlowDuration = Duration(milliseconds: 800);

  // Animation curves
  static const Curve _easeInOut = Curves.easeInOut;
  static const Curve _easeOut = Curves.easeOut;
  static const Curve _easeIn = Curves.easeIn;
  static const Curve _bounceOut = Curves.bounceOut;
  static const Curve _elasticOut = Curves.elasticOut;

  /// Get page transition animation
  static RouteTransitionsBuilder getPageTransition({
    AnimationType type = AnimationType.slideFromRight,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return (context, animation, secondaryAnimation, child) {
      switch (type) {
        case AnimationType.slideFromRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: _easeOut,
            )),
            child: child,
          );
        case AnimationType.slideFromLeft:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: _easeOut,
            )),
            child: child,
          );
        case AnimationType.slideFromBottom:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: _easeOut,
            )),
            child: child,
          );
        case AnimationType.fadeIn:
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        case AnimationType.scaleIn:
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: _bounceOut,
            )),
            child: child,
          );
        case AnimationType.rotationIn:
          return RotationTransition(
            turns: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: _easeOut,
            )),
            child: child,
          );
      }
    };
  }

  /// Get card animation controller
  static AnimationController createCardAnimationController(
      TickerProvider vsync) {
    return AnimationController(
      duration: _normalDuration,
      vsync: vsync,
    );
  }

  /// Get card entrance animation
  static Animation<double> createCardEntranceAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeOut,
    ));
  }

  /// Get card scale animation
  static Animation<double> createCardScaleAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _bounceOut,
    ));
  }

  /// Get shimmer animation
  static Animation<double> createShimmerAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeInOut,
    ));
  }

  /// Get loading animation
  static Animation<double> createLoadingAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
  }

  /// Get bounce animation
  static Animation<double> createBounceAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _bounceOut,
    ));
  }

  /// Get elastic animation
  static Animation<double> createElasticAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _elasticOut,
    ));
  }

  /// Get staggered animation for lists
  static List<AnimationController> createStaggeredAnimations(
    TickerProvider vsync,
    int count, {
    Duration duration = const Duration(milliseconds: 300),
    Duration staggerDelay = const Duration(milliseconds: 100),
  }) {
    final controllers = <AnimationController>[];
    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        duration: duration,
        vsync: vsync,
      );
      controllers.add(controller);
    }
    return controllers;
  }

  /// Animate staggered list items
  static Future<void> animateStaggeredList(
      List<AnimationController> controllers) async {
    for (int i = 0; i < controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 100 * i));
      controllers[i].forward();
    }
  }

  /// Get button press animation
  static Animation<double> createButtonPressAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeInOut,
    ));
  }

  /// Get success animation
  static Animation<double> createSuccessAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _bounceOut,
    ));
  }

  /// Get error shake animation
  static Animation<Offset> createShakeAnimation(
      AnimationController controller) {
    return Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));
  }

  /// Get progress animation
  static Animation<double> createProgressAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeOut,
    ));
  }

  /// Get floating animation
  static Animation<double> createFloatingAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  /// Get rotation animation
  static Animation<double> createRotationAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
  }

  /// Get scale animation
  static Animation<double> createScaleAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _bounceOut,
    ));
  }

  /// Get slide animation
  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0.0, 1.0),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeOut,
    ));
  }

  /// Get fade animation
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeOut,
    ));
  }

  /// Get color transition animation
  static Animation<Color?> createColorTransitionAnimation(
    AnimationController controller,
    Color begin,
    Color end,
  ) {
    return ColorTween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeInOut,
    ));
  }

  /// Get size transition animation
  static Animation<Size> createSizeTransitionAnimation(
      AnimationController controller) {
    return Tween<Size>(
      begin: Size.zero,
      end: const Size(100, 100),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeOut,
    ));
  }

  /// Get position transition animation
  static Animation<Offset> createPositionTransitionAnimation(
      AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: _easeOut,
    ));
  }

  /// Get custom curve animation
  static Animation<double> createCustomCurveAnimation(
    AnimationController controller,
    Curve curve,
  ) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  /// Get animation duration based on type
  static Duration getDuration(AnimationSpeed speed) {
    switch (speed) {
      case AnimationSpeed.fast:
        return _fastDuration;
      case AnimationSpeed.normal:
        return _normalDuration;
      case AnimationSpeed.slow:
        return _slowDuration;
      case AnimationSpeed.verySlow:
        return _verySlowDuration;
    }
  }

  /// Get animation curve based on type
  static Curve getCurve(AnimationEasing easing) {
    switch (easing) {
      case AnimationEasing.easeInOut:
        return _easeInOut;
      case AnimationEasing.easeOut:
        return _easeOut;
      case AnimationEasing.easeIn:
        return _easeIn;
      case AnimationEasing.bounceOut:
        return _bounceOut;
      case AnimationEasing.elasticOut:
        return _elasticOut;
    }
  }

  /// Log animation event
  Future<void> logAnimationEvent(
      String animationType, String screenName) async {
    await _analyticsService.logEvent(
      name: 'animation_triggered',
      parameters: {
        'animation_type': animationType,
        'screen_name': screenName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}

/// Animation type enum
enum AnimationType {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  fadeIn,
  scaleIn,
  rotationIn,
}

/// Animation speed enum
enum AnimationSpeed {
  fast,
  normal,
  slow,
  verySlow,
}

/// Animation easing enum
enum AnimationEasing {
  easeInOut,
  easeOut,
  easeIn,
  bounceOut,
  elasticOut,
}
