import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/shared/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarIntroSheet extends StatelessWidget {
  const CalendarIntroSheet({super.key});

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
                                'Ваша задача — стать внимательнее к себе, понять триггеры и структурировать рутину.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Практика ежедневных заметок  состоит из:',
                                textAlign: TextAlign.left,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '1. Дневника эмоций, мыслей и поведения — фиксируйте дискомфорт, отвечая: что я чувствую? Какие мысли за этим стоят? Проверяйте их на правдивость. Опишите своё поведение.',
                                textAlign: TextAlign.left,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '2. Определения ситуаций риска, срыва и записи альтернатив алкоголю (например, усталость — зарядка, душ, сериал).',
                                textAlign: TextAlign.left,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      SecondaryButton(
                        label: 'Создать запись',
                        onPressed: () {},
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
