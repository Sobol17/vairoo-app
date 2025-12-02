import 'package:Vairoo/src/features/notifications/data/models/chat_message_model.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_message.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_messages_page.dart';

class ChatMessagesPageModel extends ChatMessagesPage {
  ChatMessagesPageModel({required super.items, required super.nextCursor});

  factory ChatMessagesPageModel.fromJson(Map<String, dynamic> json) {
    final items =
        (json['items'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map(ChatMessageModel.fromJson)
            .toList(growable: false) ??
        const <ChatMessage>[];
    return ChatMessagesPageModel(
      items: items,
      nextCursor: json['next_cursor'] as String?,
    );
  }
}
