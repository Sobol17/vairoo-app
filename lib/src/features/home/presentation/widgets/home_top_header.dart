import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_header_row.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_quote_card.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_sobriety_card.dart';
import 'package:flutter/material.dart';

class HomeTopHeader extends StatelessWidget {
  const HomeTopHeader({
    super.key,
    required this.quote,
    required this.sobrietyCounter,
    required this.sobrietyStartDate,
    required this.onNotificationsTap,
    required this.onChatTap,
  });

  final String quote;
  final String sobrietyCounter;
  final String sobrietyStartDate;
  final VoidCallback onNotificationsTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(color: AppColors.primary),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeaderRow(
                  onChatTap: onChatTap,
                  onNotificationsTap: onNotificationsTap,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              QuoteCard(text: quote),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Divider(),
              ),
              SobrietyCard(
                counter: sobrietyCounter,
                startDate: sobrietyStartDate,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
