import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/home/domain/entities/home_insight.dart';
import 'package:flutter/material.dart';

class InsightCard extends StatefulWidget {
  const InsightCard({required this.data, this.onTap, super.key});

  final HomeInsightCardData data;
  final VoidCallback? onTap;

  @override
  State<InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  void _handleAction() {
    if (!widget.data.hasAchievements) {
      widget.onTap?.call();
      return;
    }
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InsightHeader(
          title: widget.data.title,
          actionLabel: widget.data.actionLabel,
          isExpanded: _expanded,
          showAction:
              widget.data.hasAchievements || widget.data.actionLabel != null,
          onPressed: _handleAction,
        ),
        const SizedBox(height: 8),
        _AchievementTile(
          icon: widget.data.icon,
          title: widget.data.value,
          subtitle: widget.data.subtitle,
          onTap: _handleAction,
        ),
        _expanded && widget.data.hasAchievements
            ? Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: widget.data.achievements!
                      .map(
                        (achievement) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AchievementTile(
                            icon: achievement.icon,
                            title: achievement.title,
                            subtitle: achievement.subtitle,
                            onTap: _handleAction,
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _InsightHeader extends StatelessWidget {
  const _InsightHeader({
    required this.title,
    required this.showAction,
    required this.isExpanded,
    required this.onPressed,
    this.actionLabel,
  });

  final String title;
  final String? actionLabel;
  final bool showAction;
  final bool isExpanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        if (showAction)
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Text(
                  isExpanded ? 'Скрыть' : (actionLabel ?? 'Подробнее'),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: const Icon(
                    Icons.expand_more,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 48, height: 48, child: icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
