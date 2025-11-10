import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:ai_note/src/features/notifications/presentation/controllers/notification_permission_controller.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotificationPermissionPage extends StatelessWidget {
  const NotificationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotificationPermissionController>();
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BrandLogo(color: AppColors.secondary),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Закрепи свой успех',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Напоминание — это ваш личный сигнал, это ваша страховка.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.primary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    Transform.scale(
                      scale: 1.2,
                      child: SvgPicture.asset(
                        'assets/icons/push_illustration.svg',
                        height: 420,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: controller.isRequesting
                        ? null
                        : () {
                            controller.deferPrompt();
                            context.go('/home');
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Text(
                      'Включить позже',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  PrimaryButton(
                    label: "Включить",
                    onPressed: controller.isRequesting
                        ? null
                        : controller.requestPermission,
                    isLoading: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
