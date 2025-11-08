import 'package:flutter/material.dart';

class HomeInsightCardData {
  HomeInsightCardData({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.actionLabel,
    this.onTap,
    this.achievements,
  });

  final Widget icon;
  final String title;
  final String value;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onTap;
  final List<HomeAchievementDetail>? achievements;

  bool get hasAchievements => achievements != null && achievements!.isNotEmpty;
}

class HomeAchievementDetail {
  const HomeAchievementDetail({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Widget icon;
  final String title;
  final String subtitle;
}
