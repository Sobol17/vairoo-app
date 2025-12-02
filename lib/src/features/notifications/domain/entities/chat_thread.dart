import 'package:equatable/equatable.dart';

enum ChatConsultantStatus { online, offline, away }

class ChatThread extends Equatable {
  const ChatThread({
    required this.id,
    required this.title,
    required this.consultantName,
    required this.consultantRole,
    required this.status,
    required this.avatarUrl,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  final String id;
  final String title;
  final String consultantName;
  final String consultantRole;
  final ChatConsultantStatus status;
  final String? avatarUrl;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final int unreadCount;

  ChatThread copyWith({
    String? id,
    String? title,
    String? consultantName,
    String? consultantRole,
    ChatConsultantStatus? status,
    String? avatarUrl,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ChatThread(
      id: id ?? this.id,
      title: title ?? this.title,
      consultantName: consultantName ?? this.consultantName,
      consultantRole: consultantRole ?? this.consultantRole,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    consultantName,
    consultantRole,
    status,
    avatarUrl,
    lastMessagePreview,
    lastMessageAt,
    unreadCount,
  ];
}
