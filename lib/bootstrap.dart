import 'package:Vairoo/src/features/notifications/services/push_notification_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'src/core/network/api_client.dart';
import 'src/core/storage/preferences_storage.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseReady = await _initializeFirebase();

  final sharedPreferences = await SharedPreferences.getInstance();
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  final apiClient = ApiClient(dio);
  final storage = PreferencesStorage(sharedPreferences);

  runApp(
    App(
      apiClient: apiClient,
      preferencesStorage: storage,
      enablePushNotifications: firebaseReady,
    ),
  );
}

Future<bool> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    return true;
  } on Object catch (error, stackTrace) {
    debugPrint('Firebase initialization skipped: $error');
    debugPrint('$stackTrace');
    return false;
  }
}
