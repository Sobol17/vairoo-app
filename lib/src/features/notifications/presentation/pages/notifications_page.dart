import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/notification_category.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/notification_samples.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/chats_repository.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:Vairoo/src/features/notifications/presentation/controllers/chats_controller.dart';
import 'package:Vairoo/src/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/category_switcher.dart';
import 'package:Vairoo/src/features/notifications/presentation/widgets/nofitications_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key, this.initialCategory});

  final NotificationCategory? initialCategory;

  static Future<void> _handleDeletePressed(
    BuildContext context,
    NotificationsController controller,
  ) async {
    final hasSelection = controller.hasSelection;
    final message = hasSelection
        ? 'Удалить выбранные уведомления?'
        : 'Удалить все уведомления в разделе "${controller.selectedCategory.label}"?';
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Подтверждение'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Удалить'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirm) {
      return;
    }

    if (hasSelection) {
      await controller.deleteSelected();
    } else {
      final category = controller.selectedCategory;
      if (category == NotificationCategory.system) {
        await controller.deleteAll();
      } else {
        await controller.deleteCurrentCategory();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationsController>(
          create: (context) => NotificationsController(
            repository: context.read<NotificationRepository>(),
            seed: defaultNotificationsSeed(),
            initialCategory: initialCategory,
          )..loadNotifications(allowSeed: true),
        ),
        ChangeNotifierProvider<ChatsController>(
          create: (context) =>
              ChatsController(repository: context.read<ChatsRepository>())
                ..loadChats(),
        ),
      ],
      child: Consumer2<NotificationsController, ChatsController>(
        builder: (context, notificationController, chatsController, _) {
          final theme = Theme.of(context);
          final isChatTab =
              notificationController.selectedCategory ==
              NotificationCategory.chat;

          return Scaffold(
            backgroundColor: AppColors.bgGray,
            appBar: AppBar(
              backgroundColor: AppColors.bgGray,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 120,
              titleSpacing: 0,
              actionsPadding: EdgeInsets.only(right: 16),
              leading: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    foregroundColor: AppColors.primary,
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  label: const Text('Назад'),
                ),
              ),
              actions: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    tooltip: notificationController.hasSelection
                        ? 'Удалить выбранные'
                        : 'Очистить список',
                    onPressed: isChatTab
                        ? null
                        : (notificationController.hasSelection ||
                              notificationController.hasNotifications)
                        ? () => _handleDeletePressed(
                            context,
                            notificationController,
                          )
                        : null,
                    icon: SvgPicture.asset('assets/icons/backet.svg'),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: notificationController.isLoading && !isChatTab
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Уведомления',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CategorySwitcher(
                            selected: notificationController.selectedCategory,
                            onCategorySelected:
                                notificationController.selectCategory,
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: NotificationsBody(
                              notificationsController: notificationController,
                              chatsController: chatsController,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
