import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key, required this.onAcknowledged});

  final VoidCallback onAcknowledged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 24,
      color: AppColors.accent,
      letterSpacing: 0.8,
    );
    final headline = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.5,
    );
    final supportingStyle = theme.textTheme.bodyMedium?.copyWith(
      color: Colors.white.withOpacity(0.9),
      height: 1.5,
    );
    final warningStyle = theme.textTheme.bodySmall?.copyWith(
      color: Colors.white.withOpacity(0.9),
      height: 1.5,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF54BCB8), Color(0xFF0D4B5B)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BrandLogo(color: AppColors.surface),
                const SizedBox(height: 12),
                Text(
                  'ДИСКЛЕЙМЕР',
                  textAlign: TextAlign.center,
                  style: accentStyle,
                ),
                const SizedBox(height: 32),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: headline,
                    children: [
                      const TextSpan(
                        text:
                            'Приложение «Vairoo» является инструментом поддержки и информации и ',
                      ),
                      TextSpan(
                        text:
                            'НЕ ЗАМЕНЯЕТ профессиональную медицинскую помощь, диагностику или лечение.',
                        style: headline?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Мы знаем, что решение отказаться от алкоголя — одно из самых смелых в жизни. Возможно, ты испытываешь неуверенность, страх или сомнения. Это абсолютно нормально. Каждое большое путешествие начинается с одного шага, и твой — прямо здесь.',
                  textAlign: TextAlign.left,
                  style: supportingStyle,
                ),
                const SizedBox(height: 20),
                Center(child: SvgPicture.asset('assets/icons/hearth.svg')),
                const SizedBox(height: 24),
                Text(
                  'При наличии тяжёлых симптомов отмены (делирий, судороги, сильная рвота), острой алкогольной интоксикации или суицидальных мыслей НЕМЕДЛЕННО обратитесь за экстренной медицинской помощью по телефону 103 или 112.',
                  textAlign: TextAlign.left,
                  style: warningStyle,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onAcknowledged,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text(
                      'Ознакомился',
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
