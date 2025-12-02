import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/notifications/data/models/chat_message_model.dart';
import 'package:Vairoo/src/features/notifications/data/models/chat_thread_model.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_message.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_thread.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/chats_repository.dart';
import 'package:flutter/material.dart';

class ChatDetailController extends ChangeNotifier {
  ChatDetailController({
    required ChatsRepository repository,
    required ChatDetailData initialData,
    required ApiClient apiClient,
  }) : _repository = repository,
       _initialData = initialData,
       _apiClient = apiClient;

  final ChatsRepository _repository;
  final ChatDetailData _initialData;
  final ApiClient _apiClient;

  bool _isLoading = false;
  bool _isSending = false;
  bool _isLoadingMore = false;
  ChatThread? _thread;
  List<ChatMessage> _messages = const [];
  String? _nextCursor;

  WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _isDisposed = false;
  int _reconnectAttempts = 0;

  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isLoadingMore => _isLoadingMore;
  ChatThread? get thread => _thread;
  List<ChatMessage> get messages => _messages;

  Future<void> loadInitial() async {
    _setLoading(true);
    try {
      final chat = await _repository.fetchChat(_initialData.chatId);
      final page = await _repository.fetchMessages(_initialData.chatId);
      _thread = chat;
      _messages = page.items;
      _nextCursor = page.nextCursor;
      if (_messages.isEmpty) {
        _messages = [
          if (_initialData.initialQuestion.isNotEmpty)
            _buildInitialMessage(
              id: 'initial-question',
              text: _initialData.initialQuestion,
              sender: ChatSenderType.user,
              createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
            ),
          if (_initialData.initialAnswer.isNotEmpty)
            _buildInitialMessage(
              id: 'initial-answer',
              text: _initialData.initialAnswer,
              sender: ChatSenderType.consultant,
              createdAt: DateTime.now(),
            ),
        ];
      }
      _connectSocket();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMore() async {
    if (_nextCursor == null || _isLoadingMore) {
      return;
    }
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _repository.fetchMessages(
        _initialData.chatId,
        cursor: _nextCursor,
      );
      _messages = [...page.items, ..._messages];
      _nextCursor = page.nextCursor;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (_isSending) {
      return;
    }
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final tempId =
        '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(99999)}';
    final optimistic = ChatMessage(
      id: tempId,
      chatId: _initialData.chatId,
      senderType: ChatSenderType.user,
      text: trimmed,
      attachments: const [],
      deliveryStatus: ChatDeliveryStatus.sent,
      createdAt: DateTime.now(),
      clientTempId: tempId,
    );
    _messages = [..._messages, optimistic];
    notifyListeners();

    _isSending = true;
    notifyListeners();

    try {
      final result = await _repository.sendMessage(
        _initialData.chatId,
        text: trimmed,
        clientTempId: tempId,
      );
      _upsertMessage(result);
    } catch (_) {
      _messages = _messages
          .where(
            (msg) => msg.id != tempId && (msg.clientTempId ?? '') != tempId,
          )
          .toList();
      notifyListeners();
      rethrow;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  ChatMessage _buildInitialMessage({
    required String id,
    required String text,
    required ChatSenderType sender,
    required DateTime createdAt,
  }) {
    return ChatMessage(
      id: id,
      chatId: _initialData.chatId,
      senderType: sender,
      text: text,
      attachments: const [],
      deliveryStatus: ChatDeliveryStatus.read,
      createdAt: createdAt,
    );
  }

  void _upsertMessage(ChatMessage message) {
    final candidates = <String>{
      message.id,
      if (message.clientTempId != null) message.clientTempId!,
    }..removeWhere((element) => element.isEmpty);
    final index = _messages.indexWhere(
      (item) =>
          candidates.contains(item.id) ||
          (item.clientTempId != null &&
              candidates.contains(item.clientTempId!)),
    );
    if (index == -1) {
      _messages = [..._messages, message];
    } else {
      final updated = [..._messages];
      updated[index] = message;
      _messages = updated;
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

  Future<void> _connectSocket() async {
    if (_isDisposed) {
      return;
    }
    await _disposeSocket();
    final uri = _buildSocketUri();
    final headers = <String, dynamic>{};
    final token = _apiClient.authToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final socket = await WebSocket.connect(uri.toString(), headers: headers);
      if (_isDisposed) {
        await socket.close();
        return;
      }
      _socket = socket;
      _reconnectAttempts = 0;
      _socketSubscription = socket.listen(
        _handleSocketMessage,
        onDone: _scheduleReconnect,
        onError: (_) => _scheduleReconnect(),
        cancelOnError: true,
      );
      _startPing();
    } catch (_) {
      _scheduleReconnect();
    }
  }

  Uri _buildSocketUri() {
    final base = Uri.parse(_apiClient.client.options.baseUrl);
    final scheme = base.scheme == 'https' ? 'wss' : 'ws';
    final path = '/ws/chats/${_initialData.chatId}';
    return Uri(
      scheme: scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: path,
    );
  }

  void _handleSocketMessage(dynamic raw) {
    if (raw is! String) {
      return;
    }
    Map<String, dynamic>? decoded;
    try {
      decoded = jsonDecode(raw) as Map<String, dynamic>?;
    } catch (_) {
      return;
    }
    if (decoded == null) {
      return;
    }
    final type = decoded['type'] as String?;
    final payload = decoded['payload'];
    switch (type) {
      case 'connection.ack':
        _sendSync();
        break;
      case 'message.new':
      case 'message.updated':
        if (payload is Map<String, dynamic>) {
          final message = ChatMessageModel.fromJson(payload);
          _upsertMessage(message);
        }
        break;
      case 'chat.updated':
        if (payload is Map<String, dynamic>) {
          _thread = ChatThreadModel.fromJson(payload);
          notifyListeners();
        }
        break;
      case 'pong':
        break;
      default:
        break;
    }
  }

  void _sendSync() {
    if (_messages.isEmpty) {
      return;
    }
    _socket?.add(
      jsonEncode({
        'type': 'messages.sync',
        'payload': {'lastMessageId': _messages.last.id},
      }),
    );
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _socket?.add(jsonEncode({'type': 'ping'}));
    });
  }

  void _scheduleReconnect() {
    if (_isDisposed) {
      return;
    }
    unawaited(_disposeSocket());
    _reconnectAttempts = (_reconnectAttempts + 1).clamp(1, 15);
    _reconnectTimer?.cancel();
    final delay = Duration(seconds: min(30, 2 * _reconnectAttempts));
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      _connectSocket();
    });
  }

  Future<void> _disposeSocket() async {
    _pingTimer?.cancel();
    _pingTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _socketSubscription?.cancel();
    _socketSubscription = null;
    await _socket?.close();
    _socket = null;
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_disposeSocket());
    super.dispose();
  }
}
