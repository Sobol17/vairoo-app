import 'package:Vairoo/src/features/articles/domain/entities/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> fetchArticles();
  Future<Article> fetchArticleById(String id);
}
