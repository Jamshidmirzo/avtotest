import 'package:avtotest/core/services/notification_service.dart';

import 'package:avtotest/data/datasource/di/service_locator.dart';
import 'package:avtotest/domain/model/language/language.dart';
import 'package:avtotest/firebase_options.dart';
import 'package:avtotest/presentation/application/application.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('🔥 Firebase initialized');


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 🔹 Easy localization
  await EasyLocalization.ensureInitialized();

  // 🔹 DI (ТОЛЬКО регистрация, без логики)
  await setupLocator();

  // 🔹 Инициализация уведомлений
  await serviceLocator<NotificationService>().init();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: Language.values.map((e) => e.locale).toList(),
      fallbackLocale: Language.defaultLanguage.locale,
      child: const Application(),
    ),
  );
}
