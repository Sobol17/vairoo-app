import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  bool _warningShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWarningSheet());
  }

  Future<void> _showWarningSheet() async {
    if (!mounted || _warningShown) {
      return;
    }
    _warningShown = true;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _PracticeIntroSheet(),
    );
  }

  void _openBreathingPractice() {
    context.push('/practice/breathing');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bgGray,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Практики',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _PracticeTabBar(theme: theme),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _BreathingTab(onStartPressed: _openBreathingPractice),
                    const _GamesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeTabBar extends StatelessWidget {
  const _PracticeTabBar({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final labelStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    );
    final baseUnderline = AppColors.secondary.withValues(alpha: 0.25);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Row(
          children: List.generate(
            2,
            (_) => Expanded(child: Container(height: 3, color: baseUnderline)),
          ),
        ),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.zero,
          splashFactory: NoSplash.splashFactory,
          labelPadding: const EdgeInsets.symmetric(vertical: 12),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.secondary, width: 3),
          ),
          labelColor: AppColors.secondary,
          unselectedLabelColor: AppColors.textGray,
          labelStyle: labelStyle,
          unselectedLabelStyle: labelStyle?.copyWith(color: AppColors.textGray),
          tabs: const [
            Tab(text: 'Дыхание'),
            Tab(text: 'Игры'),
          ],
        ),
      ],
    );
  }
}

class _BreathingTab extends StatelessWidget {
  const _BreathingTab({required this.onStartPressed});

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [_BreathingPracticeCard(onStartPressed: onStartPressed)],
    );
  }
}

class _BreathingPracticeCard extends StatelessWidget {
  const _BreathingPracticeCard({required this.onStartPressed});

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/relax.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: AppColors.primary.withValues(alpha: 0.72)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '00:00',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Сконцентрируйтесь на дыхании и отпустите лишние мысли.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: onStartPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.92),
                    foregroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Начать практику'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GamesTab extends StatelessWidget {
  const _GamesTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemBuilder: (context, index) {
        final game = _practiceGames[index];
        return _PracticeGameCard(game: game);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: _practiceGames.length,
    );
  }
}

class _PracticeGameCard extends StatelessWidget {
  const _PracticeGameCard({required this.game});

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
              _GameAvatar(emoji: game.emoji, color: game.color),
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

class _GameAvatar extends StatelessWidget {
  const _GameAvatar({required this.emoji, required this.color});

  final String emoji;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 26)),
    );
  }
}

class PracticeGame {
  const PracticeGame({
    required this.title,
    required this.tag,
    required this.duration,
    required this.storeUrl,
    required this.emoji,
    required this.color,
  });

  final String title;
  final String tag;
  final Duration duration;
  final String storeUrl;
  final String emoji;
  final Color color;

  String get durationLabel => '${duration.inSeconds} сек.';
}

const _practiceGames = [
  PracticeGame(
    title: 'Змейка',
    tag: 'Отвлечение',
    duration: Duration(seconds: 30),
    storeUrl:
        'https://apps.apple.com/us/app/classic-snake-game-1997-retro/id1465321784',
    emoji: '🐍',
    color: Color(0xFF5CC6C1),
  ),
  PracticeGame(
    title: 'Тетрис',
    tag: 'Антистресс',
    duration: Duration(seconds: 30),
    storeUrl: 'https://apps.apple.com/us/app/tetris/id1491074310',
    emoji: '🧱',
    color: Color(0xFF7A8FE3),
  ),
  PracticeGame(
    title: 'Шарики',
    tag: 'Антистресс',
    duration: Duration(seconds: 30),
    storeUrl:
        'https://apps.apple.com/us/app/bubble-shooter-pop-puzzle/id1483491017',
    emoji: '🔵',
    color: Color(0xFFFFB74D),
  ),
];

class _PracticeIntroSheet extends StatelessWidget {
  const _PracticeIntroSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text('Понятно'),
                  ),
                  const Spacer(),
                  Text(
                    'О практике',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 64),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Вы — архитектор своей новой жизни. Ваши инструменты — '
                'внимательность к себе, понимание триггеров и четкая рутина. '
                'Дыхание — ваш главный инструмент.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Начните с малого. Сделайте прямо сейчас один осознанный '
                'вдох и выдох. Это первый кирпичик в фундаменте вашей новой '
                'трезвой жизни.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Мы верим в ваш успех!',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text('Начать практику'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
