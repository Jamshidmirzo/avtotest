// import 'dart:developer';
//
// import 'package:avtotest/assets/constants/app_constants.dart';
// import 'package:avtotest/core/data/singletons/storage.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// import '../interceptors/device_id_intercepter.dart';
// import '../interceptors/language_interceptor.dart';
//
// class DioSettings {
//   BaseOptions _dioBaseOptions = BaseOptions(
//     baseUrl: AppConstants.baseUrl,
//     connectTimeout: const Duration(milliseconds: 35000),
//     receiveTimeout: const Duration(milliseconds: 35000),
//     followRedirects: false,
//     validateStatus: (status) => status != null && status <= 500,
//   );
//
//   void setBaseOptions({String? lang}) {
//     _dioBaseOptions = BaseOptions(
//       baseUrl: AppConstants.baseUrl,
//       connectTimeout: const Duration(milliseconds: 35000),
//       receiveTimeout: const Duration(milliseconds: 35000),
//       headers: <String, dynamic>{
//         'Accept-Language': lang,
//         'Device-Name': StorageRepository.getString(StorageKeys.deviceName, defValue: ''),
//         'User-Agent': StorageRepository.getString(StorageKeys.userAgent, defValue: ''),
//         'Device-Type': StorageRepository.getString(StorageKeys.deviceType, defValue: ''),
//         'App-Version': StorageRepository.getString(StorageKeys.appVersion, defValue: ''),
//       },
//       followRedirects: false,
//       validateStatus: (status) => status != null && status <= 500,
//     );
//   }
//
//   BaseOptions get dioBaseOptions => _dioBaseOptions;
//
//   LanguageInterceptor get _languageInterceptor => LanguageInterceptor();
//
//   LogInterceptor get _loggerInterceptor => LogInterceptor(
//         error: kDebugMode,
//         request: kDebugMode,
//         requestBody: kDebugMode,
//         responseBody: kDebugMode,
//         requestHeader: kDebugMode,
//         responseHeader: kDebugMode,
//         logPrint: (e) {
//           log(e.toString());
//         },
//       );
//
//   DeviceIdInterceptor get _deviceIdInterceptor => DeviceIdInterceptor();
//
//   Dio get dio {
//     final dio = Dio(_dioBaseOptions);
//     dio.interceptors
//       ..add(_languageInterceptor)
//       ..add(_deviceIdInterceptor)
//       ..add(_loggerInterceptor);
//
//     return dio;
//   }
// }
