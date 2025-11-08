import 'package:flutter/material.dart';

class HomeInsightCardData {
  HomeInsightCardData({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.actionLabel,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final String value;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onTap;
}
