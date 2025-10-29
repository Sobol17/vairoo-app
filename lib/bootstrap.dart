import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'src/core/network/api_client.dart';
import 'src/core/storage/preferences_storage.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
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
    ),
  );
}
