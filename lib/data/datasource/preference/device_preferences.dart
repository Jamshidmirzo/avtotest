import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class DevicePreferences {
  static final DevicePreferences _instance = DevicePreferences._internal();
  factory DevicePreferences() => _instance;
  DevicePreferences._internal();

  static DevicePreferences getInstance() => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static const _keyDeviceInstallationId = "integer_device_installation_id";

  /// Сессионный ID — генерируется на каждый запуск
  Future<String> get deviceSessionId async {
    return const Uuid().v4();
  }

  /// Установочный ID — не меняется после удаления приложения
  /// (используем системный идентификатор устройства)
  Future<String> get deviceInstallationId async {
    var id = await _storage.read(key: _keyDeviceInstallationId);

    if (id == null || id.isEmpty) {
      id = await _getHardwareId();
      await _storage.write(key: _keyDeviceInstallationId, value: id);
    }

    return id;
  }

  /// Очистка данных (для отладки)
  Future<void> clear() async {
    await _storage.delete(key: _keyDeviceInstallationId);
  }

  /// Возвращает стабильный hardware ID
  Future<String> _getHardwareId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? "UnknownIOS";
    } else {
      return "UnknownDevice";
    }
  }
}
