import 'package:shared_preferences/shared_preferences.dart';

/// Small facade over [SharedPreferences] to keep storage access testable.
class PreferencesStorage {
  PreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  SharedPreferences get instance => _prefs;

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> setStringList(String key, List<String> values) =>
      _prefs.setStringList(key, values);

  Future<bool> remove(String key) => _prefs.remove(key);
}
