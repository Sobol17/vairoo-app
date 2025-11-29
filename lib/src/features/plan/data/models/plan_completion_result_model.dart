import 'package:ai_note/src/features/plan/data/models/daily_plan_model.dart';
import 'package:ai_note/src/features/plan/domain/entities/plan_completion_result.dart';

class PlanCompletionResultModel extends PlanCompletionResult {
  PlanCompletionResultModel({
    required super.plan,
    required super.canGoNextStep,
    required super.isDayCompleted,
  });

  factory PlanCompletionResultModel.fromJson(Map<String, dynamic> json) {
    final planJson = json['plan'] as Map<String, dynamic>? ?? const {};
    return PlanCompletionResultModel(
      plan: DailyPlanModel.fromJson(planJson),
      canGoNextStep: json['can_go_next_step'] as bool? ?? false,
      isDayCompleted: json['is_day_completed'] as bool? ?? false,
    );
  }
}
