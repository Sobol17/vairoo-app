import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/circular_nav_button.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ai_note/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: (context) =>
          ProfileController(repository: context.read<ProfileRepository>())
            ..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: AppColors.bgGray,
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircularNavButton(
                              icon: Icons.chat_bubble_outline,
                              onPressed: () => context.push('/home/chat'),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Профиль',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Заложите прочный фундамент на день',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CircularNavButton(
                              icon: Icons.calendar_month_outlined,
                              onPressed: () => context.push('/calendar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: AppColors.secondaryLight,
                          child: Image.asset('assets/icons/avatar.png'),
                        ),
                        TextButton(
                          onPressed: () => context.push('/profile/edit'),
                          child: const Text('Изменить'),
                        ),
                        const SizedBox(height: 16),
                        _ProfileSection(
                          title: 'Персональная информация',
                          children: [
                            _ProfileInfoRow(
                              label: 'Имя',
                              value: controller.displayName,
                            ),
                            _ProfileInfoRow(
                              label: 'Дата рождения',
                              value: controller.birthDateLabel,
                            ),
                            _ProfileInfoRow(
                              label: 'Номер телефона',
                              value: controller.phoneLabel,
                            ),
                            _ProfileInfoRow(
                              label: 'Почта',
                              value: controller.emailLabel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ProfileSection(
                          title: 'Статистика улучшений',
                          children: [
                            _ProfileInfoRow(
                              label: 'Трезв',
                              value: controller.sobrietyDuration,
                              highlight: true,
                              showChevron: false,
                            ),
                            _ProfileInfoRow(
                              label: 'Дата начала трезвости',
                              value: controller.sobrietyStartLabel,
                              highlight: true,
                              showChevron: false,
                            ),
                            _ProfileInfoRow(
                              label: 'Затраты в день, в сред.',
                              value: controller.dailyExpensesLabel,
                              highlight: true,
                              showChevron: false,
                            ),
                            _ProfileInfoRow(
                              label: 'Ккал в день, в сред.',
                              value: controller.dailyCaloriesLabel,
                              showChevron: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _NotificationsSection(controller: controller),
                        const SizedBox(height: 24),
                        _ActionsSection(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.showChevron = true,
  });

  final String label;
  final String value;
  final bool highlight;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: AppColors.textPrimary,
    );

    final valueWidget = highlight
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textStyle)),
          valueWidget,
          if (showChevron)
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGray),
        ],
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Уведомления',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Пуш-уведомления'),
                subtitle: const Text('Вкл.'),
                value: controller.pushEnabled,
                activeColor: AppColors.secondary,
                onChanged: controller.togglePushNotifications,
              ),
              const Divider(height: 0),
              SwitchListTile(
                title: const Text('Сообщения на почту'),
                subtitle: const Text('Вкл.'),
                value: controller.emailEnabled,
                activeColor: AppColors.secondary,
                onChanged: controller.toggleEmailNotifications,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.secondary,
      fontWeight: FontWeight.w600,
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Сбросить все данные', style: style),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Выйти', style: style),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Удалить профиль', style: style),
          ),
        ],
      ),
    );
  }
}
