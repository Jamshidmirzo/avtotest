import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target

part 'subscription_response.freezed.dart';
part 'subscription_response.g.dart';

// {
//   success: true,
//   message: Success,
//   data: {
//     user: {user_id: 232, full_name: null},
//     app: {has_app_update: false, is_forced_update: false},
//     subscription: {premium_expiry_date: 2025-07-23T00:32:17.590376, has_premium: true}
//   }
// }

@freezed
class SubscriptionResponse with _$SubscriptionResponse {
  const factory SubscriptionResponse({
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'data') required UserDataContent data,
  }) = _SubscriptionResponse;

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);
}

@freezed
class UserDataContent with _$UserDataContent {
  const factory UserDataContent({
    @JsonKey(name: 'user') required UserInfo user,
    @JsonKey(name: 'app') required UpdateAppInfo updateAppInfo,
    @JsonKey(name: 'subscription') required SubscriptionInfo subscription,
  }) = _UserDataContent;

  factory UserDataContent.fromJson(Map<String, dynamic> json) =>
      _$UserDataContentFromJson(json);
}

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'full_name') String? fullName,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}

@freezed
class UpdateAppInfo with _$UpdateAppInfo {
  const UpdateAppInfo._();

  const factory UpdateAppInfo({
    @JsonKey(name: 'has_app_update') required bool hasAppUpdate,
    @JsonKey(name: 'is_forced_update') required bool isForcedUpdate,
  }) = _UpdateAppInfo;

  bool get isUpdateNotAvailable => !hasAppUpdate;

  factory UpdateAppInfo.fromJson(Map<String, dynamic> json) =>
      _$UpdateAppInfoFromJson(json);
}

@freezed
class SubscriptionInfo with _$SubscriptionInfo {
  const factory SubscriptionInfo({
    @JsonKey(name: 'premium_expiry_date') required String premiumExpiryDate,
    @JsonKey(name: 'has_premium') required bool hasPremium,
  }) = _SubscriptionInfo;

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionInfoFromJson(json);
}
