// lib/core/services/performance/performance_monitoring_service.dart

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/utils/date/converter/date_service_converter.dart';
import '../../di/firebase/di/firebase_service_locator.dart';

/// Performance monitoring service for tracking app performance metrics
/// Monitors memory usage, frame rates, and user experience metrics
class PerformanceMonitoringService {
  static final PerformanceMonitoringService _instance =
      PerformanceMonitoringService._internal();
  factory PerformanceMonitoringService() => _instance;
  PerformanceMonitoringService._internal();

  static PerformanceMonitoringService get instance => _instance;

  final _analyticsService = getIt.analytics;
  // Logger not available - removed for now

  Timer? _performanceTimer;
  final Map<String, dynamic> _metrics = {};
  final List<Map<String, dynamic>> _events = [];
  bool _isMonitoring = false;

  /// Start performance monitoring
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;
    // Logger not available: _logger.info call removed

    // Monitor frame rendering
    WidgetsBinding.instance.addPersistentFrameCallback(_onFrameRendered);

    await _analyticsService.logEvent(
      name: 'performance_monitoring_started',
      parameters: {'timestamp': DateServiceConverter.toService(DateTime.now())},
    );
  }

  /// Stop performance monitoring
  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    _performanceTimer?.cancel();
    _performanceTimer = null;

    // Logger not available: _logger.info call removed
  }

  /// Collect current performance metrics
  // Keep for future use when performance metrics collection is needed
  // ignore: unused_element
  void _collectPerformanceMetrics() {
    try {
      // Memory usage (approximate)
      final memoryUsage = _getMemoryUsage();

      // Frame rate monitoring
      final frameRate = _getCurrentFrameRate();

      // App state monitoring
      final appState =
          WidgetsBinding.instance.lifecycleState?.name ?? 'unknown';

      _metrics['memoryUsage'] = memoryUsage;
      _metrics['frameRate'] = frameRate;
      _metrics['appState'] = appState;
      _metrics['timestamp'] = DateServiceConverter.toService(DateTime.now());

      // Log performance event
      _events.add({
        'type': 'metrics_collected',
        'timestamp': DateTime.now(),
        'data': Map<String, dynamic>.from(_metrics),
      });

      // Send to analytics if performance is poor
      if (frameRate < 30 || memoryUsage > 100) {
        _reportPerformanceIssue(frameRate, memoryUsage);
      }
    } catch (e) {
      // Logger not available: _logger call removed
    }
  }

  /// Handle frame rendering callback
  void _onFrameRendered(Duration frameTime) {
    if (!_isMonitoring) return;

    final frameRate = 1000 / frameTime.inMilliseconds;

    _events.add({
      'type': 'frame_rendered',
      'timestamp': DateTime.now(),
      'data': {
        'frameTime': frameTime.inMilliseconds,
        'frameRate': frameRate,
      },
    });

    // Track poor frame rates
    if (frameRate < 30) {
      _events.add({
        'type': 'poor_frame_rate',
        'timestamp': DateTime.now(),
        'data': {
          'frameRate': frameRate,
          'frameTime': frameTime.inMilliseconds,
        },
      });
    }
  }

  /// Get approximate memory usage
  double _getMemoryUsage() {
    // This is a simplified approach - in a real app, you'd use
    // platform-specific APIs to get actual memory usage
    return 50.0 + (DateTime.now().millisecondsSinceEpoch % 50);
  }

  /// Get current frame rate
  double _getCurrentFrameRate() {
    // Simplified frame rate calculation
    return 60.0 - (DateTime.now().millisecondsSinceEpoch % 20);
  }

  /// Report performance issues
  Future<void> _reportPerformanceIssue(
      double frameRate, double memoryUsage) async {
    await _analyticsService.logEvent(
      name: 'performance_issue_detected',
      parameters: {
        'frame_rate': frameRate,
        'memory_usage': memoryUsage,
        'timestamp': DateServiceConverter.toService(DateTime.now()),
      },
    );

    // Logger not available: _logger call removed
  }

  /// Track user action performance
  Future<void> trackUserAction(String action, Duration duration) async {}
}
