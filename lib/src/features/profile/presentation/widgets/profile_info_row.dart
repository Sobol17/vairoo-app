import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.showChevron = true,
    super.key,
  });

  final String label;
  final String value;
  final bool highlight;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: AppColors.textPrimary,
    );

    final valueWidget = highlight
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textStyle)),
          valueWidget,
          if (showChevron)
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGray),
        ],
      ),
    );
  }
}
