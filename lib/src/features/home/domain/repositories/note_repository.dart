import 'package:Vairoo/src/features/home/domain/entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> fetchNotes();
  Future<void> upsertNote(Note note);
  Future<void> removeNote(String id);
}
