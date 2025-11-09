import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/calendar/data/datasources/mock_notes.dart';
import 'package:ai_note/src/features/calendar/domain/entities/calendar_note.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_bottom_sheet.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_intro_sheet.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_notes_tabs.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_tab_bar.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/circular_nav_button.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
      builder: (_) => const CalendarIntroSheet(),
    );
  }

  Future<void> _showCalendarSheet() async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const PlanCalendarBottomSheet(),
    );
  }

  void _handleCreateNote() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Скоро можно будет создать новую запись')),
    );
  }

  void _handleNoteTap(CalendarNote note) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Открываю заметку «${note.title}»')));
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
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Center(
                      child: Text(
                        'План 30 дней',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 10,
                    child: CircularNavButton(
                      icon: Icons.calendar_month_outlined,
                      onPressed: _showCalendarSheet,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CalendarTabBar(theme: theme),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    CalendarNotesTab(
                      notes: todayCalendarNotes,
                      onCreateNote: _handleCreateNote,
                      onNoteTap: _handleNoteTap,
                    ),
                    CalendarNotesTab(
                      notes: allCalendarNotes,
                      onCreateNote: _handleCreateNote,
                      onNoteTap: _handleNoteTap,
                    ),
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
