import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/plan/data/plan_samples.dart';
import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key, this.plan});

  final DailyPlan? plan;

  DailyPlan get _plan => plan ?? sampleDayPlan;

  @override
  Widget build(BuildContext context) {
    final planData = _plan;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 176, 253, 243),
                  Color.fromARGB(255, 247, 247, 247),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverAppBar(
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      toolbarHeight: 58,
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            planData.period,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            planData.subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primary,
                        ),
                        onPressed: () => context.push('/home'),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: AppColors.primary,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: MediaQuery.of(context).padding.top + 16,
                        bottom: 12,
                      ),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          final activity = planData.activities[index];
                          return _PlanActivityCard(activity: activity);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: planData.activities.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        child: _RealityCheckCard(
                          realityCheck: planData.realityCheck,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: PrimaryButton(
                    label: planData.realityCheck.ctaLabel,
                    onPressed: () {},
                    isLoading: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanActivityCard extends StatelessWidget {
  const _PlanActivityCard({required this.activity});

  final PlanActivity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  activity.icon ?? Icons.auto_awesome,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(activity.primaryActionLabel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(activity.secondaryActionLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RealityCheckCard extends StatelessWidget {
  const _RealityCheckCard({required this.realityCheck});

  final RealityCheck realityCheck;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            realityCheck.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            realityCheck.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
