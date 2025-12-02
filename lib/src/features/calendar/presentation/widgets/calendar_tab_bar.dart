import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarTabBar extends StatelessWidget {
  const CalendarTabBar({
    required this.theme,
    this.todayLabel = 'Сегодня',
    super.key,
  });

  final ThemeData theme;
  final String todayLabel;

  @override
  Widget build(BuildContext context) {
    final labelStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    );
    final baseUnderline = AppColors.secondary.withValues(alpha: 0.25);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Row(
          children: List.generate(
            2,
            (_) => Expanded(child: Container(height: 3, color: baseUnderline)),
          ),
        ),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.zero,
          splashFactory: NoSplash.splashFactory,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.secondary, width: 3),
          ),
          labelColor: AppColors.secondary,
          unselectedLabelColor: AppColors.textGray,
          labelStyle: labelStyle,
          unselectedLabelStyle: labelStyle?.copyWith(color: AppColors.textGray),
          tabs: [
            Tab(text: todayLabel),
            const Tab(text: 'Всего'),
          ],
        ),
      ],
    );
  }
}
