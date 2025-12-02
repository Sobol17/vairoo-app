import 'package:Vairoo/src/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<void> requestOtp({required String phoneNumber});
  Future<void> requestSmsOtp({required String phoneNumber});

  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<AuthSession?> loadSession();

  Future<void> clearSession();
}
