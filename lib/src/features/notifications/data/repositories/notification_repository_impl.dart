import 'package:Vairoo/src/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:Vairoo/src/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:Vairoo/src/features/notifications/data/models/notification_model.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/user_notification.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dio/dio.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NotificationLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  @override
  Future<List<UserNotification>> fetchNotifications() async {
    try {
      final models = await _remoteDataSource.fetchNotifications();
      await _localDataSource.saveNotifications(models);
      return models;
    } on DioException {
      // Fallback to cached notifications if remote fails.
      return _localDataSource.fetchNotifications();
    }
  }

  @override
  Future<void> saveNotifications(List<UserNotification> notifications) async {
    final models = notifications
        .map(NotificationModel.fromEntity)
        .toList(growable: false);
    await _localDataSource.saveNotifications(models);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _remoteDataSource.deleteAllNotifications();
    await _localDataSource.clear();
  }
}
