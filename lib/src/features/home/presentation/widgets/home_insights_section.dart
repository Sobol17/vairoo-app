import 'package:ai_note/src/features/home/domain/entities/home_insight.dart';
import 'package:ai_note/src/features/home/presentation/widgets/insight_card.dart';
import 'package:ai_note/src/features/home/presentation/widgets/insight_tabs.dart';
import 'package:flutter/material.dart';

class HomeInsightsSection extends StatefulWidget {
  const HomeInsightsSection({super.key, required this.cards});

  final List<HomeInsightCardData> cards;

  @override
  State<HomeInsightsSection> createState() => _HomeInsightsSectionState();
}

class _HomeInsightsSectionState extends State<HomeInsightsSection> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InsightsTabs(
          activeIndex: _activeTab,
          onTabSelected: (index) => setState(() => _activeTab = index),
        ),
        const SizedBox(height: 12),
        for (final card in widget.cards) ...[
          InsightCard(data: card, onTap: card.onTap),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
