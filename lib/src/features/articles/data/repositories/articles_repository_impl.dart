import 'package:ai_note/src/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:ai_note/src/features/articles/domain/entities/article.dart';
import 'package:ai_note/src/features/articles/domain/repositories/articles_repository.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  ArticlesRepositoryImpl({required ArticlesRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ArticlesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Article>> fetchArticles() {
    return _remoteDataSource.fetchArticles();
  }

  @override
  Future<Article> fetchArticleById(String id) {
    return _remoteDataSource.fetchArticleById(id);
  }
}
