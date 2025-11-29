import 'package:ai_note/src/features/disclaimer/data/datasources/disclaimer_local_data_source.dart';
import 'package:ai_note/src/features/disclaimer/domain/entities/disclaimer_type.dart';
import 'package:ai_note/src/features/disclaimer/domain/repositories/disclaimer_repository.dart';

class DisclaimerRepositoryImpl implements DisclaimerRepository {
  DisclaimerRepositoryImpl(this._localDataSource);

  final DisclaimerLocalDataSource _localDataSource;

  @override
  Future<bool> isAccepted(DisclaimerType type) {
    return _localDataSource.isAccepted(type);
  }

  @override
  Future<void> markAccepted(DisclaimerType type) {
    return _localDataSource.markAccepted(type);
  }

  @override
  bool isAcceptedSync(DisclaimerType type) {
    return _localDataSource.isAcceptedSync(type);
  }
}
