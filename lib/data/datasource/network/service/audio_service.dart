import 'package:dio/dio.dart';

class SubscriptionService {
  final Dio dio;

  SubscriptionService({
    required this.dio,
  });

  Future<Response> getAudioStreamUrl({
    required String audioFileId,
    required String deviceInstallationId,
  }) {
    return dio.get(
      'https://backend.avtotest-begzod.uz/api/v1/file/download/mobile/audio/$audioFileId@$deviceInstallationId',
    );
  }
}
