import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble._({
    required this.text,
    required this.theme,
    required this.backgroundColor,
    required this.textColor,
  });

  factory MessageBubble.user({required String text, required ThemeData theme}) {
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textBlack,
      fontWeight: FontWeight.w600,
    );
    return MessageBubble._(
      text: text,
      theme: theme,
      backgroundColor: Colors.white,
      textColor: style?.color ?? AppColors.textBlack,
    );
  }

  factory MessageBubble.specialist({
    required String text,
    required ThemeData theme,
  }) {
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      height: 1.4,
    );
    return MessageBubble._(
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
