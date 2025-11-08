import 'package:flutter/material.dart';

class GameAvatar extends StatelessWidget {
  const GameAvatar({required this.emoji, required this.color, super.key});

  final String emoji;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 26)),
    );
  }
}
