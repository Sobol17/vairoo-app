import 'package:Vairoo/src/features/notifications/domain/entities/chat_attachment.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_message.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_messages_page.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_thread.dart';

abstract class ChatsRepository {
  Future<List<ChatThread>> fetchChats();
  Future<ChatThread> createOrFetchChat();
  Future<ChatThread> fetchChat(String chatId);
  Future<ChatMessagesPage> fetchMessages(
    String chatId, {
    String? cursor,
    int limit = 50,
  });
  Future<ChatMessage> sendMessage(
    String chatId, {
    required String text,
    List<ChatAttachment> attachments = const [],
    String? clientTempId,
  });
  Future<void> reportChat(
    String chatId, {
    required String reason,
    String? description,
  });
}
