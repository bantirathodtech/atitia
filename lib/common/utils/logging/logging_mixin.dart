// lib/common/utils/logging/logging_mixin.dart

import '../../../../core/services/localization/internationalization_service.dart';
import '../../../../core/services/logging/app_logger.dart';

/// Mixin to add logging capabilities to any class
/// Provides convenient methods for common logging patterns
mixin LoggingMixin {
  AppLogger get _logger => AppLogger.instance;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _translate(
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
    final message = _translate(
      'logMethodEntryMessage',
      'Entering {methodName}',
      parameters: {'methodName': methodName},
    );

    _logger.debug(
      message,
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
    final message = _translate(
      'logMethodExitMessage',
      'Exiting {methodName}',
      parameters: {'methodName': methodName},
    );

    _logger.debug(
      message,
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
    final message = _translate(
      'logPerformanceMessage',
      'Performance: {operation} took {durationMs}ms',
      parameters: {
        'operation': operation,
        'durationMs': duration.inMilliseconds,
      },
    );

    _logger.info(
      message,
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
    final message = _translate(
      'logBusinessEventMessage',
      'Business event: {event}',
      parameters: {'event': event},
    );

    _logger.info(
      message,
      action: 'business_event',
      metadata: metadata,
      feature: feature,
    );
  }
}
