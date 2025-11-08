import 'package:flutter/material.dart';

class HomeRoutinePlan {
  const HomeRoutinePlan({
    required this.id,
    required this.title,
    required this.tagLabel,
    required this.coverImageUrl,
    required this.steps,
    this.tagIcon = Icons.wb_sunny_outlined,
  });

  final String id;
  final String title;
  final String tagLabel;
  final String coverImageUrl;
  final List<String> steps;
  final IconData tagIcon;
}
