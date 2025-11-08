import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/core/theme/html_styles.dart';
import 'package:ai_note/src/features/articles/domain/entities/article.dart';
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
          if ((article.coverImageUrl ?? '').isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  article.coverImageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }
                    return Container(
                      color: AppColors.secondaryLight,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    );
                  },
                  errorBuilder: (context, _, __) {
                    return Container(
                      color: AppColors.secondaryLight,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
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
