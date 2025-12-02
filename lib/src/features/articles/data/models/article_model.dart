import 'package:Vairoo/src/features/articles/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
    super.author,
  });

  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      title: article.title,
      subtitle: article.subtitle,
      content: article.content,
      createdAt: article.createdAt,
      updatedAt: article.updatedAt,
      author: article.author,
    );
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final createdAt =
        _parseDate(
          json['created_at'] as String? ?? json['createdAt'] as String?,
        ) ??
        DateTime.now();
    final updatedAt =
        _parseDate(
          json['updated_at'] as String? ?? json['updatedAt'] as String?,
        ) ??
        createdAt;
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      author: json['author'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'author': author,
    };
  }

  static DateTime? _parseDate(String? input) {
    if (input == null || input.isEmpty) {
      return null;
    }
    return DateTime.tryParse(input);
  }
}
