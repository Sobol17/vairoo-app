import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({required this.controller, super.key});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Уведомления',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text('Пуш-уведомления'),
                subtitle: const Text('Вкл.'),
                value: controller.pushEnabled,
                activeColor: AppColors.secondary,
                onChanged: controller.togglePushNotifications,
              ),
              const Divider(height: 0),
              SwitchListTile.adaptive(
                title: const Text('Сообщения на почту'),
                subtitle: const Text('Вкл.'),
                value: controller.emailEnabled,
                activeColor: AppColors.secondary,
                onChanged: controller.toggleEmailNotifications,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
