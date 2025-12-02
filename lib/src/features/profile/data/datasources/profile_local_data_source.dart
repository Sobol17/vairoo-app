import 'package:Vairoo/src/core/storage/preferences_storage.dart';
import 'package:Vairoo/src/features/profile/data/models/profile_model.dart';

class ProfileLocalDataSource {
  ProfileLocalDataSource(this._storage);

  static const _profileKey = 'profile_data';

  final PreferencesStorage _storage;

  Future<ProfileModel> readProfile() async {
    final stored = _storage.getString(_profileKey);
    if (stored == null || stored.isEmpty) {
      return const ProfileModel.empty();
    }
    try {
      return ProfileModel.fromEncoded(stored);
    } catch (_) {
      return const ProfileModel.empty();
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    await _storage.setString(_profileKey, profile.toEncodedJson());
  }

  Future<void> clear() => _storage.remove(_profileKey);
}
