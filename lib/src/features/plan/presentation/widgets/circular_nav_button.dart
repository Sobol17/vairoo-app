import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CircularNavButton extends StatelessWidget {
  const CircularNavButton({required this.icon, this.onPressed, super.key});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.secondary),
        ),
      ),
    );
  }
}
