import 'package:englishkey/presentation/screen/home_screen.dart';
import 'package:englishkey/presentation/screen/lessons_screen.dart';
import 'package:englishkey/presentation/screen/settings_screen.dart';
import 'package:englishkey/presentation/screen/video_player_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouterConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
    GoRoute(path: '/lessons', builder: (context, state) => LessonsScreen()),
    GoRoute(
      path: '/video_player',
      builder: (context, state) => VideoPlayerScreen(),
    ),
  ],
);
