import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SobrietyCard extends StatelessWidget {
  const SobrietyCard({
    required this.counter,
    required this.startDate,
    super.key,
  });

  final String counter;
  final String startDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Счетчик трезвости',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                counter,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            startDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
