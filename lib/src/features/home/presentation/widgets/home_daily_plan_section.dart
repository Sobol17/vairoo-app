import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/home/domain/entities/home_plan.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/routine_card.dart';
import 'package:flutter/material.dart';

class HomeDailyPlanSection extends StatefulWidget {
  const HomeDailyPlanSection({
    super.key,
    required this.dayLabel,
    required this.planDate,
    required this.routines,
    required this.onRoutineTap,
  });

  final String dayLabel;
  final DateTime planDate;
  final List<HomeRoutinePlan> routines;
  final ValueChanged<HomeRoutinePlan> onRoutineTap;

  @override
  State<HomeDailyPlanSection> createState() => _HomeDailyPlanSectionState();
}

class _HomeDailyPlanSectionState extends State<HomeDailyPlanSection> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate =
        '${widget.planDate.day.toString().padLeft(2, '0')}.${widget.planDate.month.toString().padLeft(2, '0')}.${widget.planDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.dayLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              formattedDate,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.routines.length,
            padEnds: false,
            itemBuilder: (context, index) {
              final plan = widget.routines[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == widget.routines.length - 1 ? 0 : 16,
                ),
                child: RoutineCard(
                  plan: plan,
                  onTap: () => widget.onRoutineTap(plan),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
