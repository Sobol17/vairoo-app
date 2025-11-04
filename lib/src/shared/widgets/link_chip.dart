import 'package:flutter/material.dart';

class LinkChip extends StatelessWidget {
  const LinkChip({
    required this.label,
    required this.style,
    required this.onTap,
    super.key,
  });

  final String label;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(label, style: style),
      ),
    );
  }
}
