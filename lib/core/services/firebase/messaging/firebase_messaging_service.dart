// lib/core/services/firebase/messaging/firebase_messaging_service.dart

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../di/firebase/di/firebase_service_locator.dart';

/// Firebase Cloud Messaging service for push notifications
/// Handles notification registration, token management, and message processing
class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  static FirebaseMessagingService get instance => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _analyticsService = getIt.analytics;

  String? _fcmToken;
  bool _isInitialized = false;

  /// FCM token for this device
  String? get fcmToken => _fcmToken;

  /// Whether the service is initialized
  bool get isInitialized => _isInitialized;

  /// Initializes FCM service and sets up message handlers
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission for notifications
      await _requestPermission();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      // Set up token refresh listener
      _setupTokenRefreshListener();

      _isInitialized = true;

      await _analyticsService.logEvent(
        name: 'fcm_initialized',
        parameters: {
          'has_token': _fcmToken != null,
          'token_length': _fcmToken?.length ?? 0,
        },
      );

      debugPrint('🔥 FCM Service initialized successfully');
    } catch (e) {
      debugPrint('❌ FCM Service initialization failed: $e');
      await _analyticsService.logEvent(
        name: 'fcm_initialization_error',
        parameters: {'error': e.toString()},
      );
    }
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      await _analyticsService.logEvent(
        name: 'fcm_permission_requested',
        parameters: {
          'status': settings.authorizationStatus.name,
          'alert': settings.alert == AppleNotificationSetting.enabled,
          'badge': settings.badge == AppleNotificationSetting.enabled,
          'sound': settings.sound == AppleNotificationSetting.enabled,
        },
      );

      debugPrint('🔔 FCM Permission status: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('❌ FCM Permission request failed: $e');
      await _analyticsService.logEvent(
        name: 'fcm_permission_error',
        parameters: {'error': e.toString()},
      );
    }
  }

  /// Gets the FCM token for this device
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();

      if (_fcmToken != null) {
        await _analyticsService.logEvent(
          name: 'fcm_token_obtained',
          parameters: {'token_length': _fcmToken!.length},
        );
        debugPrint('🔑 FCM Token obtained: ${_fcmToken!.substring(0, 20)}...');
      } else {
        debugPrint('⚠️ FCM Token is null');
      }
    } catch (e) {
      debugPrint('❌ FCM Token retrieval failed: $e');
      await _analyticsService.logEvent(
        name: 'fcm_token_error',
        parameters: {'error': e.toString()},
      );
    }
  }

  /// Sets up message handlers for different notification types
  void _setupMessageHandlers() {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notification taps when app is terminated
    _handleInitialMessage();
  }

  /// Sets up token refresh listener
  void _setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) async {
      _fcmToken = newToken;

      await _analyticsService.logEvent(
        name: 'fcm_token_refreshed',
        parameters: {'token_length': newToken.length},
      );

      debugPrint('🔄 FCM Token refreshed: ${newToken.substring(0, 20)}...');

      // TODO: Send new token to server
      await _updateTokenOnServer(newToken);
    });
  }

  /// Handles foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('📱 Foreground message received: ${message.messageId}');

    await _analyticsService.logEvent(
      name: 'fcm_foreground_message',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'title': message.notification?.title ?? 'no_title',
        'body': message.notification?.body ?? 'no_body',
        'data': jsonEncode(message.data),
      },
    );

    // Show in-app notification or update UI
    _showInAppNotification(message);
  }

  /// Handles notification taps
  Future<void> _handleNotificationTap(RemoteMessage message) async {
    debugPrint('👆 Notification tapped: ${message.messageId}');

    await _analyticsService.logEvent(
      name: 'fcm_notification_tapped',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'title': message.notification?.title ?? 'no_title',
        'data': jsonEncode(message.data),
      },
    );

    // Navigate to relevant screen based on notification data
    _handleNotificationNavigation(message);
  }

  /// Handles initial message when app is opened from notification
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
          '🚀 App opened from notification: ${initialMessage.messageId}');

      await _analyticsService.logEvent(
        name: 'fcm_initial_message',
        parameters: {
          'message_id': initialMessage.messageId ?? 'unknown',
          'title': initialMessage.notification?.title ?? 'no_title',
          'data': jsonEncode(initialMessage.data),
        },
      );

      _handleNotificationNavigation(initialMessage);
    }
  }

  /// Shows in-app notification for foreground messages
  void _showInAppNotification(RemoteMessage message) {
    // TODO: Implement in-app notification display
    // This could be a snackbar, banner, or custom notification widget
    debugPrint('🔔 Show in-app notification: ${message.notification?.title}');
  }

  /// Handles navigation based on notification data
  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;

    // Navigate based on notification type
    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'booking_request':
          // Navigate to booking requests
          debugPrint('📋 Navigate to booking requests');
          break;
        case 'payment':
          // Navigate to payments
          debugPrint('💳 Navigate to payments');
          break;
        case 'complaint':
          // Navigate to complaints
          debugPrint('📝 Navigate to complaints');
          break;
        case 'food_menu':
          // Navigate to food menu
          debugPrint('🍽️ Navigate to food menu');
          break;
        default:
          debugPrint('❓ Unknown notification type: ${data['type']}');
      }
    }
  }

  /// Updates FCM token on server
  Future<void> _updateTokenOnServer(String token) async {
    try {
      // TODO: Implement server API call to update FCM token
      debugPrint('🔄 Updating FCM token on server...');

      await _analyticsService.logEvent(
        name: 'fcm_token_server_update',
        parameters: {'token_length': token.length},
      );
    } catch (e) {
      debugPrint('❌ Failed to update FCM token on server: $e');
      await _analyticsService.logEvent(
        name: 'fcm_token_server_update_error',
        parameters: {'error': e.toString()},
      );
    }
  }

  /// Subscribes to a topic for targeted notifications
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);

      await _analyticsService.logEvent(
        name: 'fcm_topic_subscribed',
        parameters: {'topic': topic},
      );

      debugPrint('📢 Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Failed to subscribe to topic $topic: $e');
      await _analyticsService.logEvent(
        name: 'fcm_topic_subscribe_error',
        parameters: {'topic': topic, 'error': e.toString()},
      );
    }
  }

  /// Unsubscribes from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);

      await _analyticsService.logEvent(
        name: 'fcm_topic_unsubscribed',
        parameters: {'topic': topic},
      );

      debugPrint('📢 Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Failed to unsubscribe from topic $topic: $e');
      await _analyticsService.logEvent(
        name: 'fcm_topic_unsubscribe_error',
        parameters: {'topic': topic, 'error': e.toString()},
      );
    }
  }

  /// Clears all notifications
  Future<void> clearAllNotifications() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;

      await _analyticsService.logEvent(
        name: 'fcm_token_deleted',
        parameters: {},
      );

      debugPrint('🗑️ FCM token cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear FCM token: $e');
      await _analyticsService.logEvent(
        name: 'fcm_token_clear_error',
        parameters: {'error': e.toString()},
      );
    }
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🌙 Background message received: ${message.messageId}');

  // Handle background message processing
  // This could include updating local database, scheduling tasks, etc.
}
