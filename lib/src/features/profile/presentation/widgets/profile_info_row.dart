import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.showChevron = true,
    this.onTap,
    super.key,
  });

  final String label;
  final String value;
  final bool highlight;
  final bool showChevron;
  final VoidCallback? onTap;

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
              borderRadius: BorderRadius.circular(6),
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

    final row = Padding(
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

    if (onTap == null) {
      return row;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: row,
      ),
    );
  }
}
