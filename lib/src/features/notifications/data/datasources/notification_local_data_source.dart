import 'package:Vairoo/src/core/storage/preferences_storage.dart';
import 'package:Vairoo/src/features/notifications/data/models/notification_model.dart';

const _notificationsStorageKey = 'notifications.items';

class NotificationLocalDataSource {
  NotificationLocalDataSource(this._storage);

  final PreferencesStorage _storage;

  Future<List<NotificationModel>> fetchNotifications() async {
    final serialized = _storage.getStringList(_notificationsStorageKey);
    if (serialized == null) {
      return [];
    }

    return serialized
        .map(NotificationModel.fromJsonString)
        .toList(growable: false);
  }

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    if (notifications.isEmpty) {
      await _storage.remove(_notificationsStorageKey);
      return;
    }

    await _storage.setStringList(
      _notificationsStorageKey,
      notifications.map((item) => item.toJsonString()).toList(),
    );
  }

  Future<void> clear() => _storage.remove(_notificationsStorageKey);
}
