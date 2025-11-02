// lib/core/monitoring/production_monitoring.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../config/production_config.dart';
import '../../common/utils/date/converter/date_service_converter.dart';

/// Production monitoring and logging system
/// Provides comprehensive monitoring, logging, and analytics
class ProductionMonitoring {
  static final ProductionMonitoring _instance =
      ProductionMonitoring._internal();
  factory ProductionMonitoring() => _instance;
  ProductionMonitoring._internal();

  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;
  late final FirebasePerformance _performance;
  late final FirebaseRemoteConfig _remoteConfig;

  final List<LogEntry> _logEntries = [];
  final StreamController<LogEntry> _logStreamController =
      StreamController<LogEntry>.broadcast();
  final Map<String, Timer> _performanceTimers = {};
  final Map<String, DateTime> _performanceStartTimes = {};

  bool _isInitialized = false;

  /// Initialize monitoring system
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase services
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _performance = FirebasePerformance.instance;
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Configure analytics
      await _analytics
          .setAnalyticsCollectionEnabled(ProductionConfig.enableAnalytics);

      // Configure crashlytics
      await _crashlytics
          .setCrashlyticsCollectionEnabled(ProductionConfig.enableCrashlytics);

      // Configure performance monitoring
      await _performance.setPerformanceCollectionEnabled(
          ProductionConfig.enablePerformanceMonitoring);

      // Configure remote config
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Set default values for remote config
      await _remoteConfig.setDefaults({
        'enable_analytics': ProductionConfig.enableAnalytics,
        'enable_crashlytics': ProductionConfig.enableCrashlytics,
        'enable_performance_monitoring':
            ProductionConfig.enablePerformanceMonitoring,
        'enable_security_monitoring': ProductionConfig.enableSecurityMonitoring,
        'enable_error_reporting': ProductionConfig.enableErrorReporting,
        'enable_user_tracking': ProductionConfig.enableUserTracking,
        'enable_debug_logging': ProductionConfig.enableDebugLogging,
        'log_level': ProductionConfig.logLevel,
        'api_timeout_seconds': ProductionConfig.apiTimeoutSeconds,
        'max_retry_attempts': ProductionConfig.maxRetryAttempts,
        'max_login_attempts': ProductionConfig.maxLoginAttempts,
        'lockout_duration_minutes': ProductionConfig.lockoutDurationMinutes,
        'image_cache_size_mb': ProductionConfig.imageCacheSizeMB,
        'network_cache_size_mb': ProductionConfig.networkCacheSizeMB,
        'memory_cache_size_mb': ProductionConfig.memoryCacheSizeMB,
        'disk_cache_size_mb': ProductionConfig.diskCacheSizeMB,
      });

      // Fetch remote config
      await _remoteConfig.fetchAndActivate();

      _isInitialized = true;

