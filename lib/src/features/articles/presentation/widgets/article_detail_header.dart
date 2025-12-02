import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/articles/domain/entities/article.dart';
import 'package:flutter/material.dart';

class ArticleDetailHeader extends StatelessWidget {
  const ArticleDetailHeader({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Назад',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                ),
              ),
              const Spacer(),
              Text(
                'Статьи',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 72),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            article.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          if (article.subtitle.isNotEmpty)
            Text(
              article.subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.25,
              ),
            ),
          const SizedBox(height: 12),
          Text(
            article.author == null || article.author!.isEmpty
                ? 'Автор: команда Vario'
                : 'Автор: ${article.author}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
