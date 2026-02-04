import 'package:avtotest/data/datasource/di/service_locator.dart';
import 'package:avtotest/domain/model/language/language.dart';
import 'package:avtotest/firebase_options.dart';
import 'package:avtotest/presentation/application/application.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:avtotest/core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables early
  await dotenv.load(fileName: ".env");

  // Initialize Firebase (only once)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('🔥 Firebase initialized');

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped");
    }
  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await EasyLocalization.ensureInitialized();

  await setupLocator();

  // Initialize Notifications
  await MyFirebaseMessagingService.init();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: Language.values.map((e) => e.locale).toList(),
      fallbackLocale: Language.defaultLanguage.locale,
      child: const Application(),
    ),
  );
}
