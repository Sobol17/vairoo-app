import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChatDetailData {
  const ChatDetailData({
    required this.consultantName,
    required this.consultantRole,
    required this.question,
    required this.answer,
    this.avatarAsset,
  });

  final String consultantName;
  final String consultantRole;
  final String question;
  final String answer;
  final String? avatarAsset;

  const ChatDetailData.sample()
    : this(
        consultantName: 'Ольга',
        consultantRole: 'Специалист',
        question: 'Как начать заново после срыва?',
        answer:
            'Добрый день ответ на ваш вопрос\n'
            '- После срыва важно принять случившееся без самобичевания,\n'
            'проанализировать триггеры и разработать план поддержки',
        avatarAsset: 'assets/icons/avatar.png',
      );
}

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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: _ChatHeader(data: data),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _MessageBubble.user(
                      text: data.question,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _MessageBubble.specialist(
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
              child: const _ChatInputBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.data});

  final ChatDetailData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    );
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.textGray,
      fontWeight: FontWeight.w500,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.secondary.withValues(alpha: 0.16),
            backgroundImage: data.avatarAsset != null
                ? AssetImage(data.avatarAsset!)
                : null,
            child: data.avatarAsset == null
                ? const Icon(
                    Icons.person_outline,
                    color: AppColors.secondary,
                    size: 28,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.consultantName} (${data.consultantRole})',
                style: titleStyle,
              ),
              const SizedBox(height: 4),
              Text('На связи сейчас', style: subtitleStyle),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble._({
    required this.text,
    required this.theme,
    required this.backgroundColor,
    required this.textColor,
  });

  factory _MessageBubble.user({
    required String text,
    required ThemeData theme,
  }) {
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textBlack,
      fontWeight: FontWeight.w600,
    );
    return _MessageBubble._(
      text: text,
      theme: theme,
      backgroundColor: Colors.white,
      textColor: style?.color ?? AppColors.textBlack,
    );
  }

  factory _MessageBubble.specialist({
    required String text,
    required ThemeData theme,
  }) {
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      height: 1.4,
    );
    return _MessageBubble._(
      text: text,
      theme: theme,
      backgroundColor: Colors.white,
      textColor: style?.color ?? AppColors.textSecondary,
    );
  }

  final String text;
  final ThemeData theme;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = theme.textTheme.bodyMedium?.copyWith(color: textColor);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(text, style: textStyle),
      ),
    );
  }
}

class _ChatInputBar extends StatefulWidget {
  const _ChatInputBar();

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  late final TextEditingController _controller;
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _canSend) {
      setState(() {
        _canSend = hasText;
      });
    }
  }

  void _handleSend() {
    if (!_canSend) {
      return;
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sendBackground = _canSend
        ? AppColors.secondary
        : AppColors.secondary.withValues(alpha: 0.3);
    final sendIconColor = Colors.white.withValues(alpha: _canSend ? 1 : 0.7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Чем вам помочь?',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGray,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _canSend ? _handleSend : null,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: sendBackground,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.send_rounded, size: 20, color: sendIconColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
