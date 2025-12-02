import 'package:Vairoo/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:Vairoo/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:Vairoo/src/features/auth/domain/entities/auth_session.dart';
import 'package:Vairoo/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<void> requestOtp({required String phoneNumber}) {
    return _remoteDataSource.requestOtp(phoneNumber);
  }

  @override
  Future<void> requestSmsOtp({required String phoneNumber}) {
    return _remoteDataSource.requestOtpSms(phoneNumber);
  }

  @override
  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final sessionModel = await _remoteDataSource.verifyOtp(
      phoneNumber: phoneNumber,
      code: code,
    );

    await _localDataSource.saveSession(sessionModel);

    return sessionModel;
  }

  @override
  Future<AuthSession?> loadSession() {
    return _localDataSource.loadSession();
  }

  @override
  Future<void> clearSession() {
    return _localDataSource.clearSession();
  }
}
