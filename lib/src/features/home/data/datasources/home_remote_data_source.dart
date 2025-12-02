import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/home/data/models/home_data_model.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._client);

  final ApiClient _client;

  Future<HomeDataModel> fetchHome() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/client/home',
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
    return HomeDataModel.fromJson(data);
  }
}
