import 'package:ai_note/src/features/plan/data/datasources/plan_remote_data_source.dart';
import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';
import 'package:ai_note/src/features/plan/domain/entities/plan_completion_result.dart';
import 'package:ai_note/src/features/plan/domain/repositories/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  const PlanRepositoryImpl({required PlanRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final PlanRemoteDataSource _remoteDataSource;

  @override
  Future<DailyPlan> startPlan() {
    return _remoteDataSource.startPlan();
  }

  @override
  Future<DailyPlan> fetchCurrentPlan() {
    return _remoteDataSource.fetchCurrentPlan();
  }

  @override
  Future<PlanCompletionResult> completeItem(String itemId) {
    return _remoteDataSource.completeItem(itemId);
  }
}
