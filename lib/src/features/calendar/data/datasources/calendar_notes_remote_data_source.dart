import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/calendar/data/models/calendar_note_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class CalendarNotesRemoteDataSource {
  CalendarNotesRemoteDataSource(this._client);

  final ApiClient _client;
  static const _notesPath = '/api/client/calendar-notes';
  static final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  Future<List<CalendarNoteModel>> fetchNotes({
    DateTime? date,
    int limit = 100,
  }) async {
    final queryParameters = <String, dynamic>{
      'limit': limit,
      if (date != null) 'date': _dateFormatter.format(date.toLocal()),
    };
    final response = await _client.get<List<dynamic>>(
      _notesPath,
      queryParameters: queryParameters,
    );
    final payload = response.data;
    if (payload == null) {
      return const [];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(CalendarNoteModel.fromJson)
        .toList(growable: false);
  }

  Future<CalendarNoteModel> fetchNote(String id) async {
    final response = await _client.get<Map<String, dynamic>>('$_notesPath/$id');
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Empty response body',
        type: DioExceptionType.badResponse,
      );
    }
    return CalendarNoteModel.fromJson(data);
  }

  Future<CalendarNoteModel> createNote(CalendarNoteModel note) async {
    final response = await _client.post<Map<String, dynamic>>(
      _notesPath,
      data: note.toRequestJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Empty response body',
        type: DioExceptionType.badResponse,
      );
    }
    return CalendarNoteModel.fromJson(data);
  }

  Future<CalendarNoteModel> updateNote(CalendarNoteModel note) async {
    final response = await _client.put<Map<String, dynamic>>(
      '$_notesPath/${note.id}',
      data: note.toRequestJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Empty response body',
        type: DioExceptionType.badResponse,
      );
    }
    return CalendarNoteModel.fromJson(data);
  }

  Future<void> deleteNote(String id) {
    return _client.delete<void>('$_notesPath/$id');
  }
}
