import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level function for handling background messages.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
}

class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Android notification channel for high-importance notifications.
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Initialize the push notification service.
  Future<void> initialize() async {
    // Request permission
    await _requestPermission();

    // Create the Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Set foreground notification presentation options (iOS)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen for notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from a terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ FCM TOKEN REFRESHED');
      debugPrint('║ Token: $newToken');
      debugPrint('╚══════════════════════════════════════════════════════════');
      // TODO: Send the new token to your backend API
    });
  }

  /// Request notification permissions.
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('Notification permission status: ${settings.authorizationStatus}');
  }

  /// Get the FCM token for this device.
  /// Call this after successful authentication.
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ FCM TOKEN (after authentication)');
      debugPrint('║ Token: $token');
      debugPrint('╚══════════════════════════════════════════════════════════');
      // TODO: Send token to your backend API when endpoint is ready
      return token;
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  /// Handle foreground messages by showing a local notification.
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.messageId}');
    final notification = message.notification;

    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Handle when a user taps on a notification that opened the app from background.
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('Notification opened app: ${message.data}');
    // TODO: Navigate to a specific screen based on message.data
  }

  /// Handle local notification tap.
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped with payload: ${response.payload}');
    // TODO: Navigate to a specific screen based on payload
  }
}
