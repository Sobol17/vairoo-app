import 'package:ai_note/src/features/notifications/domain/entities/notification_category.dart';
import 'package:ai_note/src/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/chat_detail_page.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/empty_state.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({required this.controller, super.key});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    final notifications = controller.notificationsForSelectedCategory;
    if (notifications.isEmpty) {
      return const NotificationsEmptyState();
    }

    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final isSelectionMode = controller.hasSelection;
            VoidCallback? onTap;
            if (isSelectionMode) {
              onTap = () => controller.toggleSelection(notification.id);
            } else if (notification.category == NotificationCategory.chat) {
              onTap = () {
                context.push(
                  '/home/chat',
                  extra: const ChatDetailData.sample(),
                );
              };
            }
            return NotificationTile(
              notification: notification,
              isSelectionMode: isSelectionMode,
              isSelected: controller.isSelected(notification.id),
              onTap: onTap,
              onLongPress: () => controller.toggleSelection(notification.id),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: notifications.length,
        ),
        Positioned(
          bottom: 0,
          child: PrimaryButton(
            label: 'Пригласить в чат',
            onPressed: () {},
            isLoading: false,
          ),
        ),
      ],
    );
  }
}
