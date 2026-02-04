import 'package:avtotest/data/datasource/network/dto/subscription_response.dart';
import 'package:avtotest/data/datasource/network/service/subscription_service.dart';
import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
import 'package:avtotest/data/datasource/preference/user_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SubscriptionRepository {
  final SubscriptionPreferences _subscriptionPreferences;
  final SubscriptionService _subscriptionService;
  final UserPreferences _userPreferences;

  SubscriptionRepository(
    this._subscriptionPreferences,
    this._subscriptionService,
    this._userPreferences,
  );

  Future<UpdateAppInfo?> loginWithReferrerId(int referrerId) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;

    Response root = await _subscriptionService.loginWithReferrerId(
      referrerId: referrerId,
      versionCode: versionCode,
      versionName: versionName,
    );
    debugPrint("loginWithReferrerId -> response: ${root.data}");
    SubscriptionResponse response = SubscriptionResponse.fromJson(root.data);

    if (response.success) {
      await _saveSubscriptionAndUser(response);
      return response.data.updateAppInfo;
    }
    return null;
  }

  Future<UpdateAppInfo?> login({int? userId}) async {
    // if (_subscriptionPreferences.isRequestSentInLastHour) {
    //   debugPrint("login -> request already sent in last hour");
    //   return null;
    // }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;

    Response root = await _subscriptionService.login(
      versionCode: versionCode,
      versionName: versionName,
      userId: userId,
    );
    debugPrint("login -> response: ${root.data}");
    SubscriptionResponse response = SubscriptionResponse.fromJson(root.data);

    if (response.success) {
      await _saveSubscriptionAndUser(response);
      return response.data.updateAppInfo;
    }

    return null;
  }

  Future<void> _saveSubscriptionAndUser(SubscriptionResponse response) async {
    var subscription = response.data.subscription;
    String expiryDate = subscription.premiumExpiryDate;
    DateTime? expiryDateTime = DateTime.tryParse(expiryDate);

    await _subscriptionPreferences.setSubsActivated(subscription.hasPremium);
    await _subscriptionPreferences.setSubsEndDate(expiryDateTime);
    await _subscriptionPreferences.setLastRequestTime(DateTime.now());

    var user = response.data.user;
    await _userPreferences.setUserId(user.userId);
  }
}
