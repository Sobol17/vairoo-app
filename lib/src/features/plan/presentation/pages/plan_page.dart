import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';
import 'package:ai_note/src/features/plan/presentation/controllers/plan_controller.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/circular_nav_button.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/plan_activity_card.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/plan_info_card.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/plan_step_content.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlanController>();
    final plan = controller.plan;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: plan == null
                ? _buildEmptyState(controller)
                : _buildPlanView(controller, plan),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
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
    );
  }

  Widget _buildEmptyState(PlanController controller) {
    final theme = Theme.of(context);
    final errorMessage = controller.errorMessage;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isLoading)
              const CircularProgressIndicator()
            else ...[
              Text(
                errorMessage ?? 'Не удалось загрузить план на сегодня',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Попробовать снова',
                onPressed: controller.isLoading
                    ? null
                    : () => controller.createOrFetchPlan(),
                isLoading: controller.isLoading,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanView(PlanController controller, DailyPlan plan) {
    final currentStep = controller.visibleStep;
    final content = getPlanStepContent(currentStep);
    final activities = plan.blocks.itemsForStep(currentStep);

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _buildSliverAppBar(currentStep, content),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (activities.isEmpty)
                      _buildEmptyActivities()
                    else ...
                      activities.map(
                        (activity) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PlanActivityCard(
                            activity: activity,
                            onPrimaryTap: _buildPrimaryAction(activity),
                            isCompleting:
                                controller.completingItemId == activity.id,
                            onMarkComplete: () =>
                                controller.completeItem(activity.id),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    PlanInfoCard(
                      title: content.infoTitle,
                      description: content.infoDescription,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 160,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        _buildBottomBar(controller, plan, currentStep, content),
        if (controller.isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }

  Widget _buildEmptyActivities() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        'Активности этого этапа скоро появятся',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(PlanStep step, PlanStepContent content) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 72,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            step.label,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            content.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: CircularNavButton(
          icon: Icons.chevron_left,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircularNavButton(
            icon: Icons.notifications_none,
            onPressed: () => context.push('/home/notifications'),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    PlanController controller,
    DailyPlan plan,
    PlanStep currentStep,
    PlanStepContent content,
  ) {
    final isDayCompleted = controller.isDayCompleted || plan.isCompleted;
    final canGoNext = controller.canGoNextStep && !isDayCompleted;
    final actionError = controller.actionErrorMessage;
    final isFinished = currentStep == PlanStep.finished;
    final label = isDayCompleted && !canGoNext && !isFinished
        ? 'День завершен'
        : content.ctaLabel;

    VoidCallback? onPressed;
    if (isFinished) {
      onPressed = () => Navigator.of(context).maybePop();
    } else if (isDayCompleted) {
      onPressed = () => Navigator.of(context).maybePop();
    } else if (canGoNext) {
      onPressed = controller.showCurrentStep;
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (actionError != null) ...[
                Text(
                  actionError,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              PrimaryButton(
                label: label,
                onPressed: onPressed,
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback? _buildPrimaryAction(PlanActivityItem activity) {
    final route = _resolvePrimaryRoute(activity);
    if (route == null) {
      return null;
    }
    return () => context.push(route);
  }

  String? _resolvePrimaryRoute(PlanActivityItem activity) {
    final type = activity.type?.toLowerCase();
    switch (type) {
      case 'recipes':
        return '/home/recipes';
      case 'trainings':
        return '/practice';
      case 'rituals':
        return '/practice/breathing';
      case 'journal':
        return '/calendar';
      default:
        return null;
    }
  }
}
