import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/notification_category.dart';
import 'package:flutter/material.dart';

class CategorySwitcher extends StatelessWidget {
  const CategorySwitcher({
    required this.selected,
    required this.onCategorySelected,
    super.key,
  });

  final NotificationCategory selected;
  final ValueChanged<NotificationCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: NotificationCategory.values
            .map(
              (category) => Expanded(
                child: GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected == category
                          ? AppColors.secondary.withValues(alpha: 0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        category.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selected == category
                              ? AppColors.primary
                              : AppColors.textGray,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
