import '../../../../core/services/localization/internationalization_service.dart';

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

/// Enhanced error severity levels for better error categorization
enum ErrorSeverity {
  low, // Non-critical errors (e.g., optional field validation)
  medium, // Recoverable errors (e.g., network timeouts)
  high, // Critical but recoverable (e.g., authentication failures)
  critical // App-breaking errors (e.g., database corruption)
}

/// Enhanced base class for app-specific exceptions with recovery suggestions
class AppException implements Exception {
  final String message;
  final String? prefix;
  final String? details; // Additional error details
  final ErrorSeverity severity;
  final String? recoverySuggestion;
  final dynamic originalError;
  final DateTime timestamp;

  AppException({
    String? message,
    this.prefix,
    this.details,
    this.severity = ErrorSeverity.medium,
    String? recoverySuggestion,
    this.originalError,
  })  : message = message ??
            _translate('appExceptionDefaultMessage', 'An error occurred'),
        recoverySuggestion = recoverySuggestion ??
            _translate(
              'appExceptionDefaultRecovery',
              'Please try again later',
            ),
        timestamp = DateTime.now();

  @override
  String toString() {
    final baseString = prefix == null ? message : '$prefix: $message';
    final parts = <String>[baseString];

    if (details != null && details!.isNotEmpty) {
      final detailsLabel =
          _translate('appExceptionDetailsLabel', 'Details');
      parts.add('$detailsLabel: $details');
    }

    if (recoverySuggestion != null && recoverySuggestion!.isNotEmpty) {
      final suggestionLabel =
          _translate('appExceptionSuggestionLabel', '💡 Suggestion');
      parts.add('$suggestionLabel: $recoverySuggestion');
    }

    return parts.join('\n');
  }

  /// Get detailed error info for debugging
  Map<String, dynamic> toDebugMap() {
    return {
      'message': message,
      'prefix': prefix,
      'details': details,
      'severity': severity.name,
      'recoverySuggestion': recoverySuggestion,
      'originalError': originalError?.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Enhanced network exception with retry guidance
class NetworkException extends AppException {
  NetworkException({
    String? message,
    String? recoverySuggestion,
    super.originalError,
  }) : super(
          message: message ??
              _translate('networkExceptionMessage', 'No internet connection'),
          recoverySuggestion: recoverySuggestion ??
              _translate(
                'networkExceptionRecovery',
                'Check your connection and try again',
              ),
          prefix:
              _translate('networkExceptionPrefix', 'Network Error'),
          severity: ErrorSeverity.medium,
        );
}

/// Enhanced authentication exception with user-friendly messages
class AuthException extends AppException {
  AuthException({
    String? message,
    String? recoverySuggestion,
    super.originalError,
  }) : super(
          message: message ??
              _translate('authExceptionMessage', 'Authentication failed'),
          recoverySuggestion: recoverySuggestion ??
              _translate(
                'authExceptionRecovery',
                'Please check your credentials and try again',
              ),
          prefix: _translate('authExceptionPrefix', 'Auth Error'),
          severity: ErrorSeverity.high,
        );
}

/// Enhanced data parsing exception
class DataParsingException extends AppException {
  DataParsingException({
    String? message,
    String? recoverySuggestion,
    super.originalError,
  }) : super(
          message: message ??
              _translate('dataParsingExceptionMessage', 'Failed to parse data'),
          recoverySuggestion: recoverySuggestion ??
              _translate(
                'dataParsingExceptionRecovery',
                'Please try again or contact support if the problem persists',
              ),
          prefix:
              _translate('dataParsingExceptionPrefix', 'Parsing Error'),
          severity: ErrorSeverity.medium,
        );
}

/// New exception for configuration errors
class ConfigurationException extends AppException {
  ConfigurationException({
    String? message,
    String? recoverySuggestion,
    super.originalError,
  }) : super(
          message: message ??
              _translate('configurationExceptionMessage', 'Configuration error'),
          recoverySuggestion: recoverySuggestion ??
              _translate(
                'configurationExceptionRecovery',
                'Please restart the app or contact support',
              ),
          prefix:
              _translate('configurationExceptionPrefix', 'Config Error'),
          severity: ErrorSeverity.critical,
        );
}

/// New exception for validation errors
class ValidationException extends AppException {
  final String fieldName;

  ValidationException({
    required this.fieldName,
    String? message,
    String? recoverySuggestion,
    super.originalError,
  }) : super(
          message: message ??
              _translate(
                'validationExceptionMessage',
                'Validation failed for {field}',
                parameters: {'field': fieldName},
              ),
          prefix: _translate('validationExceptionPrefix', 'Validation Error'),
          severity: ErrorSeverity.low,
          recoverySuggestion: recoverySuggestion ??
              _translate(
                'validationExceptionRecovery',
                'Please check the entered information',
              ),
        );
}
