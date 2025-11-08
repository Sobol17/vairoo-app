import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/plan/data/plan_samples.dart';
import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/circular_nav_button.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/plan_activity_card.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/reality_check_card.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';

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
                      leading: Transform.translate(
                        offset: Offset(16, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircularNavButton(
                            icon: Icons.chevron_left,
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                        ),
                      ),
                      actions: const [
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: CircularNavButton(
                            icon: Icons.notifications_none,
                          ),
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
                          return PlanActivityCard(activity: activity);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: planData.activities.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        child: RealityCheckCard(
                          realityCheck: planData.realityCheck,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 12,
                      top: 12,
                    ),
                    color: Colors.white,
                    child: PrimaryButton(
                      label: planData.realityCheck.ctaLabel,
                      onPressed: () {},
                      isLoading: false,
                    ),
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
