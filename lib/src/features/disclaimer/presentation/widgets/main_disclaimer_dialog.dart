import 'package:flutter/material.dart';

class MainDisclaimerDialog extends StatelessWidget {
  const MainDisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: const Color(0xFF003F4F),
    );
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      height: 1.4,
      color: const Color(0xFF0A2A35),
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F6C7F),
              Color(0xFF005B6B),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Сегодня к вам пришла замечательная идея — сосредоточиться на трезвости!',
                  style: titleStyle?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Наши специалисты составили для вас ежедневные рекомендации на месяц, чтобы вам было легче справиться на начальном этапе трезвой жизни.',
                  style: bodyStyle?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Также вы будете чувствовать, что не одни: мы всегда на связи и готовы вам помочь.',
                  style: bodyStyle?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Ежедневно при входе в программу вы будете получать подробные рекомендации на день, которые помогут вам оставаться в ясном уме и хорошем настроении.',
                  style: bodyStyle?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Удачи, с уважением команда Vairoo!',
                  style: bodyStyle?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF30D5C8),
                    foregroundColor: const Color(0xFF00444F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Начать'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
