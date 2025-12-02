import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({required this.data, super.key});

  final ChatDetailData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    );
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.textGray,
      fontWeight: FontWeight.w500,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.secondary.withValues(alpha: 0.16),
            backgroundImage: data.avatarAsset != null
                ? AssetImage(data.avatarAsset!)
                : null,
            child: data.avatarAsset == null
                ? const Icon(
                    Icons.person_outline,
                    color: AppColors.secondary,
                    size: 28,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.consultantName} \n (${data.consultantRole})',
                style: titleStyle,
              ),
              const SizedBox(height: 4),
              Text('На связи сейчас', style: subtitleStyle),
            ],
          ),
        ],
      ),
    );
  }
}
