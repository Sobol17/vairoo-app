import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';

class PlanCompletionResult {
  const PlanCompletionResult({
    required this.plan,
    required this.canGoNextStep,
    required this.isDayCompleted,
  });

  final DailyPlan plan;
  final bool canGoNextStep;
  final bool isDayCompleted;
}
