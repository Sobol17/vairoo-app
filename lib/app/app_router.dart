import 'package:ai_note/app/app_shell.dart';
import 'package:ai_note/src/features/articles/domain/entities/article.dart';
import 'package:ai_note/src/features/articles/presentation/pages/article_detail_page.dart';
import 'package:ai_note/src/features/articles/presentation/pages/articles_page.dart';
import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_note/src/features/auth/presentation/pages/auth_page.dart';
import 'package:ai_note/src/features/calendar/presentation/pages/calendar_page.dart';
import 'package:ai_note/src/features/disclaimer/domain/entities/disclaimer_type.dart';
import 'package:ai_note/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:ai_note/src/features/disclaimer/presentation/pages/disclaimer_screen.dart';
import 'package:ai_note/src/features/home/presentation/pages/home_page.dart';
import 'package:ai_note/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:ai_note/src/features/notifications/domain/entities/notification_category.dart';
import 'package:ai_note/src/features/notifications/presentation/controllers/notification_permission_controller.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/chat_detail_page.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/notification_permission_page.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ai_note/src/features/plan/domain/entities/daily_plan.dart';
import 'package:ai_note/src/features/plan/presentation/pages/plan_page.dart';
import 'package:ai_note/src/features/practice/presentation/pages/breathing_practice_page.dart';
import 'package:ai_note/src/features/practice/presentation/pages/practice_page.dart';
import 'package:ai_note/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ai_note/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:ai_note/src/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:ai_note/src/features/profile/presentation/pages/profile_page.dart';
import 'package:ai_note/src/features/recipes/presentation/pages/recipes_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter createAppRouter({
  required AuthController authController,
  required NotificationPermissionController permissionController,
  required DisclaimerController disclaimerController,
  required Listenable refreshListenable,
}) {
  return GoRouter(
    initialLocation: '/disclaimer',
    debugLogDiagnostics: false,
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: '/disclaimer',
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const _DisclaimerEntryPage()),
      ),
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const AuthPage()),
      ),
      GoRoute(
        path: '/notification-permission',
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const NotificationPermissionPage()),
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
                    _buildTransitionPage(state, const HomePage()),
                routes: [
                  GoRoute(
                    path: 'chat',
                    pageBuilder: (context, state) {
                      final data = state.extra is ChatDetailData
                          ? state.extra as ChatDetailData
                          : const ChatDetailData.sample();
                      return _buildTransitionPage(
                        state,
                        ChatDetailPage(data: data),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'notifications',
                    pageBuilder: (context, state) =>
                        _buildTransitionPage(state, const NotificationsPage()),
                  ),
                  GoRoute(
                    path: 'chats',
                    pageBuilder: (context, state) => _buildTransitionPage(
                      state,
                      const NotificationsPage(
                        initialCategory: NotificationCategory.chat,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'plan',
                    pageBuilder: (context, state) {
                      final plan = state.extra is DailyPlan
                          ? state.extra as DailyPlan
                          : null;
                      return _buildTransitionPage(state, PlanPage(plan: plan));
                    },
                  ),
                  GoRoute(
                    path: 'recipes',
                    pageBuilder: (context, state) =>
                        _buildTransitionPage(state, const RecipesPage()),
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
                    _buildTransitionPage(state, const PracticePage()),
                routes: [
                  GoRoute(
                    path: 'breathing',
                    pageBuilder: (context, state) => _buildTransitionPage(
                      state,
                      const BreathingPracticePage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                pageBuilder: (context, state) =>
                    _buildTransitionPage(state, const CalendarPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) =>
                    _buildTransitionPage(state, const ProfilePage()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profile/edit',
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          ChangeNotifierProvider<ProfileController>(
            create: (ctx) =>
                ProfileController(repository: ctx.read<ProfileRepository>())
                  ..loadProfile(),
            child: const ProfileEditPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/articles',
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const ArticlesPage()),
        routes: [
          GoRoute(
            path: 'article/:id',
            pageBuilder: (context, state) {
              final extra = state.extra;
              if (extra is Article) {
                return _buildTransitionPage(
                  state,
                  ArticleDetailPage(article: extra),
                );
              }
              return _buildTransitionPage(state, const _ArticleMissingPage());
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = authController.isAuthenticated;
      final loggingIn = state.matchedLocation == '/auth';
      final onPermissionPage =
          state.matchedLocation == '/notification-permission';
      final onDisclaimer = state.matchedLocation == '/disclaimer';
      final needsPermissionPrompt =
          isAuthenticated && permissionController.shouldPrompt;
      final hasAcceptedDisclaimer = disclaimerController.isAcceptedSync(
        DisclaimerType.main,
      );

      if (!hasAcceptedDisclaimer && !onDisclaimer) {
        return '/disclaimer';
      }
      if (hasAcceptedDisclaimer && onDisclaimer) {
        if (!isAuthenticated) {
          return '/auth';
        }
        if (needsPermissionPrompt) {
          return '/notification-permission';
        }
        return '/home';
      }

      if (!isAuthenticated && !loggingIn && !onDisclaimer) {
        return '/auth';
      }
      if (isAuthenticated && loggingIn) {
        return '/home';
      }
      if (needsPermissionPrompt && !onPermissionPage && !onDisclaimer) {
        return '/notification-permission';
      }
      if (!needsPermissionPrompt && onPermissionPage) {
        return '/home';
      }
      return null;
    },
  );
}

CustomTransitionPage<void> _buildTransitionPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final slideTween = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: curved.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}

class _ArticleMissingPage extends StatelessWidget {
  const _ArticleMissingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.error_outline, size: 48),
              SizedBox(height: 12),
              Text(
                'Статья недоступна',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisclaimerEntryPage extends StatelessWidget {
  const _DisclaimerEntryPage();

  @override
  Widget build(BuildContext context) {
    return DisclaimerScreen(
      onAcknowledged: () {
        context.read<DisclaimerController>().markAccepted(DisclaimerType.main);
        final authController = context.read<AuthController>();
        final permissionController = context
            .read<NotificationPermissionController>();
        final needsPermissionPrompt =
            authController.isAuthenticated && permissionController.shouldPrompt;

        if (needsPermissionPrompt) {
          context.go('/notification-permission');
        } else if (authController.isAuthenticated) {
          context.go('/home');
        } else {
          context.go('/auth');
        }
      },
    );
  }
}
