import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/practice/domain/entities/practice_tab.dart';
import 'package:Vairoo/src/features/practice/presentation/widgets/breathing_tab.dart';
import 'package:Vairoo/src/features/practice/presentation/widgets/games_tab.dart';
import 'package:Vairoo/src/features/practice/presentation/widgets/practice_intro_sheet.dart';
import 'package:Vairoo/src/features/practice/presentation/widgets/practice_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key, this.initialTab = PracticeTab.calming});

  final PracticeTab initialTab;

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
      builder: (_) => const PracticeIntroSheet(),
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
      initialIndex: widget.initialTab.index,
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
                child: PracticeTabBar(theme: theme),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    BreathingTab(onStartPressed: _openBreathingPractice),
                    const GamesTab(),
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
