import 'package:caterease/core/storage/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final storage = SecureStorage();

    await Firebase.initializeApp();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await _localNotifications.initialize(initSettings);

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("✅ Notifications authorized");
      }
      //: Get FCM token
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $token\n");

      if (token != null) Clipboard.setData(ClipboardData(text: token));

      //: Background handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      //: Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        _showNotification(message);
        debugPrint("Foreground message: ${message.notification?.title}");
      });

      //: When notification is tapped and app is opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("Notification opened: ${message.notification?.title}");
      });
    } else {
      if (kDebugMode) {
        print("❌ Notifications not allowed by user");
      }
    }
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel name
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }

  // Background handler (must be a top-level function or static)
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    debugPrint("Handling a background message: ${message.messageId}");
  }
}
