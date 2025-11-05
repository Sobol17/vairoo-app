import 'package:ai_note/src/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:ai_note/src/features/notifications/data/models/notification_model.dart';
import 'package:ai_note/src/features/notifications/domain/entities/user_notification.dart';
import 'package:ai_note/src/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._localDataSource);

  final NotificationLocalDataSource _localDataSource;

  @override
  Future<List<UserNotification>> fetchNotifications() async {
    final models = await _localDataSource.fetchNotifications();
    return models;
  }

  @override
  Future<void> saveNotifications(List<UserNotification> notifications) async {
    final models = notifications
        .map(NotificationModel.fromEntity)
        .toList(growable: false);
    await _localDataSource.saveNotifications(models);
  }
}
