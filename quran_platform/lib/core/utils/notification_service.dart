import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging;

  NotificationService(this._messaging);

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('FCM: Разрешение получено');
    }

    // Get token
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('FCM foreground: ${message.notification?.title}');
    // Show local notification
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('FCM opened: ${message.data}');
    // Navigate to appropriate screen
  }

  /// Subscribe to topic for role-based notifications
  Future<void> subscribeToRole(String role) async {
    await _messaging.subscribeToTopic(role);
  }

  /// Subscribe to booking notifications
  Future<void> subscribeToBooking(String bookingId) async {
    await _messaging.subscribeToTopic('booking_$bookingId');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribe(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
