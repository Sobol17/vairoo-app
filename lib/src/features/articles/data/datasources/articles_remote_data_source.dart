import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/features/articles/data/mock_articles.dart';
import 'package:ai_note/src/features/articles/data/models/article_model.dart';
import 'package:dio/dio.dart';

class ArticlesRemoteDataSource {
  ArticlesRemoteDataSource(this._client, {bool useMockData = true})
    : _useMockData = useMockData;

  static const _articlesPath = '/articles';

  final ApiClient _client;
  final bool _useMockData;

  Future<List<ArticleModel>> fetchArticles() async {
    if (_useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return mockArticles;
    }
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
    if (_useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final article = mockArticleById(id);
      if (article != null) {
        return article;
      }
    }
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
