import 'package:ai_note/src/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<void> requestOtp({required String phoneNumber});

  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<AuthSession?> loadSession();
}
