import 'package:equatable/equatable.dart';

class Article extends Equatable {
  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedAt,
    this.coverImageUrl,
    this.author,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final DateTime publishedAt;
  final String? coverImageUrl;
  final String? author;
  final List<String> tags;

  Article copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    DateTime? publishedAt,
    String? coverImageUrl,
    String? author,
    List<String>? tags,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      author: author ?? this.author,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        content,
        publishedAt,
        coverImageUrl,
        author,
        tags,
      ];
}
