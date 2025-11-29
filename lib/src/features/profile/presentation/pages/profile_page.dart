import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/home/presentation/widgets/header_circle_button.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ai_note/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:ai_note/src/features/profile/presentation/widgets/actions_section.dart';
import 'package:ai_note/src/features/profile/presentation/widgets/notifications_section.dart';
import 'package:ai_note/src/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:ai_note/src/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                            HeaderCircleButton(
                              color: AppColors.surface,
                              icon: SvgPicture.asset(
                                'assets/icons/chat.svg',
                                width: 20,
                              ),
                              onTap: () => context.push('/home/chat'),
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
                            HeaderCircleButton(
                              color: AppColors.surface,
                              icon: SvgPicture.asset(
                                'assets/icons/calendar.svg',
                                width: 20,
                              ),
                              onTap: () => context.push('/calendar'),
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
                          onPressed: () async {
                            final updated = await context.push('/profile/edit');
                            if (updated == true) {
                              // ignore: use_build_context_synchronously
                              await controller.loadProfile();
                            }
                          },
                          child: const Text('Изменить'),
                        ),
                        const SizedBox(height: 16),
                        ProfileSection(
                          title: 'Персональная информация',
                          children: [
                            ProfileInfoRow(
                              label: 'Имя',
                              value: controller.displayName,
                            ),
                            ProfileInfoRow(
                              label: 'Дата рождения',
                              value: controller.birthDateLabel,
                            ),
                            ProfileInfoRow(
                              label: 'Номер телефона',
                              value: controller.phoneLabel,
                            ),
                            ProfileInfoRow(
                              label: 'Почта',
                              value: controller.emailLabel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ProfileSection(
                          title: 'Статистика улучшений',
                          children: [
                            ProfileInfoRow(
                              label: 'Трезв',
                              value: controller.sobrietyDuration,
                              highlight: true,
                              showChevron: false,
                            ),
                            ProfileInfoRow(
                              label: 'Дата начала трезвости',
                              value: controller.sobrietyStartLabel,
                              highlight: true,
                              showChevron: false,
                            ),
                            ProfileInfoRow(
                              label: 'Затраты в день, в сред.',
                              value: controller.dailyExpensesLabel,
                              highlight: true,
                              showChevron: false,
                            ),
                            ProfileInfoRow(
                              label: 'Ккал в день, в сред.',
                              value: controller.dailyCaloriesLabel,
                              showChevron: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        NotificationsSection(controller: controller),
                        const SizedBox(height: 24),
                        ActionsSection(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
