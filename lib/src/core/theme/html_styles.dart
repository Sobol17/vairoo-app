import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Map<String, Style> htmlStyles(BuildContext context) {
  final theme = Theme.of(context);
  final body = theme.textTheme.bodyLarge;
  return {
    'body': Style(
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
      color: AppColors.textPrimary,
      fontSize: FontSize(body?.fontSize ?? 16),
      fontFamily: body?.fontFamily,
      fontWeight: body?.fontWeight,
      lineHeight: LineHeight(body?.height ?? 1.5),
    ),
    'p': Style(margin: Margins.only(bottom: 16)),
    'li': Style(
      margin: Margins.only(bottom: 12),
      padding: HtmlPaddings.zero,
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w500,
      listStylePosition: ListStylePosition.outside,
    ),
    'ul': Style(margin: Margins.only(bottom: 4, left: 12)),
    'ol': Style(margin: Margins.only(bottom: 4, left: 12)),
    'strong': Style(fontWeight: FontWeight.w700),
    'h3': Style(
      fontSize: FontSize((theme.textTheme.titleLarge?.fontSize ?? 20)),
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      margin: Margins.only(top: 8, bottom: 12),
    ),
  };
}
