import 'package:avtotest/data/datasource/preference/device_preferences.dart';
import 'package:dio/dio.dart';

class CommonInterceptor extends QueuedInterceptor {
  final DevicePreferences _devicePreferences;

  CommonInterceptor(this._devicePreferences);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final headers = <String, String>{};

    headers['Device-Session-Id'] = _devicePreferences.deviceSessionId;
    headers['Device-Installation-Id'] =
        await _devicePreferences.deviceInstallationId;

    options.headers.addAll(headers);
    handler.next(options);
  }
}
