import 'package:ai_note/src/features/recipes/domain/entities/recipe.dart';

abstract class RecipesRepository {
  Future<List<Recipe>> fetchRecipes();
  Future<Recipe> fetchRecipeById(String id);
}
