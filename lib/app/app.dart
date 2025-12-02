import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/core/storage/preferences_storage.dart';
import 'package:Vairoo/src/core/theme/app_theme.dart';
import 'package:Vairoo/src/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:Vairoo/src/features/articles/data/repositories/articles_repository_impl.dart';
import 'package:Vairoo/src/features/articles/domain/repositories/articles_repository.dart';
import 'package:Vairoo/src/features/calendar/data/datasources/calendar_notes_remote_data_source.dart';
import 'package:Vairoo/src/features/calendar/data/repositories/calendar_notes_repository_impl.dart';
import 'package:Vairoo/src/features/calendar/domain/repositories/calendar_notes_repository.dart';
import 'package:Vairoo/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:Vairoo/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:Vairoo/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:Vairoo/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:Vairoo/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:Vairoo/src/features/disclaimer/data/datasources/disclaimer_local_data_source.dart';
import 'package:Vairoo/src/features/disclaimer/data/repositories/disclaimer_repository_impl.dart';
import 'package:Vairoo/src/features/disclaimer/domain/repositories/disclaimer_repository.dart';
import 'package:Vairoo/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:Vairoo/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:Vairoo/src/features/home/data/datasources/note_local_data_source.dart';
import 'package:Vairoo/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:Vairoo/src/features/home/data/repositories/note_repository_impl.dart';
import 'package:Vairoo/src/features/home/domain/repositories/home_repository.dart';
import 'package:Vairoo/src/features/home/domain/repositories/note_repository.dart';
import 'package:Vairoo/src/features/home/presentation/controllers/home_controller.dart';
import 'package:Vairoo/src/features/notifications/data/datasources/chats_remote_data_source.dart';
import 'package:Vairoo/src/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:Vairoo/src/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:Vairoo/src/features/notifications/data/repositories/chats_repository_impl.dart';
import 'package:Vairoo/src/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/chats_repository.dart';
import 'package:Vairoo/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:Vairoo/src/features/notifications/presentation/controllers/notification_permission_controller.dart';
import 'package:Vairoo/src/features/paywall/data/datasources/paywall_remote_data_source.dart';
import 'package:Vairoo/src/features/paywall/data/repositories/paywall_repository_impl.dart';
import 'package:Vairoo/src/features/paywall/domain/repositories/paywall_repository.dart';
import 'package:Vairoo/src/features/paywall/presentation/controllers/subscription_controller.dart';
import 'package:Vairoo/src/features/plan/data/datasources/plan_remote_data_source.dart';
import 'package:Vairoo/src/features/plan/data/repositories/plan_repository_impl.dart';
import 'package:Vairoo/src/features/plan/domain/repositories/plan_repository.dart';
import 'package:Vairoo/src/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:Vairoo/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:Vairoo/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:Vairoo/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:Vairoo/src/features/recipes/data/datasources/recipes_remote_data_source.dart';
import 'package:Vairoo/src/features/recipes/data/repositories/recipes_repository_impl.dart';
import 'package:Vairoo/src/features/recipes/domain/repositories/recipes_repository.dart';
import 'package:Vairoo/src/features/notifications/services/push_notification_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.apiClient,
    required this.preferencesStorage,
    this.enablePushNotifications = true,
  });

  final ApiClient apiClient;
  final PreferencesStorage preferencesStorage;
  final bool enablePushNotifications;

  @override
  Widget build(BuildContext context) {
    final providers = <SingleChildWidget>[
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
            HomeController(repository: context.read<HomeRepository>()),
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
      ProxyProvider2<AuthRemoteDataSource, AuthLocalDataSource, AuthRepository>(
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
      ChangeNotifierProvider<SubscriptionController>(
        create: (context) => SubscriptionController(
          profileRepository: context.read<ProfileRepository>(),
          authController: context.read<AuthController>(),
        ),
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
      ProxyProvider<ApiClient, NotificationRemoteDataSource>(
        update: (_, client, __) => NotificationRemoteDataSource(client),
      ),
      ProxyProvider<PreferencesStorage, NotificationLocalDataSource>(
        update: (_, storage, __) => NotificationLocalDataSource(storage),
      ),
      ProxyProvider2<
        NotificationRemoteDataSource,
        NotificationLocalDataSource,
        NotificationRepository
      >(
        update: (_, remote, local, __) => NotificationRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
        ),
      ),
      ProxyProvider<ApiClient, ChatsRemoteDataSource>(
        update: (_, client, __) => ChatsRemoteDataSource(client),
      ),
      ProxyProvider<ChatsRemoteDataSource, ChatsRepository>(
        update: (_, dataSource, __) =>
            ChatsRepositoryImpl(remoteDataSource: dataSource),
      ),
      ProxyProvider<ApiClient, ArticlesRemoteDataSource>(
        update: (_, client, __) => ArticlesRemoteDataSource(client),
      ),
      ProxyProvider<ArticlesRemoteDataSource, ArticlesRepository>(
        update: (_, dataSource, __) =>
            ArticlesRepositoryImpl(remoteDataSource: dataSource),
      ),
      ProxyProvider<ApiClient, PlanRemoteDataSource>(
        update: (_, client, __) => PlanRemoteDataSource(client),
      ),
      ProxyProvider<PlanRemoteDataSource, PlanRepository>(
        update: (_, dataSource, __) =>
            PlanRepositoryImpl(remoteDataSource: dataSource),
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
      ProxyProvider<ApiClient, CalendarNotesRemoteDataSource>(
        update: (_, client, __) => CalendarNotesRemoteDataSource(client),
      ),
      ProxyProvider<CalendarNotesRemoteDataSource, CalendarNotesRepository>(
        update: (_, dataSource, __) =>
            CalendarNotesRepositoryImpl(remoteDataSource: dataSource),
      ),
      ProxyProvider<ApiClient, RecipesRemoteDataSource>(
        update: (_, client, __) => RecipesRemoteDataSource(client),
      ),
      ProxyProvider<RecipesRemoteDataSource, RecipesRepository>(
        update: (_, dataSource, __) =>
            RecipesRepositoryImpl(remoteDataSource: dataSource),
      ),
      ProxyProvider<ApiClient, PaywallRemoteDataSource>(
        update: (_, client, __) => PaywallRemoteDataSource(client),
      ),
      ProxyProvider<PaywallRemoteDataSource, PaywallRepository>(
        update: (_, dataSource, __) =>
            PaywallRepositoryImpl(remoteDataSource: dataSource),
      ),
    ];

    if (enablePushNotifications) {
      providers.add(
        Provider<PushNotificationService>(
          lazy: false,
          create: (context) {
            final service = PushNotificationService(
              messaging: FirebaseMessaging.instance,
              permissionController: context
                  .read<NotificationPermissionController>(),
              remoteDataSource: context.read<NotificationRemoteDataSource>(),
              storage: context.read<PreferencesStorage>(),
              authController: context.read<AuthController>(),
            );
            service.initialize();
            return service;
          },
          dispose: (_, service) => service.dispose(),
        ),
      );
    }

    return MultiProvider(providers: providers, child: const _AppRouterHost());
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
    final subscriptionController = context.read<SubscriptionController>();
    _routerRefreshListenable = _MergedListenable([
      authController,
      permissionController,
      disclaimerController,
      subscriptionController,
    ]);
    _router = createAppRouter(
      authController: authController,
      permissionController: permissionController,
      disclaimerController: disclaimerController,
      subscriptionController: subscriptionController,
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
