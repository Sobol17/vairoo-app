import 'package:Vairoo/src/features/calendar/domain/entities/calendar_note.dart';

abstract class CalendarNotesRepository {
  Future<List<CalendarNote>> fetchNotes({DateTime? date, int limit = 100});
  Future<CalendarNote> fetchNote(String id);
  Future<CalendarNote> createNote(CalendarNote note);
  Future<CalendarNote> updateNote(CalendarNote note);
  Future<void> deleteNote(String id);
}
