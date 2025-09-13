import 'package:avtotest/data/datasource/preference/preferences_extensions.dart';
import 'package:avtotest/domain/model/language/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  final SharedPreferences _preferences;

  LanguagePreferences._(this._preferences);
  static LanguagePreferences? _instance;

  static Future<LanguagePreferences> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = LanguagePreferences._(prefs);
    }
    return _instance!;
  }

  static const String _keyLanguage = "string_language";

  bool get isLanguageSelected => _preferences.containsKey(_keyLanguage);

  String get languageName =>
      _preferences.getString(_keyLanguage) ?? Language.defaultLanguage.name;

  Language get language => Language.valueOrDefault(languageName);

  Future<void> setLanguage(Language language) async =>
      await _preferences.setOrRemove(_keyLanguage, language.name);

  Future<void> clear() async => await _preferences.remove(_keyLanguage);
}
