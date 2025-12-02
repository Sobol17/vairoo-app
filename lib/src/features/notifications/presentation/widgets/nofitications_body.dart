import 'package:Vairoo/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/notification_category.dart';
import 'package:Vairoo/src/features/notifications/presentation/controllers/chats_controller.dart';
import 'package:Vairoo/src/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/chat_list.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/empty_state.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/invite_button.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({
    required this.notificationsController,
    required this.chatsController,
    super.key,
  });

  final NotificationsController notificationsController;
  final ChatsController chatsController;

  @override
  Widget build(BuildContext context) {
    final isChatCategory =
        notificationsController.selectedCategory == NotificationCategory.chat;

    if (isChatCategory) {
      if (chatsController.isLoading && !chatsController.hasChats) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        children: [
          Expanded(
            child: chatsController.hasChats
                ? ChatList(
                    chats: chatsController.chats,
                    onChatTap: (chat) {
                      context.push(
                        '/home/chat',
                        extra: ChatDetailData(
                          chatId: chat.id,
                          consultantName: chat.consultantName,
                          consultantRole: chat.consultantRole,
                          initialQuestion: chat.lastMessagePreview ?? '',
                        ),
                      );
                    },
                  )
                : const NotificationsEmptyState(),
          ),
          const InviteToChatButton(label: 'Пригласить в чат'),
        ],
      );
    }

    final notifications =
        notificationsController.notificationsForSelectedCategory;

    if (notifications.isEmpty) {
      return const NotificationsEmptyState();
    }

    final listView = ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isSelectionMode = notificationsController.hasSelection;
        VoidCallback? onTap;
        if (isSelectionMode) {
          onTap = () =>
              notificationsController.toggleSelection(notification.id);
        } else if (notification.category == NotificationCategory.chat) {
          onTap = () {
            context.push('/home/chat', extra: const ChatDetailData.sample());
          };
        }
        return NotificationTile(
          notification: notification,
          isSelectionMode: isSelectionMode,
          isSelected: notificationsController.isSelected(notification.id),
          onTap: onTap,
          onLongPress: () =>
              notificationsController.toggleSelection(notification.id),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: notifications.length,
    );

    return listView;
  }
}
