import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';
import 'package:ai_note/src/features/plan/domain/entities/plan_completion_result.dart';

abstract class PlanRepository {
  Future<DailyPlan> startPlan();
  Future<DailyPlan> fetchCurrentPlan();
  Future<PlanCompletionResult> completeItem(String itemId);
}
