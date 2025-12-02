import 'package:Vairoo/src/features/notifications/data/models/chat_attachment_model.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_attachment.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.chatId,
    required super.senderType,
    required super.text,
    required super.attachments,
    required super.deliveryStatus,
    required super.createdAt,
    super.clientTempId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final attachments =
        (json['attachments'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map(ChatAttachmentModel.fromJson)
            .toList(growable: false) ??
        const <ChatAttachment>[];
    final createdAt = DateTime.tryParse(json['created_at'] as String? ?? '');
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      chatId: json['chat_id']?.toString() ?? '',
      senderType: _parseSenderType(json['sender_type'] as String?),
      text: json['text'] as String? ?? '',
      attachments: attachments,
      deliveryStatus: _parseDeliveryStatus(json['delivery_status'] as String?),
      createdAt: createdAt?.toLocal() ?? DateTime.now(),
      clientTempId: json['client_temp_id'] as String?,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessage message) {
    return ChatMessageModel(
      id: message.id,
      chatId: message.chatId,
      senderType: message.senderType,
      text: message.text,
      attachments: message.attachments,
      deliveryStatus: message.deliveryStatus,
      createdAt: message.createdAt,
      clientTempId: message.clientTempId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'chat_id': chatId,
      'sender_type': senderType.name,
      'text': text,
      'attachments': attachments
          .map(
            (attachment) => ChatAttachmentModel.fromEntity(attachment).toJson(),
          )
          .toList(),
      'delivery_status': deliveryStatus.name,
      'created_at': createdAt.toUtc().toIso8601String(),
      'client_temp_id': clientTempId,
    };
  }

  static ChatSenderType _parseSenderType(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'user':
        return ChatSenderType.user;
      case 'consultant':
        return ChatSenderType.consultant;
      case 'system':
        return ChatSenderType.system;
      default:
        return ChatSenderType.system;
    }
  }

  static ChatDeliveryStatus _parseDeliveryStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'sent':
        return ChatDeliveryStatus.sent;
      case 'delivered':
        return ChatDeliveryStatus.delivered;
      case 'read':
        return ChatDeliveryStatus.read;
      default:
        return ChatDeliveryStatus.sent;
    }
  }
}
