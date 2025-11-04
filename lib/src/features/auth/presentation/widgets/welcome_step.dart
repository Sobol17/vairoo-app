import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/disclaimer_text.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({
    super.key,
    required this.onStart,
    required this.onPrivacyTap,
    required this.onPersonalPolicyTap,
  });

  final VoidCallback? onStart;
  final VoidCallback onPrivacyTap;
  final VoidCallback onPersonalPolicyTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Добро пожаловать',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Твой путь к трезвости начинается здесь.\nИ мы будем рядом',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Transform.scale(
          scale: 1.15,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/welcome.svg',
            fit: BoxFit.fitWidth,
          ),
        ),
        const Spacer(),
        PrimaryButton(label: 'Начать', onPressed: onStart, isLoading: false),
        const SizedBox(height: 16),
        DisclaimerText(
          textStyle:
              theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ) ??
              TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
          linkStyle:
              theme.textTheme.bodySmall?.copyWith(
                color: secondary,
                decoration: TextDecoration.underline,
                decorationColor: secondary,
                fontWeight: FontWeight.w600,
              ) ??
              TextStyle(
                fontSize: 12,
                color: secondary,
                decoration: TextDecoration.underline,
                decorationColor: secondary,
                fontWeight: FontWeight.w600,
              ),
          onPrivacyTap: onPrivacyTap,
          onPersonalPolicyTap: onPersonalPolicyTap,
        ),
      ],
    );
  }
}
