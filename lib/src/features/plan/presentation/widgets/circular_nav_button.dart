import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CircularNavButton extends StatelessWidget {
  const CircularNavButton({required this.icon, this.onPressed, super.key});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        onTap: () {
          context.push('/home/notifications');
        },
        child: IconButton(
          icon: Icon(icon, color: AppColors.primary),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
