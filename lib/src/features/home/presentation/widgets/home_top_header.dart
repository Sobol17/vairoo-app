import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/home_header_row.dart';
import 'package:flutter/material.dart';

class HomeTopHeader extends StatelessWidget {
  const HomeTopHeader({
    super.key,
    required this.onNotificationsTap,
    required this.onChatTap,
  });

  final VoidCallback onNotificationsTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        bottom: false,
        child: HomeHeaderRow(
          onChatTap: onChatTap,
          onNotificationsTap: onNotificationsTap,
        ),
      ),
    );
  }
}
