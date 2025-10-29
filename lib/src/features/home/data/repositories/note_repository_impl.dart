import 'package:ai_note/src/features/home/data/datasources/note_local_data_source.dart';
import 'package:ai_note/src/features/home/data/models/note_model.dart';
import 'package:ai_note/src/features/home/domain/entities/note.dart';
import 'package:ai_note/src/features/home/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._localDataSource);

  final NoteLocalDataSource _localDataSource;

  @override
  Future<List<Note>> fetchNotes() async {
    final models = await _localDataSource.fetchNotes();
    return models;
  }

  @override
  Future<void> removeNote(String id) => _localDataSource.deleteNote(id);

  @override
  Future<void> upsertNote(Note note) {
    final model = NoteModel.fromNote(note);
    return _localDataSource.saveNote(model);
  }
}
