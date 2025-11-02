// lib/common/utils/logging/logging_helper.dart

import '../../../../core/services/logging/app_logger.dart';

/// Helper class for common logging patterns and utilities
class LoggingHelper {
  static AppLogger get _logger => AppLogger.instance;

  /// Log button clicks
  static void logButtonClick(
    String buttonName, {
    String? screen,
    String? feature,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Button clicked: $buttonName',
      feature: feature ?? 'ui',
      metadata: {
        'buttonName': buttonName,
        ...?metadata,
      },
      screen: screen,
    );
  }

  /// Log form submissions
  static void logFormSubmission(
    String formName, {
    String? screen,
    String? feature,
    Map<String, dynamic>? formData,
    bool success = true,
  }) {
    _logger.userAction(
      'Form submitted: $formName',
      feature: feature ?? 'ui',
      metadata: {
        'formName': formName,
        'success': success,
        if (formData != null) 'formData': formData,
      },
      screen: screen,
    );
  }

  /// Log filter changes
  static void logFilterChange(
    String filterType,
    dynamic oldValue,
    dynamic newValue, {
    String? screen,
    String? feature,
  }) {
    _logger.userAction(
      'Filter changed: $filterType',
      feature: feature ?? 'ui',
      metadata: {
        'filterType': filterType,
        'oldValue': oldValue?.toString(),
        'newValue': newValue?.toString(),
      },
      screen: screen,
    );
  }

  /// Log search queries
  static void logSearch(
    String query, {
    String? screen,
    String? feature,
    int? resultCount,
  }) {
    _logger.userAction(
      'Search performed',
      feature: feature ?? 'search',
      metadata: {
        'query': query,
        if (resultCount != null) 'resultCount': resultCount,
      },
      screen: screen,
    );
  }

  /// Log navigation events
  static void logNavigation(
    String from,
    String to, {
    Map<String, dynamic>? metadata,
  }) {
    _logger.navigation(from, to, metadata: metadata);
  }

  /// Log screen views
  static void logScreenView(
    String screenName, {
    String? feature,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Screen viewed: $screenName',
      feature: feature ?? 'navigation',
      metadata: {
        'screenName': screenName,
        ...?metadata,
      },
      screen: screenName,
    );
  }

  /// Log data loading
  static void logDataLoading(
    String dataType, {
    String? feature,
    bool success = true,
    int? itemCount,
    Duration? duration,
  }) {
    _logger.info(
      'Data loading: $dataType',
      action: 'data_loading',
      metadata: {
        'dataType': dataType,
        'success': success,
        if (itemCount != null) 'itemCount': itemCount,
        if (duration != null) 'duration_ms': duration.inMilliseconds,
      },
      feature: feature,
    );
  }

  /// Log errors with context
  static void logErrorWithContext(
    String operation,
    Object error, {
    String? feature,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) {
    _logger.error(
      'Error in $operation: ${error.toString()}',
      action: 'error_occurred',
      metadata: {
        'operation': operation,
        'error': error.toString(),
        if (context != null) 'context': context,
      },
      feature: feature,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log API responses
  static void logApiResponse(
    String endpoint,
    int statusCode, {
    Duration? duration,
    Map<String, dynamic>? responseData,
    String? error,
  }) {
    _logger.apiCall(
      endpoint,
      'RESPONSE',
      statusCode: statusCode,
      duration: duration,
      metadata: {
        if (responseData != null) 'responseData': responseData,
        if (error != null) 'error': error,
      },
    );
  }

  /// Log user authentication events
  static void logAuthEvent(
    String event, {
    String? userId,
    String? method,
    bool success = true,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Auth: $event',
      feature: 'authentication',
      metadata: {
        'event': event,
        if (userId != null) 'userId': userId,
        if (method != null) 'method': method,
        'success': success,
        ...?metadata,
      },
    );
  }

  /// Log role-specific actions
  static void logRoleAction(
    String role,
    String action, {
    String? feature,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      '$role action: $action',
      feature: feature ?? 'role_action',
      metadata: {
        'role': role,
        'action': action,
        ...?metadata,
      },
    );
  }

  /// Log PG-related actions
  static void logPgAction(
    String action,
    String pgId, {
    String? feature,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'PG $action',
      feature: feature ?? 'pg_management',
      metadata: {
        'action': action,
        'pgId': pgId,
        ...?metadata,
      },
    );
  }

  /// Log payment events
  static void logPaymentEvent(
    String event, {
    String? paymentId,
    String? amount,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Payment: $event',
      feature: 'payments',
      metadata: {
        'event': event,
        if (paymentId != null) 'paymentId': paymentId,
        if (amount != null) 'amount': amount,
        if (status != null) 'status': status,
        ...?metadata,
      },
    );
  }

  /// Log food-related actions
  static void logFoodAction(
    String action, {
    String? foodId,
    String? mealType,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Food $action',
      feature: 'food_management',
      metadata: {
        'action': action,
        if (foodId != null) 'foodId': foodId,
        if (mealType != null) 'mealType': mealType,
        ...?metadata,
      },
    );
  }

  /// Log complaint events
  static void logComplaintEvent(
    String event, {
    String? complaintId,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Complaint: $event',
      feature: 'complaints',
      metadata: {
        'event': event,
        if (complaintId != null) 'complaintId': complaintId,
        if (status != null) 'status': status,
        ...?metadata,
      },
    );
  }

  /// Log guest actions
  static void logGuestAction(
    String action, {
    String? guestId,
    String? pgId,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Guest $action',
      feature: 'guest_management',
      metadata: {
        'action': action,
        if (guestId != null) 'guestId': guestId,
        if (pgId != null) 'pgId': pgId,
        ...?metadata,
      },
    );
  }

  /// Log owner actions
  static void logOwnerAction(
    String action, {
    String? pgId,
    Map<String, dynamic>? metadata,
  }) {
    _logger.userAction(
      'Owner $action',
      feature: 'owner_management',
      metadata: {
        'action': action,
        if (pgId != null) 'pgId': pgId,
        ...?metadata,
      },
    );
  }
}
