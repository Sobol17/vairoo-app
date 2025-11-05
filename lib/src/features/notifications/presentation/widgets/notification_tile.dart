import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/notifications/domain/entities/user_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  final UserNotification notification;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.textBlack,
    );
    final messageStyle = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
    );

    final tileColor = isSelected
        ? AppColors.secondary.withValues(alpha: 0.16)
        : AppColors.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(asset: notification.iconAsset),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.title, style: titleStyle),
                    const SizedBox(height: 4),
                    Text(notification.message, style: messageStyle),
                  ],
                ),
              ),
              if (isSelectionMode) ...[
                const SizedBox(width: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    key: ValueKey<bool>(isSelected),
                    color: isSelected ? AppColors.secondary : AppColors.gray,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({this.asset});

  final String? asset;

  @override
  Widget build(BuildContext context) {
    final size = 48.0;
    final accent = AppColors.secondary.withValues(alpha: 0.16);
    Widget child;

    if (asset == null) {
      child = const Icon(
        Icons.notifications_none_rounded,
        color: AppColors.secondary,
        size: 26,
      );
    } else if (asset!.endsWith('.svg')) {
      child = SvgPicture.asset(
        asset!,
        width: 28,
        height: 28,
        colorFilter: const ColorFilter.mode(
          AppColors.secondary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      );
    } else {
      child = Image.asset(asset!, width: 28, height: 28, fit: BoxFit.contain);
    }

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
