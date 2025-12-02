import 'package:Vairoo/src/features/notifications/domain/entities/chat_thread.dart';

class ChatThreadModel extends ChatThread {
  ChatThreadModel({
    required super.id,
    required super.title,
    required super.consultantName,
    required super.consultantRole,
    required super.status,
    required super.avatarUrl,
    required super.lastMessagePreview,
    required super.lastMessageAt,
    required super.unreadCount,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    final lastMessageAt = DateTime.tryParse(
      json['last_message_at'] as String? ?? '',
    );
    return ChatThreadModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      consultantName: json['consultant_name'] as String? ?? '',
      consultantRole: json['consultant_role'] as String? ?? '',
      status: _parseStatus(json['status'] as String?),
      avatarUrl: json['avatar_url'] as String?,
      lastMessagePreview: json['last_message_preview'] as String?,
      lastMessageAt: lastMessageAt?.toLocal(),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  static ChatConsultantStatus _parseStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'online':
        return ChatConsultantStatus.online;
      case 'away':
        return ChatConsultantStatus.away;
      case 'offline':
      default:
        return ChatConsultantStatus.offline;
    }
  }
}
