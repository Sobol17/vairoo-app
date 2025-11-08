import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BackAction extends StatelessWidget {
  const BackAction({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.primary,
        size: 20,
      ),
      label: Text(
        'Назад',
        style: theme.textTheme.labelLarge?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 0),
      ),
    );
  }
}
