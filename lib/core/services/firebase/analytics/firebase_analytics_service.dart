import 'package:firebase_analytics/firebase_analytics.dart';

/// Enhanced Firebase Analytics service with proper error handling and null safety
class AnalyticsServiceWrapper {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  AnalyticsServiceWrapper._privateConstructor();
  static final AnalyticsServiceWrapper _instance =
      AnalyticsServiceWrapper._privateConstructor();
  factory AnalyticsServiceWrapper() => _instance;

  /// Initialize Analytics service
  Future<void> initialize() async {
    // Analytics initializes automatically
    await Future.delayed(Duration.zero);
  }

  /// Safe event logging with error handling and null filtering
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      // Filter out null values from parameters
      final safeParameters = _filterNullParameters(parameters);

      await _analytics.logEvent(
        name: name,
        parameters: safeParameters,
      );
    } catch (e) {
    }
  }

  /// Filter out null values from parameters map
  Map<String, Object> _filterNullParameters(Map<String, Object?>? parameters) {
    if (parameters == null) return {};

    return Map<String, Object>.fromEntries(
      parameters.entries
          .where((entry) => entry.value != null)
          .map((entry) => MapEntry(entry.key, entry.value!)),
    );
  }

  /// Convert nullable values to safe objects
  // Object _toSafeObject(dynamic value) {
  //   if (value == null) return 'null';
  //   if (value is int || value is double || value is String || value is bool) {
  //     return value;
  //   }
  //   return value.toString();
  // }

  /// Screen tracking with new API
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) async {
    await logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': screenName,
        'firebase_screen_class': screenClass,
      },
    );
  }

  /// User property setting with validation
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      // Ensure value is not null and not empty
      final safeValue = value.isNotEmpty ? value : 'unknown';
      await _analytics.setUserProperty(
        name: name,
        value: safeValue,
      );
    } catch (e) {
    }
  }

  /// User identification
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
    }
  }

  /// PG App Specific Events with safe parameter handling
  Future<void> logUserRegistration({String method = 'phone'}) async {
    await logEvent(
      name: 'user_registration',
      parameters: {'registration_method': method},
    );
  }

  Future<void> logPropertySearch({
    required String query,
    int? resultsCount,
  }) async {
    final parameters = <String, Object>{
      'search_query': query,
    };

    // Only add resultsCount if it's not null
    if (resultsCount != null) {
      parameters['results_count'] = resultsCount;
    }

    await logEvent(
      name: 'property_search',
      parameters: parameters,
    );
  }

  Future<void> logBookingInitiated(
      String propertyId, String bookingType) async {
    await logEvent(
      name: 'booking_initiated',
      parameters: {
        'property_id': propertyId,
        'booking_type': bookingType,
      },
    );
  }

  Future<void> logPaymentCompleted(double amount, String paymentMethod) async {
    await logEvent(
      name: 'payment_completed',
      parameters: {
        'amount': amount,
        'payment_method': paymentMethod,
      },
    );
  }

  Future<void> logPropertyView({
    required String propertyId,
    required String propertyType,
    double? price,
    String? location,
  }) async {
    final parameters = <String, Object>{
      'property_id': propertyId,
      'property_type': propertyType,
    };

    if (price != null) {
      parameters['price'] = price;
    }

    if (location != null && location.isNotEmpty) {
      parameters['location'] = location;
    }

    await logEvent(
      name: 'property_view',
      parameters: parameters,
    );
  }

  Future<void> logBookingCompleted({
    required String propertyId,
    required double amount,
    required int durationDays,
    String? paymentMethod,
  }) async {
    final parameters = <String, Object>{
      'property_id': propertyId,
      'amount': amount,
      'duration_days': durationDays,
    };

    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      parameters['payment_method'] = paymentMethod;
    }

    await logEvent(
      name: 'booking_completed',
      parameters: parameters,
    );
  }

  Future<void> logUserProfileUpdate({
    required String updateType,
    bool? hasPhoto,
  }) async {
    final parameters = <String, Object>{
      'update_type': updateType,
    };

    if (hasPhoto != null) {
      parameters['has_photo'] = hasPhoto;
    }

    await logEvent(
      name: 'user_profile_update',
      parameters: parameters,
    );
  }

  Future<void> logAppOpened() async {
    await logEvent(name: 'app_opened');
  }

  Future<void> logAppBackgrounded() async {
    await logEvent(name: 'app_backgrounded');
  }

  /// Track errors and exceptions
  Future<void> logError({
    required String errorType,
    required String message,
    String? screenName,
  }) async {
    final parameters = <String, Object>{
      'error_type': errorType,
      'message': message,
    };

    if (screenName != null && screenName.isNotEmpty) {
      parameters['screen_name'] = screenName;
    }

    await logEvent(
      name: 'app_error',
      parameters: parameters,
    );
  }

  /// Reset analytics data (for testing/logout)
  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }

  /// Set analytics collection enabled
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
