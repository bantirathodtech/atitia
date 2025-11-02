// lib/common/utils/logging/logging_mixin.dart

import '../../../../core/services/logging/app_logger.dart';

/// Mixin to add logging capabilities to any class
/// Provides convenient methods for common logging patterns
mixin LoggingMixin {
  AppLogger get _logger => AppLogger.instance;

  /// Log debug information
  void logDebug(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    _logger.debug(message,
        action: action, metadata: metadata, feature: feature);
  }

  /// Log information
  void logInfo(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    _logger.info(message, action: action, metadata: metadata, feature: feature);
  }

  /// Log warnings
  void logWarning(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    _logger.warning(message,
        action: action, metadata: metadata, feature: feature);
  }

  /// Log errors
  void logError(
    String message, {
    String? action,
    Map<String, dynamic>? metadata,
    String? feature,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.error(
      message,
      action: action,
      metadata: metadata,
      feature: feature,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log user actions
  void logUserAction(
    String action, {
    String? feature,
    Map<String, dynamic>? metadata,
    String? screen,
  }) {
    _logger.userAction(
      action,
      feature: feature,
      metadata: metadata,
      screen: screen,
    );
  }

  /// Log API calls
  void logApiCall(
    String endpoint,
    String method, {
    int? statusCode,
    Duration? duration,
    Map<String, dynamic>? metadata,
  }) {
    _logger.apiCall(
      endpoint,
      method,
      statusCode: statusCode,
      duration: duration,
      metadata: metadata,
    );
  }

  /// Log state changes
  void logStateChange(
    String from,
    String to, {
    String? feature,
    Map<String, dynamic>? metadata,
  }) {
    _logger.stateChange(
      from,
      to,
      feature: feature,
      metadata: metadata,
    );
  }

  /// Log method entry
  void logMethodEntry(
    String methodName, {
    Map<String, dynamic>? parameters,
    String? feature,
  }) {
    _logger.debug(
      'Entering $methodName',
      action: 'method_entry',
      metadata: parameters,
      feature: feature,
    );
  }

  /// Log method exit
  void logMethodExit(
    String methodName, {
    Map<String, dynamic>? result,
    String? feature,
  }) {
    _logger.debug(
      'Exiting $methodName',
      action: 'method_exit',
      metadata: result,
      feature: feature,
    );
  }

  /// Log performance metrics
  void logPerformance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    _logger.info(
      'Performance: $operation took ${duration.inMilliseconds}ms',
      action: 'performance',
      metadata: {
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
        ...?metadata,
      },
      feature: feature,
    );
  }

  /// Log business logic events
  void logBusinessEvent(
    String event, {
    Map<String, dynamic>? metadata,
    String? feature,
  }) {
    _logger.info(
      'Business event: $event',
      action: 'business_event',
      metadata: metadata,
      feature: feature,
    );
  }
}
