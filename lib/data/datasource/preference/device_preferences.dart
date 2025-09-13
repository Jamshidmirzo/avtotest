import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DevicePreferences {
  final SharedPreferences _preferences;

  DevicePreferences._(this._preferences);

  final String _keyDeviceSessionId = "integer_device_session_id";
  final String _keyDeviceInstallationId = "integer_device_installation_id";

  static DevicePreferences? _instance;

  static Future<DevicePreferences> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = DevicePreferences._(prefs);
    }
    return _instance!;
  }

  String get deviceSessionId {
    var id = _preferences.getString(_keyDeviceSessionId);
    if (id == null || id.isEmpty) {
      id = Uuid().v4();
      _preferences.setString(_keyDeviceSessionId, id);
    }
    return id;
  }

  String get deviceInstallationId {
    var id = _preferences.getString(_keyDeviceInstallationId);
    if (id == null || id.isEmpty) {
      id = Uuid().v4();
      _preferences.setString(_keyDeviceInstallationId, id);
    }
    return id;
  }
}
