import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // handle background logic here if needed
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupFlutterNotifications();
    await _setupMessageHandlers();
  }

  Future<void> _requestPermission() async {
    await Permission.notification.request();
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  static Future<void> registerFCMToken(String token) async {
    final String apiKey = dotenv.env['AUTH_API_KEY'] ?? '';
    final String appwriteEndpoint =
        dotenv.env['APPWRITE_CLOUD_FUNCTION_ENDPOINT'] ?? '';

    try {
      final response = await http.put(
        Uri.parse(appwriteEndpoint),
        headers: {"Content-Type": "application/json", "x-api-key": apiKey},
        body: jsonEncode({"token": token}),
      );

      if (response.statusCode != 201) {
      }
    } catch (e) {
    }
  }

  Future<void> _setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const AndroidNotificationChannel androidChannel =
        AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          description: 'Used for important notifications.',
          importance: Importance.high,
        );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    await _setupFlutterNotifications();

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          playSound: true,
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _localNotifications.show(
      message.data.hashCode,
      message.data['title'] ?? 'New Notification',
      message.data['body'] ?? 'You have a new message.',
      platformDetails,
      payload: message.data.toString(),
    );
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen(showNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
   
    // TODO: Add navigation or handling logic based on message.data
  }
}
