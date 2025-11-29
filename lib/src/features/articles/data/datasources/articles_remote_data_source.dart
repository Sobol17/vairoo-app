import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/features/articles/data/models/article_model.dart';
import 'package:dio/dio.dart';

class ArticlesRemoteDataSource {
  final ApiClient _client;
  static const _articlesPath = '/api/client/articles';

  ArticlesRemoteDataSource(this._client);

  Future<List<ArticleModel>> fetchArticles() async {
    final response = await _client.get<List<dynamic>>(_articlesPath);
    final payload = response.data;
    if (payload == null) {
      return const [];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(ArticleModel.fromJson)
        .toList(growable: false);
  }

  Future<ArticleModel> fetchArticleById(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_articlesPath/$id',
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
    return ArticleModel.fromJson(data);
  }
}
