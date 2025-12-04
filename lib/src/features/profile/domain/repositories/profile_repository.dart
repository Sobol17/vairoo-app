import 'package:Vairoo/src/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> loadProfile();
  Future<void> saveProfile(Profile profile);

  Future<void> updateBirthdate(DateTime date);
  Future<void> updateGoal(String goal);
  Future<void> updateHabitSpending(double amount);
  Future<void> updateDailyExpenses(double amount);
  Future<void> updateDailyCalories(double amount);

  Future<void> clearProfile();

  Future<Profile> updateProfileInfo(Profile profile);
  Future<void> acknowledgeAchievement(ProfileAchievementType type);
}
