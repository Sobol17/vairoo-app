import 'package:flutter/material.dart';

class DailyPlan {
  const DailyPlan({
    required this.period,
    required this.subtitle,
    required this.activities,
    required this.realityCheck,
  });

  final String period;
  final String subtitle;
  final List<PlanActivity> activities;
  final RealityCheck realityCheck;
}

class PlanActivity {
  const PlanActivity({
    required this.title,
    required this.description,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
    this.icon,
    this.route,
  });

  final String title;
  final String description;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final IconData? icon;
  final String? route;
}

class RealityCheck {
  const RealityCheck({
    required this.title,
    required this.description,
    required this.ctaLabel,
  });

  final String title;
  final String description;
  final String ctaLabel;
}
