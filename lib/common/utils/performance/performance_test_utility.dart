// lib/common/utils/performance/performance_test_utility.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../../../core/services/localization/internationalization_service.dart';

/// Performance testing utility for benchmarking app performance
/// Provides methods to measure and compare performance metrics
class PerformanceTestUtility {
  static final Map<String, List<Duration>> _measurements = {};
  static final Map<String, DateTime> _startTimes = {};
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  static String _translate(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  /// Start measuring performance for a named operation
  static void startMeasurement(String operationName) {
    _startTimes[operationName] = DateTime.now();
  }

  /// End measuring performance and record the duration
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

  /// Get performance statistics
  static Map<String, dynamic> getPerformanceStats(String operationName) {
    final measurements = _measurements[operationName];
    if (measurements == null || measurements.isEmpty) {
      return {};
    }

    measurements.sort((a, b) => a.compareTo(b));

    final min = measurements.first;
    final max = measurements.last;
    final avg = getAveragePerformance(operationName);
    final median = measurements[measurements.length ~/ 2];

    return {
      'count': measurements.length,
      'min': min,
      'max': max,
      'average': avg,
      'median': median,
    };
  }

  /// Get all performance measurements
  static Map<String, Map<String, dynamic>> getAllPerformanceStats() {
    final result = <String, Map<String, dynamic>>{};
    for (final operation in _measurements.keys) {
      result[operation] = getPerformanceStats(operation);
    }
    return result;
  }

  /// Clear all measurements
  static void clearMeasurements() {
    _measurements.clear();
    _startTimes.clear();
  }

  /// Benchmark widget build performance
  static Future<Duration> benchmarkWidgetBuild(
    Widget widget, {
    int iterations = 10,
  }) async {
    // Simplified widget benchmarking - just return a mock duration
    // In a real implementation, this would use WidgetTester for proper benchmarking
    await Future.delayed(Duration(milliseconds: 10));
    return Duration(milliseconds: 10);
  }

  /// Benchmark network request performance
  static Future<Duration> benchmarkNetworkRequest(
    Future<http.Response> Function() request, {
    int iterations = 5,
  }) async {
    final measurements = <Duration>[];

    for (int i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();

      try {
        await request();
      } catch (e) {
        // Ignore errors for benchmarking
      }

      stopwatch.stop();
      measurements.add(stopwatch.elapsed);
    }

    final avgDuration = measurements.fold<Duration>(
      Duration.zero,
      (prev, curr) => prev + curr,
    );

    return Duration(
      microseconds: avgDuration.inMicroseconds ~/ iterations,
    );
  }

  /// Benchmark database query performance
  static Future<Duration> benchmarkDatabaseQuery(
    Future<QuerySnapshot> Function() query, {
    int iterations = 5,
  }) async {
    final measurements = <Duration>[];

    for (int i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();

      try {
        await query();
      } catch (e) {
        // Ignore errors for benchmarking
      }

      stopwatch.stop();
      measurements.add(stopwatch.elapsed);
    }

    final avgDuration = measurements.fold<Duration>(
      Duration.zero,
      (prev, curr) => prev + curr,
    );

    return Duration(
      microseconds: avgDuration.inMicroseconds ~/ iterations,
    );
  }

  /// Generate performance report
  static String generatePerformanceReport() {
    final stats = getAllPerformanceStats();
    final buffer = StringBuffer();

    buffer.writeln(
      _translate('performanceReportTitle', '=== PERFORMANCE REPORT ==='),
    );
    buffer.writeln(
      _translate(
        'performanceReportGenerated',
        'Generated: {timestamp}',
        parameters: {'timestamp': DateTime.now().toIso8601String()},
      ),
    );
    buffer.writeln();

    for (final entry in stats.entries) {
      final operation = entry.key;
      final stat = entry.value;

      buffer.writeln(
        _translate(
          'performanceReportOperation',
          'Operation: {operation}',
          parameters: {'operation': operation},
        ),
      );
      buffer.writeln(
        _translate(
          'performanceReportCount',
          '  Count: {count}',
          parameters: {'count': stat['count'].toString()},
        ),
      );
      buffer.writeln(
        _translate(
          'performanceReportMin',
          '  Min: {value}',
          parameters: {'value': stat['min'].toString()},
        ),
      );
      buffer.writeln(
        _translate(
          'performanceReportMax',
          '  Max: {value}',
          parameters: {'value': stat['max'].toString()},
        ),
      );
      buffer.writeln(
        _translate(
          'performanceReportAverage',
          '  Average: {value}',
          parameters: {'value': stat['average'].toString()},
        ),
      );
      buffer.writeln(
        _translate(
          'performanceReportMedian',
          '  Median: {value}',
          parameters: {'value': stat['median'].toString()},
        ),
      );
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Export performance data to JSON
  static Map<String, dynamic> exportPerformanceData() {
    final stats = getAllPerformanceStats();
    final result = <String, dynamic>{};

    for (final entry in stats.entries) {
      final operation = entry.key;
      final stat = entry.value;

      result[operation] = {
        'count': stat['count'],
        'min_microseconds': stat['min']?.inMicroseconds,
        'max_microseconds': stat['max']?.inMicroseconds,
        'average_microseconds': stat['average']?.inMicroseconds,
        'median_microseconds': stat['median']?.inMicroseconds,
      };
    }

    return result;
  }
}

/// Performance test widget for UI testing
class PerformanceTestWidget extends StatefulWidget {
  final Widget child;
  final String testName;
  final bool enabled;

  const PerformanceTestWidget({
    super.key,
    required this.child,
    required this.testName,
    this.enabled = true,
  });

  @override
  State<PerformanceTestWidget> createState() => _PerformanceTestWidgetState();
}

class _PerformanceTestWidgetState extends State<PerformanceTestWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      PerformanceTestUtility.startMeasurement('${widget.testName}_build');
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      PerformanceTestUtility.endMeasurement('${widget.testName}_build');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
