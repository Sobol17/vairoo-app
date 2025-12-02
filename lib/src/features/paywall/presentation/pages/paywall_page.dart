import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:Vairoo/src/features/paywall/presentation/controllers/paywall_controller.dart';
import 'package:Vairoo/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  Future<void> _handleCheckout(BuildContext context) async {
    final controller = context.read<PaywallController>();
    final link = await controller.requestCheckoutLink();
    if (!context.mounted) {
      return;
    }
    if (link == null) {
      final error = controller.errorMessage ?? 'Не удалось получить ссылку';
      _showMessage(context, error);
      return;
    }
    final success = await launchUrlString(
      link.paymentUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!success && context.mounted) {
      _showMessage(context, 'Не удалось открыть ссылку');
    }
  }

  void _showMessage(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<PaywallController>();
    final isLoading = controller.isLoading;
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      height: 1.5,
      fontSize: 14,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const BrandLogo(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            child: const Text('Закрыть'),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/paywall.svg',
                        height: 220,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Поздравляем вас с успешным завершением этой тридцатидневной программы трезвости!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Вы очень старались, и мы надеемся, что вы заметили положительные изменения в своём отношении к алкоголю. Чтобы сохранить результат, сохраняйте мотивацию, вспоминайте проблемы от употребления и пользу отказа. Используйте новые навыки, принимайте сложность перемен и учитесь преодолевать трудности. Находите радость в каждом дне и не стесняйтесь просить помощь.',
                      style: bodyStyle,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Наше приложение продолжит поддерживать вас: можно задать вопрос специалисту, получить помощь в чате, опираться на дыхательные и другие техники саморегуляции, а также поиграть в мини-игру. Ваши пожелания помогут нам сделать приложение лучше. Этот текст выдержан в сжатом виде для удобства восприятия и мотивации.',
                      style: bodyStyle,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: _PaywallBottomPanel(
                isLoading: isLoading,
                onCheckout: () => _handleCheckout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaywallBottomPanel extends StatelessWidget {
  const _PaywallBottomPanel({
    required this.onCheckout,
    required this.isLoading,
  });

  final VoidCallback onCheckout;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaywallCard(accent: AppColors.accent),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Продолжить путь трезвости',
            onPressed: isLoading ? null : onCheckout,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

class PaywallCard extends StatelessWidget {
  const PaywallCard({required this.accent, super.key});

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
                    'Продолжить путь',
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
