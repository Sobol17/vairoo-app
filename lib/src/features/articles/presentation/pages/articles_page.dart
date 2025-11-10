import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/articles/domain/entities/article.dart';
import 'package:ai_note/src/features/articles/domain/repositories/articles_repository.dart';
import 'package:ai_note/src/features/articles/presentation/controllers/articles_controller.dart';
import 'package:ai_note/src/features/articles/presentation/widgets/articles_cart.dart';
import 'package:ai_note/src/features/articles/presentation/widgets/articles_empty_state.dart';
import 'package:ai_note/src/features/articles/presentation/widgets/articles_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArticlesController>(
      create: (context) =>
          ArticlesController(repository: context.read<ArticlesRepository>()),
      child: const _ArticlesView(),
    );
  }
}

class _ArticlesView extends StatefulWidget {
  const _ArticlesView();

  @override
  State<_ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<_ArticlesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadArticles();
    });
  }

  Future<void> _loadArticles({bool forceRefresh = false}) async {
    final controller = context.read<ArticlesController>();
    try {
      await controller.loadArticles(forceRefresh: forceRefresh);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить статьи: $error')),
      );
    }
  }

  Future<void> _onRefresh() => _loadArticles(forceRefresh: true);

  void _openArticleDetail(Article article) {
    context.push('/articles/article/${article.id}', extra: article);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ArticlesController>();
    final articles = controller.articles;

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: RefreshIndicator(
          color: AppColors.secondary,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: ArticlesHeader(
                  onBackPressed: () {
                    if (Navigator.canPop(context)) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                sliver: Builder(
                  builder: (context) {
                    if (controller.isLoading && articles.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 48),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    }
                    if (articles.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: ArticlesEmptyState(),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final article = articles[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == articles.length - 1 ? 0 : 16,
                          ),
                          child: ArticleCard(
                            article: article,
                            onTap: () => _openArticleDetail(article),
                          ),
                        );
                      }, childCount: articles.length),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
