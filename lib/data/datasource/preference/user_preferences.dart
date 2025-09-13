import 'package:avtotest/data/datasource/preference/preferences_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final SharedPreferences _preferences;

  UserPreferences._(this._preferences);

  final String keyUserId = "integer_user_id";

  static UserPreferences? _instance;

  static Future<UserPreferences> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = UserPreferences._(prefs);
    }
    return _instance!;
  }

  int get userId => _preferences.getInt(keyUserId) ?? 0101010101;

  Future<void> setUserId(int? userId) async {
    await _preferences.setOrRemove(keyUserId, userId);
  }
}
