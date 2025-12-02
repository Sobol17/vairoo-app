import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/recipes/data/models/recipe_model.dart';
import 'package:dio/dio.dart';

class RecipesRemoteDataSource {
  RecipesRemoteDataSource(this._client);

  final ApiClient _client;
  static const _recipesPath = '/api/client/recipes';

  Future<List<RecipeModel>> fetchRecipes() async {
    final response = await _client.get<List<dynamic>>(_recipesPath);
    final payload = response.data;
    if (payload == null) {
      return const [];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(RecipeModel.fromJson)
        .toList(growable: false);
  }

  Future<RecipeModel> fetchRecipeById(String recipeId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_recipesPath/$recipeId',
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
    return RecipeModel.fromJson(data);
  }
}
