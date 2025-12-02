import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ArticlesEmptyState extends StatelessWidget {
  const ArticlesEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.library_books_outlined,
          color: AppColors.secondary.withValues(alpha: 0.4),
          size: 56,
        ),
        const SizedBox(height: 16),
        Text(
          'Пока нет статей',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Мы скоро добавим материалы, загляните позже.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