      log('ProductionMonitoring', 'Monitoring system initialized successfully',
          LogLevel.info);
    } catch (e) {
      log('ProductionMonitoring', 'Failed to initialize monitoring system: $e',
          LogLevel.error);
      rethrow;
    }
  }

  /// Log a message with specified level and category
  void log(String category, String message, LogLevel level,
      {Map<String, dynamic>? metadata}) {
    if (!_isInitialized) {
      return;
    }

    final logEntry = LogEntry(
      timestamp: DateTime.now(),
      category: category,
      message: message,
      level: level,
      metadata: metadata ?? {},
    );

    _logEntries.add(logEntry);
    _logStreamController.add(logEntry);

    // Print to console if debug logging is enabled
    if (ProductionConfig.enableDebugLogging && ProductionConfig.isDevelopment) {
      print(
          '[${logEntry.level.name.toUpperCase()}] ${logEntry.category}: ${logEntry.message}');
    }

    // Send to remote logging service if enabled
    if (ProductionConfig.enableRemoteLogging) {
      _sendToRemoteLogging(logEntry);
    }

    // Send to crashlytics if error level
    if (level == LogLevel.error && ProductionConfig.enableCrashlytics) {
      _crashlytics.recordError(
        Exception(message),
        StackTrace.current,
        reason: 'Error logged from $category',
        information: metadata?.entries
                .map((e) => DiagnosticsProperty(e.key, e.value))
                .toList() ??
            [],
      );
    }
  }

  /// Log info message
  void logInfo(String category, String message,
      {Map<String, dynamic>? metadata}) {
    log(category, message, LogLevel.info, metadata: metadata);
  }

  /// Log warning message
  void logWarning(String category, String message,
      {Map<String, dynamic>? metadata}) {
    log(category, message, LogLevel.warning, metadata: metadata);
  }

  /// Log error message
  void logError(String category, String message,
      {Map<String, dynamic>? metadata}) {
    log(category, message, LogLevel.error, metadata: metadata);
  }

  /// Log debug message
  void logDebug(String category, String message,
      {Map<String, dynamic>? metadata}) {
    log(category, message, LogLevel.debug, metadata: metadata);
  }

  /// Start performance monitoring for a specific operation
  void startPerformanceMonitoring(String operationName) {
    if (!ProductionConfig.enablePerformanceMonitoring) return;

    _performanceStartTimes[operationName] = DateTime.now();

    log('PerformanceMonitoring', 'Started monitoring: $operationName',
        LogLevel.debug);
  }

  /// End performance monitoring for a specific operation
  void endPerformanceMonitoring(String operationName) {
    if (!ProductionConfig.enablePerformanceMonitoring) return;

    final startTime = _performanceStartTimes.remove(operationName);
    if (startTime == null) {
      log(
          'PerformanceMonitoring',
          'No start time found for operation: $operationName',
          LogLevel.warning);
      return;
    }

    final duration = DateTime.now().difference(startTime);

    log(
        'PerformanceMonitoring',
        'Completed monitoring: $operationName in ${duration.inMilliseconds}ms',
        LogLevel.info,
        metadata: {
          'operation': operationName,
          'duration_ms': duration.inMilliseconds,
          'duration_seconds': duration.inSeconds,
        });

    // Send to Firebase Performance if enabled
    if (ProductionConfig.enablePerformanceMonitoring && _isInitialized) {
      final trace = _performance.newTrace(operationName);
      trace.start();
      trace.stop();
    }
  }

  /// Track user event
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (!ProductionConfig.enableUserTracking) return;

    log('Analytics', 'Tracking event: $eventName', LogLevel.debug,
        metadata: parameters);

    if (ProductionConfig.enableAnalytics && _isInitialized) {
      _analytics.logEvent(
        name: eventName,
        parameters: parameters?.cast<String, Object>(),
      );
    }
  }

  /// Set user properties
  void setUserProperties(Map<String, dynamic> properties) {
    if (!ProductionConfig.enableUserTracking) return;

    log('Analytics', 'Setting user properties: $properties', LogLevel.debug);

    if (ProductionConfig.enableAnalytics && _isInitialized) {
      for (final entry in properties.entries) {
        _analytics.setUserProperty(
            name: entry.key, value: entry.value.toString());
      }
    }
  }

  /// Set user ID
  void setUserId(String userId) {
    if (!ProductionConfig.enableUserTracking) return;

    log('Analytics', 'Setting user ID: $userId', LogLevel.debug);

    if (ProductionConfig.enableAnalytics && _isInitialized) {
      _analytics.setUserId(id: userId);
    }

    if (ProductionConfig.enableCrashlytics && _isInitialized) {
      _crashlytics.setUserIdentifier(userId);
    }
  }

  /// Track screen view
  void trackScreenView(String screenName, {String? screenClass}) {
    if (!ProductionConfig.enableUserTracking) return;

    log('Analytics', 'Tracking screen view: $screenName', LogLevel.debug);

    if (ProductionConfig.enableAnalytics && _isInitialized) {
      _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    }
  }

  /// Track custom event
  void trackCustomEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (!ProductionConfig.enableUserTracking) return;

    log('Analytics', 'Tracking custom event: $eventName', LogLevel.debug,
        metadata: parameters);

    if (ProductionConfig.enableAnalytics && _isInitialized) {
      _analytics.logEvent(
        name: eventName,
        parameters: parameters?.cast<String, Object>(),
      );
    }
  }

  /// Record exception
  void recordException(dynamic exception, StackTrace? stackTrace,
      {String? reason}) {
    log('Exception', 'Exception recorded: $exception', LogLevel.error,
        metadata: {
          'exception': exception.toString(),
          'reason': reason,
        });

    if (ProductionConfig.enableCrashlytics && _isInitialized) {
      _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
      );
    }
  }

  /// Record fatal exception
  void recordFatalException(dynamic exception, StackTrace? stackTrace,
      {String? reason}) {
    log('FatalException', 'Fatal exception recorded: $exception',
        LogLevel.error,
        metadata: {
          'exception': exception.toString(),
          'reason': reason,
        });

    if (ProductionConfig.enableCrashlytics && _isInitialized) {
      _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: true,
      );
    }
  }

  /// Get log entries
  List<LogEntry> getLogEntries(
      {LogLevel? level, String? category, DateTime? since}) {
    var entries = _logEntries;

    if (level != null) {
      entries = entries.where((e) => e.level == level).toList();
    }

    if (category != null) {
      entries = entries.where((e) => e.category == category).toList();
    }

    if (since != null) {
      entries = entries.where((e) => e.timestamp.isAfter(since)).toList();
    }

    return entries.reversed.toList(); // Most recent first
  }

  /// Get log stream
  Stream<LogEntry> get logStream => _logStreamController.stream;

  /// Clear log entries
  void clearLogEntries() {
    _logEntries.clear();
    log('ProductionMonitoring', 'Log entries cleared', LogLevel.info);
  }

  /// Get monitoring metrics
  Map<String, dynamic> getMonitoringMetrics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last7Days = now.subtract(const Duration(days: 7));

    final logs24h =
        _logEntries.where((e) => e.timestamp.isAfter(last24Hours)).length;
    final logs7d =
        _logEntries.where((e) => e.timestamp.isAfter(last7Days)).length;
    final errorLogs24h = _logEntries
        .where((e) =>
            e.timestamp.isAfter(last24Hours) && e.level == LogLevel.error)
        .length;
    final warningLogs24h = _logEntries
        .where((e) =>
            e.timestamp.isAfter(last24Hours) && e.level == LogLevel.warning)
        .length;

    return {
      'total_logs': _logEntries.length,
      'logs_24h': logs24h,
      'logs_7d': logs7d,
      'error_logs_24h': errorLogs24h,
      'warning_logs_24h': warningLogs24h,
      'performance_timers_active': _performanceTimers.length,
      'monitoring_initialized': _isInitialized,
      'analytics_enabled': ProductionConfig.enableAnalytics,
      'crashlytics_enabled': ProductionConfig.enableCrashlytics,
      'performance_monitoring_enabled':
          ProductionConfig.enablePerformanceMonitoring,
      'security_monitoring_enabled': ProductionConfig.enableSecurityMonitoring,
    };
  }

  /// Send log entry to remote logging service
  void _sendToRemoteLogging(LogEntry logEntry) {
    // In production, this should send to a real logging service
    // For now, we'll just log it
    if (ProductionConfig.isDevelopment) {}
  }

  /// Dispose resources
  void dispose() {
    _logStreamController.close();
    for (final timer in _performanceTimers.values) {
      timer.cancel();
    }
    _performanceTimers.clear();
    _performanceStartTimes.clear();
  }
}

/// Log entry class
class LogEntry {
  final DateTime timestamp;
  final String category;
  final String message;
  final LogLevel level;
  final Map<String, dynamic> metadata;

  LogEntry({
    required this.timestamp,
    required this.category,
    required this.message,
    required this.level,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': DateServiceConverter.toService(timestamp),
      'category': category,
      'message': message,
      'level': level.name,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return '[${level.name.toUpperCase()}] ${DateServiceConverter.toService(timestamp)} $category: $message';
  }
}

/// Log level enum
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}
