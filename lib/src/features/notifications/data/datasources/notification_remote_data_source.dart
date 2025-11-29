import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/features/notifications/data/models/notification_model.dart';

class NotificationRemoteDataSource {
  NotificationRemoteDataSource(this._client);

  final ApiClient _client;
  static const _notificationsPath = '/api/client/notifications';

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _client.get<List<dynamic>>(_notificationsPath);
    final payload = response.data;
    if (payload == null) {
      return const [];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromApiJson)
        .toList(growable: false);
  }

  Future<void> deleteAllNotifications() async {
    await _client.delete<void>('$_notificationsPath/all');
  }
}
