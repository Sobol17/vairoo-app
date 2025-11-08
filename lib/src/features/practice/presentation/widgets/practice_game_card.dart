import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/practice/domain/entities/practice_game.dart';
import 'package:ai_note/src/features/practice/presentation/widgets/game_avatar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PracticeGameCard extends StatelessWidget {
  const PracticeGameCard({required this.game, super.key});

  final PracticeGame game;

  Future<void> _launchGame(BuildContext context) async {
    final success = await launchUrlString(
      game.storeUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть магазин приложений')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchGame(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GameAvatar(emoji: game.emoji, color: game.color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        game.tag,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                game.durationLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
