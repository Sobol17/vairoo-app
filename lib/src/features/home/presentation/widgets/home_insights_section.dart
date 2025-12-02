import 'package:Vairoo/src/features/home/domain/entities/home_insight.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/insight_card.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/insight_tabs.dart';
import 'package:flutter/material.dart';

class HomeInsightsSection extends StatefulWidget {
  const HomeInsightsSection({
    super.key,
    required this.todayCards,
    required this.totalCards,
  });

  final List<HomeInsightCardData> todayCards;
  final List<HomeInsightCardData> totalCards;

  @override
  State<HomeInsightsSection> createState() => _HomeInsightsSectionState();
}

class _HomeInsightsSectionState extends State<HomeInsightsSection> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final cards =
        _activeTab == 0 ? widget.todayCards : widget.totalCards;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InsightsTabs(
          activeIndex: _activeTab,
          onTabSelected: (index) => setState(() => _activeTab = index),
        ),
        const SizedBox(height: 12),
        for (final card in cards) ...[
          InsightCard(data: card, onTap: card.onTap),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
