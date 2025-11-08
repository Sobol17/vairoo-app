import 'package:ai_note/src/features/recipes/domain/entities/recipe.dart';
import 'package:ai_note/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:ai_note/src/features/recipes/presentation/widgets/recipe_detail_sheet.dart';
import 'package:flutter/material.dart';

class MealSection extends StatelessWidget {
  const MealSection({required this.title, required this.recipes, super.key});

  final String title;
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...recipes.map(
            (recipe) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RecipeCard(
                recipe: recipe,
                onTap: () => _openRecipeDetail(context, recipe),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openRecipeDetail(BuildContext context, Recipe recipe) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecipeDetailSheet(recipe: recipe),
    );
  }
}
