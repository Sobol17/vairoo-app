import 'package:Vairoo/src/features/practice/presentation/widgets/breathing_practice_card.dart';
import 'package:flutter/material.dart';

class BreathingTab extends StatelessWidget {
  const BreathingTab({required this.onStartPressed, super.key});

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: [
          Expanded(
            child: BreathingPracticeCard(onStartPressed: onStartPressed),
          ),
        ],
      ),
    );
  }
}
