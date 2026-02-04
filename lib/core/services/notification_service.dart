// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:ui';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class MyFirebaseMessagingService {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//   static final _localNotifications = FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//     playSound: true,
//     enableVibration: true,
//   );

//   static Future<void> init() async {
//     log("🔥 Initializing Firebase Messaging Service...");

//     // Request notification permissions
//     NotificationSettings settings =
//         await _firebaseMessaging.requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.denied) {
//       log("🚫 Notifications permission denied!");
//       return;
//     }

//     // Initialize local notifications
//     await _initLocalNotifications();

//     // Create the notification channel on Android
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);

//     // Get FCM token
//     final fcmToken = await _firebaseMessaging.getToken();
//     log("✅ FCM Token: $fcmToken");

//     // Foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log("📩 Foreground notification received: ${message.notification?.title}");
//       _showLocalNotification(message);
//     });

//     // Handle background & terminated messages
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log("🔵 Notification clicked: ${message.notification?.title}");
//     });

//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         log("⚡ App opened from terminated state: ${message.notification?.title}");
//       }
//     });
//   }

//   static Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosInitSettings =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidInitSettings,
//       iOS: iosInitSettings,
//     );

//     await _localNotifications.initialize(settings: initSettings);
//   }

//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     if (message.notification == null) return;

//     final AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       _channel.id, // <- используем созданный канал
//       _channel.name,
//       channelDescription: _channel.description,
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       fullScreenIntent: true, // <- для heads-up сверху
//       largeIcon: const DrawableResourceAndroidBitmap(
//           '@mipmap/ic_launcher'), // Show full color logo
//       color: const Color(0xFFFFFFFF), // Try to force white accent/background
//     );

//     final NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _localNotifications.show(
//       id: 0,
//       title: message.notification!.title,
//       body: message.notification!.body,
//       notificationDetails: notificationDetails,
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyFirebaseMessagingService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  // Канал уведомлений с высоким приоритетом для heads-up отображения
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  static Future<void> init() async {
    log("🔥 Initializing Firebase Messaging Service...");

    // Запрос разрешений на уведомления
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      log("🚫 Notifications permission denied!");
      return;
    }

    // Инициализация локальных уведомлений
    await _initLocalNotifications();

    // Создание notification channel на Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    if (Platform.isIOS) {
      // На iOS FCM токен появляется только после APNs токена
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      log("📲 APNs Token: ${apnsToken ?? "not yet available"}");

      // Подписка на получение FCM токена
      _firebaseMessaging.onTokenRefresh.listen((token) {
        log("✅ FCM Token received/refreshed: $token");
      });
    } else {
      // На Android можно получить токен сразу
      final fcmToken = await _firebaseMessaging.getToken();
      log("✅ FCM Token: $fcmToken");
    }

    // Слушатели уведомлений
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("📩 Foreground notification received: "
          "Title='${message.notification?.title}', "
          "Body='${message.notification?.body}'");
      _showLocalNotification(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        log("⚡ App opened from terminated state by notification: ${message.notification?.title}");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("🔵 Notification clicked (from background): ${message.notification?.title}");
    });
  }

  static Future<void> _initLocalNotifications() async {
    const androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    await _localNotifications.initialize(initSettings);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    log("🔔 Showing local notification: "
        "Title='${message.notification!.title}', "
        "Body='${message.notification!.body}'");

    // Настройка Android уведомления с большой иконкой
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      // Большая иконка из drawable - показывается без круга
      largeIcon: const DrawableResourceAndroidBitmap('@drawable/ic_notification_large'),
      // Для heads-up уведомлений сверху
      fullScreenIntent: true,
      playSound: true,
      enableVibration: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
    );
  }
}
