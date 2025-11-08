import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PracticeIntroSheet extends StatelessWidget {
  const PracticeIntroSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text('Понятно'),
                  ),
                  const Spacer(),
                  Text(
                    'О практике',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 64),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Вы — архитектор своей новой жизни. Ваши инструменты — '
                'внимательность к себе, понимание триггеров и четкая рутина. '
                'Дыхание — ваш главный инструмент.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Начните с малого. Сделайте прямо сейчас один осознанный '
                'вдох и выдох. Это первый кирпичик в фундаменте вашей новой '
                'трезвой жизни.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Мы верим в ваш успех!',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text('Начать практику'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
