import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            _emptyStateIllustration,
            width: 160,
            height: 160,
          ),
          const SizedBox(height: 24),
          Text(
            'Заметок пока нет',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте первую заметку, чтобы начать работать с AI Note.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

const _emptyStateIllustration = '''
<svg width="160" height="160" viewBox="0 0 160 160" xmlns="http://www.w3.org/2000/svg">
  <rect x="20" y="32" width="120" height="96" rx="16" fill="#E8EAF6"/>
  <rect x="36" y="52" width="72" height="10" rx="5" fill="#C5CAE9"/>
  <rect x="36" y="72" width="92" height="10" rx="5" fill="#C5CAE9"/>
  <rect x="36" y="92" width="84" height="10" rx="5" fill="#C5CAE9"/>
  <circle cx="114" cy="58" r="14" fill="#B39DDB"/>
  <path d="M114 50 L118 58 H110 Z" fill="#FFFFFF" opacity="0.9"/>
  <rect x="52" y="112" width="56" height="20" rx="10" fill="#D1C4E9"/>
  <path d="M88 118 C88 122.418 84.418 126 80 126 C75.582 126 72 122.418 72 118" stroke="#9575CD" stroke-width="4" fill="none"/>
</svg>
''';
