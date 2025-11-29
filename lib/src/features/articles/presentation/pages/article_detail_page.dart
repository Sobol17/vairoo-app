import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/articles/domain/entities/article.dart';
import 'package:ai_note/src/features/articles/presentation/widgets/article_body.dart';
import 'package:ai_note/src/features/articles/presentation/widgets/article_detail_header.dart';
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

class _ArticleDetailContent extends StatelessWidget {
  const _ArticleDetailContent({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(child: ArticleDetailHeader(article: article)),
          SliverFillRemaining(
            hasScrollBody: true,
            child: ArticleBody(article: article),
          ),
        ],
      ),
    );
  }
}
