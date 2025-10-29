import 'package:dio/dio.dart';

import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/features/auth/data/models/auth_session_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<void> requestOtp(String phoneNumber) async {
    await _client.post<dynamic>(
      '/auth/request-otp',
      data: {
        'phoneNumber': phoneNumber,
      },
    );
  }

  Future<AuthSessionModel> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/verify-otp',
      data: {
        'phoneNumber': phoneNumber,
        'code': code,
      },
    );

    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Empty response body',
        type: DioExceptionType.badResponse,
      );
    }

    return AuthSessionModel.fromJson(data);
  }
}
