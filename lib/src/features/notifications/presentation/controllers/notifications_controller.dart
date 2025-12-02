import 'package:flutter/foundation.dart';

import 'package:Vairoo/src/features/notifications/domain/entities/notification_category.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/user_notification.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/notification_repository.dart';

class NotificationsController extends ChangeNotifier {
  NotificationsController({
    required NotificationRepository repository,
    List<UserNotification>? seed,
    NotificationCategory? initialCategory,
  }) : _repository = repository,
       _seed = seed ?? const [] {
    if (initialCategory != null) {
      _selectedCategory = initialCategory;
    }
  }

  final NotificationRepository _repository;
  final List<UserNotification> _seed;

  bool _hasSeeded = false;
  bool _isLoading = false;
  NotificationCategory _selectedCategory = NotificationCategory.system;
  List<UserNotification> _notifications = const [];
  final Set<String> _selectedIds = <String>{};

  bool get isLoading => _isLoading;
  NotificationCategory get selectedCategory => _selectedCategory;
  bool get hasSelection => _selectedIds.isNotEmpty;

  List<UserNotification> get notificationsForSelectedCategory => _notifications
      .where((notification) => notification.category == _selectedCategory)
      .toList(growable: false);

  bool get hasNotifications => notificationsForSelectedCategory.isNotEmpty;
  bool get areAllSelected =>
      hasNotifications &&
      notificationsForSelectedCategory.every(_selectedIds.contains);

  bool isSelected(String id) => _selectedIds.contains(id);

  Future<void> loadNotifications({bool allowSeed = false}) async {
    _setLoading(true);
    try {
      var items = await _repository.fetchNotifications();
      if (items.isEmpty && allowSeed && !_hasSeeded && _seed.isNotEmpty) {
        items = List<UserNotification>.from(_seed);
        await _repository.saveNotifications(items);
        _hasSeeded = true;
      }

      _notifications = _sortByDateDescending(items);
      _selectedIds.clear();
    } finally {
      _setLoading(false);
    }
  }

  void selectCategory(NotificationCategory category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    _selectedIds.clear();
    notifyListeners();
  }

  void toggleSelection(String id) {
    final isInCurrentCategory = notificationsForSelectedCategory.any(
      (notification) => notification.id == id,
    );
    if (!isInCurrentCategory) {
      return;
    }

    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    if (_selectedIds.isEmpty) {
      return;
    }
    _selectedIds.clear();
    notifyListeners();
  }

  void toggleSelectAll() {
    final current = notificationsForSelectedCategory;
    if (current.isEmpty) {
      return;
    }
    final ids = current.map((notification) => notification.id);
    final shouldSelectAll = !areAllSelected;

    for (final id in ids) {
      if (shouldSelectAll) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    }
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    if (_selectedIds.isEmpty) {
      return;
    }
    _notifications = _notifications
        .where((notification) => !_selectedIds.contains(notification.id))
        .toList(growable: false);
    _selectedIds.clear();
    await _repository.saveNotifications(_notifications);
    notifyListeners();
  }

  Future<void> deleteCurrentCategory() async {
    final current = notificationsForSelectedCategory;
    if (current.isEmpty) {
      return;
    }
    final ids = current.map((notification) => notification.id).toSet();
    _notifications = _notifications
        .where((notification) => !ids.contains(notification.id))
        .toList(growable: false);
    _selectedIds.clear();
    await _repository.saveNotifications(_notifications);
    notifyListeners();
  }

  Future<void> deleteAll() async {
    await _repository.deleteAllNotifications();
    _notifications = [];
    _selectedIds.clear();
    notifyListeners();
  }

  List<UserNotification> _sortByDateDescending(
    List<UserNotification> notifications,
  ) {
    final sorted = List<UserNotification>.from(notifications);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }
}
