import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/recipes/domain/entities/recipe.dart';
import 'package:ai_note/src/features/recipes/domain/repositories/recipes_repository.dart';
import 'package:ai_note/src/features/recipes/presentation/controllers/recipes_controller.dart';
import 'package:ai_note/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:ai_note/src/features/recipes/presentation/widgets/recipe_detail_sheet.dart';
import 'package:ai_note/src/features/recipes/presentation/widgets/recipes_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipesController>(
      create: (context) =>
          RecipesController(repository: context.read<RecipesRepository>())
            ..load(),
      child: const _RecipesView(),
    );
  }
}

class _RecipesView extends StatelessWidget {
  const _RecipesView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RecipesController>();
    final grouped = controller.groupedRecipes;
    final orderedTypes = RecipeMealType.values
        .where((type) => grouped[type]?.isNotEmpty ?? false)
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(color: AppColors.primary)),
          SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: RecipesHeader(
                          onBackPressed: () => context.pop(),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        sliver: SliverList.separated(
                          itemBuilder: (context, index) {
                            final mealType = orderedTypes[index];
                            final recipes = grouped[mealType] ?? const [];
                            return _MealSection(
                              title: mealType.label,
                              recipes: recipes,
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 24),
                          itemCount: orderedTypes.length,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  const _MealSection({required this.title, required this.recipes});

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
