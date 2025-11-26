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
        pageBuilder: (context, state) =>
            buildSlidePage(key: state.pageKey, child: const SignUpView()),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) =>
            buildSlidePage(key: state.pageKey, child: const LoginView()),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String?;
          return buildSlidePage(
            key: state.pageKey,
            child: ForgotPasswordView(email: email),
          );
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
            pageBuilder: (context, state) => buildFadePage<void>(
              key: state.pageKey,
              child: const HomeView(),
            ),
          ),
          GoRoute(
            path: Routes.devotional,
            pageBuilder: (context, state) {
              return buildFadePage<void>(
                key: state.pageKey,
                child: const CategoriesView(),
              );
            },
          ),
          GoRoute(
            path: Routes.categoryDevotionals,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final category = extra?['category'] as DevotionalCategory?;
              final tag = extra?['tag'] as Tag?;
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
              return buildFadePage<void>(
                key: state.pageKey,
                child: const JournalView(),
              );
            },
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (context, state) => buildFadePage<void>(
              key: state.pageKey,
              child: const ProfileView(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.moodEntryDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final sessionId = extra?['sessionId'] as String?;
          final initialSession = extra?['initialSession'] as MoodSession?;
          final saveFuture =
              extra?['saveFuture']
                  as Future<
                    ({MoodSession? partialSession, String? sessionId})
                  >?;
          if (sessionId == null) {
            return NoTransitionPage<void>(child: Container());
          }
          return NoTransitionPage<void>(
            child: MoodEntryDetailsView(
              sessionId: sessionId,
              initialSession: initialSession,
              saveFuture: saveFuture,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.devotionalLogDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final id = extra?['id'] as int?;
          if (id == null) {
            return NoTransitionPage<void>(child: Container());
          }
          return NoTransitionPage<void>(
            child: DevotionalLogDetailsView(id: id),
          );
        },
      ),
      GoRoute(
        path: Routes.addMood,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final preSelectedMood = extra?['preSelectedMood'] as Mood?;
          return buildSlidePage(
            key: state.pageKey,
            child: AddMoodView(preSelectedMood: preSelectedMood),
          );
        },
      ),
      GoRoute(
        path: Routes.settings,
        pageBuilder: (context, state) =>
            buildSlidePage(key: state.pageKey, child: const SettingsView()),
      ),
      GoRoute(
        path: Routes.myInformation,
        pageBuilder: (context, state) => buildSlidePage(
          key: state.pageKey,
          isBottomSheet: false,
          child: const MyInformationView(),
        ),
      ),
      GoRoute(
        path: Routes.privacyAndSecurity,
        pageBuilder: (context, state) => buildSlidePage(
          key: state.pageKey,
          isBottomSheet: false,
          child: const SecurityView(),
        ),
      ),
      GoRoute(
        path: Routes.reminder,
        pageBuilder: (context, state) => buildSlidePage(
          key: state.pageKey,
          isBottomSheet: false,
          child: const ReminderView(),
        ),
      ),
    ],
  );
}

CustomTransitionPage<T> buildSlidePage<T>({
  required LocalKey key,
  required Widget child,
  bool isBottomSheet = true,
}) {
  const duration = Duration(milliseconds: 350);
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

CustomTransitionPage<T> buildFadePage<T>({
  required LocalKey key,
  required Widget child,
}) {
  const duration = Duration(milliseconds: 450);
  final curve = Curves.easeInOutCubic;

  final opacityTween = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).chain(CurveTween(curve: curve));

  final scaleTween = Tween<double>(
    begin: 0.96,
    end: 1.0,
  ).chain(CurveTween(curve: curve));

  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(opacityTween),
        child: ScaleTransition(
          scale: animation.drive(scaleTween),
          child: child,
        ),
      );
    },
  );
}
