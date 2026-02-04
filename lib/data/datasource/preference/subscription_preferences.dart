import 'package:avtotest/core/extensions/date_extensions.dart';
import 'package:avtotest/data/datasource/preference/preferences_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionPreferences {
  final SharedPreferences _preferences;
  static final ValueNotifier<int> syncNotifier = ValueNotifier(0);

  SubscriptionPreferences._(this._preferences);

  final String keyIsSubsActivated = "boolean_is_subscription_activated";
  final String keySubsEndDate = "integer_subscription_end_date";

  final String keyLastAudioPlayedDate = "integer_last_audio_played_date";
  final String keyAudioPlayCountToday = "integer_audio_play_count_today";

  final String keyLastRequestTime = "integer_last_request_time";

  static const int dailyAudioLimit = 5;

  static SubscriptionPreferences? _instance;

  static Future<SubscriptionPreferences> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = SubscriptionPreferences._(prefs);
    }
    return _instance!;
  }

  bool get isSubscriptionActivated =>
      _preferences.getBool(keyIsSubsActivated) ?? false;

  Future<void> setSubsActivated(bool isActivated) async {
    await _preferences.setBool(keyIsSubsActivated, isActivated);
    syncNotifier.value++;
  }

  DateTime? get subscriptionEndDate {
    int? date = _preferences.getInt(keySubsEndDate);
    if (date == null || date <= 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(date);
  }

  Future<void> setSubsEndDate(DateTime? endDate) async {
    debugPrint("setSubsEndDate: endDate: $endDate, today: ${DateTime.now()}");
    int? time = endDate?.millisecondsSinceEpoch;
    await _preferences.setOrRemove(keySubsEndDate, time);
    syncNotifier.value++;
  }

  bool get hasActiveSubscription {
    final isActivated = _preferences.getBool(keyIsSubsActivated) ?? false;
    final endDate = subscriptionEndDate;

    if (isActivated && endDate != null) {
      return DateTime.now().isBefore(endDate);
    }
    return false;
  }

  DateTime? get lastRequestTime {
    int? date = _preferences.getInt(keyLastRequestTime);
    if (date == null || date <= 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(date);
  }

  bool get isRequestSentInLastHour {
    int? date = _preferences.getInt(keyLastRequestTime);
    if (date == null || date <= 0) {
      return false;
    }
    var lastDate = DateTime.fromMillisecondsSinceEpoch(date);
    var nowDate = DateTime.now();
    return nowDate.difference(lastDate).inHours >= 1;
  }

  Future<void> setLastRequestTime(DateTime dateTime) async {
    var time = dateTime.millisecondsSinceEpoch;
    await _preferences.setOrRemove(keyLastRequestTime, time);
  }

  bool get canPlayAudio {
    if (hasActiveSubscription) {
      return true;
    }

    final playedDate = _preferences.getInt(keyLastAudioPlayedDate) ?? 0;
    final playedCount = _preferences.getInt(keyAudioPlayCountToday) ?? 0;

    if (playedDate.toDate().isNotToday()) {
      return true;
    }

    debugPrint("canPlayAudio: date: $playedDate, count: $playedCount");
    return playedCount <= dailyAudioLimit;
  }

  bool get cantPlayAudio => !canPlayAudio;

  Future<void> recordAudioPlay() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final playedDate = _preferences.getInt(keyLastAudioPlayedDate) ?? 0;

    debugPrint("recordAudioPlay: now: $now, playedDate: $playedDate");
    if (playedDate.toDate().isNotToday()) {
      debugPrint("Recording new audio play for today now: $now");
      await _preferences.setInt(keyLastAudioPlayedDate, now);
      await _preferences.setInt(keyAudioPlayCountToday, 1);
    } else {
      final currentCount = _preferences.getInt(keyAudioPlayCountToday) ?? 0;
      await _preferences.setInt(keyAudioPlayCountToday, currentCount + 1);
    }
  }

  int get todayAudioPlayCount {
    final lastPlayedDate = _preferences.getInt(keyLastAudioPlayedDate) ?? 0;

    if (lastPlayedDate.toDate().isNotToday()) {
      return 0;
    }

    return _preferences.getInt(keyAudioPlayCountToday) ?? 0;
  }
}
