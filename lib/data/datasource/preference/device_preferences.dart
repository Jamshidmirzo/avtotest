import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class DevicePreferences {
  static final DevicePreferences _instance = DevicePreferences._internal();
  factory DevicePreferences() => _instance;
  DevicePreferences._internal();

  static DevicePreferences getInstance() => _instance;

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Сессионный ID (каждый запуск новый)
  Future<String> get deviceSessionId async => const Uuid().v4();

  /// Установочный ID (стабилен даже после переустановки на Android)
  Future<String> get deviceInstallationId async => _getHardwareId();

  Future<String> _getHardwareId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;

        // ✅ Используем hardware id, стабильный для устройства
        final androidId = androidInfo.id; // раньше было androidId
        return androidId ?? const Uuid().v4();
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // iOS UID может сбрасываться при переустановке, но другого способа нет
        return iosInfo.identifierForVendor ?? const Uuid().v4();
      } else {
        return const Uuid().v4();
      }
    } catch (_) {
      return const Uuid().v4();
    }
  }
}
