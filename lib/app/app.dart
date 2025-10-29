import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/core/storage/preferences_storage.dart';
import 'package:ai_note/src/core/theme/app_theme.dart';
import 'package:ai_note/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ai_note/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ai_note/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ai_note/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_note/src/features/auth/presentation/pages/auth_page.dart';
import 'package:ai_note/src/features/disclaimer/data/datasources/disclaimer_local_data_source.dart';
import 'package:ai_note/src/features/disclaimer/data/repositories/disclaimer_repository_impl.dart';
import 'package:ai_note/src/features/disclaimer/domain/repositories/disclaimer_repository.dart';
import 'package:ai_note/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:ai_note/src/features/home/data/datasources/note_local_data_source.dart';
import 'package:ai_note/src/features/home/data/repositories/note_repository_impl.dart';
import 'package:ai_note/src/features/home/domain/repositories/note_repository.dart';
import 'package:ai_note/src/features/home/presentation/pages/home_page.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.apiClient,
    required this.preferencesStorage,
  });

  final ApiClient apiClient;
  final PreferencesStorage preferencesStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<PreferencesStorage>.value(value: preferencesStorage),
        Provider<Dio>.value(value: apiClient.client),
        Provider<SharedPreferences>.value(value: preferencesStorage.instance),
        ProxyProvider<ApiClient, AuthRemoteDataSource>(
          update: (_, client, __) => AuthRemoteDataSource(client),
        ),
        ProxyProvider<PreferencesStorage, AuthLocalDataSource>(
          update: (_, storage, __) => AuthLocalDataSource(storage),
        ),
        ProxyProvider2<AuthRemoteDataSource, AuthLocalDataSource,
            AuthRepository>(
          update: (_, remote, local, __) => AuthRepositoryImpl(
            remoteDataSource: remote,
            localDataSource: local,
          ),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(
            repository: context.read<AuthRepository>(),
          )..restoreSession(),
        ),
        ProxyProvider<PreferencesStorage, NoteLocalDataSource>(
          update: (_, storage, __) => NoteLocalDataSource(storage),
        ),
        ProxyProvider<NoteLocalDataSource, NoteRepository>(
          update: (_, dataSource, __) => NoteRepositoryImpl(dataSource),
        ),
        ProxyProvider<PreferencesStorage, DisclaimerLocalDataSource>(
          update: (_, storage, __) => DisclaimerLocalDataSource(storage),
        ),
        ProxyProvider<DisclaimerLocalDataSource, DisclaimerRepository>(
          update: (_, dataSource, __) => DisclaimerRepositoryImpl(dataSource),
        ),
        ChangeNotifierProvider<DisclaimerController>(
          create: (context) => DisclaimerController(
            repository: context.read<DisclaimerRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'AI Note',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const _RootPage(),
      ),
    );
  }
}

class _RootPage extends StatelessWidget {
  const _RootPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const HomePage();
        }
        return const AuthPage();
      },
    );
  }
}
