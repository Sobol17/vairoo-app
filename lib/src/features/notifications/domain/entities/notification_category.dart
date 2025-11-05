enum NotificationCategory {
  system,
  chat;

  String get label {
    switch (this) {
      case NotificationCategory.system:
        return 'Системные';
      case NotificationCategory.chat:
        return 'Чаты';
    }
  }

  static NotificationCategory fromStorage(String value) {
    return NotificationCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => NotificationCategory.system,
    );
  }
}
