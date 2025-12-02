import 'package:Vairoo/src/core/theme/html_styles.dart';
import 'package:Vairoo/src/features/articles/domain/entities/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleBody extends StatelessWidget {
  const ArticleBody({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Html(
            data: article.content,
            shrinkWrap: true,
            style: htmlStyles(context),
          ),
          SizedBox(height: bottomInset + 16),
        ],
      ),
    );
  }
}
