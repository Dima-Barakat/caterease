import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirebaseNotificationService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();

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
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();

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

  // Background handler (must be a top-level function or static)
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    debugPrint("Handling a background message: ${message.messageId}");
  }
}
