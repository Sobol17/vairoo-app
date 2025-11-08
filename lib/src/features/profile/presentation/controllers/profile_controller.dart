import 'package:ai_note/src/features/profile/domain/entities/profile.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;
  final Formatter _formatter = Formatter();

  Profile _profile = const Profile(name: '', sobrietyStartDate: null);
  bool _isLoading = false;

  Profile get profile => _profile;
  bool get isLoading => _isLoading;

  String get displayName => _profile.name.isEmpty ? 'Имя' : _profile.name;

  String get sobrietyDuration {
    final start = _profile.sobrietyStartDate;
    if (start == null) {
      return '—';
    }
    final days =
        DateTime.now()
            .difference(DateTime(start.year, start.month, start.day))
            .inDays +
        1;
    return '$days ${_pluralDays(days)}';
  }

  String get sobrietyStartLabel {
    final start = _profile.sobrietyStartDate;
    if (start == null) {
      return '—';
    }
    return _formatter.formatFullDate(start);
  }

  String get birthDateLabel {
    final birth = _profile.birthDate;
    if (birth == null) {
      return 'Добавить';
    }
    return _formatter.formatFullDate(birth);
  }

  String get phoneLabel =>
      _profile.phone?.isNotEmpty == true ? _profile.phone! : 'Добавить';

  String get emailLabel =>
      _profile.email?.isNotEmpty == true ? _profile.email! : 'Добавить';

  String get dailyExpensesLabel => _profile.dailyExpenses != null
      ? '${_profile.dailyExpenses!.toStringAsFixed(0)} руб.'
      : 'Добавить';

  String get dailyCaloriesLabel => _profile.dailyCalories != null
      ? _profile.dailyCalories!.toStringAsFixed(0)
      : 'Добавить';

  bool get pushEnabled => _profile.pushNotificationsEnabled;
  bool get emailEnabled => _profile.emailNotificationsEnabled;

  bool get isProfileComplete => _profile.isComplete;

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      final profile = await _repository.loadProfile();
      _profile = profile;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile(Profile profile) async {
    _profile = profile;
    notifyListeners();
    await _repository.saveProfile(profile);
  }

  Future<void> togglePushNotifications(bool value) async {
    final updated = _profile.copyWith(pushNotificationsEnabled: value);
    await updateProfile(updated);
  }

  Future<void> toggleEmailNotifications(bool value) async {
    final updated = _profile.copyWith(emailNotificationsEnabled: value);
    await updateProfile(updated);
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }

  String _pluralDays(int days) {
    final mod10 = days % 10;
    final mod100 = days % 100;
    if (mod10 == 1 && mod100 != 11) {
      return 'день';
    }
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return 'дня';
    }
    return 'дней';
  }
}
