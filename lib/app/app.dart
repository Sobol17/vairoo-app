import 'package:ai_note/src/core/network/api_client.dart';
import 'package:ai_note/src/core/storage/preferences_storage.dart';
import 'package:ai_note/src/core/theme/app_theme.dart';
import 'package:ai_note/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ai_note/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ai_note/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ai_note/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_note/src/features/auth/presentation/pages/auth_page.dart';
import 'package:ai_note/src/features/calendar/presentation/pages/calendar_page.dart';
import 'package:ai_note/src/features/disclaimer/data/datasources/disclaimer_local_data_source.dart';
import 'package:ai_note/src/features/disclaimer/data/repositories/disclaimer_repository_impl.dart';
import 'package:ai_note/src/features/disclaimer/domain/repositories/disclaimer_repository.dart';
import 'package:ai_note/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:ai_note/src/features/home/data/datasources/note_local_data_source.dart';
import 'package:ai_note/src/features/home/data/repositories/note_repository_impl.dart';
import 'package:ai_note/src/features/home/domain/repositories/note_repository.dart';
import 'package:ai_note/src/features/home/presentation/pages/home_page.dart';
import 'package:ai_note/src/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:ai_note/src/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:ai_note/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ai_note/src/features/practice/presentation/pages/practice_page.dart';
import 'package:ai_note/src/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ai_note/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ai_note/src/features/profile/presentation/pages/profile_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_shell.dart';

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
            useApi: false,
          )..restoreSession(),
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
        ProxyProvider<PreferencesStorage, ProfileLocalDataSource>(
          update: (_, storage, __) => ProfileLocalDataSource(storage),
        ),
        ProxyProvider<ProfileLocalDataSource, ProfileRepository>(
          update: (_, dataSource, __) =>
              ProfileRepositoryImpl(localDataSource: dataSource),
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

  @override
  void initState() {
    super.initState();
    final authController = context.read<AuthController>();
    _router = GoRouter(
      initialLocation: '/home',
      debugLogDiagnostics: false,
      refreshListenable: authController,
      routes: [
        GoRoute(
          path: '/auth',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AuthPage()),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: HomePage()),
                  routes: [
                    GoRoute(
                      path: 'notifications',
                      pageBuilder: (context, state) =>
                          const NoTransitionPage(child: NotificationsPage()),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/practice',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: PracticePage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/calendar',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: CalendarPage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: ProfilePage()),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final isAuthenticated = authController.isAuthenticated;
        final loggingIn = state.matchedLocation == '/auth';
        if (!isAuthenticated && !loggingIn) {
          return '/auth';
        }
        if (isAuthenticated && loggingIn) {
          return '/home';
        }
        return null;
      },
    );
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
