import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/notifications/domain/entities/notification_category.dart';
import 'package:ai_note/src/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/chat_detail_page.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/empty_state.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

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
        const _InviteToChatButton(),
      ],
    );
  }
}

class _InviteToChatButton extends StatelessWidget {
  const _InviteToChatButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textBlack,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => _handleShare(context),
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          label: const Text('Пригласить в чат'),
        ),
      ),
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    const inviteUrl = 'https://example.com/invite';
    const message = 'Приглашение, чтобы вместе работать над собой\n$inviteUrl';

    final box = context.findRenderObject() as RenderBox?;
    final shareOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: 'Приглашение в чат',
        sharePositionOrigin: shareOrigin,
      ),
    );
  }
}
