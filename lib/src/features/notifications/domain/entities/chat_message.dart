import 'package:equatable/equatable.dart';

import 'chat_attachment.dart';

enum ChatSenderType { user, consultant, system }

enum ChatDeliveryStatus { sent, delivered, read }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderType,
    required this.text,
    required this.attachments,
    required this.deliveryStatus,
    required this.createdAt,
    this.clientTempId,
  });

  final String id;
  final String chatId;
  final ChatSenderType senderType;
  final String text;
  final List<ChatAttachment> attachments;
  final ChatDeliveryStatus deliveryStatus;
  final DateTime createdAt;
  final String? clientTempId;

  ChatMessage copyWith({
    String? id,
    String? chatId,
    ChatSenderType? senderType,
    String? text,
    List<ChatAttachment>? attachments,
    ChatDeliveryStatus? deliveryStatus,
    DateTime? createdAt,
    String? clientTempId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      createdAt: createdAt ?? this.createdAt,
      clientTempId: clientTempId ?? this.clientTempId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderType,
    text,
    attachments,
    deliveryStatus,
    createdAt,
    clientTempId,
  ];
}
