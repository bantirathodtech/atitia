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
    this.message = 'An error occurred',
    this.prefix,
    this.details,
    this.severity = ErrorSeverity.medium,
    this.recoverySuggestion,
    this.originalError,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    final baseString = prefix == null ? message : '$prefix: $message';
    final parts = <String>[baseString];
    
    if (details != null) {
      parts.add('Details: $details');
    }
    
    if (recoverySuggestion != null) {
      parts.add('💡 Suggestion: $recoverySuggestion');
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
    super.message = 'No internet connection',
    super.recoverySuggestion = 'Check your connection and try again',
    super.originalError,
  }) : super(
          prefix: 'Network Error',
          severity: ErrorSeverity.medium,
        );
}

/// Enhanced authentication exception with user-friendly messages
class AuthException extends AppException {
  AuthException({
    super.message = 'Authentication failed',
    super.recoverySuggestion = 'Please check your credentials and try again',
    super.originalError,
  }) : super(
          prefix: 'Auth Error',
          severity: ErrorSeverity.high,
        );
}

/// Enhanced data parsing exception
class DataParsingException extends AppException {
  DataParsingException({
    super.message = 'Failed to parse data',
    super.recoverySuggestion =
        'Please try again or contact support if the problem persists',
    super.originalError,
  }) : super(
          prefix: 'Parsing Error',
          severity: ErrorSeverity.medium,
        );
}

/// New exception for configuration errors
class ConfigurationException extends AppException {
  ConfigurationException({
    super.message = 'Configuration error',
    super.recoverySuggestion = 'Please restart the app or contact support',
    super.originalError,
  }) : super(
          prefix: 'Config Error',
          severity: ErrorSeverity.critical,
        );
}

/// New exception for validation errors
class ValidationException extends AppException {
  final String fieldName;

  ValidationException({
    required this.fieldName,
    String message = 'Validation failed',
    String? recoverySuggestion,
    super.originalError,
  }) : super(
          message: '$message for $fieldName',
          prefix: 'Validation Error',
          severity: ErrorSeverity.low,
          recoverySuggestion:
              recoverySuggestion ?? 'Please check the entered information',
        );
}
