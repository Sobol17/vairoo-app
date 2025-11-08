import 'package:ai_note/src/features/practice/data/datasources/practice_games.dart';
import 'package:ai_note/src/features/practice/presentation/widgets/practice_game_card.dart';
import 'package:flutter/material.dart';

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemBuilder: (context, index) {
        final game = practiceGames[index];
        return PracticeGameCard(game: game);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: practiceGames.length,
    );
  }
}
