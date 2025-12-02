import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_message.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/chats_repository.dart';
import 'package:Vairoo/src/features/notifications/presentation/controllers/chat_detail_controller.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/chat_header.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/chat_input_bar.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/chat_message.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({required this.data, super.key});

  final ChatDetailData data;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatDetailController>(
      create: (context) => ChatDetailController(
        repository: context.read<ChatsRepository>(),
        initialData: data,
        apiClient: context.read<ApiClient>(),
      )..loadInitial(),
      child: _ChatDetailView(data: data),
    );
  }
}

class _ChatDetailView extends StatelessWidget {
  const _ChatDetailView({required this.data});

  final ChatDetailData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<ChatDetailController>();
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        titleSpacing: 0,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              foregroundColor: AppColors.primary,
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            label: const Text('Назад'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () => _showReportBottomSheet(context),
              child: Row(
                children: [
                  const Text(
                    'Пожаловаться',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/quest.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ChatHeader(data: data),
            ),
            Expanded(
              child: controller.isLoading && controller.messages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _ChatMessagesList(messages: controller.messages),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).viewPadding.bottom,
              ),
              child: ChatInputBar(
                onSend: controller.sendMessage,
                isSending: controller.isSending,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessagesList extends StatelessWidget {
  const _ChatMessagesList({required this.messages});

  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'Напишите первое сообщение',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final alignment = message.senderType == ChatSenderType.user
            ? Alignment.centerRight
            : Alignment.centerLeft;

        final bubble = switch (message.senderType) {
          ChatSenderType.user => MessageBubble.user(
            text: message.text,
            theme: theme,
          ),
          ChatSenderType.consultant => MessageBubble.specialist(
            text: message.text,
            theme: theme,
          ),
          ChatSenderType.system => MessageBubble.specialist(
            text: message.text,
            theme: theme,
          ),
        };
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Align(alignment: alignment, child: bubble),
        );
      },
    );
  }
}

Future<void> _showReportBottomSheet(BuildContext context) async {
  const reasons = [
    (
      '1. Неуважение',
      'Оскорбление, унижение, дискриминация и проявление агрессии.',
    ),
    (
      '2. Нарушения конфиденциальности',
      'Разглашение личной информации и других участников.',
    ),
    (
      '3. Реклама',
      'Отправление ссылок на сторонние ресурсы и коммерческие предложения.',
    ),
  ];

  int? selectedIndex;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ...reasons.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: ReportCard(
                      title: entry.value.$1,
                      description: entry.value.$2,
                      isSelected: selectedIndex == entry.key,
                      onTap: () => setModalState(() {
                        selectedIndex = entry.key;
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: selectedIndex == null
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Пожаловаться'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
