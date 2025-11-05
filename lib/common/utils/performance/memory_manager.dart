// lib/common/utils/performance/memory_manager.dart

import 'package:flutter/material.dart';
import 'dart:async';

/// Memory management utility for proper disposal patterns
/// Helps prevent memory leaks and optimize app performance
class MemoryManager {
  static final List<StreamSubscription> _subscriptions = [];
  static final List<TextEditingController> _controllers = [];
  static final List<ScrollController> _scrollControllers = [];
  static final List<AnimationController> _animationControllers = [];
  static final List<FocusNode> _focusNodes = [];

  /// Register a stream subscription for automatic disposal
  static void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Register a text editing controller for automatic disposal
  static void registerController(TextEditingController controller) {
    _controllers.add(controller);
  }

  /// Register a scroll controller for automatic disposal
  static void registerScrollController(ScrollController controller) {
    _scrollControllers.add(controller);
  }

  /// Register an animation controller for automatic disposal
  static void registerAnimationController(AnimationController controller) {
    _animationControllers.add(controller);
  }

  /// Register a focus node for automatic disposal
  static void registerFocusNode(FocusNode focusNode) {
    _focusNodes.add(focusNode);
  }

  /// Dispose all registered resources
  static void disposeAll() {
    // Dispose stream subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Dispose text editing controllers
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();

    // Dispose scroll controllers
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    _scrollControllers.clear();

    // Dispose animation controllers
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    _animationControllers.clear();

    // Dispose focus nodes
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _focusNodes.clear();
  }

  /// Get memory usage statistics
  static Map<String, int> getMemoryStats() {
    return {
      'subscriptions': _subscriptions.length,
      'controllers': _controllers.length,
      'scrollControllers': _scrollControllers.length,
      'animationControllers': _animationControllers.length,
      'focusNodes': _focusNodes.length,
    };
  }

  /// Clear memory and force garbage collection
  static Future<void> clearMemory() async {
    disposeAll();

    // Force garbage collection
    await Future.delayed(const Duration(milliseconds: 100));

    // Clear image cache if needed
    await _clearImageCache();
  }

  /// Clear image cache to free up memory
  static Future<void> _clearImageCache() async {
    try {
      // Clear Flutter's image cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (e) {
      debugPrint('⚠️ Memory Manager: Failed to clear image cache: $e');
    }
  }
}

/// Mixin for automatic memory management in StatefulWidgets
mixin MemoryManagementMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];
  final List<TextEditingController> _controllers = [];
  final List<ScrollController> _scrollControllers = [];
  final List<AnimationController> _animationControllers = [];
  final List<FocusNode> _focusNodes = [];

  /// Register a stream subscription for automatic disposal
  void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Register a text editing controller for automatic disposal
  void registerController(TextEditingController controller) {
    _controllers.add(controller);
  }

  /// Register a scroll controller for automatic disposal
  void registerScrollController(ScrollController controller) {
    _scrollControllers.add(controller);
  }

  /// Register an animation controller for automatic disposal
  void registerAnimationController(AnimationController controller) {
    _animationControllers.add(controller);
  }

  /// Register a focus node for automatic disposal
  void registerFocusNode(FocusNode focusNode) {
    _focusNodes.add(focusNode);
  }

  @override
  void dispose() {
    // Dispose stream subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }

    // Dispose text editing controllers
    for (final controller in _controllers) {
      controller.dispose();
    }

    // Dispose scroll controllers
    for (final controller in _scrollControllers) {
      controller.dispose();
    }

    // Dispose animation controllers
    for (final controller in _animationControllers) {
      controller.dispose();
    }

    // Dispose focus nodes
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }
}

/// Performance monitoring utility
class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<Duration>> _measurements = {};

  /// Start measuring performance for a named operation
  static void startMeasurement(String operationName) {
    _startTimes[operationName] = DateTime.now();
  }

  /// End measuring performance for a named operation
  static Duration endMeasurement(String operationName) {
    final startTime = _startTimes.remove(operationName);
    if (startTime == null) {
      return Duration.zero;
    }

    final duration = DateTime.now().difference(startTime);
    _measurements.putIfAbsent(operationName, () => []).add(duration);
    return duration;
  }

  /// Get average performance for an operation
  static Duration getAveragePerformance(String operationName) {
    final measurements = _measurements[operationName];
    if (measurements == null || measurements.isEmpty) {
      return Duration.zero;
    }

    final total = measurements.fold<Duration>(
      Duration.zero,
      (prev, curr) => prev + curr,
    );

    return Duration(
      microseconds: total.inMicroseconds ~/ measurements.length,
    );
  }

  /// Get all performance measurements
  static Map<String, Duration> getAllPerformance() {
    final result = <String, Duration>{};
    for (final operation in _measurements.keys) {
      result[operation] = getAveragePerformance(operation);
    }
    return result;
  }

  /// Clear all performance measurements
  static void clearMeasurements() {
    _startTimes.clear();
    _measurements.clear();
  }
}
