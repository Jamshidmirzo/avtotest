import 'dart:ui';

import 'package:avtotest/domain/model/language/language.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toDateString({String inputFormat = 'yyyy-MM-dd', Locale? locale}) {
    String localeCode = locale?.languageCode ?? Language.defaultLanguage.locale.languageCode;
    return DateFormat(inputFormat, localeCode).format(this);
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isNotToday() {
    return !isToday();
  }

  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  DateTime startOfDay() => DateTime(year, month, day);

  DateTime endOfDay() => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime startOfBeforeDay() {
    final yesterday = subtract(const Duration(days: 1));
    return DateTime(yesterday.year, yesterday.month, yesterday.day);
  }

  DateTime endOfBeforeDay() {
    final yesterday = subtract(const Duration(days: 1));
    return DateTime(
        yesterday.year, yesterday.month, yesterday.day, 23, 59, 59, 999);
  }

  DateTime startOfNextDay() {
    final tomorrow = add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
  }

  DateTime endOfNextDay() {
    final tomorrow = add(const Duration(days: 1));
    return DateTime(
        tomorrow.year, tomorrow.month, tomorrow.day, 23, 59, 59, 999);
  }
}

extension IntDateExtensions on int {
  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  String toDateString({String outputFormat = 'yyyy-MM-dd'}) {
    return DateTime.fromMillisecondsSinceEpoch(this)
        .toDateString(inputFormat: outputFormat);
  }
}

bool isValidDate({required String dateString, required String format}) {
  try {
    final dateFormat = DateFormat(format);
    dateFormat.parseStrict(dateString);
    return true;
  } catch (_) {
    return false;
  }
}

extension StringDateExtensions on String {
  DateTime toDate({required String inputFormat}) {
    return DateFormat(inputFormat).parse(this);
  }

  String toLocalDate({String outputFormat = "yyyy-MM-dd HH:mm:ss"}) {
    return DateTime.tryParse(this)
            ?.toLocal()
            .toDateString(inputFormat: outputFormat) ??
        this;
  }

  bool isValidDate({required String inputFormat}) {
    try {
      final dateFormat = DateFormat(inputFormat);
      dateFormat.parseStrict(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  String convertDateFormat({required String outputFormat}) {
    try {
      final date = DateTime.tryParse(this);
      if (date == null) {
        return this;
      }
      return DateFormat(outputFormat).format(date);
    } catch (e) {
      debugPrint("convertDateFormat() error: $e");
      return this;
    }
  }
}
