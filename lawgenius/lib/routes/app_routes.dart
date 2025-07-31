import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:lawgenius/views/auth/login_screen.dart';
import 'package:lawgenius/views/auth/new_password_screen.dart';
import 'package:lawgenius/views/auth/signUp_screen.dart';
import 'package:lawgenius/views/auth/verification_code_screen.dart';
//import 'package:lawgenius/views/chat/chat_history_screen.dart';
import 'package:lawgenius/views/chat/chat_screen.dart';
import 'package:lawgenius/views/home/home_screen.dart';
import 'package:lawgenius/views/main_navigation/shell_navigation_screen.dart';
import 'package:lawgenius/views/onboarding/onboarding_screen.dart';
import 'package:lawgenius/views/splash/splash_screen.dart';
import 'package:lawgenius/views/welcome/welcome.dart';

class AppRoutes {
  // Navigator key for root navigation
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: <RouteBase>[
      // Splash Screen - Initial route
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      // Onboarding Screen
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),

      // Welcome Screen
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomeScreen();
        },
      ),

      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (BuildContext context, GoRouterState state) {
          return const CreateAccountScreen();
        },
      ),

      GoRoute(
        path: '/verify-code',
        name: 'verify-code',
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyCodeScreen();
        },
      ),

      GoRoute(
        path: '/new-password',
        name: 'new-password',
        builder: (BuildContext context, GoRouterState state) {
          return const NewPasswordScreen();
        },
      ),

      GoRoute(
        path: '/chat-screen',
        builder: (context, state) {
          final chatId = state.uri.queryParameters['chatId'];
          final initialMessage = state.uri.queryParameters['initialMessage'];
          return ChatScreen(chatId: chatId, initialMessage: initialMessage);
        },
      ),

      // Main Navigation with Persistent Bottom Navigation using StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Home Branch
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/chat-history',
          //       name: 'chat-history',
          //       builder: (context, state) => const ChatHistoryScreen(),
          //     ),
          //   ],
          // ),
        ],
      ),
    ],
  );
}
