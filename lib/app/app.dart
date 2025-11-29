import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/core/storage/preferences_storage.dart';
import 'package:ai_note/src/core/theme/app_theme.dart';
import 'package:ai_note/src/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:ai_note/src/features/articles/data/repositories/articles_repository_impl.dart';
import 'package:ai_note/src/features/articles/domain/repositories/articles_repository.dart';
import 'package:ai_note/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ai_note/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ai_note/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ai_note/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_note/src/features/disclaimer/data/datasources/disclaimer_local_data_source.dart';
import 'package:ai_note/src/features/disclaimer/data/repositories/disclaimer_repository_impl.dart';
import 'package:ai_note/src/features/disclaimer/domain/repositories/disclaimer_repository.dart';
import 'package:ai_note/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:ai_note/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ai_note/src/features/home/data/datasources/note_local_data_source.dart';
import 'package:ai_note/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:ai_note/src/features/home/data/repositories/note_repository_impl.dart';
import 'package:ai_note/src/features/home/domain/repositories/home_repository.dart';
import 'package:ai_note/src/features/home/domain/repositories/note_repository.dart';
import 'package:ai_note/src/features/home/presentation/controllers/home_controller.dart';
import 'package:ai_note/src/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:ai_note/src/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:ai_note/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:ai_note/src/features/notifications/presentation/controllers/notification_permission_controller.dart';
import 'package:ai_note/src/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ai_note/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:ai_note/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ai_note/src/features/recipes/data/datasources/recipes_local_data_source.dart';
import 'package:ai_note/src/features/recipes/data/repositories/recipes_repository_impl.dart';
import 'package:ai_note/src/features/recipes/domain/repositories/recipes_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';

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
        ProxyProvider<ApiClient, HomeRepository>(
          update: (_, client, __) =>
              HomeRepositoryImpl(HomeRemoteDataSource(client)),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (context) =>
              HomeController(repository: context.read<HomeRepository>())
                ..loadHome(),
        ),
        ProxyProvider<ApiClient, ProfileRemoteDataSource>(
          update: (_, client, __) => ProfileRemoteDataSource(client),
        ),
        ProxyProvider<PreferencesStorage, ProfileLocalDataSource>(
          update: (_, storage, __) => ProfileLocalDataSource(storage),
        ),
        ProxyProvider2<
          ProfileRemoteDataSource,
          ProfileLocalDataSource,
          ProfileRepository
        >(
          update: (_, remote, local, __) => ProfileRepositoryImpl(
            remoteDataSource: remote,
            localDataSource: local,
          ),
        ),
        ProxyProvider<ApiClient, AuthRemoteDataSource>(
          update: (_, client, __) => AuthRemoteDataSource(client),
        ),
        ProxyProvider<PreferencesStorage, AuthLocalDataSource>(
          update: (_, storage, __) => AuthLocalDataSource(storage),
        ),
        ProxyProvider2<
          AuthRemoteDataSource,
          AuthLocalDataSource,
          AuthRepository
        >(
          update: (_, remote, local, __) => AuthRepositoryImpl(
            remoteDataSource: remote,
            localDataSource: local,
          ),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(
            repository: context.read<AuthRepository>(),
            apiClient: context.read<ApiClient>(),
            profileRepository: context.read<ProfileRepository>(),
            useApi: true,
          )..restoreSession(),
        ),
        ChangeNotifierProvider<NotificationPermissionController>(
          create: (context) => NotificationPermissionController(
            authController: context.read<AuthController>(),
          ),
        ),
        ProxyProvider<PreferencesStorage, NoteLocalDataSource>(
          update: (_, storage, __) => NoteLocalDataSource(storage),
        ),
        ProxyProvider<NoteLocalDataSource, NoteRepository>(
          update: (_, dataSource, __) => NoteRepositoryImpl(dataSource),
        ),
        ProxyProvider<PreferencesStorage, NotificationLocalDataSource>(
          update: (_, storage, __) => NotificationLocalDataSource(storage),
        ),
        ProxyProvider<NotificationLocalDataSource, NotificationRepository>(
          update: (_, dataSource, __) => NotificationRepositoryImpl(dataSource),
        ),
        ProxyProvider<ApiClient, ArticlesRemoteDataSource>(
          update: (_, client, __) => ArticlesRemoteDataSource(client),
        ),
        ProxyProvider<ArticlesRemoteDataSource, ArticlesRepository>(
          update: (_, dataSource, __) =>
              ArticlesRepositoryImpl(remoteDataSource: dataSource),
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
        Provider<RecipesLocalDataSource>(
          create: (_) => const RecipesLocalDataSource(),
        ),
        ProxyProvider<RecipesLocalDataSource, RecipesRepository>(
          update: (_, dataSource, __) =>
              RecipesRepositoryImpl(localDataSource: dataSource),
        ),
      ],
      child: const _AppRouterHost(),
    );
  }
}

class _AppRouterHost extends StatefulWidget {
  const _AppRouterHost();

  @override
  State<_AppRouterHost> createState() => _AppRouterHostState();
}

class _AppRouterHostState extends State<_AppRouterHost> {
  late final GoRouter _router;
  late final _MergedListenable _routerRefreshListenable;

  @override
  void initState() {
    super.initState();
    final authController = context.read<AuthController>();
    final permissionController = context
        .read<NotificationPermissionController>();
    final disclaimerController = context.read<DisclaimerController>();
    _routerRefreshListenable = _MergedListenable([
      authController,
      permissionController,
      disclaimerController,
    ]);
    _router = createAppRouter(
      authController: authController,
      permissionController: permissionController,
      disclaimerController: disclaimerController,
      refreshListenable: _routerRefreshListenable,
    );
  }

  @override
  void dispose() {
    _routerRefreshListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Note',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}

class _MergedListenable extends ChangeNotifier {
  _MergedListenable(List<Listenable> listenables) : _listenables = listenables {
    for (final listenable in _listenables) {
      listenable.addListener(_onDependencyChanged);
    }
  }

  final List<Listenable> _listenables;

  void _onDependencyChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    for (final listenable in _listenables) {
      listenable.removeListener(_onDependencyChanged);
    }
    super.dispose();
  }
}
