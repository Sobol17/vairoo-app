import 'package:ai_note/src/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ai_note/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:ai_note/src/features/profile/data/models/profile_model.dart';
import 'package:ai_note/src/features/profile/domain/entities/profile.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileLocalDataSource localDataSource,
    required ProfileRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final ProfileLocalDataSource _localDataSource;
  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Profile> loadProfile() async {
    try {
      final payload = await _remoteDataSource.fetchProfile();
      final model = ProfileModel.fromJson(payload);
      await _localDataSource.saveProfile(model);
      return model;
    } catch (_) {
      return _localDataSource.readProfile();
    }
  }

  @override
  Future<void> saveProfile(Profile profile) {
    final model = ProfileModel.fromProfile(profile);
    return _localDataSource.saveProfile(model);
  }

  @override
  Future<void> updateBirthdate(DateTime date) async {
    await _remoteDataSource.updateProfile({'date_of_birth': _formatDate(date)});
    final stored = await _localDataSource.readProfile();
    final updated = stored.copyWith(birthDate: date);
    await saveProfile(updated);
  }

  @override
  Future<void> updateGoal(String goal) async {
    await _remoteDataSource.updateProfile({'goal': goal});
    final stored = await _localDataSource.readProfile();
    final updated = stored.copyWith(goal: goal);
    await saveProfile(updated);
  }

  @override
  Future<void> updateHabitSpending(double amount) async {
    await _remoteDataSource.updateProfile({'habit_spending': amount});
    final stored = await _localDataSource.readProfile();
    final updated = stored.copyWith(habitSpending: amount);
    await saveProfile(updated);
  }

  @override
  Future<Profile> updateProfileInfo(Profile profile) async {
    final payload = <String, dynamic>{
      'name': profile.name,
      'date_of_birth': profile.birthDate?.toIso8601String(),
      'email': profile.email,
      'sobriety_goal': profile.goal,
      'daily_spending': profile.dailyExpenses,
      'goal': profile.goal,
      'habit_spending': profile.habitSpending,
      'daily_calories': profile.dailyCalories,
      'push_notifications_enabled': profile.pushNotificationsEnabled,
      'email_notifications_enabled': profile.emailNotificationsEnabled,
    }..removeWhere((key, value) => value == null);
    await _remoteDataSource.updateProfile(payload);
    final fresh = await _remoteDataSource.fetchProfile();
    final model = ProfileModel.fromJson(fresh);
    await saveProfile(model);
    return model;
  }

  @override
  Future<void> clearProfile() {
    return _localDataSource.clear();
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }
}
