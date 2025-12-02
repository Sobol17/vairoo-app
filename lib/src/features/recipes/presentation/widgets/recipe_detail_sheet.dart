import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/recipes/domain/entities/recipe.dart';
import 'package:Vairoo/src/features/recipes/domain/repositories/recipes_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeDetailSheet extends StatefulWidget {
  const RecipeDetailSheet({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailSheet> createState() => _RecipeDetailSheetState();
}

class _RecipeDetailSheetState extends State<RecipeDetailSheet> {
  late final Future<Recipe> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = context.read<RecipesRepository>().fetchRecipeById(
      widget.recipe.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Recipe>(
      future: _detailFuture,
      initialData: widget.recipe,
      builder: (context, snapshot) {
        final recipe = snapshot.data ?? widget.recipe;
        final theme = Theme.of(context);
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError = snapshot.hasError;
        final warningColor = AppColors.secondaryLight.withOpacity(0.35);
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.gray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  recipe.imageUrl,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: AppColors.secondaryLight,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: AppColors.primary,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    recipe.durationDisplay,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            recipe.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (recipe.description != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              recipe.description!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          if (isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: LinearProgressIndicator(
                                minHeight: 3,
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.primary,
                                ),
                                backgroundColor: AppColors.secondaryLight,
                              ),
                            ),
                          if (hasError)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: warningColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Не удалось загрузить подробности',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryLight.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ингредиенты:',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ...List.generate(recipe.ingredients.length, (
                                  index,
                                ) {
                                  final ingredient = recipe.ingredients[index];
                                  final isLast =
                                      index == recipe.ingredients.length - 1;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                ingredient.name,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                              ),
                                            ),
                                            Text(
                                              ingredient.amount,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isLast)
                                        const Divider(
                                          height: 1,
                                          color: AppColors.textGray,
                                        ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (recipe.instructions.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Приготовление',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    recipe.instructions,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
