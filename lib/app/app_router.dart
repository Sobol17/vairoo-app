import 'package:ai_note/app/app_shell.dart';
import 'package:ai_note/src/features/articles/domain/entities/article.dart';
import 'package:ai_note/src/features/articles/presentation/pages/article_detail_page.dart';
import 'package:ai_note/src/features/articles/presentation/pages/articles_page.dart';
import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_note/src/features/auth/presentation/pages/auth_page.dart';
import 'package:ai_note/src/features/calendar/presentation/pages/calendar_page.dart';
import 'package:ai_note/src/features/home/presentation/pages/home_page.dart';
import 'package:ai_note/src/features/notifications/domain/entities/notification_category.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/chat_detail_page.dart';
import 'package:ai_note/src/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ai_note/src/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:ai_note/src/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter(AuthController authController) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: false,
    refreshListenable: authController,
    routes: [
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const AuthPage()),
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
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/practice',
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
                      return _buildTransitionPage(
                        state,
                        const _ArticleMissingPage(),
                      );
                    },
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
                routes: [
                  GoRoute(
                    path: 'edit',
                    pageBuilder: (context, state) =>
                        _buildTransitionPage(state, const ProfileEditPage()),
                  ),
                ],
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
