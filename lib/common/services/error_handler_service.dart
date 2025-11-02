// error_handler_service.dart
import 'package:flutter/foundation.dart';

import '../../core/di/firebase/di/firebase_service_locator.dart';
import '../utils/exceptions/exceptions.dart';

/// Service for handling and standardizing error handling across the app
/// Maps technical errors to user-friendly messages
/// Logs errors to analytics and crashlytics
class ErrorHandlerService {
  final _analyticsService = getIt.analytics;
  final _crashlyticsService = getIt.crashlytics;

  ErrorHandlerService._privateConstructor();
  static final ErrorHandlerService _instance =
      ErrorHandlerService._privateConstructor();
  factory ErrorHandlerService() => _instance;

  /// Get user-friendly error message from exception
  String getUserFriendlyMessage(dynamic error, {String? fallbackMessage}) {
    if (error is NetworkException) {
      return error.message;
    }

    if (error is AppException) {
      return error.recoverySuggestion ?? error.message;
    }

    final errorString = error.toString().toLowerCase();

    // Map common errors to user-friendly messages
    if (errorString.contains('network') ||
        errorString.contains('internet') ||
        errorString.contains('connection')) {
      return 'Please check your internet connection and try again.';
    }

    if (errorString.contains('permission') || errorString.contains('denied')) {
      return 'You don\'t have permission to perform this action.';
    }

    if (errorString.contains('not found') || errorString.contains('404')) {
      return 'The requested item could not be found.';
    }

    if (errorString.contains('timeout')) {
      return 'The request took too long. Please try again.';
    }

    if (errorString.contains('unauthorized') ||
        errorString.contains('401') ||
        errorString.contains('403')) {
      return 'Your session has expired. Please sign in again.';
    }

    if (errorString.contains('validation') || errorString.contains('invalid')) {
      return 'Please check your input and try again.';
    }

    // Generic fallback
    return fallbackMessage ?? 'Something went wrong. Please try again.';
  }

  /// Handle error with full logging and user-friendly message
  Future<String> handleError(
    dynamic error, {
    String? context,
    String? feature,
    Map<String, dynamic>? metadata,
    bool showToUser = true,
  }) async {
    final userMessage = getUserFriendlyMessage(error);

    // Log to analytics
    await _analyticsService.logEvent(
      name: 'error_occurred',
      parameters: {
        'error': error.toString(),
        'context': context ?? 'unknown',
        'feature': feature ?? 'unknown',
        'user_message': userMessage,
        ...?metadata,
      },
    );

    // Log to crashlytics for non-network errors
    if (error is! NetworkException) {
      try {
        final stackTrace = (error is Error && error.stackTrace != null)
            ? error.stackTrace!
            : StackTrace.current;
        await _crashlyticsService.recordError(
          exception: error,
          stackTrace: stackTrace,
          reason: 'Error in ${feature ?? context ?? "unknown"}',
          fatal: false,
        );
      } catch (_) {
        // Best effort - don't fail if crashlytics logging fails
      }
    }

    if (kDebugMode) {
      debugPrint('Error Handler: $error');
      debugPrint('Context: $context');
      debugPrint('Feature: $feature');
    }

    return userMessage;
  }

  /// Handle error silently (log but don't show to user)
  Future<void> handleErrorSilently(
    dynamic error, {
    String? context,
    String? feature,
    Map<String, dynamic>? metadata,
  }) async {
    await handleError(
      error,
      context: context,
      feature: feature,
      metadata: metadata,
      showToUser: false,
    );
  }
}
