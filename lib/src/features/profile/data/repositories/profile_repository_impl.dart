import 'package:ai_note/src/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ai_note/src/features/profile/data/models/profile_model.dart';
import 'package:ai_note/src/features/profile/domain/entities/profile.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<Profile> loadProfile() => _localDataSource.readProfile();

  @override
  Future<void> saveProfile(Profile profile) {
    final model = ProfileModel(
      name: profile.name,
      sobrietyStartDate: profile.sobrietyStartDate,
    );
    return _localDataSource.saveProfile(model);
  }
}
