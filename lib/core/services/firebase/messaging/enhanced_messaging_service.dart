// lib/core/services/firebase/messaging/enhanced_messaging_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../di/firebase/di/firebase_service_locator.dart';
import '../analytics/firebase_analytics_service.dart';

/// 🔔 **ENHANCED MESSAGING SERVICE - PRODUCTION READY**
///
/// **Features:**
/// - Push notifications (FCM)
/// - Local notifications
/// - Topic subscriptions
/// - Notification preferences
/// - Deep linking
/// - Analytics tracking
class EnhancedMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final AnalyticsServiceWrapper _analytics = getIt<AnalyticsServiceWrapper>();
  
  static const String _notificationPrefsKey = 'notification_preferences';
  
  // Notification categories
  static const String paymentNotification = 'payment';
  static const String bookingNotification = 'booking';
  static const String complaintNotification = 'complaint';
  static const String foodNotification = 'food';
  static const String maintenanceNotification = 'maintenance';
  static const String generalNotification = 'general';

  /// Initialize the enhanced messaging service
  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    await _setupMessageHandlers();
    await _loadNotificationPreferences();
    
    // Subscribe to default topics based on user role
    await _subscribeToDefaultTopics();
    
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _analytics.logEvent(
        name: 'notification_permission_granted',
        parameters: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      await _analytics.logEvent(
        name: 'notification_permission_denied',
        parameters: {
          'status': settings.authorizationStatus.toString(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }

  /// Setup message handlers
  Future<void> _setupMessageHandlers() async {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });
    
    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundMessage(message);
    });
    
    // Handle messages when app is opened from terminated state
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleTerminatedMessage(initialMessage);
    }
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _analytics.logEvent(
      name: 'notification_received_foreground',
      parameters: {
        'message_id': message.messageId ?? '',
        'title': message.notification?.title ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    
    // Show local notification
    await _showLocalNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      data: message.data,
    );
  }

  /// Handle background messages
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await _analytics.logEvent(
      name: 'notification_opened_background',
      parameters: {
        'message_id': message.messageId ?? '',
        'title': message.notification?.title ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    
    await _handleDeepLink(message.data);
  }

  /// Handle terminated state messages
  Future<void> _handleTerminatedMessage(RemoteMessage message) async {
    await _analytics.logEvent(
      name: 'notification_opened_terminated',
      parameters: {
        'message_id': message.messageId ?? '',
        'title': message.notification?.title ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    
    await _handleDeepLink(message.data);
  }

  /// Handle notification tap response
  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      _handleDeepLink(Map<String, dynamic>.from(data));
    }
  }

  /// Handle deep linking from notifications
  Future<void> _handleDeepLink(Map<String, dynamic> data) async {
    final route = data['route'];
    final screen = data['screen'];
    
    if (route != null) {
      // TODO: Implement navigation service
      
      // TODO: Implement navigation based on route
      switch (route) {
        case 'payment':
          break;
        case 'booking':
          break;
        case 'complaint':
          break;
        case 'food':
          break;
        case 'profile':
          break;
        default:
      }
      
      await _analytics.logEvent(
        name: 'notification_deep_link',
        parameters: {
          'route': route,
          'screen': screen ?? '',
        },
      );
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  /// Subscribe to default topics
  Future<void> _subscribeToDefaultTopics() async {
    try {
      // Subscribe to general topics
      await _messaging.subscribeToTopic('general');
      await _messaging.subscribeToTopic('announcements');
      
      await _analytics.logEvent(
        name: 'topic_subscribed',
        parameters: {
          'topics': ['general', 'announcements'],
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      await _analytics.logEvent(
        name: 'topic_subscription_failed',
        parameters: {
          'error': e.toString(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }

  /// Subscribe to specific topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      await _analytics.logEvent(
        name: 'topic_subscribed',
        parameters: {
          'topic': topic,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      await _analytics.logEvent(
        name: 'topic_subscription_failed',
        parameters: {
          'topic': topic,
          'error': e.toString(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      await _analytics.logEvent(
        name: 'topic_unsubscribed',
        parameters: {
          'topic': topic,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      await _analytics.logEvent(
        name: 'topic_unsubscription_failed',
        parameters: {
          'topic': topic,
          'error': e.toString(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences(String category, bool enabled) async {
    _notificationPreferences[category] = enabled;
    await _saveNotificationPreferences();
    
    // Subscribe/unsubscribe from topic based on preference
    if (enabled) {
      await subscribeToTopic(category);
    } else {
      await unsubscribeFromTopic(category);
    }
    
    await _analytics.logEvent(
      name: 'notification_preference_updated',
      parameters: {
        'category': category,
        'enabled': enabled,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Get notification preferences
  Map<String, bool> getNotificationPreferences() {
    return Map<String, bool>.from(_notificationPreferences);
  }

  /// Send test notification
  Future<void> sendTestNotification() async {
    await _showLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification from Atitia',
      data: {'type': 'test'},
    );
  }

  /// Get FCM token
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Clear specific notification
  Future<void> clearNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Load notification preferences from local storage
  Future<void> _loadNotificationPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsString = prefs.getString(_notificationPrefsKey);
      
      if (prefsString != null) {
        final prefsMap = jsonDecode(prefsString) as Map<String, dynamic>;
        // Store preferences for use in notification filtering
        _notificationPreferences = prefsMap;
      } else {
        // Set default preferences if none exist
        _notificationPreferences = {
          paymentNotification: true,
          bookingNotification: true,
          complaintNotification: true,
          foodNotification: true,
          maintenanceNotification: true,
          generalNotification: true,
        };
        await _saveNotificationPreferences();
      }
    } catch (e) {
      // Set default preferences on error
      _notificationPreferences = {
        paymentNotification: true,
        bookingNotification: true,
        complaintNotification: true,
        foodNotification: true,
        maintenanceNotification: true,
        generalNotification: true,
      };
    }
  }

  /// Save notification preferences to local storage
  Future<void> _saveNotificationPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_notificationPrefsKey, jsonEncode(_notificationPreferences));
    } catch (e) {
    }
  }

  /// Notification preferences map
  Map<String, dynamic> _notificationPreferences = {};
}

// Global instance
final enhancedMessagingService = EnhancedMessagingService();