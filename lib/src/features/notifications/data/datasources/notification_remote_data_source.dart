import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/notifications/data/models/notification_model.dart';

class NotificationRemoteDataSource {
  NotificationRemoteDataSource(this._client);

  final ApiClient _client;
  static const _notificationsPath = '/api/client/notifications';
  static const _deviceTokenPath = '$_notificationsPath/device-token';

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

  Future<void> registerDeviceToken(String token) async {
    await _client.post<void>(
      _deviceTokenPath,
      data: <String, dynamic>{'token': token},
    );
  }

  Future<void> deleteDeviceToken(String token) async {
    await _client.delete<void>(
      _deviceTokenPath,
      data: <String, dynamic>{'token': token},
    );
  }
}
