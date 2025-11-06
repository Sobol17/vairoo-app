import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/logo.svg',
          height: 25,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            color ?? theme.colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
