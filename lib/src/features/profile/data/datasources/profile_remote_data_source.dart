import 'package:ai_note/src/core/network/api_client.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client);

  final ApiClient _client;
  static const _profilePath = '/api/client/profile/me';

  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await _client.get<Map<String, dynamic>>(_profilePath);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Empty profile response',
        type: DioExceptionType.badResponse,
      );
    }
    return data;
  }

  Future<void> updateProfile(Map<String, dynamic> payload) async {
    await _client.patch<dynamic>(_profilePath, data: payload);
  }
}
