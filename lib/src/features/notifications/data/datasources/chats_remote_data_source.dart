import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/notifications/data/models/chat_attachment_model.dart';
import 'package:Vairoo/src/features/notifications/data/models/chat_message_model.dart';
import 'package:Vairoo/src/features/notifications/data/models/chat_messages_page_model.dart';
import 'package:Vairoo/src/features/notifications/data/models/chat_thread_model.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_attachment.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_message.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_messages_page.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_thread.dart';

class ChatsRemoteDataSource {
  ChatsRemoteDataSource(this._client);

  final ApiClient _client;
  static const _chatsPath = '/api/client/chats';

  Future<List<ChatThread>> fetchChats() async {
    final response = await _client.get<List<dynamic>>(_chatsPath);
    final payload = response.data;
    if (payload == null) {
      return const [];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(ChatThreadModel.fromJson)
        .toList(growable: false);
  }

  Future<ChatThread> createOrFetchChat() async {
    final response = await _client.post<Map<String, dynamic>>(_chatsPath);
    final data = response.data ?? const <String, dynamic>{};
    return ChatThreadModel.fromJson(data);
  }

  Future<ChatThread> fetchChat(String chatId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_chatsPath/$chatId',
    );
    final data = response.data ?? const <String, dynamic>{};
    return ChatThreadModel.fromJson(data);
  }

  Future<ChatMessagesPage> fetchMessages(
    String chatId, {
    String? cursor,
    int limit = 50,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_chatsPath/$chatId/messages',
      queryParameters: <String, dynamic>{
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        'limit': limit,
      },
    );
    final data = response.data ?? const <String, dynamic>{};
    return ChatMessagesPageModel.fromJson(data);
  }

  Future<ChatMessage> sendMessage(
    String chatId, {
    required String text,
    List<ChatAttachment> attachments = const [],
    String? clientTempId,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '$_chatsPath/$chatId/messages',
      data: <String, dynamic>{
        'text': text,
        if (attachments.isNotEmpty)
          'attachments': attachments
              .map(
                (attachment) =>
                    ChatAttachmentModel.fromEntity(attachment).toJson(),
              )
              .toList(),
        if (clientTempId != null) 'client_temp_id': clientTempId,
      },
    );
    final data = response.data ?? const <String, dynamic>{};
    return ChatMessageModel.fromJson(data);
  }

  Future<void> reportChat(
    String chatId, {
    required String reason,
    String? description,
  }) async {
    await _client.post<Map<String, dynamic>>(
      '$_chatsPath/$chatId/report',
      data: <String, dynamic>{
        'reason': reason,
        if (description?.isNotEmpty ?? false) 'description': description,
      },
    );
  }
}
