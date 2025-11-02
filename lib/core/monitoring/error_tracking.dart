// lib/core/monitoring/error_tracking.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../common/utils/date/converter/date_service_converter.dart';

import '../config/production_config.dart';
import 'production_monitoring.dart';

/// Error tracking and crash reporting system
/// Provides comprehensive error tracking, crash reporting, and issue management
class ErrorTracking {
  static final ErrorTracking _instance = ErrorTracking._internal();
  factory ErrorTracking() => _instance;
  ErrorTracking._internal();

  late final FirebaseCrashlytics _crashlytics;
  late final FirebaseAnalytics _analytics;
  ProductionMonitoring? _monitoring;

  final List<ErrorReport> _errorReports = [];
  final StreamController<ErrorReport> _errorStreamController =
      StreamController<ErrorReport>.broadcast();
  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastErrorTimes = {};

  bool _isInitialized = false;

  /// Initialize error tracking system
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _crashlytics = FirebaseCrashlytics.instance;
      _analytics = FirebaseAnalytics.instance;
      _monitoring = ProductionMonitoring();

      // Configure crashlytics
      await _crashlytics
          .setCrashlyticsCollectionEnabled(ProductionConfig.enableCrashlytics);

      // Set up error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        recordError(details.exception, details.stack, reason: 'Flutter Error');
      };

      // Set up platform error handling
      PlatformDispatcher.instance.onError = (error, stack) {
        recordError(error, stack, reason: 'Platform Error');
        return true;
      };

      _isInitialized = true;

      _monitoring?.logInfo(
          'ErrorTracking', 'Error tracking system initialized successfully');
    } catch (e) {
      rethrow;
    }
  }

  /// Record an error
  void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? metadata,
    bool fatal = false,
  }) {
    if (!_isInitialized) {
      return;
    }

    final errorReport = ErrorReport(
      id: _generateErrorId(),
      timestamp: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
      reason: reason,
      metadata: metadata ?? {},
      fatal: fatal,
    );

    _errorReports.add(errorReport);
    _errorStreamController.add(errorReport);

    // Update error counts
    final errorKey = error.toString();
    _errorCounts[errorKey] = (_errorCounts[errorKey] ?? 0) + 1;
    _lastErrorTimes[errorKey] = DateTime.now();

    // Log the error
    _monitoring?.logError('ErrorTracking', 'Error recorded: $error', metadata: {
      'error_id': errorReport.id,
      'reason': reason,
      'fatal': fatal,
      'metadata': metadata,
    });

    // Send to crashlytics if enabled
    if (ProductionConfig.enableCrashlytics) {
      _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
        information: metadata?.entries
                .map((e) => DiagnosticsProperty(e.key, e.value))
                .toList() ??
            [],
      );
    }

    // Send to analytics if enabled
    if (ProductionConfig.enableAnalytics) {
      _analytics.logEvent(
        name: 'error_occurred',
        parameters: {
          'error_type': error.runtimeType.toString(),
          'error_message': error.toString(),
          'reason': reason ?? 'Unknown',
          'fatal': fatal,
          'error_count': _errorCounts[errorKey] ?? 1,
        },
      );
    }

    // Check for error patterns
    _checkErrorPatterns(errorReport);
  }

  /// Record a fatal error
  void recordFatalError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? metadata,
  }) {
    recordError(error, stackTrace,
        reason: reason, metadata: metadata, fatal: true);
  }

  /// Record a non-fatal error
  void recordNonFatalError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? metadata,
  }) {
    recordError(error, stackTrace,
        reason: reason, metadata: metadata, fatal: false);
  }

  /// Record a custom error
  void recordCustomError(
    String errorType,
    String errorMessage, {
    Map<String, dynamic>? metadata,
    bool fatal = false,
  }) {
    final customError = CustomError(errorType, errorMessage);
    recordError(customError, StackTrace.current,
        metadata: metadata, fatal: fatal);
  }

  /// Record a network error
  void recordNetworkError(
    String url,
    int statusCode,
    String message, {
    Map<String, dynamic>? metadata,
  }) {
    final networkError = NetworkError(url, statusCode, message);
    recordError(networkError, StackTrace.current, metadata: {
      'url': url,
      'status_code': statusCode,
      'message': message,
      ...?metadata,
    });
  }

  /// Record a database error
  void recordDatabaseError(
    String operation,
    String message, {
    Map<String, dynamic>? metadata,
  }) {
    final databaseError = DatabaseError(operation, message);
    recordError(databaseError, StackTrace.current, metadata: {
      'operation': operation,
      'message': message,
      ...?metadata,
    });
  }

  /// Record an authentication error
  void recordAuthenticationError(
    String method,
    String message, {
    Map<String, dynamic>? metadata,
  }) {
    final authError = AuthenticationError(method, message);
    recordError(authError, StackTrace.current, metadata: {
      'method': method,
      'message': message,
      ...?metadata,
    });
  }

  /// Record a validation error
  void recordValidationError(
    String field,
    String message, {
    Map<String, dynamic>? metadata,
  }) {
    final validationError = ValidationError(field, message);
    recordError(validationError, StackTrace.current, metadata: {
      'field': field,
      'message': message,
      ...?metadata,
    });
  }

  /// Check for error patterns and trends
  void _checkErrorPatterns(ErrorReport errorReport) {
    final errorKey = errorReport.error.toString();
    final errorCount = _errorCounts[errorKey] ?? 0;
    final lastErrorTime = _lastErrorTimes[errorKey];

    // Check for repeated errors
    if (errorCount > 5) {
      _monitoring?.logWarning('ErrorTracking',
          'Repeated error detected: $errorKey (count: $errorCount)');
    }

    // Check for error frequency
    if (lastErrorTime != null) {
      final timeSinceLastError = DateTime.now().difference(lastErrorTime);
      if (timeSinceLastError.inMinutes < 1 && errorCount > 3) {
        _monitoring?.logWarning(
            'ErrorTracking', 'High frequency error detected: $errorKey');
      }
    }

    // Check for fatal errors
    if (errorReport.fatal) {
      _monitoring?.logError('ErrorTracking', 'Fatal error detected: $errorKey');
    }
  }

  /// Get error reports
  List<ErrorReport> getErrorReports({
    bool? fatal,
    String? errorType,
    DateTime? since,
  }) {
    var reports = _errorReports;

    if (fatal != null) {
      reports = reports.where((r) => r.fatal == fatal).toList();
    }

    if (errorType != null) {
      reports = reports
          .where((r) => r.error.runtimeType.toString().contains(errorType))
          .toList();
    }

    if (since != null) {
      reports = reports.where((r) => r.timestamp.isAfter(since)).toList();
    }

    return reports.reversed.toList(); // Most recent first
  }

  /// Get error stream
  Stream<ErrorReport> get errorStream => _errorStreamController.stream;

  /// Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last7Days = now.subtract(const Duration(days: 7));

    final errors24h =
        _errorReports.where((e) => e.timestamp.isAfter(last24Hours)).length;
    final errors7d =
        _errorReports.where((e) => e.timestamp.isAfter(last7Days)).length;
    final fatalErrors24h = _errorReports
        .where((e) => e.timestamp.isAfter(last24Hours) && e.fatal)
        .length;
    final nonFatalErrors24h = _errorReports
        .where((e) => e.timestamp.isAfter(last24Hours) && !e.fatal)
        .length;

    return {
      'total_errors': _errorReports.length,
      'errors_24h': errors24h,
      'errors_7d': errors7d,
      'fatal_errors_24h': fatalErrors24h,
      'non_fatal_errors_24h': nonFatalErrors24h,
      'unique_error_types': _errorCounts.length,
      'most_common_error': _getMostCommonError(),
      'error_trend': _getErrorTrend(),
    };
  }

  /// Get most common error
  String _getMostCommonError() {
    if (_errorCounts.isEmpty) return 'None';

    var maxCount = 0;
    String mostCommon = '';

    for (final entry in _errorCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostCommon = entry.key;
      }
    }

    return mostCommon;
  }

  /// Get error trend
  String _getErrorTrend() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last48Hours = now.subtract(const Duration(hours: 48));

    final errors24h =
        _errorReports.where((e) => e.timestamp.isAfter(last24Hours)).length;
    final errors48h = _errorReports
        .where((e) =>
            e.timestamp.isAfter(last48Hours) &&
            e.timestamp.isBefore(last24Hours))
        .length;

    if (errors48h == 0) return 'stable';
    if (errors24h > errors48h) return 'increasing';
    if (errors24h < errors48h) return 'decreasing';
    return 'stable';
  }

  /// Clear error reports
  void clearErrorReports() {
    _errorReports.clear();
    _errorCounts.clear();
    _lastErrorTimes.clear();
    if (_monitoring != null) {
      _monitoring?.logInfo('ErrorTracking', 'Error reports cleared');
    } else {}
  }

  /// Generate unique error ID
  String _generateErrorId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000) % 1000000;
    return 'error_${timestamp}_$random';
  }

  /// Dispose resources
  void dispose() {
    _errorStreamController.close();
  }
}

