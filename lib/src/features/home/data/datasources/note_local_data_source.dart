import 'package:ai_note/src/core/storage/preferences_storage.dart';
import 'package:ai_note/src/features/home/data/models/note_model.dart';

const _notesStorageKey = 'home.notes';

class NoteLocalDataSource {
  NoteLocalDataSource(this._storage);

  final PreferencesStorage _storage;

  Future<List<NoteModel>> fetchNotes() async {
    final serializedNotes = _storage.getStringList(_notesStorageKey);
    if (serializedNotes == null) {
      return [];
    }

    return serializedNotes
        .map(NoteModel.fromJsonString)
        .toList(growable: false);
  }

  Future<void> saveNote(NoteModel note) async {
    final existing = await fetchNotes();
    final updated = <NoteModel>[
      for (final item in existing)
        if (item.id != note.id) item,
      note,
    ];

    await _storage.setStringList(
      _notesStorageKey,
      updated.map((item) => item.toJsonString()).toList(),
    );
  }

  Future<void> deleteNote(String id) async {
    final existing = await fetchNotes();
    final updated = existing
        .where((note) => note.id != id)
        .map((note) => note.toJsonString())
        .toList();

    if (updated.isEmpty) {
      await _storage.remove(_notesStorageKey);
      return;
    }

    await _storage.setStringList(_notesStorageKey, updated);
  }
}
