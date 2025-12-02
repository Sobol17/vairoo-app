import 'package:Vairoo/src/features/recipes/data/datasources/recipes_remote_data_source.dart';
import 'package:Vairoo/src/features/recipes/domain/entities/recipe.dart';
import 'package:Vairoo/src/features/recipes/domain/repositories/recipes_repository.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  RecipesRepositoryImpl({required RecipesRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final RecipesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Recipe>> fetchRecipes() {
    return _remoteDataSource.fetchRecipes();
  }

  @override
  Future<Recipe> fetchRecipeById(String id) {
    return _remoteDataSource.fetchRecipeById(id);
  }
}
