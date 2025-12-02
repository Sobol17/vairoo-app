import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/plan/domain/entities/daily_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanActivityCard extends StatelessWidget {
  const PlanActivityCard({
    required this.activity,
    required this.onMarkComplete,
    required this.isCompleting,
    this.onPrimaryTap,
    super.key,
  });

  final PlanActivityItem activity;
  final VoidCallback? onPrimaryTap;
  final VoidCallback onMarkComplete;
  final bool isCompleting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = _iconForActivity(activity);
    final primaryLabel = activity.buttonText ?? 'Смотреть';
    final secondaryLabel = activity.isDone ? 'Выполнено' : 'Отметить';
    final isPrimaryEnabled = onPrimaryTap != null;
    final canMarkComplete = !activity.isDone && !isCompleting;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondaryLight),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: icon,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: isPrimaryEnabled ? onPrimaryTap : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.gray,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    primaryLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    softWrap: false,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SecondaryActionButton(
                  label: secondaryLabel,
                  isCompleted: activity.isDone,
                  isLoading: isCompleting,
                  onPressed: canMarkComplete ? onMarkComplete : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconForActivity(PlanActivityItem activity) {
    final type = activity.type?.toLowerCase();
    switch (type) {
      case 'journal':
        return SvgPicture.asset(
          'assets/icons/journal.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        );
      case 'recipes':
        return SvgPicture.asset(
          'assets/icons/morning.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        );
      case 'rituals':
        return SvgPicture.asset(
          'assets/icons/ritual.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        );
      case 'trainings':
        return SvgPicture.asset(
          'assets/icons/training.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        );
      default:
        switch (activity.timeOfDay) {
          case PlanTimeOfDay.morning:
            return SvgPicture.asset(
              'assets/icons/ritual.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            );
          case PlanTimeOfDay.day:
            return SvgPicture.asset(
              'assets/icons/ritual.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            );
          case PlanTimeOfDay.evening:
            return SvgPicture.asset(
              'assets/icons/ritual.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            );
        }
    }
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onPressed,
    required this.isCompleted,
    required this.isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isCompleted;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.secondary),
      foregroundColor: AppColors.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle:
          theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ) ??
          const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
    );

    Widget child;
    if (isLoading) {
      child = const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (isCompleted) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/check.svg'),
          const SizedBox(width: 4),
          Flexible(child: Text(label)),
        ],
      );
    } else {
      child = Text(label);
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: child,
    );
  }
}
