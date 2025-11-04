import 'package:ai_note/src/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> loadProfile();
  Future<void> saveProfile(Profile profile);
}
