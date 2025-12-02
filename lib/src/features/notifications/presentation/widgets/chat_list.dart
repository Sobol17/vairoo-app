import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_thread.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({required this.chats, required this.onChatTap, super.key});

  final List<ChatThread> chats;
  final ValueChanged<ChatThread> onChatTap;

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return Center(
        child: Text(
          'Пока чатов нет',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _ChatListTile(chat: chat, onTap: () => onChatTap(chat));
      },
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({required this.chat, required this.onTap});

  final ChatThread chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = _buildSubtitle(theme);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.textBlack,
    );
    final unreadBadge = chat.unreadCount > 0
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              chat.unreadCount.toString(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _Avatar(url: chat.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.title, style: titleStyle),
                    const SizedBox(height: 4),
                    subtitle,
                  ],
                ),
              ),
              if (unreadBadge != null) ...[
                const SizedBox(width: 8),
                unreadBadge,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    final statusColor = switch (chat.status) {
      ChatConsultantStatus.online => Colors.green,
      ChatConsultantStatus.away => Colors.orange,
      ChatConsultantStatus.offline => AppColors.textGray,
    };
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.textSecondary,
    );
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: statusColor),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            chat.lastMessagePreview?.isNotEmpty == true
                ? chat.lastMessagePreview!
                : '${chat.consultantName} (${chat.consultantRole})',
            style: subtitleStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const size = 48.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: url != null && url!.isNotEmpty
          ? Image.network(url!, width: size, height: size, fit: BoxFit.cover)
          : Container(
              width: size,
              height: size,
              color: AppColors.secondary.withValues(alpha: 0.16),
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_outline,
                color: AppColors.secondary,
              ),
            ),
    );
  }
}
