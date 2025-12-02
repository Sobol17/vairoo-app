import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeStartDayButton extends StatelessWidget {
  const HomeStartDayButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: const Text('Начать день'),
    );
  }
}
