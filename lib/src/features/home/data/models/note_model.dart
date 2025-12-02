import 'dart:convert';

import 'package:Vairoo/src/features/home/domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.updatedAt,
  });

  factory NoteModel.fromNote(Note note) => NoteModel(
    id: note.id,
    title: note.title,
    content: note.content,
    updatedAt: note.updatedAt,
  );

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'updatedAt': updatedAt.toIso8601String(),
  };

  String toJsonString() => jsonEncode(toJson());

  static NoteModel fromJsonString(String source) =>
      NoteModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
