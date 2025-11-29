import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/features/plan/data/models/daily_plan_model.dart';
import 'package:ai_note/src/features/plan/data/models/plan_completion_result_model.dart';
import 'package:dio/dio.dart';

class PlanRemoteDataSource {
  PlanRemoteDataSource(this._client);

  final ApiClient _client;
  static const _basePath = '/api/client/plan';

  Future<DailyPlanModel> startPlan() async {
    final response = await _client.post<Map<String, dynamic>>(
      '$_basePath/start',
    );
    final payload = response.data;
    if (payload == null) {
      throw _emptyResponse(response);
    }
    return DailyPlanModel.fromJson(payload);
  }

  Future<DailyPlanModel> fetchCurrentPlan() async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_basePath/current',
    );
    final payload = response.data;
    if (payload == null) {
      throw _emptyResponse(response);
    }
    return DailyPlanModel.fromJson(payload);
  }

  Future<PlanCompletionResultModel> completeItem(String itemId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '$_basePath/items/$itemId/complete',
    );
    final payload = response.data;
    if (payload == null) {
      throw _emptyResponse(response);
    }
    final planPayload = payload['plan'];
    if (planPayload is! Map<String, dynamic>) {
      throw _emptyResponse(response, message: 'Missing plan payload');
    }
    return PlanCompletionResultModel.fromJson({
      ...payload,
      'plan': planPayload,
    });
  }

  Never _emptyResponse(
    Response<Map<String, dynamic>> response, {
    String message = 'Empty response body',
  }) {
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: message,
      type: DioExceptionType.badResponse,
    );
  }
}
