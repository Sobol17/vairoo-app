import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/chat_header.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/chat_input_bar.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/chat_message.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/invite_button.dart';
import 'package:ai_note/src/features/notifications/presentation/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({required this.data, super.key});

  final ChatDetailData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: MessageBubble.user(
                      text: data.question,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MessageBubble.specialist(
                      text: data.answer,
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).viewPadding.bottom,
              ),
              child: const ChatInputBar(),
            ),
          ],
        ),
      ),
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

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ...reasons.map(
            (reason) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ReportCard(title: reason.$1, description: reason.$2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6),
            child: const InviteToChatButton(label: "Пожаловаться"),
          ),
        ],
      );
    },
  );
}
