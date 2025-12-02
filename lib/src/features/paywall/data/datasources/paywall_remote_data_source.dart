import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/paywall/data/models/checkout_link_model.dart';
import 'package:dio/dio.dart';

class PaywallRemoteDataSource {
  PaywallRemoteDataSource(this._client);

  final ApiClient _client;

  Future<CheckoutLinkModel> createCheckoutLink() async {
    final response =
        await _client.post<Map<String, dynamic>>('/subscriptions/checkout/link');
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Empty checkout link response',
        type: DioExceptionType.badResponse,
      );
    }
    return CheckoutLinkModel.fromJson(data);
  }
}
