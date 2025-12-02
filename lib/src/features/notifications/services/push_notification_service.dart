import 'dart:async';
import 'dart:convert';

import 'package:Vairoo/src/core/storage/preferences_storage.dart';
import 'package:Vairoo/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:Vairoo/src/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:Vairoo/src/features/notifications/presentation/controllers/notification_permission_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _tokenStorageKey = 'notifications.device_token';
const _androidChannelId = 'vairoo.default.notifications';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationService {
  PushNotificationService({
    required FirebaseMessaging messaging,
    required NotificationPermissionController permissionController,
    required NotificationRemoteDataSource remoteDataSource,
    required PreferencesStorage storage,
    required AuthController authController,
  }) : _messaging = messaging,
       _permissionController = permissionController,
       _remoteDataSource = remoteDataSource,
       _storage = storage,
       _authController = authController {
    _permissionListener = _handlePermissionChange;
    _authListener = _handleAuthChange;
    _permissionController.addListener(_permissionListener);
    _authController.addListener(_authListener);
  }

  final FirebaseMessaging _messaging;
  final NotificationPermissionController _permissionController;
  final NotificationRemoteDataSource _remoteDataSource;
  final PreferencesStorage _storage;
  final AuthController _authController;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  late final VoidCallback _permissionListener;
  late final VoidCallback _authListener;
  StreamSubscription<String>? _tokenRefreshSub;
  String? _lastSyncedToken;
  bool _localNotificationsReady = false;

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        _androidChannelId,
        'Основные уведомления',
        description: 'Системные уведомления приложения Vairoo',
        importance: Importance.max,
      );

  Future<void> initialize() async {
    _lastSyncedToken = _storage.getString(_tokenStorageKey);
    await _configureLocalNotifications();
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _maybeStartMessaging();
  }

  Future<void> _configureLocalNotifications() async {
    if (_localNotificationsReady) {
      return;
    }
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(initializationSettings);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
    _localNotificationsReady = true;
  }

  Future<void> _maybeStartMessaging() async {
    if (!_permissionController.isGranted || !_authController.isAuthenticated) {
      return;
    }
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: false,
      announcement: true,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied ||
        settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      return;
    }
    final token = await _messaging.getToken();
    if (token != null) {
      await _syncToken(token);
    }
    _tokenRefreshSub ??= _messaging.onTokenRefresh.listen(
      (token) => _syncToken(token),
    );
  }

  void _handlePermissionChange() {
    if (_permissionController.isGranted) {
      unawaited(_maybeStartMessaging());
    } else {
      unawaited(_revokeToken());
      _stopTokenRefresh();
    }
  }

  void _handleAuthChange() {
    if (_authController.isAuthenticated) {
      unawaited(_maybeStartMessaging());
    } else {
      unawaited(_revokeToken());
      _stopTokenRefresh();
    }
  }

  Future<void> _syncToken(String token) async {
    if (token.isEmpty || token == _lastSyncedToken) {
      return;
    }
    try {
      await _remoteDataSource.registerDeviceToken(token);
      await _storage.setString(_tokenStorageKey, token);
      _lastSyncedToken = token;
    } catch (error, stackTrace) {
      debugPrint('Failed to register FCM token: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> _revokeToken() async {
    final storedToken =
        _lastSyncedToken ?? _storage.getString(_tokenStorageKey);
    if (storedToken == null || storedToken.isEmpty) {
      await _storage.remove(_tokenStorageKey);
      return;
    }
    try {
      await _remoteDataSource.deleteDeviceToken(storedToken);
    } catch (error, stackTrace) {
      debugPrint('Failed to revoke FCM token: $error');
      debugPrint('$stackTrace');
    } finally {
      await _storage.remove(_tokenStorageKey);
      _lastSyncedToken = null;
    }
  }

  void _onMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) {
      return;
    }
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );
    _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'Новое уведомление',
      notification.body,
      NotificationDetails(android: androidDetails, iOS: iOSDetails),
      payload: message.data.isEmpty ? null : jsonEncode(message.data),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Push notification tapped: ${message.messageId}');
  }

  void _stopTokenRefresh() {
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
  }

  void dispose() {
    _permissionController.removeListener(_permissionListener);
    _authController.removeListener(_authListener);
    _stopTokenRefresh();
  }
}
