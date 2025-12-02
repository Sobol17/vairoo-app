import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BackAction extends StatelessWidget {
  const BackAction({this.color, required this.onPressed, super.key});

  final Color? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final computedColor = color ?? AppColors.primary;
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: computedColor,
        size: 20,
      ),
      label: Text(
        'Назад',
        style: theme.textTheme.labelLarge?.copyWith(
          color: computedColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: computedColor,
        padding: const EdgeInsets.symmetric(horizontal: 0),
      ),
    );
  }
}
