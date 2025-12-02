import 'package:Vairoo/src/features/calendar/domain/entities/calendar_note.dart';
import 'package:Vairoo/src/features/calendar/domain/repositories/calendar_notes_repository.dart';
import 'package:flutter/material.dart';

class CalendarNotesController extends ChangeNotifier {
  CalendarNotesController({required CalendarNotesRepository repository})
    : _repository = repository,
      _selectedDate = DateTime.now();

  final CalendarNotesRepository _repository;

  bool _isLoading = false;
  DateTime _selectedDate;
  List<CalendarNote> _allNotes = const [];
  List<CalendarNote> _filteredNotes = const [];

  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;
  bool get isSelectedDateToday => _isSameDay(_selectedDate, DateTime.now());
  List<CalendarNote> get allNotes => _allNotes;
  List<CalendarNote> get filteredNotes => _filteredNotes;

  Future<void> loadNotes() async {
    _setLoading(true);
    try {
      final results = await Future.wait<List<CalendarNote>>([
        _repository.fetchNotes(limit: 100),
        _repository.fetchNotes(date: _selectedDate, limit: 100),
      ]);
      _allNotes = _sortNotes(results[0]);
      _filteredNotes = _sortNotes(results[1]);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterByDate(DateTime date) async {
    _selectedDate = date;
    _setLoading(true);
    try {
      final filtered = await _repository.fetchNotes(date: date, limit: 100);
      _filteredNotes = _sortNotes(filtered);
    } finally {
      _setLoading(false);
    }
  }

  Future<CalendarNote> createNote(CalendarNote note) async {
    final created = await _repository.createNote(note);
    _allNotes = _sortNotes([created, ..._allNotes]);
    if (_isSameDay(created.date, _selectedDate)) {
      _filteredNotes = _sortNotes([created, ..._filteredNotes]);
    }
    notifyListeners();
    return created;
  }

  Future<CalendarNote> updateNote(CalendarNote note) async {
    final updated = await _repository.updateNote(note);
    _allNotes = _replaceInList(_allNotes, updated);
    _filteredNotes = _updateFilteredList(updated);
    notifyListeners();
    return updated;
  }

  Future<void> deleteNote(CalendarNote note) async {
    await _repository.deleteNote(note.id);
    _allNotes = _allNotes.where((item) => item.id != note.id).toList();
    _filteredNotes = _filteredNotes
        .where((item) => item.id != note.id)
        .toList();
    notifyListeners();
  }

  List<CalendarNote> _sortNotes(List<CalendarNote> notes) {
    final sorted = [...notes];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<CalendarNote> _replaceInList(
    List<CalendarNote> source,
    CalendarNote updated,
  ) {
    final replaced = source
        .map((item) => item.id == updated.id ? updated : item)
        .toList();
    return _sortNotes(replaced);
  }

  List<CalendarNote> _updateFilteredList(CalendarNote updated) {
    final updatedList = _filteredNotes
        .where((item) => item.id != updated.id)
        .toList();
    if (_isSameDay(updated.date, _selectedDate)) {
      updatedList.add(updated);
    }
    return _sortNotes(updatedList);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }
}
