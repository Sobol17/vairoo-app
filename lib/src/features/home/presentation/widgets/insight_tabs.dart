import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InsightsTabs extends StatelessWidget {
  const InsightsTabs({
    required this.activeIndex,
    required this.onTabSelected,
    super.key,
  });

  final int activeIndex;
  final ValueChanged<int> onTabSelected;
  static const tabs = ['Сегодня', 'Всего'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i != 0) const SizedBox(width: 20),
          Expanded(
            child: TabItem(
              label: tabs[i],
              isActive: i == activeIndex,
              onTap: () => onTabSelected(i),
            ),
          ),
        ],
      ],
    );
  }
}

class TabItem extends StatelessWidget {
  const TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? AppColors.secondary : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondary : AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
