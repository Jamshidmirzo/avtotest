import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DevicePreferences {
  final SharedPreferences _preferences;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  DevicePreferences._(this._preferences);

  static const _keyDeviceSessionId = "integer_device_session_id";
  static const _keyDeviceInstallationId = "integer_device_installation_id";

  static DevicePreferences? _instance;

  /// 🔹 Get singleton instance
  static Future<DevicePreferences> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = DevicePreferences._(prefs);
    }
    return _instance!;
  }

  /// 🔹 Session ID — new per app launch
  String get deviceSessionId {
    var id = _preferences.getString(_keyDeviceSessionId);
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      _preferences.setString(_keyDeviceSessionId, id);
    }
    return id;
  }

  /// 🔹 Installation ID — stable even after reinstall (iOS Keychain)
  Future<String> get deviceInstallationId async {
    // 1️⃣ Check Keychain / Secure Storage
    String? id = await _secureStorage.read(key: _keyDeviceInstallationId);

    if (id != null && id.isNotEmpty) {
      return id;
    }

    // 2️⃣ Generate new one
    id = await _generateStableId();

    // 3️⃣ Save in Secure Storage (Keychain on iOS)
    await _secureStorage.write(key: _keyDeviceInstallationId, value: id);

    // Also cache in SharedPreferences (optional)
    _preferences.setString(_keyDeviceInstallationId, id);

    return id;
  }

  /// 🔧 Platform-specific stable ID
  Future<String> _generateStableId() async {
    try {
      if (Platform.isIOS) {
        final ios = await _deviceInfo.iosInfo;
        return ios.identifierForVendor ?? const Uuid().v4();
      } else {
        return const Uuid().v4();
      }
    } catch (_) {
      return const Uuid().v4();
    }
  }

  /// 🧩 Reset IDs (for testing)
  Future<void> resetIds() async {
    await _preferences.remove(_keyDeviceSessionId);
    await _preferences.remove(_keyDeviceInstallationId);
    await _secureStorage.delete(key: _keyDeviceInstallationId);
  }
}
