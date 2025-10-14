import 'package:firebase_performance/firebase_performance.dart';

/// Firebase Performance Monitoring service for tracking app performance.
///
/// Responsibility:
/// - Monitor network request performance
/// - Track custom performance traces
/// - Identify performance bottlenecks
class PerformanceMonitoringServiceWrapper {
  final FirebasePerformance _performance = FirebasePerformance.instance;

  PerformanceMonitoringServiceWrapper._privateConstructor();
  static final PerformanceMonitoringServiceWrapper _instance =
      PerformanceMonitoringServiceWrapper._privateConstructor();
  factory PerformanceMonitoringServiceWrapper() => _instance;

  /// Initialize Performance Monitoring service
  Future<void> initialize() async {
    // Performance monitoring initializes automatically
    await Future.delayed(Duration.zero);
  }

  /// Start a custom trace for performance monitoring
  Future<Trace> startTrace(String name) async {
    final trace = _performance.newTrace(name);
    await trace.start();
    return trace;
  }

  /// Start a network request trace
  Future<HttpMetric> startHttpMetric(String url, HttpMethod method) async {
    final metric = _performance.newHttpMetric(url, method);
    await metric.start();
    return metric;
  }

  /// Set performance collection enabled
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {
    await _performance.setPerformanceCollectionEnabled(enabled);
  }

  /// Check if performance monitoring is enabled
  Future<bool> isPerformanceCollectionEnabled() async {
    return await _performance.isPerformanceCollectionEnabled();
  }
}
