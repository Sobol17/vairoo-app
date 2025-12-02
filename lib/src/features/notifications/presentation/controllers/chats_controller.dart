import 'package:Vairoo/src/features/notifications/domain/entities/chat_thread.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/chats_repository.dart';
import 'package:flutter/material.dart';

class ChatsController extends ChangeNotifier {
  ChatsController({required ChatsRepository repository})
    : _repository = repository;

  final ChatsRepository _repository;

  bool _isLoading = false;
  List<ChatThread> _chats = const [];

  bool get isLoading => _isLoading;
  List<ChatThread> get chats => _chats;
  bool get hasChats => _chats.isNotEmpty;

  Future<void> loadChats() async {
    _setLoading(true);
    try {
      _chats = await _repository.fetchChats();
    } finally {
      _setLoading(false);
    }
  }

  void updateChat(ChatThread chat) {
    final existingIndex = _chats.indexWhere((item) => item.id == chat.id);
    if (existingIndex >= 0) {
      final updated = [..._chats];
      updated[existingIndex] = chat;
      _chats = updated;
    } else {
      _chats = [chat, ..._chats];
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }
}
