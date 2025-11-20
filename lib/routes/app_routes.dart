// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../core/core_exports.dart';
import '../../features/features_exports.dart';
import '../navigation/bottom_nav.dart';
import 'app_routes_names.dart';

abstract class AppRoutes {
  //--------------Navigator Keys--------------//
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  //--------------Navigator Keys--------------//

  static const _initialPath = Routes.initialPath;
  static final routerConfig = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: _initialPath,
    routes: [
      // Landing Route Handler and Splash Screen
      GoRoute(
        path: _initialPath,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: SplashView());
        },
      ),
      GoRoute(
        path: Routes.welcome,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: WelcomeView());
        },
      ),
      GoRoute(
        path: Routes.signUp,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: SignUpView());
        },
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: LoginView());
        },
      ),
      GoRoute(
        path: Routes.forgotPassword,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String?;
          return NoTransitionPage(child: ForgotPasswordView(email: email));
        },
      ),

      // Global Dashboard Shell Route
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(child: BottomNavScreen(child: child));
        },
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) =>
                NoTransitionPage<void>(child: const HomeView()),
          ),
          GoRoute(
            path: Routes.devotional,
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(child: const CategoriesView());
            },
          ),
          GoRoute(
            path: Routes.categoryDevotionals,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final category = extra?['category'] as DevotionalCategory?;
              final tag = extra?['tag'] as DevotionalTag?;
              return NoTransitionPage<void>(
                child: CategoryDevotionalsView(category: category, tag: tag),
              );
            },
          ),
          GoRoute(
            path: Routes.devotionalDetails,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final devotionalId = extra?['devotionalId'] as int?;
              if (devotionalId == null) {
                return NoTransitionPage<void>(child: Container());
              }
              return NoTransitionPage<void>(
                child: DevotionalDetailsView(devotionalId: devotionalId),
              );
            },
          ),
          GoRoute(
            path: Routes.journal,
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(child: Container());
            },
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (context, state) =>
                NoTransitionPage<void>(child: Container()),
          ),
        ],
      ),
      GoRoute(
        path: Routes.addMood,
        pageBuilder: (context, state) {
          return buildSlidePage(
            key: state.pageKey,
            child: AddMoodView(),
          );
        },
      ),
    ],
  );
}

CustomTransitionPage<T> buildSlidePage<T>({
  required LocalKey key,
  required Widget child,
  bool isBottomSheet = true,
}) {
  const duration = Duration(milliseconds: 300);
  final offset = isBottomSheet ? Offset(0, 1) : Offset(1, 0);
  final tween = Tween<Offset>(
    begin: offset,
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeOut));

  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(position: animation.drive(tween), child: child),
  );
}
