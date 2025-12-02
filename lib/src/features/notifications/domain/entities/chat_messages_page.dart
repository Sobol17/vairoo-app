import 'package:equatable/equatable.dart';

import 'chat_message.dart';

class ChatMessagesPage extends Equatable {
  const ChatMessagesPage({
    required this.items,
    required this.nextCursor,
  });

  final List<ChatMessage> items;
  final String? nextCursor;

  ChatMessagesPage copyWith({
    List<ChatMessage>? items,
    String? nextCursor,
  }) {
    return ChatMessagesPage(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  @override
  List<Object?> get props => [items, nextCursor];
}
