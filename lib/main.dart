import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'src/game/game.dart' as game;
import 'src/screens/game_detail.dart' show GameDetailScreen;
import 'src/screens/home.dart' show HomeScreen;

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(key: Key('home screen')),
      routes: [
        GoRoute(
          path: 'play/:game_id',
          builder: (BuildContext context, GoRouterState state) {
            return GameDetailScreen(
              gameId: state.pathParameters['game_id']!,
            );
          },
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);

void main() {
  usePathUrlStrategy();

  runApp(const SochessApp());
}

class SochessApp extends StatelessWidget {
  const SochessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
