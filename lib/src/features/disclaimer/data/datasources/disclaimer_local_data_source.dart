import 'package:ai_note/src/core/storage/preferences_storage.dart';
import 'package:ai_note/src/features/disclaimer/domain/entities/disclaimer_type.dart';

class DisclaimerLocalDataSource {
  DisclaimerLocalDataSource(this._storage);

  final PreferencesStorage _storage;

  Future<bool> isAccepted(DisclaimerType type) async =>
      _storage.getBool(_key(type)) ?? false;

  Future<void> markAccepted(DisclaimerType type) async {
    await _storage.setBool(_key(type), true);
  }

  String _key(DisclaimerType type) => 'disclaimer_${type.name}_accepted';
}
