import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/calendar/domain/entities/calendar_note.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/calendar_bg.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/calendar_notes_empty.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/create_note_button.dart';
import 'package:Vairoo/src/features/calendar/presentation/widgets/note_card.dart';
import 'package:flutter/material.dart';

class CalendarNotesTab extends StatelessWidget {
  const CalendarNotesTab({
    required this.notes,
    required this.onCreateNote,
    required this.onNoteTap,
  });

  final List<CalendarNote> notes;
  final VoidCallback onCreateNote;
  final ValueChanged<CalendarNote> onNoteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = notes.isEmpty
        ? const CalendarNotesEmptyState()
        : ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
            children: [
              Text(
                'Заметки',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              ...notes.map(
                (note) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CalendarNoteCard(
                    note: note,
                    onTap: () => onNoteTap(note),
                  ),
                ),
              ),
            ],
          );

    return Stack(
      children: [
        const CalendarBackground(),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(child: content),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: CreateNoteButton(onPressed: onCreateNote),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
