import 'package:ai_note/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.onBack, required this.isLoading, super.key});

  final VoidCallback? onBack;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const BrandLogo(),
          if (onBack != null)
            Positioned(
              left: -15,
              top: -8,
              child: TextButton.icon(
                onPressed: isLoading ? null : onBack,
                icon: const Icon(Icons.chevron_left_rounded),
                label: const Text('Назад'),
                style: TextButton.styleFrom(
                  foregroundColor: color,
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
