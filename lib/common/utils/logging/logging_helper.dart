// lib/common/utils/logging/logging_helper.dart

import '../../../../core/services/localization/internationalization_service.dart';
import '../../../../core/services/logging/app_logger.dart';

/// Helper class for common logging patterns and utilities
class LoggingHelper {
  static AppLogger get _logger => AppLogger.instance;
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

  /// Log button clicks
  static void logButtonClick(
    String buttonName, {
    String? screen,
    String? feature,
    Map<String, dynamic>? metadata,
  }) {
    final message = _translate(
      'logButtonClicked',
      'Button clicked: {buttonName}',
      parameters: {'buttonName': buttonName},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logFormSubmitted',
      'Form submitted: {formName}',
      parameters: {'formName': formName},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logFilterChanged',
      'Filter changed: {filterType}',
      parameters: {'filterType': filterType},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logSearchPerformed',
      'Search performed',
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logScreenViewed',
      'Screen viewed: {screenName}',
      parameters: {'screenName': screenName},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logDataLoading',
      'Data loading: {dataType}',
      parameters: {'dataType': dataType},
    );

    _logger.info(
      message,
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
    final message = _translate(
      'logErrorOperation',
      'Error in {operation}: {error}',
      parameters: {
        'operation': operation,
        'error': error.toString(),
      },
    );

    _logger.error(
      message,
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
    final label = _translate(
      'logApiResponseLabel',
      'RESPONSE',
    );

    _logger.apiCall(
      endpoint,
      label,
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
    final message = _translate(
      'logAuthEventMessage',
      'Auth: {event}',
      parameters: {'event': event},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logRoleActionMessage',
      '{role} action: {action}',
      parameters: {
        'role': role,
        'action': action,
      },
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logPgActionMessage',
      'PG {action}',
      parameters: {'action': action},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logPaymentEventMessage',
      'Payment: {event}',
      parameters: {'event': event},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logFoodActionMessage',
      'Food {action}',
      parameters: {'action': action},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logComplaintEventMessage',
      'Complaint: {event}',
      parameters: {'event': event},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logGuestActionMessage',
      'Guest {action}',
      parameters: {'action': action},
    );

    _logger.userAction(
      message,
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
    final message = _translate(
      'logOwnerActionMessage',
      'Owner {action}',
      parameters: {'action': action},
    );

    _logger.userAction(
      message,
      feature: 'owner_management',
      metadata: {
        'action': action,
        if (pgId != null) 'pgId': pgId,
        ...?metadata,
      },
    );
  }
}
