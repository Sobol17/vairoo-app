import 'package:ai_note/src/features/notifications/domain/entities/user_notification.dart';

abstract class NotificationRepository {
  Future<List<UserNotification>> fetchNotifications();
  Future<void> saveNotifications(List<UserNotification> notifications);
}
