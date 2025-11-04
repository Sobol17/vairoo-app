import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({
    super.key,
    required this.sobrietyDuration,
    required this.sobrietyStartLabel,
  });

  final String sobrietyDuration;
  final String sobrietyStartLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatRow(
            label: 'Трезв',
            value: sobrietyDuration,
            valueStyle: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _StatRow(
            label: 'Начало трезвости',
            value: sobrietyStartLabel,
            valueBackground: AppColors.secondary.withOpacity(0.16),
            valueStyle: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.valueBackground,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Color? valueBackground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueWidget = Text(
      value,
      style:
          valueStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textBlack,
            fontWeight: FontWeight.w500,
          ),
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (valueBackground != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: valueBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            child: valueWidget,
          )
        else
          valueWidget,
      ],
    );
  }
}
