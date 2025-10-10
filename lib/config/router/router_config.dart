import 'package:englishkey/presentation/screen/complete_sentences_screen.dart';
import 'package:englishkey/presentation/screen/home_screen.dart';
import 'package:englishkey/presentation/screen/lessons_screen.dart';
import 'package:englishkey/presentation/screen/login_screen.dart';
import 'package:englishkey/presentation/screen/sentences_screen.dart';
import 'package:englishkey/presentation/screen/settings_screen.dart';
import 'package:englishkey/presentation/screen/suggestion_screen.dart';
import 'package:englishkey/presentation/screen/user_screen.dart';
import 'package:englishkey/presentation/screen/video_player_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouterConfig = GoRouter(
  /* redirect: (context, state) {
    final currentUser = FirebaseAuth.instance.currentUser;

    final isLoggerIn = currentUser != null;

    if (!isLoggerIn) {
      return '/login';
    }
    if (isLoggerIn) {
      return '/';
    }
    return null;
  }, */
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/lessons', builder: (context, state) => LessonsScreen()),
    GoRoute(
      path: '/complete_sentence',
      builder: (context, state) => CompleteSentencesScreen(),
    ),
    GoRoute(
      path: '/suggestion',
      builder: (context, state) => SuggestionScreen(),
    ),
    GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
    GoRoute(path: '/user', builder: (context, state) => UserScreen()),
    GoRoute(
      path: '/video_player',
      builder: (context, state) {
        final keyString = state.extra as String?;
        return VideoPlayerScreen(key: ValueKey(keyString ?? 'default'));
      },
    ),
    GoRoute(path: '/sentences', builder: (context, state) => SentencesScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  ],
);
