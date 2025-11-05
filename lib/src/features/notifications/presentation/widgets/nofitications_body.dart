import 'package:ai_note/src/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/empty_state.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({required this.controller, super.key});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    final notifications = controller.notificationsForSelectedCategory;
    if (notifications.isEmpty) {
      return const NotificationsEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isSelectionMode = controller.hasSelection;
        final onTap = isSelectionMode
            ? () => controller.toggleSelection(notification.id)
            : null;
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
  }
}
