import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/articles/domain/entities/article.dart';
import 'package:Vairoo/src/features/articles/domain/repositories/articles_repository.dart';
import 'package:Vairoo/src/features/articles/presentation/widgets/article_body.dart';
import 'package:Vairoo/src/features/articles/presentation/widgets/article_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: _ArticleDetailContent(article: article),
      ),
    );
  }
}

class _ArticleDetailContent extends StatefulWidget {
  const _ArticleDetailContent({required this.article});

  final Article article;

  @override
  State<_ArticleDetailContent> createState() => _ArticleDetailContentState();
}

class _ArticleDetailContentState extends State<_ArticleDetailContent> {
  Article? _article;
  bool _isLoading = false;
  String? _error;

  Article get _displayArticle => _article ?? widget.article;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadArticle());
  }

  Future<void> _loadArticle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repository = context.read<ArticlesRepository>();
      final result = await repository.fetchArticleById(widget.article.id);
      setState(() {
        _article = result;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                ArticleDetailHeader(article: _displayArticle),
                if (_isLoading)
                  const LinearProgressIndicator(
                    minHeight: 3,
                    color: AppColors.secondary,
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Не удалось загрузить статью: $_error',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: ArticleBody(article: _displayArticle),
          ),
        ],
      ),
    );
  }
}
