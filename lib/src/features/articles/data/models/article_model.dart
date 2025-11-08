import 'package:ai_note/src/features/articles/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.content,
    required super.publishedAt,
    super.coverImageUrl,
    super.author,
    super.tags = const [],
  });

  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      title: article.title,
      summary: article.summary,
      content: article.content,
      publishedAt: article.publishedAt,
      coverImageUrl: article.coverImageUrl,
      author: article.author,
      tags: List<String>.from(article.tags),
    );
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      content: json['content'] as String? ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      coverImageUrl: json['coverImageUrl'] as String?,
      author: json['author'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList(growable: false) ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'publishedAt': publishedAt.toIso8601String(),
      'coverImageUrl': coverImageUrl,
      'author': author,
      'tags': tags,
    };
  }
}
