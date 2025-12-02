import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/auth/data/models/auth_session_model.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<void> requestOtp(String phoneNumber) async {
    await _client.post<dynamic>(
      '/api/client/auth/request_code',
      data: {'phone': phoneNumber},
    );
  }

  Future<void> requestOtpSms(String phoneNumber) async {
    await _client.post<dynamic>(
      '/api/client/auth/request_code/sms',
      data: {'phone': phoneNumber},
    );
  }

  Future<AuthSessionModel> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/client/auth/verify_code',
      data: {'phone': phoneNumber, 'code': code},
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

    return AuthSessionModel.fromJson(data, fallbackPhoneNumber: phoneNumber);
  }
}
