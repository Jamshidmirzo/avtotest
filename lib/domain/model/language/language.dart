import 'dart:ui';

enum Language {
  uzbekLatin,
  uzbekCyrill,
  russianRu;

  String get restCode {
    return switch (this) {
      Language.uzbekLatin => "uz",
      Language.uzbekCyrill => "en",
      Language.russianRu => "ru",
    };
  }

  String get languageName {
    return switch (this) {
      Language.uzbekLatin => "O'zbekcha",
      Language.uzbekCyrill => "Ўзбекча",
      Language.russianRu => "Русский",
    };
  }

  String get identifier {
    return switch (this) {
      Language.uzbekLatin => "uz_UZ",
      Language.uzbekCyrill => "en_EN",
      Language.russianRu => "ru_RU",
    };
  }

  Locale get locale {
    return switch (this) {
      Language.uzbekLatin => Locale('uz', 'UZ'),
      Language.uzbekCyrill => Locale('en', 'US'),
      Language.russianRu => Locale('ru', 'RU'),
    };
  }

  static Language valueOrDefault(String? languageName) {
    return Language.values.firstWhere(
      (e) => e.name.toUpperCase() == languageName?.toUpperCase(),
      orElse: () => defaultLanguage,
    );
  }

  static Language valueFromLocale(Locale locale) {
    final code = locale.languageCode.toLowerCase();
    return Language.values.firstWhere(
          (e) => e.locale.languageCode.toLowerCase() == code,
      orElse: () => defaultLanguage,
    );
  }

  static Language get defaultLanguage => Language.uzbekLatin;
}
