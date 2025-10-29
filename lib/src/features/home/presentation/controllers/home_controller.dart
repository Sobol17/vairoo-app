import 'package:flutter/foundation.dart';

import 'package:ai_note/src/features/home/domain/entities/note.dart';
import 'package:ai_note/src/features/home/domain/repositories/note_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController({required NoteRepository repository})
      : _repository = repository;

  final NoteRepository _repository;

  bool _isLoading = false;
  List<Note> _notes = const [];

  bool get isLoading => _isLoading;
  List<Note> get notes => List.unmodifiable(_notes);

  Future<void> loadNotes() async {
    _setLoading(true);
    try {
      _notes = await _repository.fetchNotes();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final now = DateTime.now();
    final note = Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      updatedAt: now,
    );
    await _repository.upsertNote(note);
    await loadNotes();
  }

  Future<void> removeNote(String id) async {
    await _repository.removeNote(id);
    _notes = _notes.where((note) => note.id != id).toList(growable: false);
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }
}
