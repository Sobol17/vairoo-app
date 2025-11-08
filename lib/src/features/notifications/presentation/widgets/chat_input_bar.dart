import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
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
