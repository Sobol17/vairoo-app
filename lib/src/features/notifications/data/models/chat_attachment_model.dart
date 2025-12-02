import 'package:Vairoo/src/features/notifications/domain/entities/chat_attachment.dart';

class ChatAttachmentModel extends ChatAttachment {
  const ChatAttachmentModel({required super.url, required super.type});

  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) {
    return ChatAttachmentModel(
      url: json['url'] as String? ?? '',
      type: _parseType(json['type'] as String?),
    );
  }

  factory ChatAttachmentModel.fromEntity(ChatAttachment attachment) {
    return ChatAttachmentModel(url: attachment.url, type: attachment.type);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'url': url, 'type': type.name};
  }

  static ChatAttachmentType _parseType(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'image':
        return ChatAttachmentType.image;
      case 'audio':
        return ChatAttachmentType.audio;
      case 'video':
        return ChatAttachmentType.video;
      case 'file':
        return ChatAttachmentType.file;
      default:
        return ChatAttachmentType.other;
    }
  }
}
