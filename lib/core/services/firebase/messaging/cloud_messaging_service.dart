import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase Cloud Messaging service for push notifications.
///
/// Responsibility:
/// - Handle push notification registration
/// - Manage notification permissions
/// - Process incoming messages
/// - Track notification tokens
class CloudMessagingServiceWrapper {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  CloudMessagingServiceWrapper._privateConstructor();
  static final CloudMessagingServiceWrapper _instance =
      CloudMessagingServiceWrapper._privateConstructor();
  factory CloudMessagingServiceWrapper() => _instance;

  /// Initialize messaging and request permissions
  Future<void> initialize() async {
    // Request notification permissions
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
    }

    // Get FCM token for this device
    final token = await getToken();
    print('FCM Token: $token');
  }

  /// Get the current FCM token
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Subscribe to topics for broadcast notifications
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topics
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Setup foreground message handling
  void setupForegroundHandler(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  /// Setup background message handling
  void setupBackgroundHandler(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }
}
