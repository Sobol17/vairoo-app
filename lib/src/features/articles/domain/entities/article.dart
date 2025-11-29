import 'package:equatable/equatable.dart';

class Article extends Equatable {
  const Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.author,
  });

  final String id;
  final String title;
  final String subtitle;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? author;

  Article copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? author,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    content,
    createdAt,
    updatedAt,
    author,
  ];
}
