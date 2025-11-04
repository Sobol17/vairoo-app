import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ai_note/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:ai_note/src/features/profile/presentation/widgets/profile_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          appBar: AppBar(
            backgroundColor: AppColors.bgGray,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Профиль',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            leading: Transform.translate(
              offset: Offset(16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/chat.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.bgGray,
                        child: Image.asset('assets/icons/avatar.png'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: controller.isProfileComplete
                              ? () {}
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            disabledBackgroundColor: Colors.white,
                            disabledForegroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: BorderSide(
                                color: controller.isProfileComplete
                                    ? AppColors.secondary
                                    : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            textStyle: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Начать общаться'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Заполните недостающие данные своего профиля перед использованием чата!',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Статистика улучшений',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ProfileStatsCard(
                        sobrietyDuration: controller.sobrietyDuration,
                        sobrietyStartLabel: controller.sobrietyStartLabel,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
