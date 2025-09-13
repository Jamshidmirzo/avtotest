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

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: Language.values.map((e) => e.locale).toList(),
      fallbackLocale: Language.defaultLanguage.locale,
      // startLocale: const Locale('uz-UZ'),
      child: const Application(),
    ),
  );
}
