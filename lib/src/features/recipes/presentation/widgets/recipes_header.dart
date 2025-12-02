import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/articles/presentation/widgets/back_action.dart';
import 'package:flutter/material.dart';

class RecipesHeader extends StatelessWidget {
  const RecipesHeader({required this.onBackPressed, super.key});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(color: AppColors.primary),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackAction(color: AppColors.surface, onPressed: onBackPressed),
                const Spacer(),
                Text(
                  'Рецепты',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.surface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 72),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
