import 'dart:convert';

import 'package:ai_note/src/features/notifications/domain/entities/notification_category.dart';
import 'package:ai_note/src/features/notifications/domain/entities/user_notification.dart';

class NotificationModel extends UserNotification {
  const NotificationModel({
    required super.id,
    required super.category,
    required super.title,
    required super.message,
    required super.createdAt,
    super.iconAsset,
    super.isRead,
  });

  factory NotificationModel.fromEntity(UserNotification notification) {
    return NotificationModel(
      id: notification.id,
      category: notification.category,
      title: notification.title,
      message: notification.message,
      createdAt: notification.createdAt,
      iconAsset: notification.iconAsset,
      isRead: notification.isRead,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      category: NotificationCategory.fromStorage(json['category'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      iconAsset: json['iconAsset'] as String?,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  factory NotificationModel.fromApiJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      category: NotificationCategory.system,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'iconAsset': iconAsset,
      'isRead': isRead,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static NotificationModel fromJsonString(String source) {
    return NotificationModel.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}
