import 'package:flutter/material.dart';

class PracticeGame {
  const PracticeGame({
    required this.title,
    required this.tag,
    required this.duration,
    required this.storeUrl,
    required this.emoji,
    required this.color,
  });

  final String title;
  final String tag;
  final Duration duration;
  final String storeUrl;
  final String emoji;
  final Color color;

  String get durationLabel => '${duration.inSeconds} сек.';
}
