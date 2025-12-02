import 'package:flutter/foundation.dart';

import 'package:Vairoo/src/features/articles/domain/entities/article.dart';
import 'package:Vairoo/src/features/articles/domain/repositories/articles_repository.dart';

class ArticlesController extends ChangeNotifier {
  ArticlesController({required ArticlesRepository repository})
    : _repository = repository;

  final ArticlesRepository _repository;

  bool _isLoading = false;
  List<Article> _articles = const [];
  Article? _currentArticle;

  bool get isLoading => _isLoading;
  List<Article> get articles => List.unmodifiable(_articles);
  Article? get currentArticle => _currentArticle;

  Future<void> loadArticles({bool forceRefresh = false}) async {
    if (_articles.isNotEmpty && !forceRefresh) {
      return;
    }
    await _withLoading(() async {
      _articles = await _repository.fetchArticles();
    });
  }

  Future<Article> loadArticleById(String id, {bool preferCache = true}) async {
    if (preferCache) {
      Article? cached;
      for (final article in _articles) {
        if (article.id == id) {
          cached = article;
          break;
        }
      }
      if (cached != null) {
        _currentArticle = cached;
        notifyListeners();
      }
    }

    return _withLoading(() async {
      final article = await _repository.fetchArticleById(id);
      _currentArticle = article;
      final hasArticle = _articles.any((item) => item.id == article.id);
      if (hasArticle) {
        _articles = _articles
            .map((item) => item.id == article.id ? article : item)
            .toList(growable: false);
      } else {
        _articles = <Article>[..._articles, article];
      }
      return article;
    });
  }

  Future<T> _withLoading<T>(Future<T> Function() runner) async {
    _setLoading(true);
    try {
      return await runner();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }
}
