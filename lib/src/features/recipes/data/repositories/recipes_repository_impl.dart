import 'package:ai_note/src/features/recipes/data/datasources/recipes_local_data_source.dart';
import 'package:ai_note/src/features/recipes/domain/entities/recipe.dart';
import 'package:ai_note/src/features/recipes/domain/repositories/recipes_repository.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  RecipesRepositoryImpl({required RecipesLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final RecipesLocalDataSource _localDataSource;

  @override
  Future<List<Recipe>> fetchRecipes() {
    return _localDataSource.fetchRecipes();
  }

  @override
  Future<Recipe> fetchRecipeById(String id) async {
    final recipes = await _localDataSource.fetchRecipes();
    return recipes.firstWhere((recipe) => recipe.id == id);
  }
}