/// Error report class
class ErrorReport {
  final String id;
  final DateTime timestamp;
  final dynamic error;
  final StackTrace? stackTrace;
  final String? reason;
  final Map<String, dynamic> metadata;
  final bool fatal;

  ErrorReport({
    required this.id,
    required this.timestamp,
    required this.error,
    this.stackTrace,
    this.reason,
    required this.metadata,
    required this.fatal,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': DateServiceConverter.toService(timestamp),
      'error': error.toString(),
      'error_type': error.runtimeType.toString(),
      'stack_trace': stackTrace?.toString(),
      'reason': reason,
      'metadata': metadata,
      'fatal': fatal,
    };
  }

  @override
  String toString() {
    return 'ErrorReport(id: $id, error: $error, fatal: $fatal, timestamp: $timestamp)';
  }
}

/// Custom error classes
class CustomError implements Exception {
  final String type;
  final String message;

  CustomError(this.type, this.message);

  @override
  String toString() => 'CustomError($type): $message';
}

class NetworkError implements Exception {
  final String url;
  final int statusCode;
  final String message;

  NetworkError(this.url, this.statusCode, this.message);

  @override
  String toString() => 'NetworkError($url): $statusCode - $message';
}

class DatabaseError implements Exception {
  final String operation;
  final String message;

  DatabaseError(this.operation, this.message);

  @override
  String toString() => 'DatabaseError($operation): $message';
}

class AuthenticationError implements Exception {
  final String method;
  final String message;

  AuthenticationError(this.method, this.message);

  @override
  String toString() => 'AuthenticationError($method): $message';
}

class ValidationError implements Exception {
  final String field;
  final String message;

  ValidationError(this.field, this.message);

  @override
  String toString() => 'ValidationError($field): $message';
}
