import 'package:equatable/equatable.dart';

import 'notification_category.dart';

class UserNotification extends Equatable {
  const UserNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.createdAt,
    this.iconAsset,
    this.isRead = false,
  });

  final String id;
  final NotificationCategory category;
  final String title;
  final String message;
  final DateTime createdAt;
  final String? iconAsset;
  final bool isRead;

  UserNotification copyWith({
    String? id,
    NotificationCategory? category,
    String? title,
    String? message,
    DateTime? createdAt,
    String? iconAsset,
    bool? isRead,
  }) {
    return UserNotification(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      iconAsset: iconAsset ?? this.iconAsset,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
    id,
    category,
    title,
    message,
    createdAt,
    iconAsset,
    isRead,
  ];
}
