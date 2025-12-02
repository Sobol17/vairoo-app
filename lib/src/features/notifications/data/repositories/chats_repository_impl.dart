import 'package:Vairoo/src/features/notifications/data/datasources/chats_remote_data_source.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_attachment.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_message.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_messages_page.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_thread.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  const ChatsRepositoryImpl({required ChatsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ChatsRemoteDataSource _remoteDataSource;

  @override
  Future<List<ChatThread>> fetchChats() {
    return _remoteDataSource.fetchChats();
  }

  @override
  Future<ChatThread> createOrFetchChat() {
    return _remoteDataSource.createOrFetchChat();
  }

  @override
  Future<ChatThread> fetchChat(String chatId) {
    return _remoteDataSource.fetchChat(chatId);
  }

  @override
  Future<ChatMessagesPage> fetchMessages(
    String chatId, {
    String? cursor,
    int limit = 50,
  }) {
    return _remoteDataSource.fetchMessages(
      chatId,
      cursor: cursor,
      limit: limit,
    );
  }

  @override
  Future<ChatMessage> sendMessage(
    String chatId, {
    required String text,
    List<ChatAttachment> attachments = const [],
    String? clientTempId,
  }) {
    return _remoteDataSource.sendMessage(
      chatId,
      text: text,
      attachments: attachments,
      clientTempId: clientTempId,
    );
  }

  @override
  Future<void> reportChat(
    String chatId, {
    required String reason,
    String? description,
  }) {
    return _remoteDataSource.reportChat(
      chatId,
      reason: reason,
      description: description,
    );
  }
}
