import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderCircleButton extends StatelessWidget {
  const HeaderCircleButton({
    required this.icon,
    this.color,
    required this.onTap,
    super.key,
  });

  final SvgPicture icon;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color ?? Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
