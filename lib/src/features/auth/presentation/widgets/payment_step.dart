import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentStep extends StatelessWidget {
  const PaymentStep({
    super.key,
    required this.isLoading,
    required this.onStartTrial,
  });

  final bool isLoading;
  final VoidCallback onStartTrial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final accent = AppColors.accent;
    final secondaryText = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Персональный план',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '«Первые 30 дней новой жизни»',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Самое сложное — начать',
          textAlign: TextAlign.center,
          style: secondaryText,
        ),
        const Spacer(),
        Transform.scale(
          scale: 1.15,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/payment_bg.svg',
            fit: BoxFit.fitWidth,
          ),
        ),
        const Spacer(),
        _PaymentPlanCard(accent: accent),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Начать 14 дней бесплатно',
          onPressed: isLoading ? null : onStartTrial,
          isLoading: isLoading,
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 64,
            height: 4,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentPlanCard extends StatelessWidget {
  const _PaymentPlanCard({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: accent, width: 3),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '299 Руб.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Твой старт к свободе',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '30 Дней',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
