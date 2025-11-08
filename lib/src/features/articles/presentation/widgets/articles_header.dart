import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/articles/presentation/widgets/back_action.dart';
import 'package:flutter/material.dart';

class ArticlesHeader extends StatelessWidget {
  const ArticlesHeader({required this.onBackPressed, super.key});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(color: AppColors.bgGray),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackAction(onPressed: onBackPressed),
                const Spacer(),
                Text(
                  'Статьи',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontSize: 18,
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
