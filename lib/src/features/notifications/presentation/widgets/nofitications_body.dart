import 'package:ai_note/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:ai_note/src/features/notifications/domain/entities/notification_category.dart';
import 'package:ai_note/src/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/empty_state.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/invite_button.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({required this.controller, super.key});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    final notifications = controller.notificationsForSelectedCategory;
    final isChatCategory =
        controller.selectedCategory == NotificationCategory.chat;
    final showInviteButton = isChatCategory && !controller.hasSelection;

    if (notifications.isEmpty) {
      return const NotificationsEmptyState();
    }

    final listView = ListView.separated(
      padding: EdgeInsets.only(bottom: showInviteButton ? 112 : 24),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isSelectionMode = controller.hasSelection;
        VoidCallback? onTap;
        if (isSelectionMode) {
          onTap = () => controller.toggleSelection(notification.id);
        } else if (notification.category == NotificationCategory.chat) {
          onTap = () {
            context.push('/home/chat', extra: const ChatDetailData.sample());
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
    );

    if (!showInviteButton) {
      return listView;
    }

    return Column(
      children: [
        Expanded(child: listView),
        const SizedBox(height: 8),
        const InviteToChatButton(label: "Пригласить в чат"),
      ],
    );
  }
}
