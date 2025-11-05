// lib/core/services/logging/app_logger.dart

import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../../common/utils/date/converter/date_service_converter.dart';

/// Core logging service for the Atitia PG Management app
/// Provides structured logging with different levels and user context
/// Integrates with existing analytics and supports both console and file logging
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._internal();

  AppLogger._internal();

  // Log levels (lowerCamelCase to match Dart style guide)
  static const String levelDebug = 'DEBUG';
  static const String levelInfo = 'INFO';
  static const String levelWarning = 'WARNING';
  static const String levelError = 'ERROR';
  static const String levelCritical = 'CRITICAL';

  // User context
  String? _currentUserId;
  String? _currentUserRole;
  String? _currentPgId;
  String? _currentScreen;

  /// Initialize logger with user context
  void initialize({
    String? userId,
    String? userRole,
    String? pgId,
    String? screen,
  }) {
    _currentUserId = userId;
    _currentUserRole = userRole;
    _currentPgId = pgId;
    _currentScreen = screen;
  }

  /// Update user context
  void updateContext({
    String? userId,
    String? userRole,
    String? pgId,
    String? screen,
  }) {
    if (userId != null) _currentUserId = userId;
    if (userRole != null) _currentUserRole = userRole;
    if (pgId != null) _currentPgId = pgId;
    if (screen != null) _currentScreen = screen;
  }

  /// Clear user context
  void clearContext() {
    _currentUserId = null;
    _currentUserRole = null;
    _currentPgId = null;
    _currentScreen = null;
  }

  /// Log debug information (development only)
  void debug(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    if (kDebugMode) {
      _log(levelDebug, message,
          action: action, metadata: metadata, feature: feature);
    }
  }

  /// Log general information
  void info(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    _log(levelInfo, message, action: action, metadata: metadata, feature: feature);
  }

  /// Log warnings
  void warning(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    _log(levelWarning, message,
        action: action, metadata: metadata, feature: feature);
  }

  /// Log errors
  void error(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final errorMetadata = <String, dynamic>{
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      ...?metadata,
    };
    _log(levelError, message,
        action: action, metadata: errorMetadata, feature: feature);
  }

  /// Log critical errors
  void critical(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final errorMetadata = <String, dynamic>{
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      ...?metadata,
    };
    _log(levelCritical, message,
        action: action, metadata: errorMetadata, feature: feature);
  }

  /// Log user actions
  void userAction(
    String action, {
    String? feature,
    Map<String, dynamic>? metadata,
    String? screen,
  }) {
    _log(
      levelInfo,
      'User action: $action',
      action: action,
      metadata: metadata,
      feature: feature,
      screen: screen,
    );
  }

  /// Log navigation events
  void navigation(
    String from,
    String to, {
    Map<String, dynamic>? metadata,
  }) {
    _log(
      levelInfo,
      'Navigation: $from → $to',
      action: 'navigation',
      metadata: {
        'from': from,
        'to': to,
        ...?metadata,
      },
      feature: 'navigation',
    );
  }

  /// Log API calls
  void apiCall(
    String endpoint,
    String method, {
    int? statusCode,
    Duration? duration,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      levelInfo,
      'API $method $endpoint',
      action: 'api_call',
      metadata: {
        'endpoint': endpoint,
        'method': method,
        if (statusCode != null) 'statusCode': statusCode,
        if (duration != null) 'duration_ms': duration.inMilliseconds,
        ...?metadata,
      },
      feature: 'api',
    );
  }

  /// Log state changes
  void stateChange(
    String from,
    String to, {
    String? feature,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      levelInfo,
      'State change: $from → $to',
      action: 'state_change',
      metadata: {
        'from': from,
        'to': to,
        ...?metadata,
      },
      feature: feature,
    );
  }

  /// Core logging method
  void _log(
    String level,
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
    String? screen,
  }) {
    final context = _buildContext();
    final logData = _buildLogData(
        level, message, action, metadata, feature, screen, context);

    // Console logging
    _logToConsole(level, logData);

    // File logging (in debug mode)
    if (kDebugMode) {
      _logToFile(logData);
    }
  }

  /// Build user context
  Map<String, dynamic> _buildContext() {
    return {
      if (_currentUserId != null) 'userId': _currentUserId,
      if (_currentUserRole != null) 'userRole': _currentUserRole,
      if (_currentPgId != null) 'pgId': _currentPgId,
      if (_currentScreen != null) 'screen': _currentScreen,
    };
  }

  /// Build complete log data
  Map<String, dynamic> _buildLogData(
    String level,
    String message,
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
    String? screen,
    Map<String, dynamic> context,
  ) {
    return {
      'timestamp': DateServiceConverter.toService(DateTime.now()),
      'level': level,
      'message': message,
      if (action != null) 'action': action,
      if (feature != null) 'feature': feature,
      if (screen != null) 'screen': screen,
      'context': context,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Log to console
  void _logToConsole(String level, Map<String, dynamic> logData) {
    final emoji = _getLevelEmoji(level);
    final context = logData['context'] as Map<String, dynamic>;
    final contextStr = context.isNotEmpty
        ? ' [${context.entries.map((e) => '${e.key}:${e.value}').join(', ')}]'
        : '';

    developer.log(
      '$emoji ${logData['message']}$contextStr',
      name: 'AtitiaLogger',
      level: _getLogLevel(level),
      error: logData['metadata']?['error'],
      stackTrace: logData['metadata']?['stackTrace'],
    );
  }

  /// Log to file (debug mode only)
  void _logToFile(Map<String, dynamic> logData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/atitia_logs.txt');

      final logLine =
          '${logData['timestamp']} [${logData['level']}] ${logData['message']}\n';
      await logFile.writeAsString(logLine, mode: FileMode.append);
    } catch (e) {
      // Silent fail for file logging
    }
  }

  /// Get emoji for log level
  String _getLevelEmoji(String level) {
    switch (level) {
      case levelDebug:
        return '🐛';
      case levelInfo:
        return 'ℹ️';
      case levelWarning:
        return '⚠️';
      case levelError:
        return '❌';
      case levelCritical:
        return '🚨';
      default:
        return '📝';
    }
  }

  /// Get numeric log level for developer.log
  int _getLogLevel(String level) {
    switch (level) {
      case levelDebug:
        return 500;
      case levelInfo:
        return 800;
      case levelWarning:
        return 900;
      case levelError:
        return 1000;
      case levelCritical:
        return 1200;
      default:
        return 800;
    }
  }

  /// Get current context for external use
  Map<String, dynamic> get currentContext => _buildContext();

  /// Check if logging is enabled for level
  bool isLoggingEnabled(String level) {
    if (level == levelDebug) return kDebugMode;
    return true;
  }
}
