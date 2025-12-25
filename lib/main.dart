import 'dart:ui';

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
  // 🔹 Обязательная инициализация Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Загрузка env
  await dotenv.load(fileName: ".env");

  // 🔹 Инициализация Firebase (СТРОГО до runApp)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('🔥 Firebase initialized');

  // 🔹 Ориентация экрана
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 🔹 Easy localization
  await EasyLocalization.ensureInitialized();

  // 🔹 DI (ТОЛЬКО регистрация, без логики)
  await setupLocator();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: Language.values.map((e) => e.locale).toList(),
      fallbackLocale: Language.defaultLanguage.locale,
      child: const Application(),
    ),
  );
}
