import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.actionColor,
    this.icon = Icons.chevron_left_rounded,
    super.key,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final Color? actionColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: SizedBox(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onAction,
                icon: Icon(icon),
                label: Text(actionLabel),
                style: TextButton.styleFrom(
                  foregroundColor: actionColor ?? AppColors.secondary,
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
