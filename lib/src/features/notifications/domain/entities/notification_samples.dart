import 'package:ai_note/src/features/notifications/domain/entities/notification_category.dart';
import 'package:ai_note/src/features/notifications/domain/entities/user_notification.dart';

List<UserNotification> defaultNotificationsSeed() {
  final now = DateTime.now();
  return [
    UserNotification(
      id: 'system-1',
      category: NotificationCategory.system,
      title: 'Награда получена',
      message: 'Первый день трезвости!',
      createdAt: now.subtract(const Duration(hours: 3)),
      iconAsset: 'assets/icons/goal_bg.svg',
    ),
    UserNotification(
      id: 'system-2',
      category: NotificationCategory.system,
      title: 'Вы активировали план',
      message: 'Отлично, начало положено',
      createdAt: now.subtract(const Duration(hours: 5)),
      iconAsset: 'assets/icons/calendar.svg',
    ),
    UserNotification(
      id: 'chat-1',
      category: NotificationCategory.chat,
      title: 'Новое сообщение',
      message: 'Консультант ответил на ваш вопрос.',
      createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      iconAsset: 'assets/icons/chat.svg',
    ),
  ];
}
