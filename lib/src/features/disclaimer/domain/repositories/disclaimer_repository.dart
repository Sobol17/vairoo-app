import 'package:ai_note/src/features/disclaimer/domain/entities/disclaimer_type.dart';

abstract class DisclaimerRepository {
  Future<bool> isAccepted(DisclaimerType type);

  Future<void> markAccepted(DisclaimerType type);

  bool isAcceptedSync(DisclaimerType type);
}
