import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/calendar/domain/entities/calendar_note.dart';
import 'package:Vairoo/src/features/calendar/presentation/controllers/calendar_notes_controller.dart';
import 'package:Vairoo/src/features/calendar/presentation/pages/calendar_note_detail_page.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/calendar_bottom_sheet.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/calendar_intro_sheet.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/calendar_notes_tabs.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/calendar_tab_bar.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/create_note_sheet.dart';
import 'package:Vairoo/src/features/plan/presentation/widgets/circular_nav_button.dart';
import 'package:Vairoo/src/shared/helpers/formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool _warningShown = false;
  final Formatter _formatter = Formatter();

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
    final controller = context.read<CalendarNotesController>();
    final date = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          PlanCalendarBottomSheet(initialDate: controller.selectedDate),
    );
    if (date != null) {
      await controller.filterByDate(date);
    }
  }

  Future<void> _handleCreateNote() async {
    if (!mounted) return;
    final note = await showModalBottomSheet<CalendarNote>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CreateCalendarNoteSheet(),
    );
    if (note == null || !mounted) {
      return;
    }
    final controller = context.read<CalendarNotesController>();
    try {
      await controller.createNote(note);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заметка создана')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось создать заметку')),
      );
    }
  }

  void _handleNoteTap(CalendarNote note) {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CalendarNoteDetailPage(
          note: note,
          onUpdate: _updateNote,
          onDelete: _removeNote,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CalendarNotesController>();

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
                child: CalendarTabBar(
                  theme: theme,
                  todayLabel: _buildSelectedLabel(controller),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          CalendarNotesTab(
                            notes: controller.filteredNotes,
                            onCreateNote: _handleCreateNote,
                            onNoteTap: _handleNoteTap,
                          ),
                          CalendarNotesTab(
                            notes: controller.allNotes,
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

  Future<void> _updateNote(CalendarNote updated) async {
    final controller = context.read<CalendarNotesController>();
    try {
      await controller.updateNote(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заметка обновлена')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось обновить заметку')),
      );
    }
  }

  Future<void> _removeNote(CalendarNote note) async {
    final controller = context.read<CalendarNotesController>();
    try {
      await controller.deleteNote(note);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заметка «${note.title}» удалена')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось удалить заметку')),
      );
    }
  }

  String _buildSelectedLabel(CalendarNotesController controller) {
    if (controller.isSelectedDateToday) {
      return 'Сегодня';
    }
    return _formatter.formatCalendarDate(controller.selectedDate);
  }
}
