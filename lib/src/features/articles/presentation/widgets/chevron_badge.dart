import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChevronBadge extends StatelessWidget {
  const ChevronBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }
}
