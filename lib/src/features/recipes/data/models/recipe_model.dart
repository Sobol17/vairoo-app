import 'package:ai_note/src/features/recipes/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.durationMinutes,
    required super.tags,
    required super.mealType,
    required super.imageUrl,
    required super.ingredients,
    required super.instructions,
    super.description,
  });
}
