import 'dart:developer';
import 'dart:io';

import 'package:avtotest/data/datasource/preference/device_preferences.dart';
import 'package:dio/dio.dart';

class SubscriptionService {
  final Dio dio;
  final DevicePreferences devicePreferences;

  SubscriptionService({
    required this.dio,
    required this.devicePreferences,
  });

  Future<Response> loginWithReferrerId({
    required int referrerId,
    required String versionCode,
    required String versionName,
  }) {
    final body = {
      "session_id": devicePreferences.deviceSessionId,
      "device_id": devicePreferences.deviceInstallationId,
      "user_id": referrerId,
      "app_version": versionCode,
      "app_version_name": versionName
    };

    // https://backend.avtotest-begzod.uz/api/v1/auth/mobile/login
    return dio.post(
      'https://backend.avtotest-begzod.uz/api/v1/auth/mobile/login',
      data: body,
    );
  }

  Future<Response> login({
    required String versionCode,
    required String versionName,
  }) async {
    final sessionId = await devicePreferences.deviceSessionId;
    final installationId = await devicePreferences.deviceInstallationId;
    // await devicePreferences.clear(); // --- IGNORE ---
    log("Device Session ID: $sessionId");
    log("Device Installation ID: $installationId");

    final body = {
      "session_id": sessionId,
      "device_id": installationId,
      "user_id": null,
      "app_version": versionCode,
      "app_version_name": versionName,
      "type": Platform.isIOS ? "ios" : "android",
    };

    return dio.post(
      'https://backend.avtotest-begzod.uz/api/v1/auth/mobile/login',
      data: body,
    );
  }
}
