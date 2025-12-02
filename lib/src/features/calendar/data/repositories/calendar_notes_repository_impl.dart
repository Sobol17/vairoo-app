import 'package:Vairoo/src/features/calendar/data/datasources/calendar_notes_remote_data_source.dart';
import 'package:Vairoo/src/features/calendar/data/models/calendar_note_model.dart';
import 'package:Vairoo/src/features/calendar/domain/entities/calendar_note.dart';
import 'package:Vairoo/src/features/calendar/domain/repositories/calendar_notes_repository.dart';

class CalendarNotesRepositoryImpl implements CalendarNotesRepository {
  CalendarNotesRepositoryImpl({
    required CalendarNotesRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CalendarNotesRemoteDataSource _remoteDataSource;

  @override
  Future<List<CalendarNote>> fetchNotes({DateTime? date, int limit = 100}) {
    return _remoteDataSource.fetchNotes(date: date, limit: limit);
  }

  @override
  Future<CalendarNote> fetchNote(String id) {
    return _remoteDataSource.fetchNote(id);
  }

  @override
  Future<CalendarNote> createNote(CalendarNote note) {
    return _remoteDataSource.createNote(CalendarNoteModel.fromEntity(note));
  }

  @override
  Future<CalendarNote> updateNote(CalendarNote note) {
    return _remoteDataSource.updateNote(CalendarNoteModel.fromEntity(note));
  }

  @override
  Future<void> deleteNote(String id) {
    return _remoteDataSource.deleteNote(id);
  }
}
