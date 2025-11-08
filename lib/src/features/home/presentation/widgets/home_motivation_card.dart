import 'package:ai_note/src/features/home/presentation/widgets/home_quote_card.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_sobriety_card.dart';
import 'package:flutter/material.dart';

class HomeMotivationCard extends StatelessWidget {
  const HomeMotivationCard({
    super.key,
    required this.quote,
    required this.sobrietyCounter,
    required this.sobrietyStartDate,
  });

  final String quote;
  final String sobrietyCounter;
  final String sobrietyStartDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          QuoteCard(text: quote),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(),
          ),
          SobrietyCard(counter: sobrietyCounter, startDate: sobrietyStartDate),
        ],
      ),
    );
  }
}
