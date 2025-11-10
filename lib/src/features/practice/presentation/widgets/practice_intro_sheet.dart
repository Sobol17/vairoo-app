import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PracticeIntroSheet extends StatelessWidget {
  const PracticeIntroSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom;
    final sheetHeight = media.size.height - 60;
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: SizedBox(
        height: sheetHeight,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SheetHeader(
                theme: theme,
                onClose: () => context.pop(),
                title: 'О практике',
              ),
              Expanded(
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 24 + bottomInset),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Вы — архитектор своей новой жизни. Ваши инструменты — внимательность к себе, понимание триггеров и четкая рутина. Дыхание — ваш главный инструмент.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Начните с малого. Сделайте прямо сейчас один осознанный вдох и выдох. Это первый кирпичик в фундаменте вашей новой трезвой жизни.',
                                textAlign: TextAlign.center,
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
                            ],
                          ),
                        ),
                      ),
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
                      SizedBox(height: bottomInset + 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.theme,
    required this.onClose,
    required this.title,
  });

  final ThemeData theme;
  final VoidCallback onClose;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: SizedBox(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onClose,
                icon: const Icon(Icons.chevron_left_rounded),
                label: const Text('Понятно'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
