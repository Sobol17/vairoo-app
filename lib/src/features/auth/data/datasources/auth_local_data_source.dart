import 'package:Vairoo/src/core/storage/preferences_storage.dart';
import 'package:Vairoo/src/features/auth/data/models/auth_session_model.dart';

const _authSessionKey = 'auth.session';

class AuthLocalDataSource {
  AuthLocalDataSource(this._storage);

  final PreferencesStorage _storage;

  Future<void> saveSession(AuthSessionModel session) async {
    await _storage.setString(_authSessionKey, session.toJsonString());
  }

  Future<AuthSessionModel?> loadSession() async {
    final serialized = _storage.getString(_authSessionKey);
    if (serialized == null) {
      return null;
    }

    try {
      return AuthSessionModel.fromJsonString(serialized);
    } on FormatException {
      // Corrupted or legacy payload — drop it silently.
      await clearSession();
      return null;
    }
  }

  Future<void> clearSession() async {
    await _storage.remove(_authSessionKey);
  }
}
