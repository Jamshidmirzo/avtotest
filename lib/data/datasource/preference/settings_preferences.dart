import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferences {
  final SharedPreferences _preferences;

  SettingsPreferences._(this._preferences);

  final String _keyIsHintEnabled = "boolean_is_answer_hint_enabled";

  static SettingsPreferences? _instance;

  static Future<SettingsPreferences> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = SettingsPreferences._(prefs);
    }
    return _instance!;
  }

  bool get isAnswerHintShowingEnabled {
    return _preferences.getBool(_keyIsHintEnabled) ?? false;
  }
}
