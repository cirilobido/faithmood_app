import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../dev_utils/dev_utils_exports.dart';
import '_local_notifications_service.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({
    required LocalNotificationsService localNotificationsService,
  }) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // Handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.instance.subscribeToTopic('all');

    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM token for the device
    final token = await getToken();
    devLogger('Push notifications token: $token');

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          devLogger('FCM token refreshed: $fcmToken');
          // TODO: optionally send token to your server for targeting this device
        })
        .onError((error) {
          // Handle errors during token refresh
          devLogger('Error refreshing FCM token: $error');
        });
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    _analytics.logEvent(
      name: 'notification_permission',
      parameters: {'permission': result.authorizationStatus.toString()},
    );
    devLogger('User granted permission: ${result.authorizationStatus}');
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    devLogger('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      // Display a local notification using the service
      _analytics.logEvent(
        name: 'notification_received_foreground',
        parameters: {'title': notificationData.title ?? ''},
      );
      _localNotificationsService?.showNotification(
        title: notificationData.title,
        body: notificationData.body,
        payload: message.data.toString(),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    _analytics.logEvent(
      name: 'notification_opened_app',
      parameters: {'title': message.notification?.title ?? ''},
    );
    devLogger(
      'Notification caused the app to open: ${message.data.toString()}',
    );
    // TODO: Add navigation or specific handling based on message data
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  devLogger('Background message received: ${message.data.toString()}');
}
